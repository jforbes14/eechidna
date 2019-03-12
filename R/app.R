#' Shiny app for exploring census and electorate data
#' 
#' @param election_year Year of Federal election to be explored (2001, 2004, 2007, 2010, 2013 or 2016)
#' @param age Age variables to show. Variable(s) should match column names from
#' \link{abs2016}. By default, all variables are shown.
#' @param religion Religion variables to show. Variable(s) should match column 
#' names from \link{abs2016}. By default, all variables are shown.
#' @param other Other census variables to show. Variable(s) should match column 
#' names from \link{abs2016}. By default, all variables are shown.
#' @param palette a named character vector of selection colors. The vector names
#' are used as the display in the drop-down control.
#' @author Carson Sievert
#' @export
#' @examples \dontrun{
#' library(shiny)
#' library(plotly)
#' library(tidyverse)
#' # for comparing labor/liberal
#' launch_app(
#'   election_year = 2016,
#'   age = c("Age20_24", "Age25_34", "Age55_64"),
#'   religion = c("Christianity", "Catholic", "NoReligion"),
#'   other = c("AusCitizen", "MedianPersonalIncome", "Unemployed")
#' )
#' 
#' # for inspecting highly contested areas
#' launch_app(
#'   election_year = 2016,
#'   age = c("Age25_34", "Age35_44", "Age55_64"),
#'   religion = c("Christianity", "Catholic", "NoReligion"),
#'   other = c("Owned", "Indigenous", "AusCitizen")
#' )
#' 
#' launch_app()
#' 
#' }

