
#API
library(rjson)
library(jsonlite)
library(RCurl)

#WRANGLING
library(tidyverse)
library(dplyr)
library(lubridate)
library(scales)

#VIZ PLOT
library(ggplot2)
library(plotly)
library(ggthemes)
library(paletti)
library(glue)
library(extrafont)
library(RColorBrewer)
library(RColorBrewer)
loadfonts(quiet = T)


# Forecast
library(padr)

# VIZ MAP
library(leaflet)
library(rgdal)
if(!require(geojsonio)) install.packages("geojsonio", repos = "http://cran.us.r-project.org")


#SHINY
#if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
#if(!require(shinycssloaders)) install.packages("shinycssloaders", repos = "http://cran.us.r-project.org")
#if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
#if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")

library(shiny)
library(shinycssloaders)
library(shinyWidgets)
library(shinydashboard)
library(shinythemes)

options(scipen = 1234567)






