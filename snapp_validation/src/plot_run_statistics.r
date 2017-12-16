# m_matschiner Fri Nov 11 17:31:36 CET 2016

# Make a directory for plots unless it already exists.
mkdir -p ../res/snapp/plots

# Get all tables relevant for experiment 1.
run_stats_root_s <- read.table("../res/snapp/ex1/root/s/summary/run_statistics.txt",header=T)
run_stats_root_m <- read.table("../res/snapp/ex1/root/m/summary/run_statistics.txt",header=T)
run_stats_root_l <- read.table("../res/snapp/ex1/root/l/summary/run_statistics.txt",header=T)
run_stats_young_s <- read.table("../res/snapp/ex1/young/s/summary/run_statistics.txt",header=T)
run_stats_young_m <- read.table("../res/snapp/ex1/young/m/summary/run_statistics.txt",header=T)
run_stats_young_l <- read.table("../res/snapp/ex1/young/l/summary/run_statistics.txt",header=T)
run_stats_large_pop <- read.table("../res/snapp/ex2/large_pop/summary/run_statistics.txt",header=T)
run_stats_huge_pop <- read.table("../res/snapp/ex2/huge_pop/summary/run_statistics.txt",header=T)
run_stats_large_sample <- read.table("../res/snapp/ex3/large_sample/summary/run_statistics.txt",header=T)
run_stats_tiny_sample <- read.table("../res/snapp/ex3/tiny_sample/summary/run_statistics.txt",header=T)

# Generate a first plot with boxplots of the number of unique patterns.
pdf("../res/snapp/plots/figureS3_topleft.pdf")
data <- data.frame(s=run_stats_root_s$number_of_site_patterns,m=run_stats_root_m$number_of_site_patterns,l=run_stats_root_l$number_of_site_patterns)
boxplot(data,main="Number of unique patterns",pars=list(ylim=c(0,300)))
dev.off()

# Generate plots with boxplots of the time required per iterations in seconds.
pdf("../res/snapp/plots/figureS3_topleft.pdf")
data <- data.frame(root_s=run_stats_root_s$time_per_iteration,young_s=run_stats_young_s$time_per_iteration,root_m=run_stats_root_m$time_per_iteration,young_m=run_stats_young_m$time_per_iteration,root_l=run_stats_root_l$time_per_iteration,young_l=run_stats_young_l$time_per_iteration)
boxplot(data,main="Time per iteration (sec)",pars=list(ylim=c(0,0.7)))
dev.off()

pdf("../res/snapp/plots/figureS3_centerleft.pdf")
data <- data.frame(normal_pop=run_stats_root_m$time_per_iteration,large_pop=run_stats_large_pop$time_per_iteration,huge_pop=run_stats_huge_pop$time_per_iteration)
boxplot(data,main="Time per iteration (sec)",pars=list(ylim=c(0,0.8)))
dev.off()

pdf("../res/snapp/plots/figureS3_bottomleft.pdf")
data <- data.frame(tiny_sample=run_stats_tiny_sample$time_per_iteration,normal_sample=run_stats_root_m$time_per_iteration,large_sample=run_stats_large_sample$time_per_iteration)
boxplot(data,main="Time per iteration (sec)",pars=list(ylim=c(0,3.0)))
dev.off()

# Generate plots with boxplots of the iterations required for convergence.
pdf("../res/snapp/plots/figureS3_topmiddle.pdf")
iterations_required_root_s <- run_stats_root_s$iterations_required/1000000
iterations_required_root_m <- run_stats_root_m$iterations_required/1000000
iterations_required_root_l <- run_stats_root_l$iterations_required/1000000
iterations_required_young_s <- run_stats_young_s$iterations_required/1000000
iterations_required_young_m <- run_stats_young_m$iterations_required/1000000
iterations_required_young_l <- run_stats_young_l$iterations_required/1000000
data <- data.frame(root_s=iterations_required_root_s,young_s=iterations_required_young_s,root_m=iterations_required_root_m,young_m=iterations_required_young_m,root_l=iterations_required_root_l,young_l=iterations_required_young_l)
boxplot(data,main="Iteration required for convergence (million)",pars=list(ylim=c(0,9)))
dev.off()

