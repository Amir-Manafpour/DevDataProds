library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    titlePanel("Predicting MPG based on Weight and Horsepower"),

    sidebarLayout(position = "left",
        sidebarPanel(
            p("This app models and predicts mpg values based on weight of cars. Two models
            are fitted to the data: (1) linear model and (2)model including 2nd order
            terms (i.e. parabolic)."),
            p("The user can also select to add the horsepower (hp) variable in developing
            the models.Otherwise only the weight variable (wt) is considered. When hp is
            included, an hp value needs to be selected to draw the fitted curve/line in
              the graph."),
            p("The prediction results include both models' predictions as well as the
              regression coeffecients for each model. The predicted MPG values are based
              on the hp and wt input values. These prediction values are also plotetd in
              the graph as orange and red dots on the regression lines."),
            h4("Select Regression Modeling Options"),
            checkboxInput("modelhp", "Consider horsepower variable (hp)", value = FALSE),
            conditionalPanel(
                condition = 'input.modelhp',
                sliderInput("hp", "Gross horsepower:", min = 50, max = 340, value = 147)
            ),
            checkboxInput("showlinear", "Show linear regression line", value = FALSE),
            checkboxInput("showparab", "Show 2nd-order regression line", value = TRUE)
        ),

        mainPanel(
            plotlyOutput("mpgPlot"),
            h2("MPG Prediction"),
            fluidRow(
                column(3, sliderInput("wt", "Select weight (1000 lbs):", min = 1.5, max = 5.5, value = 3.21)),
                column(3,offset = 1, 
                       h4("Predicted MPG"),
                       textOutput("predictmpg"),
                       textOutput("predictmpgparab")
                       ),
                column(2,
                       h4("Linear model"),
                       tableOutput("linearcoeffs"),
                       ),
                column(2,
                       h4("2nd order model"),
                       tableOutput("parabcoeffs")
                       )
            ),
        )
    )
))
