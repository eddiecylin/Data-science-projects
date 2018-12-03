require("httr")
require("jsonlite")

token <- ""
base <- "https://www.eventbriteapi.com/v3/"
endpoint <- "events/search/"
keyword <- "data"
location <- "new+york+city"

call1 <- paste(base,endpoint,"?","q","=", keyword, "&", "location.address=", location, "&", "token=", token, sep="")

get_events <- GET(call1,type = "basic")
get_events_text <- content(get_events, "text")
get_events_json <- fromJSON(get_events_text, flatten = TRUE)
get_events_df <- as.data.frame(get_events_json)

for(i in 2:pages){
  
  #Making an API call that has page_number= at the end. This will increment by 1 in each loop until you have all pages
  call_2 <- paste(base,endpoint,"?","ticker","=", stock,"&","page_number=", i, sep="")
  
  #Making the API call
  get_prices_2 <- GET(call_2, authenticate(username,password, type = "basic"))
  
  #Parsing it to JSON
  get_prices_text_2 <- content(get_prices_2, "text")
  
  #Converting it from JSON to a list you can use. This actually gives you a list, one item of which is the data, with the rest is information about the API call
  get_prices_json_2 <- fromJSON(get_prices_text_2, flatten = TRUE)
  
  #This grabs just the data you want and makes it a data frame
  get_prices_df_2 <- as.data.frame(get_prices_json_2)
  
  #Now you add the data to the existing data frame and repeat
  get_prices_df <- rbind(get_prices_df, get_prices_df_2)

}
