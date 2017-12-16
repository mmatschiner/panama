table_300 <- read.table("../analysis/snapp/root/sample_300/summary/theta_and_node_age_errors.txt",header=T)
table_1000 <- read.table("../analysis/snapp/root/sample_1000/summary/theta_and_node_age_errors.txt",header=T)
table_3000 <- read.table("../analysis/snapp/root/sample_3000/summary/theta_and_node_age_errors.txt",header=T)

theta_error_300 <- table_300$estimated_theta-table_300$true_theta
theta_error_1000 <- table_1000$estimated_theta-table_1000$true_theta
theta_error_3000 <- table_1000$estimated_theta-table_3000$true_theta

age_error_300 <- table_300$mean_error
age_error_3000 <- table_3000$mean_error
age_error_1000 <- table_1000$mean_error

plot(theta_error_300,age_error_300,xlab="Error in Theta estimate",ylab="Error in age estimate",col="#d33682",main="Theta error vs. age error",ylim=c(-2.5,2.5))
points(theta_error_1000,age_error_1000,col="#2aa198")
points(theta_error_3000,age_error_3000,col="#b58900")