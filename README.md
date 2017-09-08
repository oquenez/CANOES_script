# CANOES_script

All thoses scripts are made to analyse WES data with the software CANOES (http://www.columbia.edu/~ys2411/canoes/)

Follow the tutorial describe on the CANOES web page for the generation of the primary data (gc content and readcount).

Main scripts are:

	defineTarget.sh
	description :
		merge targets with less than 30bp
	input :
		your captureKit target definition, in bed format
	output :
		extended catureKit in bed Format


	
	cleanCANOESentries.pl 
	description : 
		clean all name of chromosome (remove "chr" and X/Y chromosomes).
		filter target if more than 10% of the samples present 0 reads
		
	input :
		readCount file produces by bedtools multicov
		gcCount file produces by GATK GCContentByInterval
	output : 
		generate both readCount file and gc file.
		
		
