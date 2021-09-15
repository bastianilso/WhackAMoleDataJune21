library(gsheet)
library(tidyverse)
source("utils/loadrawdata.R")

options("digits.secs"=6)
# Load data from directories
D <- LoadFromDirectory("data")

# Load data from Google Sheets
L <- gsheet2tbl('https://docs.google.com/spreadsheets/d/1k0Z2F5E3WeDRdzlxepo-tuQasdhFwQRGoYVBtmXHdWA/edit#gid=237988817')

#############
# Format D
#############
D <- D %>% rename(Condition = i2, Participant = i1)

D <- D %>% mutate(Participant = as.numeric(Participant))

#############
# Merge
#############
D <- D %>% left_join(L, by=c('Condition' = 'Condition', 'Participant' = 'Participant'))

#############
# Save to RDA
#############
save(D, file = 'data_whack.rda', compress=TRUE)
