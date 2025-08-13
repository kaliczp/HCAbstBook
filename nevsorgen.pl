# for i in `ls *txt`; do perl ../nevsorgen.pl $i < $i >> fullauthtitle.txt; done
my $number = 0;
my $moreinst = 0;
$inst_was = 0;
my $title = "Test";
my $authors = "Peter Kalicz";
while ($line = <STDIN>)
{
    $number++;
    $line =~ s/\r//g;
    chomp $line;
    if($number == 1){
	$title = $line;
    }
    if($number == 3){
	## A tartalomjegyzék sor előállítása. Nem szedett ki :2-ket!
	$rawauth = $line;
	if($rawauth =~ /\([1-9]/){
	    $rawauth =~ s/\([1-9]//g;
	    $rawauth =~ s/\:[2-9]//g;
	    $moreinst = 1;
	}
	my @authors = split(",",$rawauth);
	$numauthors = $#authors + 1;
	@name = split(" ",@authors[0]);
	$firstauthname = @name[$#name];
	if($numauthors > 1){
	    if($numauthors > 2){
		$firstauthname = join(" ",$firstauthname,"et~al.");
	    } else {
		@name = split(" ", @authors[1]);
		$secondauth = @name[$#name];
		$firstauthname = join("",$firstauthname," and ", $secondauth,".");
	    }
	} else {
	    $firstauthname = join("",$firstauthname,".")
	}
	## A szerzők csinosítása a szöveghez
	## In the case of several institutions
	if($line =~ /\(/){
	    $line =~ s/\([0-9]//g;
	    ## Több hivatkozás direkt csere. Jobb megoldás kellene.
	    $line =~ s/:2:3//g;
	    $line =~ s/:2//g;
	    $line =~ s/:3:7//g;
	    $line =~ s/:3//g;
	    $line =~ s/:3//g;
	    $line =~ s/:4//g;
	    $line =~ s/:7//g;
	    $line =~ s/:5//g;
	    $line =~ s/:6//g;
	    $line =~ s/:6//g;
	    $line =~ s/:9//g;
	    $line =~ s/:10//g;
	}
	$authors = $line;
# A nem vesszővel kezdődő szóközök cserélése törhetetlenné.
#	$authors =~ s///g
	## Miután a szerzők megvannak lehet írni a toc-ot és
	## a szöveget.
	print $authors,": ";
	print $title;
    }
    if($number > 4 && $number < 16 && $line =~ m/[0-9]\)/ && $inst_was < 2){
	if($moreinst){
#	    $line =~ s/^10/{10}\$/;
	    $line =~ s/^/\$\^/;
	    $line =~ s/\)/\$/;
	} else { # Csak egy institute
	    $line =~ s/^1\)//;
	}
	## Itt csak menteni kellene
	$inst_was = 1;
    }
    if ($number > 5 && $number < 20 && $line =~ /^\s*$/) { # checks for 0 or more whitespaces (\s*) bound by beginning(^)/end($) of line.
	$inst_was = 2;
	## Institutionokat nyomtatni, aztán az emailt
	$number = 21;
    }
    # if($number > 5 && $number < 10 && $line !~ /\)/ && $inst_was !~ 1){
    # 	## Institutionokat nyomtatni, aztán az emailt
    # 	print "\\end{flushleft}\n\n\\noindent\n";
    # 	$number = 20;
    # }
}
print "\n\n";
