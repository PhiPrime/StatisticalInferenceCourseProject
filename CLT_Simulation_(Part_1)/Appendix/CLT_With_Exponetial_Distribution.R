## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ----Load_Libraries, message = FALSE------------------------------------------
library(tidyverse); library(gridExtra)
phi <- (1+sqrt(5))/2 #For dimensions


## ----Simulation---------------------------------------------------------------
set.seed(1618033)
n <- 40
sims <- 1000
l <- 0.2 #lambda
multipleObs <- matrix(rexp(n*sims, l), sims, n)
means <- apply(multipleObs, 1, mean)
sds <- apply(multipleObs, 1, sd)


## ----Histogram_of_Sample_Means, fig.height= 3, fig.width = 3*phi--------------
muplot <- ggplot(data.frame(x = means), aes(x)) +
        geom_histogram(binwidth = 0.2, aes(y = ..density..),
                       fill = "#AA0000", colour = "#000000") +
        labs(x = "Sample Mean", y = "Density") +
        ggtitle("Distribution of Sample Means")
muplot + geom_vline(xintercept = 1/l, lwd = 1.5, colour = "#5BC2E7") +
        geom_vline(xintercept = mean(means), lwd = 1.5, colour = "#FF9E61") +
        geom_vline(xintercept = median(means), lwd = 1.5, colour = "#00FF00")


## ----Histogram_of_sds, fig.height= 3, fig.width = 3*phi-----------------------
plot <- ggplot(data.frame(x = sds), aes(x)) +
        geom_histogram(binwidth = 0.25, aes(y = ..density..),
                       fill = "#AA0000", colour = "#000000") +
        geom_vline(xintercept = 1/l, lwd = 2, colour = "#5BC2E7") +
        geom_vline(xintercept = mean(sds), lwd = 2, colour = "#FF9E61") +
        labs(x = "Sample Standard Deviation", y = "Density") +
        ggtitle("Distribution of Sample Standard Deviations")
plot


## ----Outlier_Row--------------------------------------------------------------
multipleObs[sds > 10,]


## ----Exp_Dist-----------------------------------------------------------------
exsam <- rexp(sims,l)

## ----Plot_Densities, fig.height= 3, fig.width = 3*phi-------------------------
explot <- ggplot(data.frame(x = exsam), aes(x))+ 
        geom_density(lwd = 2) +
        labs(x = "Value of Sample Data Points", y = "Density") +
        ggtitle("Exponential Distribution")
g1 <- explot +
        geom_vline(xintercept = mean(exsam), 
              colour = "#FF0000", lwd = 2) +
        geom_vline(xintercept = median(exsam), 
              colour = "#5BC2E7", lwd = 2)

CLTplot <- ggplot(data.frame(x = means), aes(x)) + 
        geom_density(lwd = 2) +
        labs(x = "Sample Means", y = "Density") +
        ggtitle("Sample Mean Distribution")
g2 <- CLTplot +
        geom_vline(xintercept = mean(means), 
              colour = "#FF0000", lwd = 2) +
        geom_vline(xintercept = median(means), 
              colour = "#5BC2E7", lwd = 2)

grid.arrange(g1, g2, ncol = 2)        

