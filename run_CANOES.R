#launch CANOES
args<-commandArgs(TRUE)

#	args[1] #path to CANOES.R
#	args[2] #path to gc file 
#	args[3] #path to reads file
#	args[4] #path to samplelist file
#	args[5] #output file prefix


source(args[1])

gc <- read.table(args[2])$V2
canoes.reads <- read.table(args[3])
sample.names <- unlist(read.table(args[4], stringsAsFactors=FALSE))
names(canoes.reads) <- c("chromosome", "start", "end", sample.names)
target <- seq(1, nrow(canoes.reads))
canoes.reads <- cbind(target, gc, canoes.reads)
xcnv.list <- vector('list', length(sample.names))
for (i in 1:length(sample.names)){
	xcnv.list[[i]] <- CallCNVs(sample.names[i], canoes.reads)
}

xcnvs <- do.call('rbind', xcnv.list)
pdf(paste0(args[5],"_CNVplots.pdf"))
for (i in 1:nrow(xcnvs)){
  PlotCNV(canoes.reads, xcnvs[i, "SAMPLE"], xcnvs[i, "TARGETS"])
}
dev.off()

write.csv2(xcnvs,file=paste0(args[5],".cnv.csv"))
