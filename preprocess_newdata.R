# preprocessing new data 

# The new data and the old event logs have different formats / use different definitions

# old application event logs are in English and w/ prefix "A_", while new app event logs are in Dutch and w/o prefix
unique(state$AS_APPLICATIONSTATE_DESC)
unique(applicationEventLogs$event)

# old offer event logs are in English and w/ prefix "O_", while new offer event logs are in Dutch and w/o prefix
unique(offer$OS_OFFERSTATE_DESC)
unique(offerEventLogs$event)

# old workitem event logs are in English and w/ prefix "W_", while new workitem event logs are in Dutch and w/o prefix
unique(workitem$WI_ACTION_DESC)
unique(workitem$WI_QUEUE_DESC)
unique(applicationEventLogs$event)

# make the definitions uniform
state$event <- NA
state["event"][state$AS_APPLICATIONSTATE_DESC == "Lopend",] <- "A_Pending"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Lopend",] <- "A_Pending"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Valideren",] <- "A_Validating"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Concept",] <- "A_Concept"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Ingediend",] <- "A_Submitted" 
state["event"][state$AS_APPLICATIONSTATE_DESC == "Afgerond",] <- "A_Create Application"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Incompleet",] <- "A_Incomplete" 
state["event"][state$AS_APPLICATIONSTATE_DESC == "Geaccepteerd",] <- "A_Accepted"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Geannuleerd",] <- "A_Cancelled"
state["event"][state$AS_APPLICATIONSTATE_DESC == "Afgewezen",] <- "A_Denied"

offer$event <- NA
offer["event"][offer$OS_OFFERSTATE_DESC ==  "Geaccepteerd",] <- "O_Accepted"
offer["event"][offer$OS_OFFERSTATE_DESC == "Geannuleerd",] <- "O_Cancelled"
offer["event"][offer$OS_OFFERSTATE_DESC == "Geweigerd",] <- "O_Refused" 
offer["event"][offer$OS_OFFERSTATE_DESC == "Retour ontvangen",] <- "O_Returned"
offer["event"][offer$OS_OFFERSTATE_DESC == "Verzonden (post en mijnlening)",] <- "O_Sent (mail and online)"
offer["event"][offer$OS_OFFERSTATE_DESC == "Aangemaakt",] <- "O_Created"
offer["event"][offer$OS_OFFERSTATE_DESC == "Verzonden (mijnlening)",] <- "O_Sent (online only)"

workitem$event <- NA
workitem["event"][workitem$WI_QUEUE_DESC ==  "Nabellen incomplete dossiers",] <- "W_Call incomplete files"
workitem["event"][workitem$WI_QUEUE_DESC ==  "Valideren aanvraag",] <- "W_Validate application"
workitem["event"][workitem$WI_QUEUE_DESC ==  "Completeren aanvraag",] <- "W_Complete application"
workitem["event"][workitem$WI_QUEUE_DESC ==  "Nabellen offertes",] <- "W_Call after offers"
workitem["event"][workitem$WI_QUEUE_DESC ==  "Afhandelen leads",] <- "W_Handle leads"
workitem["event"][workitem$WI_QUEUE_DESC ==  "Beoordelen fraude",] <- "W_Assess potential fraud"

# link the state and application data
applicationEvents <- merge(application, state, by = "A_ID")

# enrich application event data with the customer- , income-, scenario-, 
applicants_no_duplicates <- applicants[!duplicated(applicants$A_ID),]
length(unique(application$A_ID)) == nrow(applicants_no_duplicates) # check if there is customer data for all applications
applicationEvents <- merge(applicationEvents, applicants_no_duplicates, by = "A_ID")

scenarios_no_zeroes <- scenarios[apply(scenarios[c(3)], 1, function(z) any(z!=0)),]
scenarios_no_zeroes <- applicants[!duplicated(applicants$A_ID),] # remove duplicates --> applicants with more than one application and different maxAmounts
applicationEvens <- merge(applicationEvents, scenarios_no_zeroes, by = "A_ID", all.x = TRUE, all.y = FALSE)

# enrich offer event data with customer data 