# historical_search
R code for a function to use Academic Researcher developer access to do a full archive search through the Twitter API



historical_search(search, start_date, end_date)

The function repeatedly calls a full archive search to the Twitter API for keywords in the text of tweets. 
##It will not return retweets (-is:retweet is already coded into the call the function makes).


search= The search term needs to be a character string in URI format, e.g., "%23elxn43%20OR%20%23cdnpoli" for "#elxn43 OR #cdnpoli"

start_date, end_date= The start_date and end_date need to be  character strings in yyyy-mm-dd format, e.g., "2019-09-13"


Please Note: The function will continue to make calls to the Twitter API until the returned next_token=NULL (i.e., all tweets are obtained); 
             Therefore, if the date range is too wide and/or search query is too broad, the function will continue to run for a long time
             

df = The output of the function is a tibble containing status_id, author_id, text, conversation_id, public_metrics, created_at, referenced_tweets, username, name, location.

referenced_tweets is a column containing lists; it can be expanded easily using df %>% unnest(referenced_tweets, keep_empty=TRUE)
