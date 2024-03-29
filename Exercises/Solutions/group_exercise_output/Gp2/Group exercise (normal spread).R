set.seed(250)

n_swine <- 5000

farm <- data.frame(id =1:n_swine,
                   age=round(runif(n_swine,21,180)),
                   infected=0,
                   dayfrominf=0)

farm$infected[1] <- 1
farm$dayfrominf[1] <- 1

ProbInfection <- 0.25

end_time <- 365

age_collect <- numeric(end_time)

inf_collect <- data.frame(susceptible=rep(0,end_time), infected=rep(0, end_time),  recovered=rep(0, end_time))

for (t in seq_len(end_time))
{
  slaughtered <- farm$age>=180
  farm$infected[slaughtered] <- 0
  farm$dayfrominf[slaughtered] <- 0
  farm$age[slaughtered] <- 21
  
  Prob<-1-exp((-ProbInfection)*(length(farm$infected[farm$infected==1])/n_swine))
  
  PotInf       <- which(farm$infected==0)
  NewInf       <- PotInf[rbinom(length(PotInf),1,prob=Prob)==1]
  if(length(NewInf)>0) farm$infected[NewInf] <- 1
  
  farm$dayfrominf[farm$infected==1] <- farm$dayfrominf[farm$infected==1] + 1
  NewRec       <- which(farm$dayfrominf>=10)
  if(length(NewRec)>0) farm$infected[NewRec] <- 2
  
  farm$age <- farm$age + 1
  
  age_collect[t] <- mean(farm$age)
  
  sus <- length(farm$infected[farm$infected==0])
  inf <- length(farm$infected[farm$infected==1])
  rec <- length(farm$infected[farm$infected==2])
  inf_collect[t,1] <- sus
  inf_collect[t,2] <- inf
  inf_collect[t,3] <- rec
}

plot(inf_collect$susceptible, type="l", lwd=2, col=3, xlab="Time", ylab="No. individuals", ylim=c(0,n_swine))
lines(inf_collect$infected, type="l", lwd=2, col=2)
lines(inf_collect$recovered, type="l", lwd=2, col=1)
legend("right", text.col=c(3,2,1), legend=c("Susceptible", "Infected", "Recovered"), 
       bty="n")
