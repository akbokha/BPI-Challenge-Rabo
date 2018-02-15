# preproccessing dataset for predictive analysis based on offer related attributes
library(plyr)

offerEvents = applicationEventLogs

uniqueOffer <- nrow(unique(offerEvents["OfferID"])) - 1 # - 1 for NA
# Confirming with the number mentioned in the paper

# a subset in which we only have the start events (event == A_Submitted)
offerEvents$start <- NA
offerEvents["start"][offerEvents$event == "A_Submitted",] <- TRUE
offerStart <- subset(offerEvents, start)
offerStart <- offerStart[,c("case", "completeTime")]

# a subset in which we only have the event related to incompleteness of documents
offerEvents$incomplete <- NA
offerEvents["incomplete"][offerEvents$event == "A_Incomplete",] <- TRUE
offerIncomplete <- subset(offerEvents, incomplete)
offerIncomplete <- offerIncomplete[,c("case", "EventID")]
offerIncomplete <- ddply(offerIncomplete,~case,summarise,freqIncompleteness=length(unique(EventID)))
# funny fact: applications can have up to 7 A_Incomplete events :')

# going to add the offers that had no events related to incompleteness of documents
uniqueIDs <- data.frame(unique(offerEvents$case))
uniqueIDs <- tail(uniqueIDs, -1)
uniqueIDs["zero"] <- 0
colnames(uniqueIDs)[1] <- "case"
offerIncomplete <- merge(offerIncomplete, uniqueIDs, by = "case", all = TRUE)
colnames(offerIncomplete)[2] <- "frequencyIncompleteness"
offerIncomplete <- offerIncomplete[,c("case", "frequencyIncompleteness")]
offerIncomplete["frequencyIncompleteness"][is.na(offerIncomplete$frequencyIncompleteness),] <- 0

# extract the records (events) that leave the system (completed, cancelled or denied)
offerEvents$end <- NA
offerEvents["end"][offerEvents$event == "A_Pending",] <- TRUE # successful completion
offerEvents["end"][offerEvents$event == "A_Cancelled",] <- TRUE # cancelled by the client
offerEvents["end"][offerEvents$event == "A_Denied",] <- TRUE # denied by the bank
offerEvents <- subset(offerEvents, end)

# calculate the number of days the application was in their system
offerEvents["durationDays"] <- NA
offerStart["startDay"] <- as.Date(offerStart$completeTime)
offerEvents["endDay"] <-as.Date(offerEvents$completeTime)
offerEvents["mark"] <- TRUE
offerEvents <- merge(offerStart, offerEvents, by = "case")
offerEvents =  offerEvents[!duplicated(offerEvents[c("mark","case")]),] # remove duplicates
offerEvents["durationDays"] <- offerEvents$endDay - offerEvents$startDay

# A_Incomplete indicates that the documents were incorrect/absent during the verification process
offerEvents <- merge(offerEvents, offerIncomplete, by = "case")

# remove records which have a NA for "Selected" (Target Variable)
offerEvents <- offerEvents[complete.cases(offerEvents["Selected"]),]

# there are a lot of missing values for credit score --> minimize bias of this attribute
offerEvents["CreditScore"][offerEvents["CreditScore"] == 0,] <- NA
medianWithoutNA <- function(x) {
  median(x[which(!is.na(x))])
}

# replace all NA values for credit scores with the median credit score value
medianCreditScores <- unname(apply(offerEvents["CreditScore"], 2, medianWithoutNA))
offerEvents["CreditScore"][is.na(offerEvents["CreditScore"]),] <- medianCreditScores