#launch CANOES
args<-commandArgs(TRUE)

#	args[1] #path CANOES.R
#	args[2] #path gc file 
#	args[3] #path reads file
#	args[4] #path to allSample list
#	args[5] #sample to analyses


source(args[1])

#gc <- read.table("CNVClean20.gc.txt")$V2
gc <- read.table(args[2])$V2
#canoes.reads <- read.table("CNVClean20.reads.txt")
canoes.reads <- read.table(args[3])
sample.names <- unlist(read.table(args[4], stringsAsFactors=FALSE))
names(canoes.reads) <- c("chromosome", "start", "end", sample.names)
target <- seq(1, nrow(canoes.reads))
canoes.reads <- cbind(target, gc, canoes.reads)
xcnvs <- CallCNVs(args[5], canoes.reads)

write.csv2(xcnvs,file=paste0(args[5],".cnv.csv"))
