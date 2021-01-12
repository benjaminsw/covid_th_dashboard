if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, httr, jsonlite)

# read data
res <- GET("https://covid19.th-stat.com/api/open/timeline")
data <-  fromJSON(rawToChar(res$content))
df <- data$Data
df$Date <- as.Date(format(as.Date(df$Date, "%m/%d/%Y"), format="%d %b %Y"),"%d %b %Y")

new_confirmed_df <- data.frame(time=df$Date,  value=df$NewConfirmed)
new_confirmed_df <- xts(new_confirmed_df[,-1], order.by=new_confirmed_df[,1])
index(new_confirmed_df) <- index(new_confirmed_df)-0

ui <- fluidPage(
    titlePanel("Covid-19 Cases Thailand"),
    
    #sidebarLayout(
        #sidebarPanel(
            #sliderInput("range", 
                        #label = "Choose a start and end year:",
                        #min = df$Date[1], 
                        #max = df$Date[nrow(df)], 
                        #value = c(df$Date[1], df$Date[nrow(df)]))
        #),
        
        mainPanel(
            dygraphOutput("new_confirmed_plot")
        )
    #)
)
server <- function(input, output) {
    
    output$new_confirmed_plot <- renderDygraph({
        dygraph(new_confirmed_df)
    })
    
}
shinyApp(ui, server)

