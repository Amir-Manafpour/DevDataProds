library(shiny)
library(plotly)

shinyServer(function(input, output, session) {
    data("mtcars"); df <- mtcars
    
    mdl <- function(modelhp, parab = FALSE) {
        if(modelhp){
            if(parab){
                params <- mpg ~ wt + hp + I(wt^2) + I(hp^2)
            } else {
                params <- mpg ~ wt + hp
            }
        } else {
            if(parab){
                params <- mpg ~ wt + I(wt^2)
            } else {
                params <- mpg ~ wt
            }
        }
        lm(params, data = df)
    }
    
    predicts <- function(modelhp, inputhp, parab = FALSE){
        selected.mdl <- mdl(modelhp, parab)
        if(modelhp){
            newdf <- df
            newdf$hp <- inputhp
            predict(selected.mdl, newdata = newdf)
        } else {
            predict(selected.mdl)
        } 
    }
    
    mpg.predict <- function(inputwt, modelhp, inputhp, parab = FALSE){
        selected.mdl <- mdl(modelhp, parab)
        if(modelhp){
            newdf <- data.frame(wt = inputwt, hp = inputhp)
        } else {
            newdf <- data.frame(wt = inputwt)
        }
        predict(selected.mdl, newdata = newdf)
    }
    
    output$mpgPlot <- renderPlotly({
        df$predict <- predicts(input$modelhp, input$hp)
        df$predictParab <- predicts(input$modelhp, input$hp, parab = TRUE)
        gg <- ggplot(data = df, aes(x = wt, y = mpg)) +
            geom_point(aes(color = hp)) +
            xlab("Weight (1000 lbs)") +
            ylab("Miles per gallon") +
            labs(col = "Horsepower")
        if(input$showlinear){
            gg <- gg +
                geom_line(aes(y=predict)) +
                geom_point(aes(input$wt, mpg.predict(input$wt, input$modelhp, input$hp, parab = FALSE)), color = "red", size = 3)
        }
        if(input$showparab) {
            gg <- gg + 
                geom_line(aes(y=predictParab)) +
                geom_point(aes(input$wt, mpg.predict(input$wt, input$modelhp, input$hp, parab = TRUE)), color = "orange", size = 3)
        }
        ggplotly(gg)
    })
    
    output$predictmpg <- renderText({
        num <- round(mpg.predict(input$wt, input$modelhp, input$hp, parab = FALSE),1)
        paste(num, " (linear model)")
    })
    
    output$predictmpgparab <- renderText({
        num <- round(mpg.predict(input$wt, input$modelhp, input$hp, parab = TRUE),1)
        paste(num, "(2nd order model)")
    })
    
    output$linearcoeffs <- renderTable({
        mdlcoefs <- mdl(input$modelhp, parab = F)$coef
        data.frame(coefficient = names(mdlcoefs),
                   value = mdlcoefs)
    })
    
    output$parabcoeffs <- renderTable({
        mdlcoefs <- mdl(input$modelhp, parab = T)$coef
        data.frame(coefficient = names(mdlcoefs),
                   value = mdlcoefs)
    })
})
