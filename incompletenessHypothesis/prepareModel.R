# preproccessing dataset for predictive analysis based on offer related attributes

offerEvents <- applicationEventLogs[complete.cases(applicationEventLogs["Selected"]),]
# There are no NA's for the "Selected" attribute

uniqueOffers <- nrow(unique(offerEvents["OfferID"])) - 1 # - 1 for NA
# Confirming with the numver mentioned in the paper

# there are a lot of missing values for credit score --> minimize bias of this attribute
offerEvents["CreditScore"][offerEvents["CreditScore"] == 0,] <- NA
medianWithoutNA <- function(x) {
  median(x[which(!is.na(x))])
}

# replace all NA values for credit scores with the median credit score value
medianCreditScores <- unname(apply(offerEvents["CreditScore"], 2, medianWithoutNA))
offerEvents["CreditScore"][is.na(offerEvents["CreditScore"]),] <- medianCreditScores

# A_Incomplete indicates that the documents were incorrect/absent during the verification process
offerEvents$FrequencyOfIncompleteness <- (offerEvents$event == "A_Incomplete")