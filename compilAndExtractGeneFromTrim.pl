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
$storedline{'dd'}    = $fLines[3];
$storedline{'gene'} = $fLines[10];
$storedline{'score'} = $fLines[4];
$storedline{'cases'} = $fLines[5];
$storedline{'controls'} = $fLines[6];
$lastGene = $fLines[10];
my %genesCNV;

while ( my $line = <INFILE> ) {
	chomp($line);
	my @lines = split( "\t", $line );
	if (   ( $lines[0] eq $storedline{'chr'} )
		&& ( $lines[1] eq $storedline{'start'} )
		&& ( $lines[2] eq $storedline{'end'} )
		&& ( $lines[3] eq $storedline{'dd'})
	 )
	{
		if ($lastGene ne $lines[12] ){
			$storedline{'gene'}="$storedline{'gene'},$lines[10]";
			$lastGene = $lines[10];
		}
	}
	else {
		my @list = split(",",$storedline{'gene'});
		my %genes;
		foreach my $gene (@list){
			$genes{$gene}=1;
		}
		for my $k (keys(%genes)){
			my $keyGene = "$storedline{'dd'}%${k}";
			if(!exists($genesCNV{$keyGene})){
				$genesCNV{$keyGene}{'count'}=$storedline{'score'};
				$genesCNV{$keyGene}{'case'}=$storedline{'cases'};
				$genesCNV{$keyGene}{'control'}=$storedline{'controls'}
			}else{
				$genesCNV{$keyGene}{'count'}=$genesCNV{$keyGene}{'count'}+$storedline{'score'};
				$genesCNV{$keyGene}{'case'}=$genesCNV{$keyGene}{'case'}+$storedline{'cases'};
                                $genesCNV{$keyGene}{'control'}=$genesCNV{$keyGene}{'control'}+$storedline{'controls'};
			}
		}
		$storedline{'chr'}   = $lines[0];
		$storedline{'start'} = $lines[1];
		$storedline{'end'}   = $lines[2];
		$storedline{'dd'}    = $lines[3];
		$storedline{'gene'} = $lines[10];
		$storedline{'score'} = $lines[4];
		$storedline{'cases'} = $lines[5];
		$storedline{'controls'} = $lines[6];
		$lastGene = $lines[10];
	}
}
my @list = split(",",$storedline{'gene'});
my %genes;
foreach my $gene (@list){
	$genes{$gene}=1;
}
for my $k (keys(%genes)){
	my $keyGene = "$storedline{'dd'}%$k";
        if(!exists($genesCNV{$keyGene})){
        	$genesCNV{$keyGene}{'count'}=$storedline{'score'};
                $genesCNV{$keyGene}{'case'}=$storedline{'cases'};
                $genesCNV{$keyGene}{'control'}=$storedline{'controls'}
	}else{
        	$genesCNV{$keyGene}{'count'}=$genesCNV{$keyGene}{'count'}+$storedline{'score'};
                $genesCNV{$keyGene}{'case'}=$genesCNV{$keyGene}{'case'}+$storedline{'cases'};
                $genesCNV{$keyGene}{'control'}=$genesCNV{$keyGene}{'control'}+$storedline{'controls'};
	}
}
print OUTFILE "Gene\tCNV\tTotal\tCases\tControls\n";
for my $k (keys(%genesCNV)){
	my @key = split("%",$k);
	print OUTFILE "$key[1]\t$key[0]\t",$genesCNV{$k}{'count'},"\t",$genesCNV{$k}{'case'},"\t",$genesCNV{$k}{'control'},"\n";
}

close(INFILE);
close(OUTFILE);
