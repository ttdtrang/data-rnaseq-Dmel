#' extract.id
#'
#' @export
extract.keyvalue <- function(string,separator = " = ") {
     x =  sapply(strsplit(string, split = separator),trimws)
     if (is.null(dim(x))) {
         return(setNames(x[2], x[1]))
     }
     return(setNames(x[2,], x[1,]))
}

#' read.soft
#'
#' Read a SOFT-formated file and return a table
#' @export
read.soft <-
    function(filename,
             entryType = 'PLATFORM',
             idColumnName = 'PlatformId',
             output = 'json',
             ignoreFields = c('Platform_sample_id', 'Platform_series_id'),
             verbose = FALSE) {
        fh = tryCatch({
            file(filename, 'r')
        }, error = function(e) {
            stop(e)
        })
        recordNumber = 0
        isReadingRecord = FALSE
        records = list()
        while (TRUE) {
            line = readLines(fh, n = 1)
            if (length(line) == 0) {
                break
            }
            firstChar = substr(line, 1, 1)
            entryData = NULL
            switch(firstChar,
                   "^" = {
                       entryData = extract.keyvalue(substr(line, 2, nchar(line)))
                       if (names(entryData) != entryType) {
                           isReadingRecord = FALSE
                           next
                       } else {
                           recordNumber = recordNumber + 1
                           isReadingRecord = TRUE
                           records[[recordNumber]] <- list()
                           names(entryData) = idColumnName
                       }
                   },
                   "!" = {
                       if (isReadingRecord) {
                           entryData = extract.keyvalue(substr(line, 2, nchar(line)))
                           if (names(entryData)[1] %in% ignoreFields) {
                               entryData <- NULL
                           }
                       }
                   },
                   {
                       # all other lines
                       if (verbose)  message(paste("Line not processed:", line))
                   })
            if (!is.null(entryData)) {
                # with some keys, there can be multiple values
                key = names(entryData)[1]
                currValue = records[[recordNumber]][[key]]
                records[[recordNumber]][[key]]  <- ifelse(is.null(currValue),
                                                                          entryData[1],
                                                                          append(currValue, entryData[1]))
                if (is.null(currValue)) {
                    records[[recordNumber]][[key]] <- entryData[1]
                } else {
                    records[[recordNumber]][[key]] <- (append(currValue, entryData[1])) 
                }
            }
        }
        close(fh)
        json.str = jsonlite::toJSON(records, auto_unbox = TRUE, pretty = TRUE)
        if (output == 'dataframe') {
            return(jsonlite::fromJSON(json.str))
        } else {
            return(json.str)
        }
    }

#' read.soft2dataframe
#' 
#' @export
read.soft2dataframe <- function(filename,entryType='PLATFORM',idColumnName='PlatformId',...) {
    read.soft(filename,entryType=entryType,idColumnName=idColumnName,output='dataframe',...)
} 

#' read.softtable
#' 
#' @export
read.softtable <- function(filename, ...) {
    fh = tryCatch({
        file(description = filename, open = 'r')
    }, error = function(e) {
        message(class(filename))
        stop(e)
    })
    dataLineNo = 0
    while (TRUE) {
        line = readLines(fh,n=1)
        if  (length(line) == 0) { break }
        dataLineNo = dataLineNo + 1
        if (length(grep(pattern = "^!.+table_begin", line))>0) { break }
    }
    close(fh)
    read.table(filename,header=TRUE,sep='\t', comment.char = '!', skip = dataLineNo,...)
}

#' camelcase
#' 
#' Convert an underdashed string to camel-case
camelcase <- function(some_string, separator="_") {
    ele = sapply(strsplit(some_string,split = separator)[[1]], FUN = function(x) {
        return(paste0(toupper(substr(x,1,1)),tolower(substr(x,2,nchar(x)))))
    })
    # return(ele)
    return(paste0(ele, collapse = ""))
}

extract.SRAId <- function(annotation_str) {
    return(sub("(.+)(SR[A-Z]\\d+)", "\\2", x= annotation_str, perl=TRUE))
}
