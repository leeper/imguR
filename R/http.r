.check_error <- function(x, method){
    
    # check rate limiting
    if(getOption('imgur_user_rate_warning', 0) > 0 || 
       getOption('imgur_client_rate_warning', 0) > 0) {
        h <- x$headers
        client <- ifelse("x-ratelimit-clientremaining" %in% names(h),
                         as.numeric(h$`x-ratelimit-clientremaining`),
                         NA)
        user <- ifelse("x-ratelimit-userremaining" %in% names(h),
                       as.numeric(h$`x-ratelimit-userremaining`),
                       NA)
        reset_time <- as.POSIXct(as.numeric(h$`x-ratelimit-userreset`), 
                                 origin = '1970-01-01')
        if(!is.na(user) && user <= getOption('imgur_user_rate_warning', 0)) {
            warning("User rate limit approaching. ", 
                    user, " calls available.\n",
                    "Credits will reset at:", reset_time)
        }
        if(!is.na(client) && client <= getOption('imgur_client_rate_warning', 0)) {
            warning("Client rate limit approaching. ",
                    client, " calls available.\n",
                    "Please contact Thomas Leeper <thosjleeper@gmail.com> about this message.")
        }
    }
    
    # something here to check token expiration?
    
    if(method == 'DELETE'){
        if(length(out$content) == 0){
            stop_for_status(x)
            return("")
        } else {
            out <- content(x)
            stop_for_status(x)
            return(out$data)
        }
    } else {
        out <- content(x)
        if(!out$success)
            message('Imgur Error: ', out$data$error)
        stop_for_status(x)
        return(out$data)
    }
    
}

imgurGET <-
function(endpoint, 
         base_url = "https://api.imgur.com/3/", 
         key = "1babd0decbb90f2", # Thomas Leeper imguR
         #key = "9f3460e67f308f6", # Yihui Xie knitr
         #key = "4feb29d00face5bc1b9dae536e15c373", # Aaron Statham imguR
         token = NULL,
         ...){
    if(!is.null(token)){
        if(inherits(token, "Token2.0"))
            token <- token$credentials$access_token
        if(!is.character(token))
            stop('The Imgur API OAuth token must be a character string!')
        out <- GET(paste0(base_url, endpoint), 
                   config(httpheader = c(Authorization = paste('Bearer', token))),
                   ...)
    } else if(!is.null(key)) {
        if(!is.character(key))
            stop('The Imgur API Key must be a character string!')
        out <- GET(paste0(base_url, endpoint), 
                   config(httpheader = c(Authorization = paste('Client-ID', key))),
                   ...)
    } else {
        stop("Must specify an API key or OAuth2.0 Access Token.")
    }
    .check_error(out, 'GET')
}

imgurPOST <-
function(endpoint, 
         base_url = "https://api.imgur.com/3/", 
         key = "1babd0decbb90f2", # Thomas Leeper imguR
         #key = "9f3460e67f308f6", # Yihui Xie knitr
         #key = "4feb29d00face5bc1b9dae536e15c373", # Aaron Statham imguR
         token = NULL,
         ...){
    if(!is.null(token)){
        if(inherits(token, "Token2.0"))
            token <- token$credentials$access_token
        if(!is.character(token))
            stop('The Imgur API OAuth token must be a character string!')
        out <- POST(paste0(base_url, endpoint), 
                    config(httpheader = c(Authorization = paste('Bearer', token))),
                    ...)
    } else if(!is.null(key)) {
        if(!is.character(key))
            stop('The Imgur API Key must be a character string!')
        out <- POST(paste0(base_url, endpoint), 
                    config(httpheader = c(Authorization = paste('Client-ID', key))),
                    ...)
    } else {
        stop("Must specify an API key or OAuth2.0 Access Token.")
    }
    .check_error(out, 'POST')
}

imgurPUT <-
function(endpoint, 
         base_url = "https://api.imgur.com/3/", 
         key = "1babd0decbb90f2", # Thomas Leeper imguR
         #key = "9f3460e67f308f6", # Yihui Xie knitr
         #key = "4feb29d00face5bc1b9dae536e15c373", # Aaron Statham imguR
         token = NULL,
         ...){
    if(!is.null(token)){
        if(inherits(token, "Token2.0"))
            token <- token$credentials$access_token
        if(!is.character(token))
            stop('The Imgur API OAuth token must be a character string!')
        out <- PUT(paste0(base_url, endpoint), 
                   config(httpheader = c(Authorization = paste('Bearer', token))),
                   ...)
    } else if(!is.null(key)) {
        if(!is.character(key))
            stop('The Imgur API Key must be a character string!')
        out <- PUT(paste0(base_url, endpoint), 
                   config(httpheader = c(Authorization = paste('Client-ID', key))),
                   ...)
    } else {
        stop("Must specify an API key or OAuth2.0 Access Token.")
    }
    .check_error(out, 'PUT')
}

imgurDELETE <-
function(endpoint, 
         base_url = "https://api.imgur.com/3/", 
         key = "1babd0decbb90f2", # Thomas Leeper imguR
         #key = "9f3460e67f308f6", # Yihui Xie knitr
         #key = "4feb29d00face5bc1b9dae536e15c373", # Aaron Statham imguR
         token = NULL,
         ...){
    if(!is.null(token)){
        if(inherits(token, "Token2.0"))
            token <- token$credentials$access_token
        if(!is.character(token))
            stop('The Imgur API OAuth token must be a character string!')
        out <- DELETE(paste0(base_url, endpoint), 
                      config(httpheader = c(Authorization = paste('Bearer', token))),
                      ...)
    } else if(!is.null(key)) {
        if(!is.character(key))
            stop('The Imgur API Key must be a character string!')
        out <- DELETE(paste0(base_url, endpoint), 
                      config(httpheader = c(Authorization = paste('Client-ID', key))),
                      ...)
    } else {
        stop("Must specify an API key or OAuth2.0 Access Token.")
    }
    .check_error(out, 'DELETE')
}
