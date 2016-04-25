#' Shiny app for exploring census and electorate data
#' 
#' @import ggplot2
#' @import shiny
#' @importFrom plotly ggplotly layout plotlyOutput event_data renderPlotly as.widget 
#' @import dplyr
#' @import ggthemes
#' @importFrom tidyr gather
#' @export
#' @examples \dontrun{
#' launchApp()
#' }

launchApp <- function() {
 # abs2011 <- NULL # to appease package check, but these also seem to break the app. what to do?
 # hexDat <- NULL
 # variable <- NULL
 # value <- NULL
 # ID <- NULL
 # Electorate <- NULL
 # State <- NULL
 # aec2013_fp <- NULL
 # BallotPosition <- NULL
 # PartyAb <- NULL
 # OrdinaryVotes <- NULL
 # formal <- NULL
 # total_formal <- NULL
  data("abs2011", package = "eechidna") #,  envir = environment()
  data("aec2013_fp", package = "eechidna")
  data("hexDat", package = "eechidna")
  # a bit of data cleaning
  longAbs <- tidyr::gather(abs2011, variable, value, -ID, -Electorate, -State)
  longAbs$value <- as.numeric(longAbs$value)
  longAbs <- longAbs[!is.na(longAbs$value),]
  longAbs$variable <- factor(
    longAbs$variable, 
    levels = unique(longAbs$variable)
  )
  isAge <- grepl("^Age", longAbs$variable)
  ages <- longAbs[isAge, ]
  isReg <- longAbs$variable %in% c("Christianity", "Catholic", "Buddhism", "Islam", "Judaism", "NoReligion")
  religion <- longAbs[isReg, ]
  other <- longAbs[!isAge & !isReg, ]
  
  # election data: proportion of total votes for each party by electorate
  byParty <- aec2013_fp %>% 
    mutate(formal = BallotPosition != 999) %>% 
    group_by(Electorate, PartyAb) %>% 
    summarize(total_formal = sum(OrdinaryVotes[formal], na.rm=TRUE),
              prop_informal  = sum(OrdinaryVotes[!formal]/(sum(OrdinaryVotes, na.rm=TRUE) * 100))) %>%
    # each electorate sums to not quite 100%, but pretty close
    mutate(prop_total_of_electorate = total_formal / sum(total_formal))
  
  # retrieve selected electorates
  selector <- function() {
    d <- data.frame(
      Electorate = hexDat$Electorate,
      fill = rep("black", nrow(hexDat)),
      stringsAsFactors = FALSE
    )
    function(nms, color = "red") {
      if (missing(nms)) return(d)
      d[d$Electorate %in% nms, "fill"] <- color
      d <<- d
      d
    }
  }
  selectDat <- selector()
  
  ui <- fluidPage(
    fluidRow(
      column(
        width = 2,
        selectInput(
          "color", "Select a color:", choices = c("red", "blue", "yellow", "purple")
        )
      ),
      column(
        width = 6,
        selectizeInput(
          "parties", "Select parties:", unique(aec2013_fp$PartyAb), 
          selected = c("ALP", "GRN", "LP", "NP", "CLP", "LNQ"),
          multiple = TRUE
        )
      )
    ),
    fluidRow(
      column(
        width = 6,
        plotlyOutput("map")
      ),
      column(
        width = 6,
        plotlyOutput("byParty")
      )
    ),
    fluidRow(
      column(
        width = 4,
        plotOutput(
          "ages", height = 1000, brush = brushOpts("ageBrush", direction = "x")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "religion", height = 800, brush = brushOpts("regBrush", direction = "x")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "densities", height = 2000, brush = brushOpts("denBrush", direction = "x")
        )
      )
    )
  )
  
  
  server <- function(input, output) {
    # PartyAb <-  NULL # to appease package check, but also prevent package from working...
    # prop_total_of_electorate <-  NULL
    # fill <- NULL
    # Electorate <- NULL
    # value <- NULL
    # hexDat <- NULL
    # xcent <- NULL
    # ycent <- NULL
    
    # build up the selection sequentially
    selectElect <- reactive({
      selectDat(unique(longAbs$Electorate), "black")
      if (!is.null(input$ageBrush)) {
        b <- input$ageBrush
        idx <- (longAbs$variable %in% b$panelvar1) &
          (b$xmin <= longAbs$value & longAbs$value <= b$xmax)
        nms <- unique(longAbs[idx, "Electorate"])
        isolate({
          selectDat(nms, input$color)
        })
      }
      if (!is.null(input$denBrush)) {
        b <- input$denBrush
        idx <- (longAbs$variable %in% b$panelvar1) &
          (b$xmin <= longAbs$value & longAbs$value <= b$xmax)
        nms <- unique(longAbs[idx, "Electorate"])
        isolate({
          selectDat(nms, input$color)
        })
      }
      if (!is.null(input$regBrush)) {
        b <- input$regBrush
        idx <- (longAbs$variable %in% b$panelvar1) &
          (b$xmin <= longAbs$value & longAbs$value <= b$xmax)
        nms <- unique(longAbs[idx, "Electorate"])
        isolate({
          selectDat(nms, input$color)
        })
      }
      d <- event_data("plotly_selected")
      if (!is.null(d)) {
        print(d)
        isolate({
          selectDat(d$key, input$color)
        })
      }
      d2 <- event_data("plotly_click")
      if (!is.null(d2)) {
        isolate({
          selectDat(d2$key, input$color)
        })
      }
      selectDat()
    })
    
    output$byParty <- renderPlotly({
      byParty <- byParty[byParty$PartyAb %in% input$parties, ]
      d <- dplyr::left_join(byParty, selectElect(), by = "Electorate")
      p <- ggplot(d, aes(x = PartyAb, y = prop_total_of_electorate, colour = fill, key = Electorate)) + 
        geom_jitter(width = 0.25, alpha = 0.5) +
        scale_colour_identity() +
        theme_bw() +
        theme(legend.position = "none") + 
        labs(x = NULL, y = NULL)
      ggplotly(p, tooltip = "key") %>% layout(dragmode = "select")
    })
    
    output$ages <- renderPlot({
      d <- dplyr::left_join(ages, selectElect(), by = "Electorate")
      ggplot(d, aes(value, fill = fill)) + 
        geom_dotplot(binwidth = 0.15, dotsize = 1.9) +
        facet_wrap(~ variable, ncol = 1) + 
        scale_fill_identity() +
        labs(x = NULL, y = NULL) + 
        theme(legend.position = "none") +
        theme_bw() 
    })
    
    output$religion <- renderPlot({
      d <- dplyr::left_join(religion, selectElect(), by = "Electorate")
      ggplot(d, aes(value, colour = fill)) + 
        geom_dotplot(dotsize = 0.1) +
        scale_colour_identity() +
        facet_wrap(~variable, ncol = 1) +
        labs(x = NULL, y = NULL) + 
        theme(legend.position = "none") +
        theme_bw() 
    })
    
    output$densities <- renderPlot({
      d <- dplyr::left_join(other, selectElect(), by = "Electorate")
      ggplot(d, aes(value, colour = fill)) + 
        geom_dotplot(dotsize = 0.1) +
        scale_colour_identity() +
        facet_wrap(~variable, scales = "free", ncol = 1) +
        labs(x = NULL, y = NULL) + 
        theme(legend.position = "none") +
        theme_bw() 
    })
    
    output$map <- renderPlotly({
      d <- dplyr::left_join(hexDat, selectElect(), by = "Electorate")
      p <- ggplot(d, aes(xcent, ycent, text = Electorate, key = Electorate, fill = fill)) + 
        geom_hex(stat = "identity") + ggthemes::theme_map() +
        theme(legend.position = "none") + 
        scale_fill_identity() +
        lims(x = c(-80, 8), y = c(-40, 50))
      ggplotly(p, tooltip = "text") %>% layout(dragmode = "lasso")
    })
    
  }
  
  shinyApp(ui, server)
}





