## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ----Load_Data, message = FALSE-----------------------------------------------
library(datasets); library(tidyverse) 
library(gridExtra); library(knitr)
phi <- (1+sqrt(5))/2 #For fig dimensions
data("ToothGrowth")
dat <- ToothGrowth


## ----Summary, fig.height = 4, fig.width= 4*phi--------------------------------
grouped <- group_by(dat, dose, supp)
ggplot(grouped, aes(len)) +
        geom_boxplot() +
        theme(axis.ticks.y = element_blank(),
              axis.text.y = element_blank()) +
        facet_grid(dose~supp) +
        xlab("Length")
        
        
summary <- summarize(grouped, 
          Count = sum(!is.na(len)), Mean = mean(len), Median = median(len), 
          Range = paste0("[",range(len)[1], ", ", range(len)[2], "]"),
          Shaprio_Wilk_Test = round(shapiro.test(len)$p.value, 3))
kable(summary)


## ----t_tests------------------------------------------------------------------
subsets <- matrix(rep(rep(NA, 10), 6), nrow = 6, ncol = 10)
CIs <- matrix(rep(rep(NA, 2), 6), nrow = 6, ncol = 2)
a <- 0.05
for (i in 0:5) {
        subsets[i + 1,] <- seq(1 + 10*i, 10*(i + 1), by = 1)
        con <- t.test(dat[subsets[i + 1,],]$len, 
                      alternative = "two.sided", conf.level = 1 - a)$conf.int
        CIs[i + 1, 1] <- con[1]
        CIs[i + 1, 2] <- con[2]
}
CIs <- data.frame(LB = CIs[,1], UB = CIs[,2], 
                  supp = rep(c("VC", "OJ"), each = 3),
                  dose = rep(c(0.5,1.0,2.0), times = 2))

## ----Denisty_Plot, fig.height = 4, fig.width = 4*phi--------------------------
ggplot(grouped, aes(len)) +
        facet_grid(supp~.) +
        geom_density(aes(group = dose, fill = as.factor(dose)), alpha = 0.5) +
        geom_vline(data = CIs[CIs$supp == "VC",], lwd = 2, 
                    aes(xintercept = LB, 
                        group = dose, color = as.factor(dose))) +
        geom_vline(data = CIs[CIs$supp == "VC",], lwd = 2, 
                    aes(xintercept = UB, 
                        group = dose, color = as.factor(dose))) +
        geom_vline(data = CIs[CIs$supp == "OJ",], lwd = 2, 
                    aes(xintercept = LB, 
                        group = dose, color = as.factor(dose))) +
        geom_vline(data = CIs[CIs$supp == "OJ",], lwd = 2,
                    aes(xintercept = UB, 
                        group = dose, color = as.factor(dose))) +
        labs(x = "Length", y = "Density", 
             fill = "Dose (mg/day)", color = "Dose (mg/day)") + 
        ggtitle("Density Plots with Confidence Intervals")


## -----------------------------------------------------------------------------
#Ceiling and floor-ing values to maintain confidence level
CIs$LB <- ceiling(CIs$LB*100)/100
CIs$UB <- floor(CIs$UB*100)/100
names(CIs) <- c("Lower_Bound", "Upper_Bound",
                "supp", "dose")
kable(CIs)

