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

	run_CANOES.R
	description :
		main script used to call CNV with CANOES, used for a complete batch
	command :
		Rscript run_CANOES.R CANOES.R $prefix.gc.txt $prefix.reads.txt sample.list outName
	input :
		the official Rlib CANOES.R
		the gcCount
		the readCount
		the sampleList (1 per line)
		an prefix for the output
	output :
		a csv file containing all the cnv detected, the file name is $outName.cnv.csv

	************************************************************************

	run_monoCANOES.R
	description : 
		variation from main script, used to call on one sample only (useful for splitting process)
	command :
		Rscript run_monoCANOES.R CANOES.R $prefix.gc.txt $prefix.reads.txt sample.list sampleId
	input :
		the official Rlib CANOES.R
                the gcCount
                the readCount
                the sampleList (1 per line)
                the sample to analyse
	
	output :
		csv file named sampleId.cnv.csv containing all the cnv detected

	************************************************************************

	extratToBedFormat.sh
	description :
		bash script used to convert from csv to bed format
	command :
		./extractToBedFormat.sh cnv.csv > cnv.bed
	input :
		direct output from R script
	output :
		a converted bed file
	
	************************************************************************
