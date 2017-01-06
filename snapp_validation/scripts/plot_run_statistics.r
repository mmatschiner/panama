# m_matschiner Fri Nov 11 17:31:36 CET 2016

# Get all tables relevant for experiment 1.
run_stats_root_s <- read.table("../analysis/snapp/ex1/root/s/summary/run_statistics.txt",header=T)
run_stats_root_m <- read.table("../analysis/snapp/ex1/root/m/summary/run_statistics.txt",header=T)
run_stats_root_l <- read.table("../analysis/snapp/ex1/root/l/summary/run_statistics.txt",header=T)
run_stats_young_s <- read.table("../analysis/snapp/ex1/young/s/summary/run_statistics.txt",header=T)
run_stats_young_m <- read.table("../analysis/snapp/ex1/young/m/summary/run_statistics.txt",header=T)
run_stats_young_l <- read.table("../analysis/snapp/ex1/young/l/summary/run_statistics.txt",header=T)

# Generate a first plot with boxplots of the number of unique patterns.
pdf("../analysis/snapp/ex1/combined/figure2_topleft.pdf")
data <- data.frame(s=run_stats_root_s$number_of_site_patterns,m=run_stats_root_m$number_of_site_patterns,l=run_stats_root_l$number_of_site_patterns)
boxplot(data,main="Number of unique patterns",pars=list(ylim=c(0,300)))
dev.off()

# Generate a second plot with boxplots of the time required per iterations in seconds.
pdf("../analysis/snapp/ex1/combined/figure2_topright.pdf")
data <- data.frame(root_s=run_stats_root_s$time_per_iteration,young_s=run_stats_young_s$time_per_iteration,root_m=run_stats_root_m$time_per_iteration,young_m=run_stats_young_m$time_per_iteration,root_l=run_stats_root_l$time_per_iteration,young_l=run_stats_young_l$time_per_iteration)
boxplot(data,main="Time per iteration (sec)",pars=list(ylim=c(0,0.7)))
dev.off()

# Generate a third plot with boxplots of the iterations required for convergence.
pdf("../analysis/snapp/ex1/combined/figure2_bottomleft.pdf")
iterations_required_root_s <- run_stats_root_s$iterations_required/1000000
iterations_required_root_m <- run_stats_root_m$iterations_required/1000000
iterations_required_root_l <- run_stats_root_l$iterations_required/1000000
iterations_required_young_s <- run_stats_young_s$iterations_required/1000000
iterations_required_young_m <- run_stats_young_m$iterations_required/1000000
iterations_required_young_l <- run_stats_young_l$iterations_required/1000000
data <- data.frame(root_s=iterations_required_root_s,young_s=iterations_required_young_s,root_m=iterations_required_root_m,young_m=iterations_required_young_m,root_l=iterations_required_root_l,young_l=iterations_required_young_l)
boxplot(data,main="Iteration required for convergence (million)",pars=list(ylim=c(0,9)))
dev.off()

# Generate a fourth plot with boxplots of the time required for convergence.
pdf("../analysis/snapp/ex1/combined/figure2_bottomright.pdf")
time_required_root_s <- run_stats_root_s$iterations_required*run_stats_root_s$time_per_iteration/3600
time_required_root_m <- run_stats_root_m$iterations_required*run_stats_root_m$time_per_iteration/3600
time_required_root_l <- run_stats_root_l$iterations_required*run_stats_root_l$time_per_iteration/3600
time_required_young_s <- run_stats_young_s$iterations_required*run_stats_young_s$time_per_iteration/3600
time_required_young_m <- run_stats_young_m$iterations_required*run_stats_young_m$time_per_iteration/3600
time_required_young_l <- run_stats_young_l$iterations_required*run_stats_young_l$time_per_iteration/3600
data <- data.frame(root_s=time_required_root_s,young_s=time_required_young_s,root_m=time_required_root_m,young_m=time_required_young_m,root_l=time_required_root_l,young_l=time_required_young_l)
boxplot(data,main="Time required for convergence",pars=list(ylim=c(0,350)))
dev.off()