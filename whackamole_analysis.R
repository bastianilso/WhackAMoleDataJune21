library(plotly)
library(tidyverse)
options("digits.secs"=6)
source("utils/visutils.R")
source("utils/calcutils.R")


fig <- plot_ly() %>%
  config(scrollZoom = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = c("pan2d","select2d","hoverCompareCartesian", "toggleSpikelines","zoom2d","toImage", "sendDataToCloud", "editInChartStudio", "lasso2d", "drawclosedpath", "drawopenpath", "drawline", "drawcircle", "eraseshape", "autoScale2d", "hoverClosestCartesian","toggleHover", "")) %>%
  layout(dragmode = "pan", showlegend=T, xaxis=list(mirror=T, ticks='outside', showline=T), yaxis=list(mirror=T, ticks='outside', showline=T))

load('data_whack1.rda')



#############
# Summaries
#############

Sch <- D %>% filter(!Hand == "Both") %>% group_by(Participant,Condition,Motorspace) %>%
  summarize(MoleHit = sum(Event == "Mole Hit"),
            MoleSpawned = sum(Event == "Mole Spawned"),
            HitRate = MoleHit / MoleSpawned * 100,
            Speed = mean(MoleActivatedDuration, na.rm=T),
            Distance = sum(Distance)) %>% group_by(Motorspace) %>% 
  summarize(MoleHit = mean(MoleHit),
            MoleSpawned = mean(MoleSpawned),
            HitRateSD = sd(HitRate),
            HitRate = mean(HitRate),
            SpeedSD = sd(Speed),
            DistanceSD = sd(Distance),
            `Hit Rate` = paste0(format(round(HitRate,0), nsmall = 0),'\\%'," (",format(round(mean(HitRateSD),1), nsmall = 1),")"),
            Speed = paste0(format(round(mean(Speed),2), nsmall = 2),"s"," (",format(round(mean(SpeedSD),1), nsmall = 1),")"),
            Distance = paste0(format(round(mean(Distance),1), nsmall = 1),"m"," (",format(round(mean(DistanceSD),1), nsmall = 1),")")
            ) %>% select(-MoleHit, -MoleSpawned, -HitRate,-HitRateSD,-SpeedSD,-DistanceSD)

paste(colnames(Sch), collapse=" & ")
message(paste(Sch %>% apply(.,1,paste,collapse=" & "), collapse=" \\\\ "))

# summary of condition order
Sco <- D %>% group_by(Motorspace, Order) %>%
  summarize(speed = mean(MoleActivatedDuration, na.rm=T))

# summary of mole
Sm <- D %>% group_by(MoleId) %>%
  summarize(speed = mean(MoleActivatedDuration, na.rm=T),
            sd = sd(MoleActivatedDuration, na.rm=T))

plot_ly(data = D %>% filter(Participant == 7), x=~Timestamp,
        y=~MoleActivatedDuration, mode='markers',type='scatter')

#[Yesterday 18.26] Hendrik Knoche
#For the table. I'd remove space between number and unit. %, m, s.
#Maybe include SDs from per person mean
# like 1
#[Yesterday 18.42] Hendrik Knoche
#How many out of range events/time/m? Outside motor space?
# like 1
