# # load / attach necessary (add-on) packages
library(readr)

applicationEvents <- read_csv("./data/applicationEventLog/applicationEvents.csv")
offerEvents <- read_csv("./data/offerEventLog/offerEvents.csv")