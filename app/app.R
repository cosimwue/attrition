#!/usr/bin/env Rscript

library(shiny)
library(ggplot2)
library(reshape2)

prob <- function(size.def, size.one, power.one, size.two = 0 , power.two = 0) {
  #' Generates the probability for an individual unit to succumb to enemy fire.
  #' The int size.def describes the number of units taking fire,
  #' the int size.one (and size.two) describes the number units firing
  #' the int power.one (and power.two) describes the power of units firing.
  return ((size.one * power.one + size.two * power.two) / size.def)
}

battle <- function(size, coeff, prob) {
  #' Uses a randomized roll for every unit do determine whether it dies or not.
  #' The int size describes the number of units taking fire,
  #' the float coeff describes a special bonus/malus (armour, position, training) for a unit,
  #' the float prob describes the probability of death for a unit.
  temp <- 0
  for (j in 1:size) {
    if ((prob - coeff * prob) >= runif(1, 0, 1)) {
      temp <- temp + 1
    }
    newsize <- size - temp
    if (newsize < 0) {
      newsize <- 0
    }
  }
  return (newsize)
}

warsim <- function(size.r1, power.r1, size.b1, power.b1, time, coeff.r1, coeff.b1, size.r2,
                   power.r2, coeff.r2, size.b2, power.b2, coeff.b2) {
  #' Simulates a battle of two sides, current maximum of 2 different units a side.
  #' 
  #' size_r1: int used to describe the size of the first part of the units on side r.
  #' power_r1: float used to describe the power of the first part of the units on side r.
  #' size_b1: int used to describe the size of the first part of the units on side b.
  #' power_b1: float used to describe the power of the first part of the units on side b.
  #' time: int used to describe the amount of battle rounds/time units.
  #' coeff_r1: float used to describe bonus/malus (armour, training, position)
  #'   of a unit of the first part of side r (maximum = 1).
  #' coeff_b1: float used to describe bonus/malus (armour, training, position)
  #'   of a unit of the first part of side b (maximum = 1).
  #' size_r2: int used to describe the size of the second part of the units on side r (default = 0). 
  #' power_r2: float used to describe the power of the second part of the units on side r (default = 0). 
  #' coeff_r2: float used to describe bonus/malus (armour, training, position)
  #'   of a unit of the second part of side r (maximum = 1).
  #' size_b2: int used to describe the size of the second part of the units on side b (default = 0). 
  #' power_b2: float used to describe the power of the second part of the units on side b (default = 0). 
  #' coeff_b2: float used to describe bonus/malus (armour, training, position)
  #'   of a unit of the second part of side b (maximum = 1).
  if (coeff.r1 > 1 | coeff.b1 > 1 | coeff.r2 > 1 | coeff.b2 > 1) {
    stop("Coefficient cannot be > 1, please select a smaller value.")
  }
  r <- size.r1 + size.r2
  b <- size.b1 + size.b2
  
  r.size <- c(r)
  b.size <- c(b)
  
  for (i in 1:time) {
    prob.r <- prob(r, size.b1, power.b1, size.b2, power.b2)
    prob.b <- prob(b, size.r1, power.r1, size.r2, power.r2)
    
    size.r1 <- battle(size.r1, coeff.r1, prob.r)
    size.r2 <- battle(size.r2, coeff.r2, prob.r)
    size.b1 <- battle(size.b1, coeff.b1, prob.b)
    size.b2 <- battle(size.b2, coeff.b2, prob.b)
    
    r <- size.r1 + size.r2
    b <- size.b1 + size.b2
    
    r.size <- c(r.size, r)
    b.size <- c(b.size, b)
    
    if (r == 0 | b == 0) {
      break
    }
  }
  return (data.frame(r=r.size, b=b.size, t=1:length(r.size)))
}

ui <- fluidPage(
  title = "Simulating war",
  
  h1("Simulating war"),

  div(plotOutput('plot'), style="width: 70%; margin: 0 auto;"),
  
  br(),
  
  wellPanel(
    sliderInput("time", "Time steps", 10, 200,
                value = 100, step = 10)
  ),
  
  fluidRow(
    column(3,
           h3("Red: Unit 1"),
           numericInput("size.r1", 
                        span("Size", style="font-weight: normal;"), 
                        value = 500),
           numericInput("power.r1", 
                        span("Power", style="font-weight: normal;"), 
                        value = 0.02),
           numericInput("coeff.r1",
                        span("Bonus/malus", style="font-weight: normal;"), 
                        value = 0)
    ),
    column(3,
           h3("Red: Unit 2"),
           numericInput("size.r2", 
                        span("Size", style="font-weight: normal;"), 
                        value = 0),
           numericInput("power.r2", 
                        span("Power", style="font-weight: normal;"), 
                        value = 0),
           numericInput("coeff.r2", 
                        span("Bonus/malus", style="font-weight: normal;"), 
                        value = 0)
    ),
    column(3,
           h3("Blue: Unit 1"),
           numericInput("size.b1", 
                        span("Size", style="font-weight: normal;"), 
                        value = 1000),
           numericInput("power.b1", 
                        span("Power", style="font-weight: normal;"), 
                        value = 0.01),
           numericInput("coeff.b1", 
                        span("Bonus/malus", style="font-weight: normal;"), 
                        value = 0)
    ),
    column(3,
           h3("Blue: Unit 2"),
           numericInput("size.b2", 
                        span("Size", style="font-weight: normal;"), 
                        value = 0),
           numericInput("power.b2",
                        span("Power", style="font-weight: normal;"), 
                        value = 0),
           numericInput("coeff.b2", 
                        span("Bonus", style="font-weight: normal;"), 
                        value = 0)
    )
  ),
  span("© 2018, CC BY-SA 4.0, Backend: Ralf Babl, Frontend: Severin Simmler.", style="font-size: 10px; text-align: right;")
)

server <- function(input, output) {
  dfm <- reactive({
    df <- warsim(input$size.r1, input$power.r1, input$size.b1, input$power.b1, input$time,
                 input$coeff.r1, input$coeff.b1, input$size.r2, input$power.r2, input$coeff.r2,
                 input$size.b2, input$power.b2, input$coeff.b2)
    return(melt(df, id.vars = "t"))
  })
  
  output$plot <- renderPlot({
    p <- ggplot(dfm(), aes(x=t, y=value, color=variable))
    p <- p + theme(text = element_text(size=16))
    p <- p + geom_line()
    p <- p + labs(x="Time step", y="Size, in persons")
    p <- p + scale_color_manual("", labels = c("Blue units", "Red units"), values = c("#3465A4", "#CC0000"))
    return(p)
  })
}

shinyApp(ui = ui, server = server)