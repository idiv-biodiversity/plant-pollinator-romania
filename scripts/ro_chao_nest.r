# /////////////////////////////////////////////////////////////////////////
# 
## Network Analysis Code
#     Chao Estimator and Nestedness
#
# /////////////////////////////////////////////////////////////////////////


#load network matrix
network<- data.frame(read.csv("Supporting_Information_S5.csv"))

#create Chao data frame  
library(vegan)

mat2<-matrix(nrow=ncol(network), ncol = 5)
rownames(mat2)<-colnames(network)
colnames(mat2)<-c("S.obs", "S.chao1", "se.chao1", "S.ACE", "se.ACE")
for(i in 1:ncol(network))
{
  mat2[i,]<-estimateR(as.integer(network[,i]), index="Chao")
}
mat2
write.table(mat2, file="Rom_Chao_Values.csv", sep = ",", row.names = T)

#Make rownames not part of data.frame and then convert to matrix
network2 <- network[,-1]
rownames(network2) <- network[,1]
network2<-data.matrix(network2)

#nestedness- presence-absence matrix necessary
network3<- ifelse(network2 > 0, 1, 0)
y<-nestedness(network3, null.models=FALSE)
y2<-nestedness(network3, null.models = TRUE, n.nulls = 10, binmatnestout=FALSE)
y3<-nestedtemp(network3)

nestedness(network3, null.models = TRUE, n.nulls = 1000, popsize = 30, binmatnestout=FALSE)

