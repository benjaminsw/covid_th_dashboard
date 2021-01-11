if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, httr, jsonlite)

# read data
res <- GET("https://covid19.th-stat.com/api/open/timeline")
data <-  fromJSON(rawToChar(res$content))
df <- data$Data
df$Date <- as.Date(format(as.Date(df$Date, "%m/%d/%Y"), format="%d %b %Y"),"%d %b %Y")

Year <- c(2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010)
Auckland <- c(1760, 1549, 1388, 1967, 1326, 1765, 1814, 1693, 1502, 1751)
Wellington <- c(2176, 3154, 1138, 1196, 2132, 3176, 4181, 5169, 3150, 4175)
Lyttelton <- c(2176, 3154, 1138, 1196, 2132, 3176, 4181, 5169, 3150, 4175)
my_data <- as.data.frame(cbind(Year,Auckland,Wellington, Lyttelton))

ui <- fluidPage(
    titlePanel("Covid-19 Cases Thailand"),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("range", 
                        label = "Choose a start and end year:",
                        min = df$Date[1], 
                        max = df$Date[nrow(df)], 
                        value = c(df$Date[1], df$Date[nrow(df)]),sep = "",)
        ),
        
        mainPanel(
            tableOutput("DataTable")
        )
    )
)
server <- function(input, output) {
    
    output$DataTable <- renderTable({
        dt <- my_data[my_data$Year >= input$range[1] & my_data$Year <= input$range[2],]
        dt[,c("Year",input$var)]
    },include.rownames=FALSE)
    
}
shinyApp(ui, server)

