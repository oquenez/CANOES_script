use Getopt::Long;
use strict;

#Define boolean constant
use constant false => 0;
use constant true  => 1;

my $sampleFile;
my $output;
GetOptions(
	"sample=s" => \$sampleFile,
	"output=s" => \$output
);

open(SAMPLE,"<$sampleFile") or die ("can't open sample file $sampleFile\n");
open(OUTFILE,">$output") or dir ("can't open output file $output\n");
my $firstFile = true;
my @outArray;

while (<SAMPLE>){
        chomp($_);
	open(FILE, "<$_.reads.txt") or die ("can't open $_.reads.txt\n");
	my $lNb=0;
	if ($firstFile){
		$firstFile = false;
		while(<FILE>){
			chomp($_);
			my @line = split("\t",$_);
			@{$outArray[$lNb]}=@line;
			$lNb++;
		}
	}else{
		while(<FILE>){
			chomp($_);
			my @line = split("\t",$_);
			push(@{$outArray[$lNb]},@line[3 .. (scalar(@line)-1)]);
			$lNb++;
		}
	}
	close(FILE);
}
for my $line (@outArray){
	print OUTFILE join("\t",@$line),"\n";
}

close(SAMPLE);
close(OUTFILE);
