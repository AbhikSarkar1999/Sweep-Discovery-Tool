#Using Library

library(PopGenome)
library(randomForest)

#Generating Features using the Feature Generation Function
SweepPrediction<-function(Datapath,Chromosome,Start,Finish) {
  
  #Creating Windows/Partitions 
  
  num <- floor((Finish-Start+1)/11)
  end_points <- seq(from = Start, to = Finish, by = num)
  end_points[length(end_points)+1] <- Finish
  
  #Listing 11 windows
  ChrSeg <- list()
  for (i in 1:11) {
    ChrSeg[[i]]<- readVCF(Datapath,1000,Chromosome,end_points[i], end_points[i+1])
  }
  
  #Calculating features for 11 windows
  
  df <- data.frame(matrix(nrow=1, ncol=0))
  ChrSeg[1:11]
  for (i in 1:11) {
    class<-ChrSeg[[i]]
    GENOME.class.slide <- sliding.window.transform(class,2000,1000, type=2)
    genome.pos <- sapply(GENOME.class.slide@region.names, function(x){
      split <- strsplit(x," ")[[1]][c(1,3)]
      val <- mean(as.numeric(split))
      return(val)
    })
    # total length
    L<-length(GENOME.class.slide@region.names)
    #Diversity Statistics
    slide <- diversity.stats(GENOME.class.slide)
    
    #Calculation of Pi
    nucdiv <- slide@Pi
    nucdhapdiv <- slide@hap.diversity.within
    Hd<-sum(nucdhapdiv)
    Hd<-Hd/L
    pi_wini<-(0.0081*((Hd)**2))
    df <- cbind(df, pi_wini)
    colnames(df)[i] <- paste0("pi_win",i)
  }
  
  for (i in 1:11) {
    class<-ChrSeg[[i]]
    GENOME.class.slide <- sliding.window.transform(class,2000,1000, type=2)
    genome.pos <- sapply(GENOME.class.slide@region.names, function(x){
      split <- strsplit(x," ")[[1]][c(1,3)]
      val <- mean(as.numeric(split))
      return(val)
    })
    # total length
    L<-length(GENOME.class.slide@region.names)
    #Diversity Statistics
    slide <- diversity.stats(GENOME.class.slide)
    
    #Calculation of Wattersons_theta
    head(nucdiv)
    slide<- neutrality.stats(GENOME.class.slide,detail=TRUE)
    get.neutrality(slide)
    theta_Watterson<-slide@theta_Watterson
    theta_Watterson<-na.omit(theta_Watterson)
    thetawat<-sum(theta_Watterson)
    thetaW_wini<-(thetawat/L)
    df <- cbind(df, thetaW_wini)
    colnames(df)[i+11] <- paste0("thetaW_win",i)
  }
  
  for (i in 1:11) {
    class<-ChrSeg[[i]]
    GENOME.class.slide <- sliding.window.transform(class,2000,1000, type=2)
    genome.pos <- sapply(GENOME.class.slide@region.names, function(x){
      split <- strsplit(x," ")[[1]][c(1,3)]
      val <- mean(as.numeric(split))
      return(val)
    })
    # total length
    L<-length(GENOME.class.slide@region.names)
    #Diversity Statistics
    slide <- diversity.stats(GENOME.class.slide)
    
    #Calculation of Tajima's_D Statistic
    head(nucdiv)
    slide<- neutrality.stats(GENOME.class.slide,detail=TRUE)
    get.neutrality(slide)
    Tajima.D<-slide@Tajima.D
    ActTaj<-na.omit(Tajima.D)
    Tajima.DSum<-sum(ActTaj)
    tajD_wini<-(Tajima.DSum/L)
    df <- cbind(df, tajD_wini)
    colnames(df)[i+22] <- paste0("tajD_win",i)
  }
  
  for (i in 1:11) {
    class<-ChrSeg[[i]]
    GENOME.class.slide <- sliding.window.transform(class,2000,1000, type=2)
    genome.pos <- sapply(GENOME.class.slide@region.names, function(x){
      split <- strsplit(x," ")[[1]][c(1,3)]
      val <- mean(as.numeric(split))
      return(val)
    })
    # total length
    L<-length(GENOME.class.slide@region.names)
    #Diversity Statistics
    slide <- diversity.stats(GENOME.class.slide)
    
    #Calculation of Kelly's_ZnS Statistic
    
    GENOME.class.slide<-linkage.stats(GENOME.class.slide)
    get.linkage(GENOME.class.slide)
    Kelly.Z_nS<-GENOME.class.slide@Kelly.Z_nS
    Kelly.Z_nS<-na.omit(Kelly.Z_nS)
    kelly.Z_nsSUM<-sum(Kelly.Z_nS)
    ZnS_wini<-(kelly.Z_nsSUM/L)
    df <- cbind(df, ZnS_wini)
    colnames(df)[i+33] <- paste0("ZnS_win",i)
  }
  
  for (i in 1:11) {
    class<-ChrSeg[[i]]
    GENOME.class.slide <- sliding.window.transform(class,2000,1000, type=2)
    genome.pos <- sapply(GENOME.class.slide@region.names, function(x){
      split <- strsplit(x," ")[[1]][c(1,3)]
      val <- mean(as.numeric(split))
      return(val)
    })
    # total length
    L<-length(GENOME.class.slide@region.names)
    #Diversity Statistics
    slide <- diversity.stats(GENOME.class.slide)
    
    #Calculation of  Omega Statistic
    GENOME.class.slide<-linkage.stats(GENOME.class.slide)
    get.linkage(GENOME.class.slide)
    Kelly.Z_nS<-GENOME.class.slide@Kelly.Z_nS
    Kelly.Z_nS<-na.omit(Kelly.Z_nS)
    kelly.Z_nsSUM<-sum(Kelly.Z_nS)
    ZnS_wini<-(kelly.Z_nsSUM/L)
    k<-ZnS_wini
    Omega_wini<-(-((log(1-(k/2)))/2))
    Omega_wini
    df <- cbind(df, Omega_wini)
    colnames(df)[i+44] <- paste0("Omega_win",i)
  }
  #Fetching the Data Frame with features
  df
  #Fetching RDS File for Prediction
  
  model<-readRDS("models/rffinal.rds")
  
  #Predicting Selective Sweep Class
  Prediction <- predict(model, newdata = df)
  Prediction<-data.frame(Prediction)
  return(Prediction)
}