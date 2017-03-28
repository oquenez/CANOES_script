use Getopt::Long;
use strict;

#Define boolean constant
use constant false => 0;
use constant true  => 1;

my $sampleFile;
GetOptions(
	"sample=s"     => \$sampleFile
);

open(SAMPLE,"<$sampleFile") or die ("can't open sample file $sampleFile\n");

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
}
for my $line (@outArray){
	print join("\t",@$line),"\n";
}
