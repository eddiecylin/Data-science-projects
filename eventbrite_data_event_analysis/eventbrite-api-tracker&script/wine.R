

# Install packages
library(httr)
library(jsonlite)
library(lubridate)
library(magrittr)
library(stringr)
library(tidyverse)
options(stringsAsFactors = FALSE)


### Retrieve data from first event page

print("retrieve data from the 1st page for wine events")

# initiate a tracker to log the work activities
tracker <- c()
# record the time when this batch of work began
current_time <- as.character(Sys.time())
tracker <- c(tracker, current_time)
print(current_time)

# set API path with endpoint to get event about vegan foods
call_1 <- paste("https://www.eventbriteapi.com/v3/events/search/?q=wine&location.address=new+york+city&token=", "H5ZTGFKD2N3DJCLBGIQX", sep="")

get_events <- GET(call_1)
get_events_text <- content(get_events, "text")
get_events_json <- fromJSON(get_events_text, flatten = TRUE)
first_events_df <- as.data.frame(get_events_json)# the first dataframe to be rbind-ed
tracker <- c(tracker, "page_1")


### Specify interested columns in the dataframe

select_col <- c("pagination.page_number", "pagination.page_size", "pagination.page_count", "events.id", "events.url", "events.organization_id", "events.created", "events.changed", "events.published", "events.status", "events.currency", "events.listed", "events.shareable", "events.online_event", "events.tx_time_limit", "events.locale", "events.is_series", "events.is_series_parent", "events.inventory_type", "events.is_reserved_seating", "events.show_pick_a_seat", "events.show_colors_in_seatmap_thumbnail", "events.source",  "events.is_free", "events.summary", "events.organizer_id", "events.venue_id", "events.category_id", "events.subcategory_id", "events.format_id", "events.is_externally_ticketed", "events.name.text", "events.description.text", "events.end.timezone", "events.end.utc",  "events.end.utc", "events.logo.original.width", "events.logo.original.height", "location.latitude", "location.longitude", "location.augmented_location.country", "location.address")


### Loop through remaining pages and store information in the current iteration

# subset dataframe with interested columns
first_events_df <- first_events_df[ , select_col]
# get the total number of pages in this daily interation
pages <- get_events_json$pagination$page_count
# loop through the rest of the page 
for(i in 2:pages){
  call_next <- paste("https://www.eventbriteapi.com/v3/events/search/?q=wine&location.address=new+york+city&token=", "H5ZTGFKD2N3DJCLBGIQX", "&page=", i, sep="")
  get_events_next <- GET(call_next)
  get_events_text_next <- content(get_events_next, "text")
  get_events_json_next <- fromJSON(get_events_text_next, flatten = TRUE)
  get_events_df_next <- as.data.frame(get_events_json_next)
  get_events_df_next <- get_events_df_next[ , select_col] 
  get_events_df <- rbind(first_events_df, get_events_df_next)
  tracker <- c(tracker, paste("page_", i)) 
  
}


### Romove duplicated events & store csv files

# remove duplicated events by event ID
df_clean <- get_events_df[!duplicated(get_events_df$events.id), ]
# change event name to lower case
df_clean$events.name.text <- tolower(df_clean$events.name.text)
# sanity check: make sure retrieved events have the keyword 'beer'
df_clean <- df_clean[grep("wine", df_clean$events.description.text),]
df_clean['label'] = 'wine'
# create dataframe names
current_dataframe_name <- paste("df_wine", current_time, ".csv", sep = "")
# save csv files
write.csv(df_clean, current_dataframe_name)

tracker_name <- paste("wine tracker", current_time, ".txt", sep = "")
write.table(tracker, file = tracker_name, sep = " ", row.names = TRUE, col.names = NA)
print("wine events all done!!")


