
library(httr)
library(jsonlite)
library(lubridate)
library(magrittr)
library(stringr)
options(stringsAsFactors = FALSE)



### set credentials

token <- "H5ZTGFKD2N3DJCLBGIQX"
base <- "https://www.eventbriteapi.com/v3/"
endpoint <- "events/search/"

print("retrieve data from the 1st page")

# initiate a tracker to log the work activities
tracker <- c()
# record the time when this batch of work began
current_time <- as.character(Sys.time())
tracker <- c(tracker, current_time)
print(current_time)
# get the 1st page of data(50 events/page)
call_1 <- paste(base,endpoint,"?","token=", token, sep="")
call_kim <- paste("https://www.eventbriteapi.com/v3/events/search/?q=data&location.address=new+york+city&token=4DCJAQLR65UKPS4BYJ6S")

get_events <- GET(call_kim)
get_events_text <- content(get_events, "text")
get_events_json <- fromJSON(get_events_text, flatten = TRUE)
get_events_df <- as.data.frame(get_events_json)# the first df to be rbind-ed
columns_to_keep <- c("pagination.page_number", "events.id", "events.created", "events.listed", "events.online_event",
                     "events.locale", "events.is_free", "events.name.text","events.description.text", "events.start.utc",
                     "events.end.utc", "events.start.timezone", "location.latitude", "location.longitude")
get_events_df <- get_events_df[columns_to_keep]
tracker <- c(tracker, "page_1")


print("retrieve data from 2 ~ last page(per API request) & rbind with 1st page")

# get the total number of pages
pages <- get_events_json$pagination$page_count
# loop through the rest of the page 
for(i in 2:pages){
        call_next <- paste(base,endpoint,"?","token=", token,"&page=", i, sep="")
        get_events_next <- GET(call_next)
        get_events_text_next <- content(get_events_next, "text")
        get_events_json_next <- fromJSON(get_events_text_next, flatten = TRUE)
        get_events_df_next <- as.data.frame(get_events_json_next)
        get_events_df_next <- get_events_df_next[columns_to_keep] 
        get_events_df <- rbind(get_events_df, get_events_df_next)
        tracker <- c(tracker, paste("page_", i)) 
        
}


print("filter data with conditions and key words") 

# set filtering conditions: use the key word "data" to test
df_clean <- get_events_df[!duplicated(get_events_df$events.id), ]
df_clean <- df_clean[(df_clean$events.online_event == FALSE & df_clean$events.locale == "en_US"), ]

df_clean$events.name.text <- tolower(df_clean$events.name.text)
df_kw <- df_clean[grep("data",df_clean$events.name.text),] 


print("save dataframe & tracker files (after filtering) as csv/ text files") 

current_dataframe_name <- paste("df_", current_time, ".csv", sep = "")
write.csv(df_kw, current_dataframe_name)

tracker_name <- paste("tracker", current_time, ".txt", sep = "")
write.table(tracker, file = tracker_name, sep = " ", row.names = TRUE, col.names = NA)
print("all done!!")