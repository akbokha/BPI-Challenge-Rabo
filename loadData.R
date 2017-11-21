# load / attach necessary (add-on) packages
library(readr)

applicationEventLogs <- read_csv("./data/applicationEventLog/applicationEvents.csv")
offerEventLogs <- read_csv("./data/offerEventLog/offerEvents.csv")

applicants <- read.delim("./data/laraData/applicant_20170101-20170930.txt", sep = ';')
#applicationData <- read.delim("./data/laraData/application_20170101-20170930_anon.txt", sep = ';', dec = ";")
documents <- read.delim("./data/laraData/document_20170101-20170930.txt", sep = ';')
incomes <- read.delim("./data/laraData/income_20170101-20170930.txt", sep = ';')
scenarios <- read.delim("./data/laraData/scenario_20170101-20170930.txt", sep = ';')
#states <- read.delim("./data/laraData/state_20170101-20170930_anon.txt", sep = ';')
#workitems <- read.delim("./data/laraData/workitem_20170101-20170930_anon.txt", sep = ';')
