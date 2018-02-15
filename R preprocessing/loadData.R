# load / attach necessary (add-on) packages
library(readr)

applicationEventLogs <- read_csv("./data/applicationEventLog/applicationEvents.csv")
offerEventLogs <- read_csv("./data/offerEventLog/offerEvents.csv")

applicants <- read_delim("./data/laraData/applicant.csv", ";", escape_double = FALSE, trim_ws = TRUE)
documents <- read_delim("./data/laraData/document.csv", ";", escape_double = FALSE, trim_ws = TRUE)
incomes <- read_delim("./data/laraData/income.csv", ";", escape_double = FALSE, trim_ws = TRUE)
scenarios <- read_delim("./data/laraData/scenario.csv", ";", escape_double = FALSE, trim_ws = TRUE)

# new event logs
application <- read_delim("./data/laraData/application.csv", ";", escape_double = FALSE, trim_ws = TRUE)
offer <- read_delim("./data/laraData/offer.csv", ";", escape_double = FALSE, trim_ws = TRUE)
state <- read_delim("./data/laraData/state.csv", ";", escape_double = FALSE, trim_ws = TRUE)
workitem <- read_delim("./data/laraData/workitem.csv", ";", escape_double = FALSE, trim_ws = TRUE)
