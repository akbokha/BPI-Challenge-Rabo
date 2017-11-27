# load / attach necessary (add-on) packages
library(readr)

applicationEventLogs <- read_csv("./data/applicationEventLog/applicationEvents.csv")
offerEventLogs <- read_csv("./data/offerEventLog/offerEvents.csv")

applicants <- read.delim("./data/laraData/applicant_20170101-20170930.txt", sep = ';')
documents <- read.delim("./data/laraData/document_20170101-20170930.txt", sep = ';')
incomes <- read.delim("./data/laraData/income_20170101-20170930.txt", sep = ';')
scenarios <- read.delim("./data/laraData/scenario_20170101-20170930.txt", sep = ';')

applicationDataBadFormat <- read.table("./data/laraData/reformat/application_20170101-20170930.txt", sep = ';')
#applicationDataBadFormat <- as.data.frame(t(applicationDataBadFormat))
applicationDataBadFormat <- setNames(data.frame(matrix(unlist(applicationDataBadFormat[-c(1:8),]),
                                                       ncol = 8, byrow = TRUE)), c(unlist(applicationDataBadFormat[1:8,])))

states <- read.delim("./data/laraData/state_20170101-20170930_anon.txt", sep = ';')
workitems <- read.delim("./data/laraData/workitem_20170101-20170930_anon.txt", sep = ';')
offers <- read.delim("./data/laraData/offer_20170101-20170930_anon.txt", sep = ';')