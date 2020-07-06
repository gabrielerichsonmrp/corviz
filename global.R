source('dependencies.R')
# load all packages
#lapply(required_packages, require, character.only = TRUE)

# DATA --------------------------------------------------------------------------

worldcountry = geojson_read("input_data/countries.geo.json", what = "sp")

base_url <- "https://corona.lmao.ninja/v2/"


get_corona_summary <- function(){
  full_url_summary = paste0(base_url,"all")
  full_url_summary <- URLencode(full_url_summary)
  json_corona_summary <- fromJSON(getURL(full_url_summary))
  json_corona_summary$updated <- as.POSIXlt.POSIXct(json_corona_summary$updated/1000) + hours(7)
  
  return(json_corona_summary)
}

get_corona_update <- function(){
  full_url_update = paste0(base_url,"countries?yesterday=","false")
  #full_url_update = paste0(base_url,"countries")
  full_url_update <- URLencode(full_url_update)
  json_corona_update <- fromJSON(getURL(full_url_update))
  country <- unnest(json_corona_update$countryInfo)
  json_corona_update <- cbind(country,json_corona_update[,-c(3)])
  colnames(json_corona_update)[1] <- "country_id"
  
  col_order <- c("country_id","country","iso2","iso3","lat","long","flag",
                 "cases","deaths","recovered","todayCases","todayDeaths")
  
  json_corona_update$updated <- ymd_hms(as.POSIXlt.POSIXct(json_corona_update$updated/1000))
  
  corona_update <- json_corona_update %>% 
    select(country_id,country,iso2,iso3,lat,long,flag,updated,cases,todayCases,deaths,todayDeaths,recovered,
           active, critical, casesPerOneMillion, deathsPerOneMillion, tests, testsPerOneMillion)
  
  corona_update <- corona_update %>% arrange(desc(cases,deaths,recovered)) %>% 
    mutate(
      position = row_number(),
      updated = updated + hours(7)
    )
  
  return(corona_update)
}


# HISTORICAL
get_corona_history <- function(){
  
  #UPDATE
  #full_url_history = paste0(base_url, "historical?lastdays=",x)
  full_url_history = paste0(base_url, "historical")
  full_url_history <- URLencode(full_url_history)
  json_corona_history <- fromJSON(getURL(full_url_history))
  
  cases <- as.data.frame(unnest(json_corona_history$timeline$cases))
  deaths <- as.data.frame(unnest(json_corona_history$timeline$deaths))
  recovered <- as.data.frame(unnest(json_corona_history$timeline$recovered))
  
  corona_history <- cbind(country=json_corona_history$country, province=json_corona_history$province,cases) 
  corona_history <- gather(corona_history,"date","cases",c(3:ncol(corona_history))) %>% 
    mutate(
      date = mdy(date)
    ) %>% 
    arrange(country,date)
  
  corona_history <- corona_history %>% 
    mutate(
      deaths =  gather(deaths,"date","deaths",c(1:ncol(deaths))) %>% 
        mutate(
          date = mdy(date)
        ) %>% arrange(date) %>% .$deaths,
      recovered = gather(recovered,"date","recovered",c(1:ncol(recovered))) %>% 
        mutate(
          date = mdy(date)
        ) %>% arrange(date) %>% .$recovered
    ) %>% 
    select(-province)
  
  return(corona_history)
}



corona_history <- get_corona_history()






















# THEME --------------------------------------------------------------------------
# COLOR
pal_one = c(
  col1="#207c06",
  col2="#799922",
  col3="#beb448",
  col4="#ffd178",
  col5="#f3a252",
  col6="#e5703b",
  col7="#d33333")


pal_viridis = c(
  col1="#404788FF",
  col2="#39568CFF",
  col3="#33638DFF",
  col4="#2D708EFF",
  col5="#287D8EFF",
  col6="#238A8DFF",
  col7="#1F968BFF",
  col8="#20A387FF",
  col9="#29AF7FFF",
  col10="#3CBB75FF"
)

txt_table_color="#aeb1b1"
head_table_color ="#78767647"
bg_table_color="#222629"

viz_palette(pal_one)

my_theme_hex <- get_hex(pal_one)
my_theme_fill  <- get_scale_fill(get_pal(pal_one))
my_theme_color <- get_scale_color(get_pal(pal_one))
my_color_gradient <- colorRampPalette(pal_one)
my_theme_gradientn <- function(x) scale_colour_gradientn(colours = my_color_gradient(x))


# PLOT THEME
my_plot_theme <- function (base_size, base_family="Segoe UI Semibold"){ 
  dark_color="#FFFFFF"
  facet_header = "#78767647"
  
  half_line <- base_size/2
  theme_algoritma <- theme(
    
    plot.background = element_rect(fill=dark_color,colour = NA), #background plot
    plot.title = element_text(size = rel(1.2), margin = margin(b = half_line * 1.2), 
                              color="white", hjust = 0, family=base_family, face = "bold"),
    plot.subtitle = element_text(size = rel(1.0), margin = margin(b = half_line * 1.2), color="white", hjust=0),
    plot.margin=unit(c(0.5,0.9,0.9,0.5),"cm"),
    #plot.margin=unit(c(0.5,r=5,1,0.5),"cm"),
    
    panel.background = element_rect(fill="#18181800",colour = "#3d3d3d"), #background chart
    panel.border = element_rect(fill=NA,color = "#3d3d3d"),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color="#3d3d3d", linetype=2),
    panel.grid.minor.y = element_blank(),
    #panel.margin = unit(0.8*half_line, "mm"), 
    panel.margin.x = NULL, 
    panel.margin.y = NULL, 
    panel.ontop = FALSE,
    panel.spacing = unit(1.2,"lines"),
    
    legend.background = element_rect(fill="#18181800",colour = NA),
    legend.text = element_text(size = rel(0.7),color="#bdbdbd"),
    legend.title =  element_text(colour = "white", size = base_size, lineheight = 0.8),
    legend.box = NULL, 
    
    # text = element_text(colour = "white", size = base_size, lineheight = 0.9, 
    #                    angle = 0, margin = margin(), debug = FALSE),
    axis.text = element_text(size = rel(0.8), color="#bdbdbd"),
    axis.text.x = element_text(margin = margin(t = 0.9 * half_line/2)),
    axis.text.y = element_text(margin = margin(r = 0.9 * half_line/2)),
    axis.title.x = element_text(colour = "white", size = base_size, lineheight = 0.8,
                                margin = margin(t = 0.9 * half_line, b = 0.9 * half_line/2)), 
    axis.title.y = element_text(colour = "white", size = base_size, lineheight = 0.8,
                                angle = 90, margin = margin(r = 0.9 * half_line, l = 0.9 * half_line/2)),
    
    strip.background = element_rect(fill=facet_header,colour = NA),
    strip.text = element_text(colour = "white", size = rel(0.8)), 
    strip.text.x = element_text(margin = margin(t = half_line*0.8, b = half_line*0.8)), 
    strip.text.y = element_text(angle = -90, margin = margin(l = half_line, r = half_line)),
    strip.switch.pad.grid = unit(0.1, "cm"), 
    strip.switch.pad.wrap = unit(0.1, "cm"),
    complete = TRUE
    
  )
}

