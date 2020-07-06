server <- function(input, output, session) {

  cor_summary <- get_corona_summary()
  cor_global <- get_corona_update()
  
  last_update_global <- cor_summary$updated
  total_cases <- cor_summary$cases
  total_deaths <- cor_summary$deaths
  total_recovered  <- cor_summary$recovered
  total_active_case <- cor_summary$active
  
  
  output$mymap <- renderLeaflet({
    
    bin= c(0,100,1000,5000,25000,50000,100000,500000,1000000,Inf)
   
    polygon_pal <- colorBin("Orange", domain = cor_global$cases, bins = bin, na.color = "GREY")
    bin_pal <- colorBin(pal_one, domain = cor_global$cases, bins = bin, na.color = "grey")
    #plot_map <- worldcountry[worldcountry$ISO_A3 %in% cor_global$iso3, ]
    plot_map <- worldcountry[worldcountry$id %in% cor_global$iso3, ]
    #summary(worldcountry$ISO_A3)
    
    
    labels <- sprintf(
      "<strong>%s</strong><br/>Total Cases: %s <br>Total Deaths: %s <br>Recovered: %s <br/><i><small>Includes individuals known to have <br/>cases today (%s) and died today (%s).<br>Last Update: %s</small><i>",
      cor_global$country, 
      comma(cor_global$cases), 
      comma(cor_global$deaths), 
      comma(cor_global$recovered),
      comma(cor_global$todayCases),
      comma(cor_global$todayDeaths),
      cor_global$updated
    ) %>% lapply(htmltools::HTML)
    
    leaflet(plot_map,options = leafletOptions(minZoom = 2)) %>%
      addTiles() %>% 
      addProviderTiles(providers$CartoDB.Positron) %>%
      fitBounds(~-10,-60,~80,80) %>%
      clearMarkers() %>%
      clearShapes() %>%
      addLegend("topright", pal = bin_pal, values = ~cor_global$cases,
                title = "<small>Total Cases</small>") %>% 
      addPolygons(stroke = FALSE, 
                  weight = 0.2,
                  smoothFactor = 0.2, 
                  fillOpacity = 0.05,
                  color = ~polygon_pal(cor_global$cases)
                  ) %>% 
      addCircleMarkers(
             data = cor_global %>% select(country,lat,long,updated,cases,deaths,recovered,todayCases,todayDeaths),
             lng =  ~ long,
             lat =  ~ lat,
             label = labels,
             popup = labels,
             labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),textsize = "15px",direction = "auto"),
             weight = 1,
             radius = ~(cases)^(1/4.5),
             fillOpacity = 0.5,
             color = ~bin_pal(cor_global$cases)
             )
  })
  
  output$txt_last_update <- renderText({
    paste("Last Update: ",last_update_global)
  })
  
  output$txt_total_cases <- renderText({
    prettyNum(total_cases, big.mark=",")
  })
  
  output$txt_total_recovered <- renderText({
    prettyNum(total_recovered, big.mark=",")
  })
  
  output$txt_total_deaths <- renderText({
    prettyNum(total_deaths, big.mark=",")
  })
  
  output$out_total_recovered <- renderValueBox({
    valueBox(
      value = prettyNum(total_recovered, big.mark=","),
      subtitle = "Recovered"
    )
  })
  
  output$plot_top_country <- renderPlotly({
    top_country_cases <- cor_global %>% arrange(desc(cases)) %>% head(10) %>% 
      filter(country!="Indonesia") %>% 
      select(position,country, cases,iso3,recovered,deaths,active,critical)
    
    indonesia <- cor_global %>% filter(country=="Indonesia") %>% 
      select(position, country, cases,iso3,recovered,deaths,active,critical) 
    
    top_country_cases <- rbind(indonesia,top_country_cases) %>% 
      mutate(
        cases = as.integer(cases),
        country = as.factor(country),
        country = reorder(country,cases)
      ) %>% 
      mutate(
        popup = glue("{country} ({iso3})
                     Total {comma(cases)} Cases
                     Total {comma(recovered)} Recovered
                     Total {comma(deaths)} Deaths
                     {comma(active)} Active cases
                     {comma(critical)} Critical cases")
      )
      
    plot_top_countries <- ggplot(top_country_cases,aes(country,round(cases/total_cases,4)*100))+
      geom_col(aes(fill=cases, text=popup), show.legend = FALSE)+
      geom_text(aes(label=paste0(round(cases/total_cases,4)*100,"%"),y=(round(cases/total_cases,4)*100)+3.2),size=2.5,color="#191919")+
      labs(
        y="Percentage on total global cases"
      )+
      coord_flip()+
      theme_minimal()+
      theme( 
        axis.text.x=element_text(size=8,margin = margin(b=5)),
        axis.text.y=element_text(size=8),
        axis.text.y.left = element_text(margin = margin(l=10)),
        axis.title.y = element_blank(),
        axis.title.x = element_text(size=8)
      )+
      scale_fill_continuous(low = my_theme_hex("col1"), high=my_theme_hex("col7"))
    
    ggplotly(plot_top_countries, tooltip="popup") %>% 
      config(displayModeBar = FALSE) %>% 
      layout(showlegend=FALSE)
    
      
    
  })
  
  
  
  

}