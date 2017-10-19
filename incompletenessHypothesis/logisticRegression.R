# execute ./prepareModel.R first

offerEventsIncomplete <- offerEvents
offerEventsIncomplete <- offerEventsIncomplete[,c(
  "case", "durationDays", "frequencyIncompleteness", "CreditScore", "MonthlyCost", "Accepted", "Selected")]
offerEventsIncomplete["Accepted"][offerEventsIncomplete["Accepted"] == "true",] <- 1
offerEventsIncomplete["Accepted"][offerEventsIncomplete["Accepted"] == "false",] <- 0
offerEventsIncomplete["Selected"][offerEventsIncomplete["Selected"] == "true",] <- 1
offerEventsIncomplete["Selected"][offerEventsIncomplete["Selected"] == "false",] <- 0
offerEventsIncomplete$Accepted <- as.numeric(offerEventsIncomplete$Accepted)
offerEventsIncomplete$Selected <- as.numeric(offerEventsIncomplete$Selected)


# random data split of 80/20 into training and test data set
offerEventsIncomplete <- offerEventsIncomplete[sample(nrow(offerEventsIncomplete)),] # shuffle records
train <- offerEventsIncomplete[1:floor(nrow(offerEventsIncomplete) * 0.8),]
test <- offerEventsIncomplete[ceiling(nrow(offerEventsIncomplete) * 0.8):nrow(offerEventsIncomplete),]

# fit model

logistic <- glm(Selected ~ `durationDays` + `frequencyIncompleteness` + `MonthlyCost` + 
                  `Accepted` + `CreditScore`, data = train)
summary(logistic)

# new credit loans are likely to be selected than limit raise loans
# monthlycost, credit score and duration have a negative impact on the outcome
# but note that the frequencyOfIncompleteness does not have a negative impact on the outcom