#' Shiny app for exploring census and electorate data
#' 
#' @import shiny
#' @import plotly
#' @importFrom tidyr gather
#' @export
#' @examples \dontrun{
#' launchApp()
#' }

launchApp <- function() {
  data("abs2011", package = "echidnaR")
  data("aec2013", package = "echidnaR")
  data("hexDat", package = "echidnaR")
  longAbs <- tidyr::gather(abs2011, variable, value, -ID, -Name, -State)
  longAbs$value <- as.numeric(longAbs$value)
  # by default, no electorates
  longAbs$selected_ <- FALSE
  longAbs <- longAbs[!is.na(longAbs$value),]
  longAbs$variable <- factor(
    longAbs$variable, 
    levels = unique(longAbs$variable)
  )
  ages <- longAbs[grepl("^Age", longAbs$variable), ]
  other <- longAbs[!grepl("^Age", longAbs$variable), ]
  
  electorates <- unique(abs2011$ELECT_DIV)
  ui <- fluidPage(
    fluidRow(
      column(
        width = 6,
        plotlyOutput("map")
      )
    ),
    fluidRow(
      column(
        width = 6,
        plotOutput(
          "ages", height = 1000, brush = brushOpts("ageBrush", direction = "x")
        )
      ),
      column(
        width = 6,
        plotOutput(
          "densities", height = 2000, brush = brushOpts("denBrush", direction = "x")
        )
      )
    ),
    verbatimTextOutput("select")
  )
  
  
  server <- function(input, output) {
    
    output$select <- renderPrint({
      #selectElect()
      input$ageBrush
    })
    
    # filter census data if brush is filled
    selectElect <- reactive({
      if (is.null(input$ageBrush)) {
        return(longAbs)
      }
      b <- input$ageBrush
      idx1 <- longAbs$variable %in% b$panelvar1
      idx2 <- b$xmin <= longAbs$value & longAbs$value <= b$xmax
      unique(longAbs[idx1 & idx2, "Name"])
    })
    
    output$ages <- renderPlot({
      ages$selected_ <- ages$Name %in% selectElect()
      p <- ggplot(ages, aes(value, fill = selected_)) + 
        geom_dotplot(binwidth = 0.15, dotsize = 1.9)
      p + 
        facet_wrap(~variable, ncol = 1) + 
        labs(x = NULL, y = NULL) + theme(legend.position = "none")
    })
    
    output$densities <- renderPlot({
      other$selected_ <- other$Name %in% selectElect()
      p <- ggplot(other, aes(value, colour = selected_)) + 
        geom_dotplot(dotsize = 0.1)
      p + 
        facet_wrap(~variable, scales = "free", ncol = 1) +
        labs(x = NULL, y = NULL) + theme(legend.position = "none")
    })
    
    output$map <- renderPlotly({
      hexDat$selected_ <- hexDat$electorate %in% selectElect()
      p <- ggplot(hexDat, aes(xcent, ycent, text = electorate, fill = selected_)) + 
        geom_hex(stat = "identity") + ggthemes::theme_map() +
        theme(legend.position = "none") + 
        lims(x = c(-80, 8), y = c(-40, 50))
      ggplotly(p, tooltip = "text")
    })
    
  }
  
  shinyApp(ui, server)
}





