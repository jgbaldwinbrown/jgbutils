library(ggplot2)
data <- read.table("../full_run/inter/fst_dist_combo_hap2.txt", sep="\t")

colnames(data) <- c("index", "pop1n", "pop2n", "FST", "nbsnps", "pop1_extra", "pop2_extra", "fsthead", "pop1", "pop2", "FST_old", "disthead", "Population_1", "Population_2", "Distance")
str(data)

#p <- ggplot(data=data, aes(Distance, FST, color=factor(Population_1), shape=factor(Population_2))) +
#    geom_point() +
#    theme_bw() +
#    ggtitle("Isolation by distance of wild populations")+
#    scale_shape_manual(values=1:10)

p <- ggplot(data=data, aes((Distance / 1000), FST)) +
    geom_point() +
    theme_bw() +
    labs(title="Isolation by distance of natural populations", x="Distance (kilometers)")+
    geom_smooth(method='lm', se=FALSE) +
    geom_smooth(method='lm', se=FALSE, data = data[data$Population_1 != "WAL" & data$Population_2 != "WAL",], color = "#EE1144")
#
#pdf("ibd.pdf", width=8, height=6)
#p
#dev.off()

pdf("ibd2a.pdf", width=4*1.2, height=3*1.2)
p
dev.off()


#87	Pool8	Pool10	0.305021868837451	1314641	AMT1	JD1	fst	amt1	jd1	0.0507287008176	distance	AMT1	JD1	7659.83787223
#86	Pool8	Pool9	0.260076073890885	1314641	AMT1	SWP4	fst	amt1	swp4	0.0464031924059	distance	AMT1	SWP4	8742.35844527