pdf("../res/snapp/plots/figureS3_centermiddle.pdf")
iterations_required_normal_pop <- run_stats_root_m$iterations_required/1000000
iterations_required_large_pop <- run_stats_large_pop$iterations_required/1000000
iterations_required_huge_pop <- run_stats_huge_pop$iterations_required/1000000
data <- data.frame(normal_pop=iterations_required_normal_pop,large_pop=iterations_required_large_pop,huge_pop=iterations_required_huge_pop)
boxplot(data,main="Iteration required for convergence (million)",pars=list(ylim=c(0,3.0)))
dev.off()

pdf("../res/snapp/plots/figureS3_bottommiddle.pdf")
iterations_required_tiny_sample <- run_stats_tiny_sample$iterations_required/1000000
iterations_required_normal_sample <- run_stats_root_m$iterations_required/1000000
iterations_required_large_sample <- run_stats_large_sample$iterations_required/1000000
data <- data.frame(tiny_sample=iterations_required_tiny_sample,normal_sample=iterations_required_normal_sample,large_sample=iterations_required_large_sample)
boxplot(data,main="Iteration required for convergence (million)",pars=list(ylim=c(0,1.0)))
dev.off()

# Generate plots with boxplots of the time required for convergence.
pdf("../res/snapp/plots/figureS3_topright.pdf")
time_required_root_s <- run_stats_root_s$iterations_required*run_stats_root_s$time_per_iteration/3600
time_required_root_m <- run_stats_root_m$iterations_required*run_stats_root_m$time_per_iteration/3600
time_required_root_l <- run_stats_root_l$iterations_required*run_stats_root_l$time_per_iteration/3600
time_required_young_s <- run_stats_young_s$iterations_required*run_stats_young_s$time_per_iteration/3600
time_required_young_m <- run_stats_young_m$iterations_required*run_stats_young_m$time_per_iteration/3600
time_required_young_l <- run_stats_young_l$iterations_required*run_stats_young_l$time_per_iteration/3600
data <- data.frame(root_s=time_required_root_s,young_s=time_required_young_s,root_m=time_required_root_m,young_m=time_required_young_m,root_l=time_required_root_l,young_l=time_required_young_l)
boxplot(data,main="Time required for convergence",pars=list(ylim=c(0,350)))
dev.off()

pdf("../res/snapp/plots/figureS3_centerright.pdf")
time_required_normal_pop <- run_stats_root_m$iterations_required*run_stats_root_m$time_per_iteration/3600
time_required_large_pop <- run_stats_large_pop$iterations_required*run_stats_large_pop$time_per_iteration/3600
time_required_huge_pop <- run_stats_huge_pop$iterations_required*run_stats_huge_pop$time_per_iteration/3600
data <- data.frame(normal_pop=time_required_normal_pop,large_pop=time_required_large_pop,huge_pop=time_required_huge_pop)
boxplot(data,main="Time required for convergence",pars=list(ylim=c(0,750)))
dev.off()

pdf("../res/snapp/plots/figureS3_bottomright.pdf")
time_required_tiny_sample <- run_stats_tiny_sample$iterations_required*run_stats_tiny_sample$time_per_iteration/3600
time_required_normal_sample <- run_stats_root_m$iterations_required*run_stats_root_m$time_per_iteration/3600
time_required_large_sample <- run_stats_large_sample$iterations_required*run_stats_large_sample$time_per_iteration/3600
data <- data.frame(tiny_sample=time_required_tiny_sample,normal_sample=time_required_normal_sample,large_sample=time_required_large_sample)
boxplot(data,main="Time required for convergence",pars=list(ylim=c(0,500)))
dev.off()
