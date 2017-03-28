#launch CANOES
args<-commandArgs(TRUE)

#	args[1] #path to CANOES.R
#	args[2] #path to reads file
#	args[3] #path to gc file
#	args[4] #path to samplelist file
#	args[5] #output file prefix


source(args[1])

canoes.reads <- read.table(args[2])
gc <- read.table(args[3])$V2
sample.names <- unlist(read.table(args[4], stringsAsFactors=FALSE))
names(canoes.reads) <- c("chromosome", "start", "end", sample.names)
target <- seq(1, nrow(canoes.reads))
canoes.reads <- cbind(target, gc, canoes.reads)
myCNV<-data.frame(SAMPLE=factor("F_SAMPLE"),CNV=factor("DUP"),INTERVAL=factor("3:47960150-47960363"),KB=0.213,CHR=3,MID_BP=47960256,TARGETS=factor("41172..41172"),NUM_TARG=1,MLCN=3,Q_SOME=47)
geno.list <- list()
for (i in 1:length(sample.names)){
	geno.list[[sample.names[i]]] <- GenotypeCNVs(myCNV,sample.names[i],canoes.reads)
}
genos <- do.call('rbind',geno.list)

write.csv2(genos,file=paste0(args[5],".genotype.csv"))
