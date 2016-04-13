
#Calculate travel time budget considering all trip purposes


#-------read the data-------------------------------------
data_base<-read.csv("C:/Users/AnaTsui/Desktop/Maryland DB/DDBB_HH1.csv") 
data_TOTAL<-subset(data_base,TT_TOTAL>0)

data_TOTAL$HH_income_inv<-1/(data_TOTAL$HH_income)^0.5

#-------------------using step AIC-------------------------

stepAIC(survreg(Surv(TT_TOTAL, TOTAL) ~ HH_size2+HH_size3+HH_size4+HH_size51+Females+Children+Young+Retired+HH_workers+HH_students+HH_cars+HH_licensed+HH_income_inv+HH_area2+HH_area3+T_HBWORK+T_HBSHOP+T_HBOTHER+T_HBSCHOOL+T_NHBWORK+T_NHBOTHER,data = data_TOTAL,dist='weibull'))


out.weib<-survreg(Surv(TT_TOTAL, TOTAL) ~ HH_size2 + HH_size3 + HH_size4 + HH_size51 + Young + Retired + HH_workers + HH_students + HH_cars + HH_licensed + HH_income_inv + HH_area2 + HH_area3 + T_HBWORK + T_HBSHOP + T_HBOTHER + T_HBSCHOOL + T_NHBWORK + T_NHBOTHER, data = data_TOTAL, dist = "weibull")
summary(out.weib)

data_TOTAL$fit<-predict(out.weib)
cor(data_TOTAL$fit,data_TOTAL$TT_TOTAL)
extractAIC(out.weib)
summary(out.weib)

write.csv(data_shop,file="C:/Users/AnaTsui/Desktop/Maryland DB/R_HH/DDBB_HH_TOTAL_v5.csv")


data_TOTAL$HH_size_L<-as.factor(data_TOTAL$HH_size_L)

d7<-ggplot(data_TOTAL,aes(x=TT_TOTAL,y=fit,colour=HH_size_L))+geom_point(size=1.5)+scale_colour_manual(name="Household size",values=c("#D7191C", "orange", "yellow" ,"#ABDDA4" ,"#2B83BA"),labels=c("1", "2","3","4","5+"))+xlab("Observed total travel time (min)")+ylab("Predicted total travel time (min)")+theme_bw()+theme(legend.position="bottom",legend.text=element_text(size=12,face="bold"),legend.title=element_text(size=12,face="bold"))+theme(axis.title.x=element_text(face="bold",size=16),axis.text.x=element_text(face="bold",size=16),axis.title.y=element_text(face="bold",size=16),axis.text.y=element_text(face="bold",size=16))+ guides(colour = guide_legend(override.aes = list(size=5)))+theme(plot.title = element_text(lineheight=.8, face="bold"))+xlim(0,1500)+ylim(0,1500)+ geom_abline(intercept = 0, slope = 1)+facet_wrap(~HH_size_L)
d7

jpeg(file="C:/Users/AnaTsui/Desktop/Maryland DB/R_HH/7.jpeg")
d7
dev.off()
