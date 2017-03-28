use Getopt::Long;
use strict;

#Script to filter cnv on different criteria: 
# size
# score

#Define boolean constant
use constant false => 0;
use constant true  => 1;

my $in;
my $score;
my $size;
my $out;
my $case;
my $control;
my $sampleSize;
my $pc;

GetOptions(
	"cnv=s"  => \$in,
	"score=i" => \$score,
	"size=i" => \$size,
	"sampleSize=i" => \$sampleSize,
	"case=s" => \$case,
	"control=s" => \$control,
	"out=s" => \$out,
	"pc=i" => \$pc
);

my $occLimit = $sampleSize/(100/$pc);
my %cnv;
my %controls;
my %cases;


#First step : loading the case/control list
open(CASE,"<$case") or die ("can't open cases list file):$case\n");
while (<CASE>){
	chomp($_);
	$cases{$_}=1;
}
close(CASE);

open(CONTROL,"<$control") or die ("can't open controls list file):$control\n");
while (<CONTROL>){
        chomp($_);
        $controls{$_}=1;
}
close(CONTROL);

#in = bedfile with 9 columns
#0 chr
#1 start
#2 end
#3 sample name
#4 type of CNV
#5 size
#6 nb target
#7 nb copy
#8 score


open( INFILE,  "<$in" )  or die("can't open input file : $in\n");
open( OUTFILE,  ">$out" )  or die("can't open output file : $out\n");
while (my $line =<INFILE>){
	my $keep = true;
	chomp($line);
	my @lines = split("\t", $line);
	#first filter : score quality
	if ($lines[8] eq "NA"){
		$keep=false;
	}else{
		if($lines[8]<$score){
			$keep=false;
		}
	}
	#next filter : size
	if($lines[5]<$size){
		$keep=false;
	}
	if($keep){
		my $key="$lines[0]-$lines[1]-$lines[2]-$lines[4]";
		if (!exists($cnv{$key})){
			$cnv{$key}{'count'}=1;
			if(exists($cases{$lines[3]})){
				$cnv{$key}{'case'}=1;
	                        $cnv{$key}{'control'}=0;
			}else{
				if(exists($controls{$lines[3]})){
					$cnv{$key}{'case'}=0;
	                                $cnv{$key}{'control'}=1;
				}else{
					$cnv{$key}{'case'}=0;
                                        $cnv{$key}{'control'}=0;
				}
			}
		}else{
			$cnv{$key}{'count'}=$cnv{$key}{'count'}+1;
			if(exists($cases{$lines[3]})){
                                $cnv{$key}{'case'}=$cnv{$key}{'case'}+1;
                        }else{
				if(exists($controls{$lines[3]})){
                                	$cnv{$key}{'control'}=$cnv{$key}{'control'}+1;
				}
                        }
		}
	}
}
for my $key (keys(%cnv)){
	if($cnv{$key}{'count'}<$occLimit){
		my @list=split("-",$key);
		print OUTFILE "$list[0]\t$list[1]\t$list[2]\t$list[3]\t",$cnv{$key}{'count'},"\t",$cnv{$key}{'case'},"\t",$cnv{$key}{'control'},"\n";
	}
}

close(INFILE);
close(OUTFILE);
