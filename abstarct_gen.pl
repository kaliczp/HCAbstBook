my $number = 0;
my $moreinst = 0;
$inst_was = 0;
my $title = "Test";
my $authors = "Peter Kalicz";
print "\\phantomsection\n";
print "\\stepcounter{articleid}\n";
while ($line = <STDIN>)
{
    $number++;
    $line =~ s/\r//g;
    chomp $line;
    if($number == 1){
	$title = $line;
    }
    if($number == 3){
	## A tartalomjegyzék sor előállítása.
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
	print "\\addcontentsline{toc}{section}{";
	print join(" ",$firstauthname,$title),"}\n";
	## A szerzők csinosítása a szöveghez
	## In the case of several institutions
	if($line =~ /\(/){
	    $line =~ s/\(/\$\^/g;
	    $line =~ s/,/\$,/g;
	    $line =~ s/$/\$/;
	    ## Több hivatkozás direkt csere. Jobb megoldás kellene.
	    $line =~ s/1:2:3/\{1,2,3\}/g;
	    $line =~ s/1:2/\{1,2\}/g;
	    $line =~ s/1:5/\{1,5\}/g;
	    $line =~ s/2:3:7/\{2,3,7\}/g;
	    $line =~ s/1:3:5/\{1,3,5\}/g;
	    $line =~ s/2:4:5/\{2,4,5\}/g;
	    $line =~ s/2:3/\{2,3\}/g;
	    $line =~ s/1:3/\{1,3\}/g;
	    $line =~ s/2:4/\{2,4\}/g;
	    $line =~ s/1:7/\{1,7\}/g;
	    $line =~ s/4:5/\{4,5\}/g;
	    $line =~ s/4:6/\{4,6\}/g;
	    $line =~ s/2:6/\{2,6\}/g;
	    $line =~ s/3:9/\{3,9\}/g;
	    $line =~ s/3:4/\{3,4\}/g;
	    $line =~ s/3:5/\{3,5\}/g;
	    $line =~ s/2:10/\{2,10\}/g;
	}
	$fullauthors = $line;
# A nem vesszővel kezdődő szóközök cserélése törhetetlenné.
#	$authors =~ s///g
	## Miután a szerzők megvannak lehet írni a toc-ot és
	## a szöveget.
	print "\\begin{flushleft}\n";
	print "\n\\abstrtitle{",$title,"}\n\n";
	print "\\name{",$fullauthors,"}\n\n";
	## Creation of indexes
	for (my $nameidx=0; $nameidx < $numauthors; $nameidx++) {
	    $aktauth = @authors[$nameidx];
	    $aktauth =~ s/^\s+//;
	    ## Reorder name
	    @aktauthsplit = split(" ",$aktauth);
	    $reorderaktauth = join(", ", @aktauthsplit[$#aktauthsplit],@aktauthsplit[0]);
	    if($nameidx == 0){
		print "\\index{",$reorderaktauth,"|textit}\n";
	    } else {
		print "\\index{",$reorderaktauth,"}\n";
	    }
	}
    }
    if($number > 4 && $number < 16 && $line =~ m/[0-9]\)/ && $inst_was < 2){
	if($moreinst){
#	    $line =~ s/^10/{10}\$/;
	    $line =~ s/^/\$\^/;
	    $line =~ s/\)/\$/;
	    print "\\institute{",$line,"}\n\n";
	} else { # Csak egy institute
	    $line =~ s/^1\)//;
	    print "\\institute{",$line,"}\n\n";
	}
	## Itt csak menteni kellene
	$inst_was = 1;
    }
    if ($number > 5 && $number < 20 && $line =~ /^\s*$/) { # checks for 0 or more whitespaces (\s*) bound by beginning(^)/end($) of line.
	$inst_was = 2;
	## Institutionokat nyomtatni, aztán az emailt
	print "\\end{flushleft}\n\n\\noindent";
	$number = 21;
    }
    # if($number > 5 && $number < 10 && $line !~ /\)/ && $inst_was !~ 1){
    # 	## Institutionokat nyomtatni, aztán az emailt
    # 	print "\\end{flushleft}\n\n\\noindent\n";
    # 	$number = 20;
    # }
    if($number > 20){
	print $line,"\n";
    }
}
print "\\newpage{}\n";
