library(gsheet)
library(tidyverse)
source("utils/loadrawdata.R")

options("digits.secs"=6)
# Load data from directories
#D <- LoadFromDirectory("data")

#save(D, file = 'data_whack_raw.rda', compress=TRUE)
load('data_whack_raw.rda')

# Load data from Google Sheets
L <- gsheet2tbl('https://docs.google.com/spreadsheets/d/1k0Z2F5E3WeDRdzlxepo-tuQasdhFwQRGoYVBtmXHdWA/edit#gid=237988817')

#############
# Format D
#############
D <- D %>% rename(Condition = i2, Participant = i1)

D <- D %>% mutate(Participant = as.numeric(Participant))

D = D %>% mutate(Timestamp = as.POSIXct(Timestamp, format = "%Y-%m-%d %H:%M:%OS"),
                 Framecount = as.integer(Framecount),
                 GameTimeSpent = as.numeric(GameTimeSpent),
                 GameTimeLeft = as.numeric(GameTimeLeft),
                 MoleActivatedDuration = as.numeric(MoleActivatedDuration),
                 RightControllerPosWorldZ = as.numeric(RightControllerPosWorldZ),
                 RightControllerPosWorldY = as.numeric(RightControllerPosWorldY),
                 RightControllerPosWorldX = as.numeric(RightControllerPosWorldX),
                 LeftControllerPosWorldZ = as.numeric(LeftControllerPosWorldZ),
                 LeftControllerPosWorldY = as.numeric(LeftControllerPosWorldY),
                 LeftControllerPosWorldX = as.numeric(LeftControllerPosWorldX),
                 MotorSpaceCenterPositionX = as.numeric(MotorSpaceCenterPositionX),
                 MotorSpaceCenterPositionY = as.numeric(MotorSpaceCenterPositionY),
                 MotorSpaceCenterPositionZ = as.numeric(MotorSpaceCenterPositionZ),
                 MotorSpaceHeight = as.numeric(MotorSpaceHeight),
                 MotorSpaceWidth = as.numeric(MotorSpaceWidth),
                 LeftControllerPosTravelX = ifelse(is.na(as.numeric(LeftControllerPosTravelX)), 0, as.numeric(LeftControllerPosTravelX)),
                 LeftControllerPosTravelY = ifelse(is.na(as.numeric(LeftControllerPosTravelY)), 0, as.numeric(LeftControllerPosTravelY)),
                 LeftControllerPosTravelZ = ifelse(is.na(as.numeric(LeftControllerPosTravelZ)), 0, as.numeric(LeftControllerPosTravelZ)),
                 RightControllerPosTravelX = ifelse(is.na(as.numeric(RightControllerPosTravelX)), 0, as.numeric(RightControllerPosTravelX)),
                 RightControllerPosTravelY = ifelse(is.na(as.numeric(RightControllerPosTravelY)), 0, as.numeric(RightControllerPosTravelY)),
                 RightControllerPosTravelZ = ifelse(is.na(as.numeric(RightControllerPosTravelZ)), 0, as.numeric(RightControllerPosTravelZ)),
                 Distance = LeftControllerPosTravelX + LeftControllerPosTravelY + LeftControllerPosTravelZ +
                            RightControllerPosTravelX + RightControllerPosTravelY + RightControllerPosTravelZ) %>%
  arrange(Timestamp)

#############
# Count no. of movements inside/outside the motorspace
#############
# TODO.


#############
# Merge
#############
D <- D %>% left_join(L, by=c('Condition' = 'Condition', 'Participant' = 'Participant'))

#############
# Save to RDA
#############
# Split into 4 

save(D, file = 'data_whack1.rda', compress=TRUE)

