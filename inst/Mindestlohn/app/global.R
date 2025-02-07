library(RTutor)
library(ggplot2)
library(haven)
library(stargazer)
library(sandwich)
library(ggdag)
library(lfe)
library(broom)

# does not seem to work anymore on shinyapps.io
#setwd("./work") 
app =  show.ps(user.name="Guest", ps.name="Mindestlohn", make.web.app=TRUE, save.nothing=FALSE, offline=FALSE)

app$verbose = FALSE
appReadyToRun(app)

#shinyApp(ui = app$ui, server = app$server)
#runEventsApp(app)
