use Getopt::Long;
use strict;

#Define boolean constant
use constant false => 0;
use constant true  => 1;

my $in;
my $out;

GetOptions(
	"in=s"  => \$in,
	"out=s" => \$out
);

open( INFILE,  "<$in" )  or die("can't open input file : $in\n");
open( OUTFILE, ">$out" ) or die("can't open output file : $out\n");
my $lastGene;
my $fLine = <INFILE>;
my %storedline;
chomp($fLine);
my @fLines = split( "\t", $fLine );
$storedline{'chr'}   = $fLines[0];
$storedline{'start'} = $fLines[1];
$storedline{'end'}   = $fLines[2];
$storedline{'ind'}    = $fLines[3];
$storedline{'dd'}    = $fLines[4];
$storedline{'gene'} = $fLines[12];
$storedline{'size'} = $fLines[5];
$storedline{'target'} = $fLines[6];
$storedline{'tx'} = $fLines[7];
$storedline{'score'} = $fLines[8];
$lastGene = $fLines[12];

while ( my $line = <INFILE> ) {
	chomp($line);
	my @lines = split( "\t", $line );
	if (   ( $lines[0] eq $storedline{'chr'} )
		&& ( $lines[1] eq $storedline{'start'})
		&& ( $lines[4] eq $storedline{'dd'} )
		&& ( $lines[3] eq $storedline{'ind'} )
	 )
	{
		$storedline{'end'}=$lines[2];
		if ($lastGene ne $lines[12] ){
			$storedline{'gene'}="$storedline{'gene'},$lines[12]";
			$lastGene = $lines[12];
		}
	}
	else {
		my @list = split(",",$storedline{'gene'});
		my %genes;
		foreach my $gene (@list){
			$genes{$gene}=1;
		}
		print OUTFILE $storedline{'chr'}, "\t", $storedline{'start'}, "\t",
		  $storedline{'end'}, "\t", $storedline{'ind'}, "\t", $storedline{'dd'}, "\t", $storedline{'size'},"\t",$storedline{'target'},"\t",$storedline{'tx'},"\t",$storedline{'score'},"\t",join(",",keys(%genes)),"\n";
		$storedline{'chr'}   = $lines[0];
		$storedline{'start'} = $lines[1];
		$storedline{'end'}   = $lines[2];
		$storedline{'ind'}    = $lines[3];
		$storedline{'dd'}    = $lines[4];
		$storedline{'gene'} = $lines[12];
		$storedline{'size'} = $lines[5];
		$storedline{'target'} = $lines[6];
		$storedline{'tx'} = $lines[7];
		$storedline{'score'} = $lines[8];
		$lastGene = $lines[12];
	}
}
my @list = split(",",$storedline{'gene'});
my %genes;
foreach my $gene (@list){
	$genes{$gene}=1;
}
print OUTFILE $storedline{'chr'}, "\t", $storedline{'start'}, "\t",
	$storedline{'end'}, "\t", $storedline{'ind'}, "\t", $storedline{'dd'}, "\t", $storedline{'size'},"\t",$storedline{'target'},"\t",$storedline{'tx'},"\t",$storedline{'score'},"\t",join(",",keys(%genes)),"\n";

close(INFILE);
close(OUTFILE);
