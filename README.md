# CANOES_script

All thoses scripts are made to analyse WES data with the software CANOES (http://www.columbia.edu/~ys2411/canoes/)

Follow the tutorial describe on the CANOES web page for the generation of the primary data (gc content and readcount).

Main scripts are:

	defineTarget.sh
	description :
		merge targets with less than 30bp
	command :
		./defineTarget.sh myCaptureKit.bed > myOutput.bed
	input :
		your captureKit target definition, in bed format
	output :
		extended catureKit in bed Format

	************************************************************************

	compilSample.pl
	description :
		merge all ReadCount from multiple Sample
	command:
		perl compilSample.pl --sample my sampleList --output project.reads.txt
	input:
		a list of readCount file, without ".reads.txt" suffix
	output:
		readCount File with all the sample. 

	************************************************************************

	cleanCANOESentries.pl 
	description : 
		clean all name of chromosome (remove "chr" and X/Y chromosomes).
		filter target if more than 10% of the samples present 0 reads
	command :
		perl cleanCANOESentries.pl --gc myGcdata.txt --reads myReadscount.txt --outPrefix myPrefix
	input :
		readCount file produces by bedtools multicov
		gcCount file produces by GATK GCContentByInterval
	output : 
		generate both readCount file and gc file. ($prefix.gc.txt and $prefix.reads.txt)
		
        ************************************************************************
