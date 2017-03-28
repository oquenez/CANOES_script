#launch CANOES
args<-commandArgs(TRUE)

#	args[1] #path CANOES.R
#	args[2] #path gc file 
#	args[3] #path reads file
#	args[4] #path to complete Sample file
#	args[5] #path to sample to analyses
#       args[6] #path to CNV file
#	args[7] #output file prefix


source(args[1])

gc <- read.table(args[2])$V2
canoes.reads <- read.table(args[3])
sample.names <- unlist(read.table(args[4], stringsAsFactors=FALSE))
names(canoes.reads) <- c("chromosome", "start", "end", sample.names)
analyse<-unlist(read.table(args[5],stringsAsFactors=FALSE))
target <- seq(1, nrow(canoes.reads))
canoes.reads <- cbind(target, gc, canoes.reads)
#myCNV<-data.frame(SAMPLE=factor("F_SAMPLE"),CNV=factor("DUP"),INTERVAL=factor("3:47960150-47960363"),KB=0.213,CHR=3,MID_BP=47960256,TARGETS=factor("41172..41172"),NUM_TARG=1,MLCN=3,Q_SOME=47)
x<-read.table(file=args[6],sep=";",header=T)
geno.list <- list()
for (i in 1:length(analyse)){
	geno.list[[analyse[i]]] <- GenotypeCNVs(x,analyse[i],canoes.reads,Tnum=2,D=10000)
}
genos <- do.call('rbind',geno.list)

write.csv2(genos,file=paste0(args[7],".genotype.csv"))

