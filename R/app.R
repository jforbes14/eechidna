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
  longAbs <- tidyr::gather(abs2011, variable, value, -ID, -Name, -State)
  longAbs$value <- as.numeric(longAbs$value)
  longAbs <- longAbs[!is.na(longAbs$value),]
  idx <- grepl("^Age", longAbs$variable)
  ages <- longAbs[idx, ]
  other <- longAbs[!idx, ]
  ages$variable <- factor(
    ages$variable, 
    levels = unique(ages$variable)
  )
  electorates <- unique(abs2011$ELECT_DIV)
  ui <- fluidPage(
    plotlyOutput("map"),
    fluidRow(
      column(
        width = 6,
        plotOutput("ages", height = 800)
      ),
      column(
        width = 6,
        plotOutput("densities", height = 1000)
      )
    )
  )
  
  server <- function(input, output) {
    
   output$map <- renderPlotly({
     p <- ggplot(data = nat_map, 
                 aes(long, lat, group = group, key = ELECT_DIV,
                     text = ELECT_DIV)) + 
       geom_polygon() + ggthemes::theme_map()
     
     l <- plotly_build(ggplotly(p, tooltip = "text"))
     #l$data[[1]]$type <- "scattergl"
     l$layout$height <- 400
     l$layout$width <- 400
     l
     
     # I reckon it'd be better to work with the spaital polygon
     #leaflet() %>%
     #  addPolygons(nat_map$long, nat_map$lat, group = nat_map$group)
     
     
   })
    
    output$ages <- renderPlot({
      p <- ggplot(ages, aes(value)) + geom_density()
      ed <- event_data("plotly_click")
      if (!is.null(ed)) {
        d <- ages[ages$Name %in% ed$key, ]
        p <- p + geom_vline(data = d, aes(xintercept = value, color = Name))
      }
      p + 
        facet_wrap(~variable, ncol = 1) + 
        labs(x = NULL, y = NULL) + theme(legend.position = "none")
    })
    
    output$densities <- renderPlot({
      p <- ggplot(other, aes(value)) + geom_density()
      ed <- event_data("plotly_click")
      if (!is.null(ed)) {
        d <- other[other$Name %in% ed$key, ]
        p <- p + geom_vline(data = d, aes(xintercept = value, color = Name))
      }
      p + 
        facet_wrap(~variable, scales = "free", ncol = 1) + 
        labs(x = NULL, y = NULL)
    })
  }
  
  shinyApp(ui, server)
}





