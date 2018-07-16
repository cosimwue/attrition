#!/usr/bin/env Rscript

library(shiny)
library(markdown)
library(ggplot2)
library(reshape2)

lanchester <- function(time, size.r, power.r, size.b, power.b) {
  #' Simulates a battle of two sides.
  #'
  #' time: int used to describe the amount of battle rounds/time units.
  #' size.r: int used to describe the size of the side r.
  #' power.r: float used to describe the power of the side r.
  #' size.b: int used to describe the size of the side b.
  #' power.b: float used to describe the power of the side b.
  r.size <- c(size.r)
  b.size <- c(size.b)
  
  for (i in 1:time) {
    if (size.r > 0 & size.b > 0) {
      diff.equa.r <- power.r * size.r
      diff.equa.b <- power.b * size.b
    }
    else {
      break
    }
    
    size.r = size.r - diff.equa.b
    size.b = size.b - diff.equa.r

    r <- size.r
    b <- size.b
    
    r.size <- c(r.size, r)
    b.size <- c(b.size, b)
    }
  return (data.frame(r=r.size, b=b.size, t=1:length(r.size)))
}

prob.osipov <- function(size.def, size.one, power.one, size.two = 0 , power.two = 0) {
  #' Generates the probability for an individual unit to succumb to enemy fire.
  #' The int size.def describes the number of units taking fire,
  #' the int size.one (and size.two) describes the number units firing
  #' the int power.one (and power.two) describes the power of units firing.
  return ((size.one * power.one + size.two * power.two) / size.def)
}

battle.osipov <- function(size, coeff, prob) {
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

osipov <- function(time, size.r, power.r, coeff.r, size.b1, power.b1, coeff.b1, size.b2, 
                   power.b2, coeff.b2) {
  #' Simulates a battle of two sides, current maximum of 2 different units a side.
  #' 
  #' time: int used to describe the amount of battle rounds/time units.
  #' size.r: int used to describe the size of the side r.
  #' power.r: float used to describe the power of the side r.
  #' coeff.r: float used to describe bonus/malus (armour, training, position).
  #' size.b1: int used to describe the size of the first part of the units on side b.
  #' power.b1: float used to describe the power of the first part of the units on side b.
  #' coeff.b1: float used to describe bonus/malus (armour, training, position) of a unit of the first part of side b (maximum = 1).
  #' size.b2: int used to describe the size of the second part of the units on side b (default = 0). 
  #' power.b2: float used to describe the power of the second part of the units on side b (default = 0). 
  #' coeff.b2: float used to describe bonus/malus (armour, training, position) of a unit of the second part of side b (maximum = 1).
  if (coeff.r > 1 | coeff.b1 > 1 | coeff.b2 > 1) {
    stop("Coefficient cannot be > 1, please select a smaller value.")
  }
  r <- size.r
  b <- size.b1 + size.b2
  
  r.size <- c(r)
  b.size <- c(b)
  
  for (i in 1:time) {
    prob.r <- prob.osipov(r, size.b1, power.b1, size.b2, power.b2)
    prob.b <- prob.osipov(b, size.r, power.r)
    
    size.r <- battle.osipov(size.r, coeff.r, prob.r)
    size.b1 <- battle.osipov(size.b1, coeff.b1, prob.b)
    size.b2 <- battle.osipov(size.b2, coeff.b2, prob.b)
    
    r <- size.r
    b <- size.b1 + size.b2
    
    r.size <- c(r.size, r)
    b.size <- c(b.size, b)
    
    if (r == 0 | b == 0) {
      break
    }
  }
  return (data.frame(r=r.size, b=b.size, t=1:length(r.size)))
}

plot.simulation <- function(df) {
  #' Plots the model output
  p <- ggplot(df, aes(x=t, y=value, color=variable))
  p <- p + theme(text = element_text(size=16))
  p <- p + geom_line()
  p <- p + labs(x="Time step", y="Size, in persons")
  p <- p + scale_color_manual("", labels = c("Red", "Blue"), values = c("b" = "#3465A4", "r" = "#CC0000"))
  return(p)
}

ui <- navbarPage("Simulating war",
                 tabPanel("About",
                          includeMarkdown("about.md")
                 ),
                 tabPanel("Lanchester's model",
                          sidebarLayout(
                            sidebarPanel(
                              sliderInput("time.lanchester", "Time steps", 0, 300,
                                          value = 150, step = 1),
                              hr(),
                              numericInput("size.r.lanchester", 
                                           "Size of red", 
                                           value = 1000),
                              numericInput("power.r.lanchester", 
                                           "Power of red", 
                                           value = 0.08),
                              hr(),
                              numericInput("size.b.lanchester", 
                                           "Size of blue", 
                                           value = 800),
                              numericInput("power.b.lanchester", 
                                           "Power of blue", 
                                           value = 0.09)
                            ),
                            mainPanel(
                              plotOutput("plot.lanchester")
                            )
                          )
                        ),
                 tabPanel("Osipov's model",
                          sidebarLayout(
                            sidebarPanel(
                              sliderInput("time.osipov", "Time steps", 0, 300,
                                          value = 150, step = 1),
                              hr(),
                              numericInput("size.r.osipov", 
                                           "Size of red", 
                                           value = 1000),
                              numericInput("power.r.osipov", 
                                           "Power of red", 
                                           value = 0.08),
                              hr(),
                              numericInput("size.b1.osipov", 
                                           "Size of blue", 
                                           value = 800),
                              numericInput("power.b1.osipov", 
                                           "Power of blue", 
                                           value = 0.09)
                            ),
                            mainPanel(
                              plotOutput("plot.osipov")
                            )
                          )
                        )
                 )

server <- function(input, output, session) {
    dfm.lanchester <- reactive({
      df <- lanchester(input$time.lanchester,
                       input$size.r.lanchester,
                       input$power.r.lanchester,
                       input$size.b.lanchester,
                       input$power.b.lanchester)
      return(melt(df, id.vars = "t"))
    })
    
    dfm.osipov <- reactive({
      df <- osipov(input$time.osipov,
                   input$size.r.osipov,
                   input$power.r.osipov,
                   0,
                   input$size.b1.osipov,
                   input$power.b1.osipov,
                   0,
                   0,
                   0,
                   0)
      return(melt(df, id.vars = "t"))
    })
    
    output$plot.lanchester <- renderPlot(
                                plot.simulation(
                                  dfm.lanchester()
                                  )
                                )
    output$plot.osipov <- renderPlot(
                            plot.simulation(
                              dfm.osipov()
                              )
                            )
  }

shinyApp(ui = ui, server = server)