launch_app <- function(
  election_year = 2016,
  age = c("Age00_04", "Age05_14", "Age15_19", "Age20_24", "Age25_34", 
    "Age35_44", "Age45_54", "Age55_64", "Age65_74",  "Age75_84",  
    "Age85plus"),
  religion = c("Christianity", "Catholic", "Buddhism", "Islam", "Judaism", "NoReligion"),
  other = c("AusCitizen", "MedianPersonalIncome", "Unemployed", "BachelorAbv",
    "Indigenous", "EnglishOnly", "OtherLanguageHome", "Married", 
    "DeFacto", "FamilyRatio", "Owned"),
  palette = c('#1B9E77', '#F0027F', '#E6AB02', '#66A61E', '#7570B3', '#D95F02', '#3690C0')
) {
  election_year = as.numeric(election_year)
  
  if (!as.numeric(election_year) %in% c(2001, 2004, 2007, 2010, 2013, 2016)) {
    warning("Election year enter is not valid. Year must be one of 2001, 2004, 2007, 2010, 2013 and 2016. 
      Using 2016 by default.")
    election_year = 2016
  }
  
  # 1st preference votes for candidates for the House for each electorate
  if (election_year == 2001) {
    fp_data <- as.data.frame(eechidna::fp01)
    tcp_data <- as.data.frame(eechidna::tcp01)
    nat_data <- as.data.frame(eechidna::nat_data01)
    nat_map <- as.data.frame(eechidna::nat_map01)
    abs_data <- as.data.frame(eechidna::abs2001)
  } else if (election_year == 2004) {
    fp_data <- as.data.frame(eechidna::fp04)
    tcp_data <- as.data.frame(eechidna::tcp04)
    nat_data <- as.data.frame(eechidna::nat_data04)
    nat_map <- as.data.frame(eechidna::nat_map04)
    abs_data <- as.data.frame(eechidna::abs2004)
  } else if (election_year == 2007) {
    fp_data <- as.data.frame(eechidna::fp07)
    tcp_data <- as.data.frame(eechidna::tcp07)
    nat_data <- as.data.frame(eechidna::nat_data07)
    nat_map <- as.data.frame(eechidna::nat_map07)
    abs_data <- as.data.frame(eechidna::abs2007)
  } else if (election_year == 2010) {
    fp_data <- as.data.frame(eechidna::fp10)
    tcp_data <- as.data.frame(eechidna::tcp10)
    nat_data <- as.data.frame(eechidna::nat_data10)
    nat_map <- as.data.frame(eechidna::nat_map10)
    abs_data <- as.data.frame(eechidna::abs2010)
  } else if (election_year == 2013) {
    fp_data <- as.data.frame(eechidna::fp13)
    tcp_data <- as.data.frame(eechidna::tcp13)
    nat_data <- as.data.frame(eechidna::nat_data13)
    nat_map <- as.data.frame(eechidna::nat_map13)
    abs_data <- as.data.frame(eechidna::abs2013)
  } else if (election_year == 2016) {
    fp_data <- as.data.frame(eechidna::fp16)
    tcp_data <- as.data.frame(eechidna::tcp16)
    nat_data <- as.data.frame(eechidna::nat_data16)
    nat_map <- as.data.frame(eechidna::nat_map16)
    abs_data <- as.data.frame(eechidna::abs2016)
  }
    
  
  # by default, we show parties that won at least 1 electorate
  relevantParties <- fp_data %>% 
    group_by(PartyAb) %>% 
    summarise(n = sum(ifelse(Elected == "Y", 1, 0))) %>% 
    filter(n > 0)
  
  # proportion of first preference votes for each party by electorate
  if ("OrdinaryVotes" %in% names(fp_data)) {
    voteProps <- fp_data %>%
      group_by(DivisionNm, PartyAb) %>%
      summarise(n = sum(OrdinaryVotes)) %>%
      mutate(prop = n / sum(n))
  } else {
    voteProps <- fp_data %>%
      group_by(DivisionNm, PartyAb) %>%
      summarise(prop = sum(Percent))
  }
  
  
  # create a sensible ranking for PartyAb
  m <- voteProps %>%
    group_by(PartyAb) %>%
    summarise(m = mean(prop)) %>%
    arrange(m)
  
  lvls <- as.data.frame(m)$PartyAb
  fp_data$PartyAb <- factor(fp_data$PartyAb, levels = lvls)
  voteProps$PartyAb <- factor(voteProps$PartyAb, levels = lvls)
  
  # 2 candidate preferred data
  if ("OrdinaryVotes" %in% names(tcp_data)) {
    tcp_data <- tcp_data %>% 
      mutate(FullName = paste(GivenNm, Surname)) %>%
      group_by(DivisionNm) %>% 
      summarise(
        difference = abs(diff(OrdinaryVotes) / sum(OrdinaryVotes)),
        parties = paste(PartyAb[order(OrdinaryVotes, decreasing = TRUE)], collapse = " over "),
        candidates = paste(FullName[order(OrdinaryVotes, decreasing = TRUE)], collapse = " over ")
      ) %>%
      arrange(difference) %>%
      mutate(DivisionNm = factor(DivisionNm, levels = DivisionNm)) %>%
      mutate(tooltip = paste0(DivisionNm, "<br />", parties, "<br />", candidates))
  } else {
    tcp_data <- tcp_data %>%
      mutate(FullName = paste(GivenNm, Surname)) %>%
      group_by(DivisionNm) %>% 
      summarise(
        difference = abs(diff(Percent) / sum(Percent)),
        parties = paste(PartyAb[order(Percent, decreasing = TRUE)], collapse = " over "),
        candidates = paste(FullName[order(Percent, decreasing = TRUE)], collapse = " over ")
      ) %>%
      arrange(difference) %>%
      mutate(DivisionNm = factor(DivisionNm, levels = DivisionNm)) %>%
      mutate(tooltip = paste0(DivisionNm, "<br />", parties, "<br />", candidates))
  }
 
  
  
  # a bit of data cleaning
  nat_data$DivisionNm <- nat_data$elect_div
  abs_data <- abs_data[c("DivisionNm", age, religion, other)]
  abs_data <- dplyr::semi_join(abs_data, fp_data, by = "DivisionNm")
  longAbs <- tidyr::gather(
    abs_data, variable, value, -DivisionNm
  )
  longAbs$value <- as.numeric(longAbs$value)
  longAbs <- longAbs[!is.na(longAbs$value),]
  longAbs$variable <- factor(
    longAbs$variable, 
    levels = unique(longAbs$variable)
  )
  isAge <- grepl("^Age", longAbs$variable)
  ageDat <- longAbs[isAge, ]
  isReg <- longAbs$variable %in% religion
  religionDat <- longAbs[isReg, ]
  otherDat <- longAbs[!isAge & !isReg, ]
  
  
  
  # there are multiple brushes in the UI, but they have common properties
  brush_opts <- function(id, ...) {
    brushOpts(id = id, direction = "x", resetOnNew = TRUE, ...)
  }
  
  ui <- fluidPage(
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
          checkboxInput("persist", "Persistant selections?", TRUE),
          colourpicker::colourInput("color", "Selection color:", palette = "limited", allowedCols = palette)
        ),
        column(
          width = 6,
          selectizeInput(
            "parties", "Select parties:", unique(fp_data), 
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
          "religion", height = 150 * length(religion), brush = brush_opts("brushReligion")
        )
      ),
      column(
        width = 4,
        plotOutput(
          "densities", height = 150 * length(other), brush = brush_opts("brushDen")
        )
      )
    )
  )
  
  
  server <- function(input, output, session) {
    
    # initiate selection data and *input brushes* as reactive values so we can
    # "clear the world" - http://stackoverflow.com/questions/30588472/is-it-possible-to-clear-the-brushed-area-of-a-plot-in-shiny/36927826#36927826
    rv <- reactiveValues(
      data = data.frame(
        DivisionNm = nat_data$DivisionNm,
        fill = factor(rep("black", nrow(nat_data)), levels = c("black", palette)),
        stringsAsFactors = FALSE
      )
    )
    
    # clear brush values and remove the div from the page
    observeEvent(input$clear, {
      rv$data$fill <- "black"
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
        fill[selected] <- input$color
        rv$data$fill <- fill
      }
    }
    
    observeEvent(input$brushAge, {
      b <- input$brushAge
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$DivisionNm %in% unique(longAbs[idx, "DivisionNm"])
      updateRV(selected)
    })
    
    observeEvent(input$brushReligion, {
      b <- input$brushReligion
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$DivisionNm %in% unique(longAbs[idx, "DivisionNm"])
      updateRV(selected)
    })
    
    observeEvent(input$brushDen, {
      b <- input$brushDen
      idx <- (b$xmin <= longAbs$value & longAbs$value <= b$xmax) &
        (longAbs$variable %in% b$panelvar1)
      selected <- rv$data$DivisionNm %in% unique(longAbs[idx, "DivisionNm"])
      updateRV(selected)
    })
    
    observeEvent(event_data("plotly_selected"), {
      selected <- rv$data$DivisionNm %in% event_data("plotly_selected")$key
      updateRV(selected)
    })
    
    observeEvent(event_data("plotly_click"), {
      k <- event_data("plotly_click")$key
      if (any(k %in% unique(fp_data$PartyAb))) {
        # map the party selection back to DivisionNms
        d <- fp_data %>% filter(Elected == "Y")
        d <- d[match(rv$data$DivisionNm, d$DivisionNm), ]
        selected <- d$PartyAb %in% k
      } else {
        selected <- rv$data$DivisionNm %in% k
      }
      updateRV(selected)
    })
    
    output$winProps <- renderPlotly({
      # total seats by party affliation
      d <- fp_data[fp_data$PartyAb %in% input$parties, ]
      dat <- left_join(d, rv$data, by = "DivisionNm")
      wins <- dat %>%
        group_by(PartyAb, PartyNm, fill) %>%
        summarise(nseats = sum(ifelse(Elected == "Y", 1, 0)))
      
      p <- ggplot(wins, aes(PartyAb, nseats, 
        fill = fill, text = PartyNm, key = PartyAb)) + 
        geom_bar(stat = "identity", position = "stack") +
        scale_fill_identity() + theme_bw() + 
        theme(legend.position = "none") + coord_flip() +
        xlab(NULL) + ylab("Number of electorates")
      ggplotly(p, tooltip = "text") %>% 
        #layout(hovermode = "x") %>% 
        plotly::config(collaborate = F, cloud = F, displaylogo = F)
    })
    
    output$voteProps <- renderPlotly({
      voteProps <- voteProps[voteProps$PartyAb %in% input$parties, ]
      dat <- dplyr::left_join(voteProps, rv$data, by = "DivisionNm") %>% dplyr::ungroup()
      p <- ggplot(dat, aes(x = PartyAb, y = prop, colour = fill, 
        key = DivisionNm, text = DivisionNm)) + 
        #geom_jitter(width = 0.25, alpha = 0.5) +
        geom_line(aes(group = DivisionNm), alpha = 0.2) +
        geom_point(alpha = 0.5, size = 0.001) +
        scale_colour_identity() + theme_bw() +
        theme(legend.position = "none") + coord_flip() +
        xlab(NULL) + ylab("Proportion of 1st preferences")
      ggplotly(p, tooltip = "text") %>% layout(dragmode = "select")
    })
    
    output$pp <- renderPlotly({
      dat <- dplyr::left_join(tcp_data, rv$data, by = "DivisionNm")
      dat$DivisionNm <- factor(dat$DivisionNm, levels = levels(tcp_data$DivisionNm))
      p <- ggplot(dat, aes(difference, DivisionNm, colour = fill,
        key = DivisionNm, text = tooltip)) + 
        scale_colour_identity() + theme_bw() +
        theme(legend.position = "none") +
        geom_point(alpha = 0.5) + ylab(NULL) + 
        xlab("Absolute difference in vote totals") + 
        theme(axis.text.y = element_blank(), 
          axis.ticks.y = element_blank(),
          panel.grid.major.y = element_blank())
      ggplotly(p, tooltip = "text") %>% layout(dragmode = "select")
    })
    
    output$ages <- renderPlot({
      dat <- left_join(ageDat, rv$data, by = "DivisionNm")
      means <- summarise(group_by(dat, variable, fill), m = mean(value))
      dat <- left_join(dat, means, by = c("variable", "fill"))
      ggplot(dat, aes(value, fill = fill)) +
        geom_density(alpha = 0.3) +
        geom_vline(aes(xintercept = m, colour = fill)) +
        facet_wrap(~ variable, scales = "free_y", ncol = 1) +
        scale_fill_identity() + scale_colour_identity() +
        labs(x = NULL, y = NULL) +
        theme_bw() +
        theme(
          legend.position = "none", 
          axis.text = element_text(size = 16),
          strip.text = element_text(size = 16)
        )
    })
    
    output$densities <- renderPlot({
      dat <- dplyr::left_join(otherDat, rv$data, by = "DivisionNm")
      means <- summarise(group_by(dat, variable, fill), m = mean(value))
      dat <- left_join(dat, means, by = c("variable", "fill"))
      ggplot(dat, aes(value, fill = fill)) +
        geom_density(alpha = 0.3) +
        geom_vline(aes(xintercept = m, colour = fill)) +
        scale_fill_identity() + scale_colour_identity() +
        facet_wrap(~variable, scales = "free", ncol = 1) +
        labs(x = NULL, y = NULL) +
        theme_bw() +
        theme(
          legend.position = "none", 
          axis.text = element_text(size = 16),
          strip.text = element_text(size = 16)
        )
      
    })
    
    output$religion <- renderPlot({
      dat <- dplyr::left_join(religionDat, rv$data, by = "DivisionNm")
      means <- summarise(group_by(dat, variable, fill), m = mean(value))
      dat <- left_join(dat, means, by = c("variable", "fill"))
      ggplot(dat, aes(value, fill = fill)) +
        geom_density(alpha = 0.3) +
        geom_vline(aes(xintercept = m, colour = fill)) +
        scale_fill_identity() + scale_colour_identity() +
        facet_wrap(~variable, scales = "free_y", ncol = 1) +
        labs(x = NULL, y = NULL) +
        theme_bw() +
        theme(
          legend.position = "none", 
          axis.text = element_text(size = 16),
          strip.text = element_text(size = 16)
        )
    })
    
    output$map <- renderPlotly({
      dat <- dplyr::left_join(nat_data, rv$data, by = "DivisionNm")
      p <- ggplot() +
        geom_polygon(data = nat_map,
          aes(x = long, y = lat, group = group, order = order),
          fill="grey90", colour="white") +
        geom_point(data = dat, alpha = 0.5,
          aes(x, y, text = DivisionNm, key = DivisionNm, colour = fill)) +
        ggthemes::theme_map() +
        theme(legend.position = "none") +
        scale_color_identity()
      
      mapRatio <- with(nat_map, diff(range(long)) / diff(range(lat)))
      p %>% ggplotly(tooltip = "text", height = 400, width = 400 * mapRatio) %>% 
        style(hoverinfo = "none", traces = 1)
    })
    
  }
  
  shinyApp(ui, server)
}
