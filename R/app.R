#' Shiny app for exploring census and electorate data
#' 
#' @import shiny
#' @import ggplot2
#' @importFrom plotly ggplotly layout plotlyOutput event_data renderPlotly as.widget plotly_build
#' @importFrom shinyjs useShinyjs runjs
#' @import dplyr
#' @import ggthemes
#' @importFrom tidyr gather
#' @export
#' @examples \dontrun{
#' launchApp()
#' }

launchApp <- function() {
  # a bit of data cleaning
  nat_data_cart <- eechidna::nat_data_cart
  nat_data_cart$Electorate <- nat_data_cart$ELECT_DIV
  abs2011 <- eechidna::abs2011
  # some of these variables are heavily right-skewed and cause problems
  # for the dotplot sizing
  abs2011$Area <- NULL
  abs2011$Buddhism <- NULL
  abs2011$Islam <- NULL
  abs2011$Judaism <- NULL
  longAbs <- tidyr::gather(
    abs2011, variable, value, -ID, -Electorate, -State
  )
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
  aec13 <- as.data.frame(eechidna::aec2013_fp_electorate)
  
  voteProps <- aec13 %>%
    group_by(Electorate, PartyAb) %>%
    summarise(n = sum(Total_OrdinaryVotes_in_electorate)) %>%
    mutate(prop = n / sum(n))
  
  # create a sensible ranking for PartyAb
  m <- voteProps %>%
    group_by(PartyAb) %>%
    summarise(m = mean(prop)) %>%
    arrange(m)
  
  lvls <- as.data.frame(m)$PartyAb
  aec13$PartyAb <- factor(aec13$PartyAb, levels = lvls)
  voteProps$PartyAb <- factor(voteProps$PartyAb, levels = lvls)
  
  # there are multiple brushes in the UI, but they have common properties
  brush_opts <- function(id, ...) {
    brushOpts(id = id, direction = "x", ...)
  }
  
  ui <- fluidPage(
    shinyjs::useShinyjs(),
    fluidRow(
      column(
        width = 1,
        checkboxInput("show", "Show Controls")
      ),
      column(
        width = 1,
        actionButton("clear", "Clear Selections")
      )
    ),
    conditionalPanel(
      "input.show",
      fluidRow(
        column(
          width = 2,
          checkboxInput("persist", "Persistant selections?", FALSE),
          selectInput(
            "color", "Selection color:", 
            choices = c("red", "blue", "yellow", "purple")
          )
        ),
        column(
          width = 6,
          selectizeInput(
            "parties", "Select parties:", unique(eechidna::aec2013_fp$PartyAb), 
            selected = c("ALP", "GRN", "LP", "NP", "CLP", "LNQ"),
            multiple = TRUE
          )
        )
      )
    ),
    fluidRow(
      column(
        width = 4,
        plotlyOutput("voteProps")
      ),
      column(
        width = 4,
        plotlyOutput("winProps")
      ),
      column(
        width = 4,
        plotlyOutput("map")
      )
    ),
    fluidRow(
      column(
        width = 4,
        plotOutput(
          "ages", height = 1500, brush = brush_opts("brushAge")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "densities", height = 2000, brush = brush_opts("brushDen")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "religion", height = 450, brush = brush_opts("brushReligion")
        )
      )
    )
  )
  
  
  server <- function(input, output) {
    
    # initiate selection data and *input brushes* as reactive values so we can
    # "clear the world" - http://stackoverflow.com/questions/30588472/is-it-possible-to-clear-the-brushed-area-of-a-plot-in-shiny/36927826#36927826
    rv <- reactiveValues(
      data = data.frame(
        Electorate = nat_data_cart$Electorate,
        fill = rep("black", nrow(nat_data_cart)),
        stringsAsFactors = FALSE
      )
    )
    
    # clear brush values and remove the div from the page
    observeEvent(input$clear, {
      rv$data$fill <- "black"
      shinyjs::runjs("document.getElementById('ages_brush').remove()")
      shinyjs::runjs("document.getElementById('densities_brush').remove()")
      shinyjs::runjs("document.getElementById('densities_brush').remove()")
    })
    
    observeEvent(input$brushAge, {
      b <- input$brushAge
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$Electorate %in% unique(longAbs[idx, "Electorate"])
      if (input$persist) {
        rv$data$fill[selected] <- input$color
      } else {
        fill <- rv$data$fill
        fill[rv$data$fill %in% input$color] <- "black"
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    })
    
    observeEvent(input$brushReligion, {
      b <- input$brushReligion
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$Electorate %in% unique(longAbs[idx, "Electorate"])
      if (input$persist) {
        rv$data$fill[selected] <- input$color
      } else {
        fill <- rv$data$fill
        fill[rv$data$fill %in% input$color] <- "black"
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    })
    
    observeEvent(input$brushDen, {
      b <- input$brushDen
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$Electorate %in% unique(longAbs[idx, "Electorate"])
      if (input$persist) {
        rv$data$fill[selected] <- input$color
      } else {
        fill <- rv$data$fill
        fill[rv$data$fill %in% input$color] <- "black"
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    })
    
    observeEvent(event_data("plotly_selected"), {
      selected <- rv$data$Electorate %in% event_data("plotly_selected")$key
      if (input$persist) {
        rv$data$fill[selected] <- input$color
      } else {
        fill <- rv$data$fill
        fill[rv$data$fill %in% input$color] <- "black"
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    })
    
    observeEvent(event_data("plotly_click"), {
      selected <- rv$data$Electorate %in% event_data("plotly_click")$key
      if (input$persist) {
        rv$data$fill[selected] <- input$color
      } else {
        fill <- rv$data$fill
        fill[rv$data$fill %in% input$color] <- "black"
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    })
    
    output$winProps <- renderPlotly({
      # total seats by party affliation
      d <- aec13[aec13$PartyAb %in% input$parties, ]
      dat <- left_join(d, rv$data, by = "Electorate")
      wins <- dat %>%
        group_by(PartyAb, fill) %>%
        summarise(nseats = sum(ifelse(Elected == "Y", 1, 0)))
      p <- ggplot(wins, aes(PartyAb, nseats, fill = fill)) + 
        geom_bar(stat = "identity", position = "stack") +
        scale_fill_identity() + theme_bw() + 
        theme(legend.position = "none") + coord_flip() +
        xlab(NULL) + ylab("Number of electorates")
      ggplotly(p, tooltip = "y", source = "B")
    })
    
    output$voteProps <- renderPlotly({
      voteProps <- voteProps[voteProps$PartyAb %in% input$parties, ]
      dat <- dplyr::left_join(voteProps, rv$data, by = "Electorate")
      p <- ggplot(dat, aes(x = PartyAb, y = prop, colour = fill, 
                           key = Electorate, text = Electorate)) + 
        geom_jitter(width = 0.25, alpha = 0.5) +
        scale_colour_identity() + theme_bw() +
        theme(legend.position = "none") + coord_flip() +
        xlab(NULL) + ylab("Proportion of votes")
      ggplotly(p, tooltip = "text") %>% layout(dragmode = "select")
    })
    
    output$ages <- renderPlot({
      dat <- dplyr::left_join(ages, rv$data, by = "Electorate")
      ggplot(dat, aes(value, fill = fill)) +
        geom_dotplot(binwidth = 0.25, dotsize = 1.2) +
        facet_wrap(~ variable, ncol = 1) +
        scale_fill_identity() +
        labs(x = NULL, y = NULL) +
        theme(legend.position = "none") +
        theme_bw()
    })

    output$densities <- renderPlot({
      dat <- dplyr::left_join(other, rv$data, by = "Electorate")
      ggplot(dat, aes(value, fill = fill)) +
        geom_dotplot(dotsize = 0.3) +
        scale_fill_identity() +
        facet_wrap(~variable, scales = "free", ncol = 1) +
        labs(x = NULL, y = NULL) +
        theme(legend.position = "none") +
        theme_bw()
    })

    output$religion <- renderPlot({
      dat <- dplyr::left_join(religion, rv$data, by = "Electorate")
      ggplot(dat, aes(value, fill = fill)) +
        geom_dotplot(dotsize = 0.2) +
        scale_fill_identity() +
        facet_wrap(~variable, ncol = 1) +
        labs(x = NULL, y = NULL) +
        theme(legend.position = "none") +
        theme_bw()
    })

    output$map <- renderPlotly({
      dat <- dplyr::left_join(nat_data_cart, rv$data, by = "Electorate")
      p <- ggplot() +
        geom_polygon(data = eechidna::nat_map,
                     aes(x = long, y = lat, group = group, order = order),
                     fill="grey90", colour="white") +
        geom_point(data = dat,
                   aes(x, y, text = Electorate, key = Electorate, colour = fill)) +
        ggthemes::theme_map() +
        theme(legend.position = "none") +
        scale_color_identity()
      l <- plotly_build(ggplotly(p, tooltip = "text"))
      l$data[[1]]$hoverinfo <- "none"
      l$layout$dragmode <- "select"
      l$layout$autosize <- FALSE
      l$layout$height <- 400
      l$layout$width <- 400
      l$layout$margin <- list(t = 0, b = 0, r = 0, l = 0)
      l
    })
    
  }
  
  shinyApp(ui, server)
}
