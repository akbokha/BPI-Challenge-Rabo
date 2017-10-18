# # load / attach necessary (add-on) packages
library(readr)

applicationEventLogs <- read_csv("./data/applicationEventLog/applicationEvents.csv")
offerEventLogs <- read_csv("./data/offerEventLog/offerEvents.csv")