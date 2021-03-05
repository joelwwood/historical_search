library(httr)
library(tidyjson)
library(tidyverse)

#paste in your Academic Research developer bearer token here; it must be a character string in an object called token
token<-"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"



### This function repeatedly calls a full archive search to the Twitter API for keywords in the text of tweets. 
##It will not return retweets (-is:retweet is already coded into the call the cuntion makes).
## The search term needs to be a character string in URI format, e.g., "%23elxn43%20OR%20%23cdnpoli" for "#elxn43 OR #cdnpoli"
## The start_date and end_date need to be  character strings in yyyy-mm-dd format, e.g., "2019-09-13"
## The function will continue to make calls to the Twitter API until the returned next_token=NULL (i.e., all tweets are obtained); 
# Therefore, if date range is too wide and/or search query is too broad, the function will continue to run for a long time
#The output of the function is a tibble


historical_search<-function(search,start_date,end_date){
  api<-'https://api.twitter.com/2/tweets/search/all?query=('
  fields<-')%20-is:retweet&max_results=500&tweet.fields=author_id,created_at,public_metrics,conversation_id,referenced_tweets&expansions=author_id&user.fields=location&start_time='
  end1<-'T00:00:00.00Z&end_time='
  end2<-'T00:00:00.00Z'
  full<-paste(api,search,fields,start_date,end1,end_date,end2,sep="")
  initial_call<-GET(full,add_headers(Authorization = paste("Bearer",token,sep=" ")))
  data<-jsonlite::fromJSON(content(initial_call,"text"))
  df<-data$data %>% as_tibble() %>%
    rename(status_id=id,
           id=author_id) %>%
    left_join(as_tibble(data$includes$users)) %>%
    rename(author_id=id) 
  
  next_token<-data$meta$next_token
  
  while(length(next_token)>0){
    Sys.sleep(1) #wait 1 seconds; worry about ratelimit
    call_wtoken<-GET(paste(full,'&next_token=',next_token,sep=""), add_headers(Authorization = paste("Bearer",token,sep=" ")))
    data<-jsonlite::fromJSON(content(call_wtoken,"text"))
    
    df<-data$data %>% as_tibble() %>%
      rename(status_id=id,
             id=author_id) %>%
      left_join(as_tibble(data$includes$users)) %>%
      rename(author_id=id)  %>%
      bind_rows(df)
    
    next_token<-data$meta$next_token
  }
  
  df
}





