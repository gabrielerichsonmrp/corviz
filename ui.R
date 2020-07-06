head <- tags$head(
    tags$style(HTML('.info-box {min-height: 60px;}
                                  .info-box-icon {
                                        height: 60px; 
                                        width: 60px; line-height: 60px; 
                                        font-size: 24px;
                                  } 
                                  .info-box-content {
                                        font-size: 50%; 
                                        padding-top: 10px; 
                                        padding-bottom: 4px; 
                                        margin-left: 60px;
                                  }
                                  '
                    
                    
    )),
    tags$link(rel = "icon", 
              type = "image/png", 
              href = "icon_yellow_100.png")
)


navbarPage <- navbarPage(
    
    theme = shinytheme("flatly"), 
    collapsible = TRUE,
    title = "CORVIZ",
    id="nav",
    
    tabPanel("COVID-19 Global",
             tags$head(includeCSS("styles.css")),
             fluidRow(
                 column(
                     id="tes", width=3,
                     id = "controls", 
					 class = "panel panel-default",
                     
                     p(class="title","Coronavirus Pandemic"),
                     tags$i(h5(withSpinner(textOutput("txt_last_update"),type=7, color="#e6c0a0", size=0.2,proxy.height=200), align = "left")),
                     hr(),
                     
                     
                     p("Coronavirus Cases:",align = "center"),
                     h1(withSpinner(textOutput("txt_total_cases"),type=7, color="#e6c0a0", size=0.3,proxy.height=200), align = "center"),
                     
                     fluidRow(
                         column(
                             width=6,
                             p("Recovered:",align = "center"),
                             h2(withSpinner(textOutput("txt_total_recovered"),type=7, color="#e6c0a0", size=0.3,proxy.height=200), align = "center"),
                         ),
                         column(
                             width=6,
                             p("Deaths:",align = "center"),
                             h3(withSpinner(textOutput("txt_total_deaths"),type=7, color="#e6c0a0", size=0.3,proxy.height=200), align = "center")
                         )
                     ),
                     hr(),
                     h5("Top 10 Country + Indonesia by Cases", align="center"),
                     fluidRow(
                         withSpinner(plotlyOutput("plot_top_country", height = 240),type=4, color="#e6c0a0")
                         
                     ),
                     tags$i(h6(
                         "Data is updated every 10 minutes, refer to: ", 
                         tags$a(href="https://www.worldometers.info/coronavirus/", "WORLDMETER: COVID-19 Coronavirus Pandemic")), align="center"),
                     
                     hr(),
                     #h5("#BersamaLawanCorona", align="center"),
                     p(class="headhelp","#BersamaLawanCorona",align="center"),
                     fluidRow(
                         div(
                             tags$a(id="imglogo",
                                 href="https://kitabisa.com/campaign/indonesialawancorona", 
                                 tags$img(src="kitabisa.png", 
                                          title="KITABISA: Indonesia Lawan Corona", 
                                          width="150",
                                          height="32")
                             ),
                             tags$a(id="imglogo",
                                 href="https://www.covid19.go.id/", 
                                 tags$img(src="covidgoid.png", 
                                          title="Gugus Tugas Percepatan Penanganan COVID-19", 
                                          width="32",
                                          height="32")
                             )
                         ),
                         align="center"
                         
                         
                     ),
                     p(
                         id = "logo", 
                         class = "card", 
                         top = 80, right = 28, width = 36, fixed=TRUE, draggable = FALSE, height = "auto",
                         actionButton("twitter_share", label = "", icon = icon("twitter"),style='padding:10px',
                                      onclick = sprintf("window.open('%s')", 
                                                        "https://twitter.com/intent/tweet?text=%20Update data Coronavirus Pandemic setiap 10 minutes. Mari membantu dan saling menjaga.%20Link:&url=https://gabrielerichson.shinyapps.io/corviz&hashtags=coronavirus,dirumahaja,gcorviz19,BersamaLawanCorona")))
                 ),
                 column(
                     id="covid_world_map",
                     width=9,
                     withSpinner(leafletOutput("mymap", width="100%", height = 640),type=4, color="#e6c0a0")
                     
                 )
                 
             ),
             fluidRow(
                 tags$div(id="devwords",
                       tags$em("Everything will be okay in the end. If it's not okay, it's not the end.- John Lennon"),br(),
                        tags$a(href="https://www.linkedin.com/in/gabrielerichson/", "Developed by Gabriel Erichson (2020)")
                )
             )
             
             # div(class="outer",
             #     tags$head(includeCSS("styles.css")),
             #     leafletOutput("mymap", width="100%"),
             #     tags$div(id="devwords",
             #              tags$em("Everything will be okay in the end. If it's not okay, it's not the end.- John Lennon"),br(),
             #              tags$a(href="https://www.linkedin.com/in/gabrielerichson/", "Developed by Gabriel Erichson (2020)")
             #     ),
             # 
             #     absolutePanel(id = "logo", 
             #                   class = "card", 
             #                   top = 80, right = 28, width = 36, fixed=TRUE, draggable = FALSE, height = "auto",
             #                   actionButton("twitter_share", label = "", icon = icon("twitter"),style='padding:10px',
             #                                onclick = sprintf("window.open('%s')", 
             #                                                  "https://twitter.com/intent/tweet?text=%20Live update Coronavirus Pandemic every 10 minutes. Please use dekstop browser in landscape mode for better experience.%20Link:&url=https://gabrielerichson.shinyapps.io/corviz&hashtags=coronavirus,dirumahaja,gcorviz19,BersamaLawanCorona")))
             #     
             #     
             # )
    )
)



ui <- tagList(
    bootstrapPage(
        head,
        navbarPage
    )
)