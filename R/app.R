#' Shiny app for exploring census and electorate data
#' 
#' @param age Age variables to show (by default, all of them are shown)
#' @param religion Religion variables to show (by default, all of them are shown)
#' @param other Other census variables to show (by default, all of them are shown)
#' @param palette a named character vector of selection colors. The vector names
#' are used as the display in the drop-down control.
#' @author Carson Sievert
#' @export
#' @examples \dontrun{
#' launchApp(
#'   age = c("Age20_24", "Age85plus"),
#'   religion = c("Christianity", "Catholic", "NoReligion"),
#'   other = c("Unemployed", "Population", "MedianIncome")
#' )
#' }

launchApp <- function(
  age = c("Age00_04", "Age05_14", "Age15_19", "Age20_24", "Age25_34", 
              "Age35_44", "Age45_54", "Age55_64", "Age65_74",  "Age75_84",  
              "Age85plus"),
  religion = c("Christianity", "Catholic", "Buddhism", "Islam", "Judaism", "NoReligion"),
  other = c("Population", "MedianIncome", "Unemployed", "Bachelor", "Postgraduate", "BornOverseas",
            "Indigenous", "EnglishOnly", "OtherLanguageHome", "Married", 
            "DeFacto", "FamilyRatio", "Internet", "NotOwned"),
  palette = c("forest" = "#1b9e77", "pink" = "#f0027f", "yellow" = "#e6ab02",
    "green" = "#66a61e", "violet" = "#7570b3", "orange" = "#d95f02", "blue" = "#3690c0")
  ) {
  # a bit of data cleaning
  nat_data_cart <- eechidna::nat_data_cart
  nat_data_cart$Electorate <- nat_data_cart$ELECT_DIV
  abs2011 <- eechidna::abs2011[c("ID", "Electorate", "State", age, religion, other)]
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
  isReg <- longAbs$variable %in% religion
  religion <- longAbs[isReg, ]
  other <- longAbs[!isAge & !isReg, ]
  
  # 1st preference votes for candidates for the House for each electorate
  aec13 <- as.data.frame(eechidna::aec2013_fp_electorate)
  
  # by default, we show parties that won at least 1 electorate
  relevantParties <- aec13 %>% 
    group_by(PartyAb) %>% 
    summarise(n = sum(ifelse(Elected == "Y", 1, 0))) %>% 
    filter(n > 0)
  
  # proportion of first preference votes for each party by electorate
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
  
  # 2 party preferred data
  aec13pp <- data.frame(eechidna::aec2013_2pp_electorate)
  aec13pp <- aec13pp %>% 
    mutate(difference = Average_Australian_Labor_Party_Percentage_in_electorate - 
             Average_Liberal_National_Coalition_Percentage_in_electorate) %>%
    select(Electorate, difference) %>%
    arrange(abs(difference)) %>%
    mutate(Electorate = factor(Electorate, levels = Electorate))
  
  # there are multiple brushes in the UI, but they have common properties
  brush_opts <- function(id, ...) {
    brushOpts(id = id, direction = "x", resetOnNew = TRUE, ...)
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
          selectInput("color", "Selection color:", choices = palette)
        ),
        column(
          width = 6,
          selectizeInput(
            "parties", "Select parties:", unique(eechidna::aec2013_fp$PartyAb), 
            selected = relevantParties$PartyAb,
            multiple = TRUE
          )
        )
      )
    ),
    fluidRow(
      column(
        width = 2,
        plotlyOutput("winProps")
      ),
      column(
        width = 3,
        plotlyOutput("pp")
      ),
      column(
        width = 3,
        plotlyOutput("voteProps")
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
          "ages", height = 150 * length(age), brush = brush_opts("brushAge")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "densities", height = 100 * length(other), brush = brush_opts("brushDen")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "religion", height = 100 * length(religion), brush = brush_opts("brushReligion")
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
        fill = factor(rep("black", nrow(nat_data_cart)), levels = c("black", as.character(palette))),
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
    
    # reusable function for "telling the world" about the selection
    # it should modify the reactive value _once_ since shiny will send messages
    # on every modification
    updateRV <- function(selected) {
      if (input$persist) {
        rv$data$fill[selected] <- input$color
      } else {
        fill <- rv$data$fill
        fill[rv$data$fill %in% input$color] <- "black"
        print(input$color)
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    }
    
    observeEvent(input$brushAge, {
      b <- input$brushAge
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$Electorate %in% unique(longAbs[idx, "Electorate"])
      updateRV(selected)
    })
    
    observeEvent(input$brushReligion, {
      b <- input$brushReligion
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$Electorate %in% unique(longAbs[idx, "Electorate"])
      updateRV(selected)
    })
    
    observeEvent(input$brushDen, {
      b <- input$brushDen
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$Electorate %in% unique(longAbs[idx, "Electorate"])
      updateRV(selected)
    })
    
    observeEvent(event_data("plotly_selected"), {
      selected <- rv$data$Electorate %in% event_data("plotly_selected")$key
      updateRV(selected)
    })
    
    observeEvent(event_data("plotly_click"), {
      k <- event_data("plotly_click")$key
      if (any(k %in% unique(aec13$PartyAb))) {
        # map the party selection back to electorates
        d <- aec13 %>% filter(Elected == "Y")
        d <- d[match(rv$data$Electorate, d$Electorate), ]
        selected <- d$PartyAb %in% k
      } else {
        selected <- rv$data$Electorate %in% k
      }
      updateRV(selected)
  })
    
    output$winProps <- renderPlotly({
      # total seats by party affliation
      d <- aec13[aec13$PartyAb %in% input$parties, ]
      dat <- left_join(d, rv$data, by = "Electorate")
      wins <- dat %>%
        group_by(PartyAb, PartyNm, fill) %>%
        summarise(nseats = sum(ifelse(Elected == "Y", 1, 0)))
      p <- ggplot(wins, aes(PartyAb, nseats, 
                            fill = fill, text = PartyNm, key = PartyAb)) + 
        geom_bar(stat = "identity", position = "stack") +
        scale_fill_identity() + theme_bw() + 
        theme(legend.position = "none") + coord_flip() +
        xlab(NULL) + ylab("Number of electorates")
      ggplotly(p, tooltip = "text")
    })
    
    output$voteProps <- renderPlotly({
      voteProps <- voteProps[voteProps$PartyAb %in% input$parties, ]
      dat <- dplyr::left_join(voteProps, rv$data, by = "Electorate")
      p <- ggplot(dat, aes(x = PartyAb, y = prop, colour = fill, 
                           key = Electorate, text = Electorate)) + 
        #geom_jitter(width = 0.25, alpha = 0.5) +
        geom_line(aes(group = Electorate), alpha = 0.5) +
        geom_point(alpha = 0.5, size = 0.001) +
        scale_colour_identity() + theme_bw() +
        theme(legend.position = "none") + coord_flip() +
        xlab(NULL) + ylab("Proportion of votes")
      ggplotly(p, tooltip = "text") %>% layout(dragmode = "select")
    })
    
    output$pp <- renderPlotly({
      dat <- dplyr::left_join(aec13pp, rv$data, by = "Electorate")
      dat$Electorate <- factor(dat$Electorate, levels = levels(aec13pp$Electorate))
      p <- ggplot(dat, aes(difference, Electorate, colour = fill,
                      key = Electorate, text = Electorate)) + 
        scale_colour_identity() + theme_bw() +
        theme(legend.position = "none") +
        geom_point() + ylab(NULL) + 
        xlab(" <- Coalition   Labor ->") + 
        theme(axis.text.y = element_blank(), 
              axis.ticks.y = element_blank(),
              panel.grid.major.y = element_blank())
      ggplotly(p, tooltip = "text") %>% layout(dragmode = "select")
    })
    
    output$ages <- renderPlot({
      dat <- dplyr::left_join(ages, rv$data, by = "Electorate")
      ggplot(dat, aes(value, fill = fill)) +
        geom_dotplot(binwidth = 0.25, dotsize = 1.2, alpha = 0.4) +
        facet_wrap(~ variable, ncol = 1) +
        scale_fill_identity() +
        labs(x = NULL, y = NULL) +
        theme(legend.position = "none") +
        theme_bw()
    })

    output$densities <- renderPlot({
      dat <- dplyr::left_join(other, rv$data, by = "Electorate")
      ggplot(dat, aes(value, fill = fill)) +
        geom_dotplot(dotsize = 0.5) +
        scale_fill_identity() +
        facet_wrap(~variable, scales = "free", ncol = 1) +
        labs(x = NULL, y = NULL) +
        theme(legend.position = "none") +
        theme_bw()
    })

    output$religion <- renderPlot({
      dat <- dplyr::left_join(religion, rv$data, by = "Electorate")
      ggplot(dat, aes(value, fill = fill)) +
        geom_dotplot(dotsize = 0.5) +
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
