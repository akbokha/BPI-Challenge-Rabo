# execute ./prepareModel.R first
library(randomForest)
library(caret)

# achieve a higher predictive accuracy
# logistic regression can hardly handle categorical variabes

offerEventsIncomplete <- offerEvents
offerEventsIncomplete <- offerEventsIncomplete[,c(
  "case", "durationDays", "frequencyIncompleteness", "CreditScore", "MonthlyCost", "Accepted",
  "Selected", "LoanGoal", "RequestedAmount", "OfferedAmount", "NumberOfTerms")]
offerEventsIncomplete["Accepted"][offerEventsIncomplete["Accepted"] == "true",] <- TRUE
offerEventsIncomplete["Accepted"][offerEventsIncomplete["Accepted"] == "false",] <- FALSE
offerEventsIncomplete["Selected"][offerEventsIncomplete["Selected"] == "true",] <- TRUE
offerEventsIncomplete["Selected"][offerEventsIncomplete["Selected"] == "false",] <- FALSE

offerEventsIncomplete$Selected = as.factor(offerEventsIncomplete$Selected)
offerEventsIncomplete$LoanGoal = as.factor(offerEventsIncomplete$LoanGoal)
offerEventsIncomplete$Accepted = as.factor(offerEventsIncomplete$Accepted)
offerEventsIncomplete$durationDays <- as.numeric(offerEventsIncomplete$durationDays)
offerEventsIncomplete$frequencyIncompleteness <- as.numeric(offerEventsIncomplete$frequencyIncompleteness)
offerEventsIncomplete$RequestedAmount <- as.numeric(offerEventsIncomplete$RequestedAmount)
offerEventsIncomplete$OfferedAmount <- as.numeric(offerEventsIncomplete$OfferedAmount)

# random data split of 80/20 into training and test data set
offerEventsIncomplete <- offerEventsIncomplete[sample(nrow(offerEventsIncomplete)),] # shuffle records
train <- offerEventsIncomplete[1:floor(nrow(offerEventsIncomplete) * 0.8),]
test <- offerEventsIncomplete[ceiling(nrow(offerEventsIncomplete) * 0.8):nrow(offerEventsIncomplete),]


rforest.rf <- randomForest(Selected ~ `durationDays` + `frequencyIncompleteness` + `MonthlyCost` + 
                  `Accepted` + `CreditScore` + `LoanGoal` + `RequestedAmount` + `OfferedAmount`, data = train, method = "class")
varImpPlot(rforest.rf)