# /////////////////////////////////////////////////////////////////////////
#
## Data Analysis Code
#   Anova, Tukey, Pollen Limitation, Breeding System, and T-Tests
# 
# /////////////////////////////////////////////////////////////////////////

#load plant data
library(readxl)
data <- read_excel("Supporting_Information_S6.xlsx")

#subset plant data for different species

#Camser #plant_data <- subset(data, species=="Camser")
#Cirery #plant_data <- subset(data, species=="Cirery")
#Diacar #plant_data <- subset(data, species=="Diacar")
#Helnum #plant_data <- subset(data, species=="Helnum")
#Hypper #plant_data <- subset(data, species=="Hypper")
#Lotcor #plant_data <- subset(data, species=="Lotcor")
#Scacol #plant_data <- subset(data, species=="Scacol")
#Sonarv #plant_data <- subset(data, species=="Sonarv")
#Troeur #plant_data <- subset(data, species=="Troeur")

#remove notes column and then NA's
View(plant_data)
plant_data$notes<-NULL
Plant_data<-na.omit(plant_data)

#subset data into different treatments
sup<-subset(Plant_data,treat=="supplement")
con<-subset(Plant_data,treat=="open")
bag<-subset(Plant_data,treat=="bag")

#ANOVA and Tukey
d<-aov(ratio~treat,data=Plant_data)
summary(d)
TukeyHSD(d)

#Effect Size of autogomy
log(mean((sup$ratio)+0.5))-log(mean((bag$ratio)+0.5))

#Effect size of pollen limitation
log(mean((sup$ratio)+0.5))-log(mean((con$ratio)+0.5))

#breeding system t-test
t.test(sup$ratio, bag$ratio)

#Pollen Lim t-test
t.test(sup$ratio, con$ratio)


