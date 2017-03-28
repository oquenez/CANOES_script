#launch CANOES
args<-commandArgs(TRUE)

#	args[1] #path CANOES.R
#	args[2] #path gc file 
#	args[3] #path reads file
#	args[4] #path to allSample list
#	args[5] #path to sample to analyses
#	args[6] #output file prefix


source(args[1])

#gc <- read.table("CNVClean20.gc.txt")$V2
gc <- read.table(args[2])$V2
#canoes.reads <- read.table("CNVClean20.reads.txt")
canoes.reads <- read.table(args[3])
sample.names <- unlist(read.table(args[4], stringsAsFactors=FALSE))
names(canoes.reads) <- c("chromosome", "start", "end", sample.names)
analyse<-unlist(read.table(args[5],stringsAsFactors=FALSE))
target <- seq(1, nrow(canoes.reads))
canoes.reads <- cbind(target, gc, canoes.reads)
xcnv.list <- vector('list', length(analyse))
for (i in 1:length(analyse)){
	xcnv.list[[i]] <- CallCNVs(analyse[i], canoes.reads)
}
xcnvs <- do.call('rbind', xcnv.list)

write.csv2(xcnvs,file=paste0(args[6],".cnv.csv"))
