my $number = 0;
my $moreinst = 0;
$inst_was = 0;
my $title = "Test";
my $authors = "Peter Kalicz";
my $first_paragraph = 0;
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
    if($number == 2){
	## A tartalomjegyzék sor előállítása.
	$rawauth = $line;
	if($rawauth =~ /[2-9]/){
	    $rawauth =~ s/[1-9]//g;
	    $rawauth =~ s/,,,/,/g;
	    $rawauth =~ s/,,/,/g;
	    $rawauth =~ s/, $//g;
	    $moreinst = 1;
	} else {
	    $rawauth =~ s/1//g;
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
	print "\\addcontentsline{toc}{subsection}{";
	print join(" ",$firstauthname,$title),"}\n";
	## A szerzők csinosítása a szöveghez
	## In the case of several institutions
	if($line =~ /[2-9]/){
	    $line =~ s/([1-9],[2-9],[2-9]), /\$\^{$1}\$, /g; # 3 nums
	    $line =~ s/([1-9],[2-9]), /\$\^{$1}\$, /g; # 2 nums
	    $line =~ s/([1-9]), /\$\^$1\$, /g; # 1 num
	    $line =~ s/([1-9],[2-9])$/\$\^{$1}\$/g; # 2 nums at end
	    $line =~ s/([1-9])$/\$\^$1\$/g; # 1 num at end
	} else { # Only one institution
	    $line =~ s/1/\$\^1\$/g;
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
    if($number > 2 && $number < 10 && $line =~ m/[0-9]/ && $inst_was < 2){
	if($moreinst){
#	    $line =~ s/^10/{10}\$/;
	    $line =~ s/^/\$\^/;
	    $line =~ s/ /\$/;
	    print "\\institute{",$line,"}\n\n";
	} else { # Csak egy institute
	    $line =~ s/^1 /\$\^1\$/;
	    print "\\institute{",$line,"}\n\n";
	}
	## Itt csak menteni kellene
	$inst_was = 1;
    }
    if ($number > 3 && $number < 16 && $line =~ /^\s*$/) { # checks for 0 or more whitespaces (\s*) bound by beginning(^)/end($) of line.
	$inst_was = 2;
	$number = 10;
    }
    # if($number > 5 && $number < 10 && $line !~ /\)/ && $inst_was !~ 1){
    # 	## Institutionokat nyomtatni, aztán az emailt
    # 	print "\\end{flushleft}\n\n\\noindent\n";
    # 	$number = 20;
    # }
    if($inst_was > 1 && $number > 10 && $number < 20) {
	if($line =~ /@/){
	    ## After affiliation email is printed
	    $line =~ s/Corresponding author: //;
	    print "\\email{",$line,"}\n\n";
	    print "\\end{flushleft}\n\n";
	} else { # in case of no email address
	    print "\\end{flushleft}\n\n\\noindent ";
	    print $line,"\n\n";
	    $first_paragraph = 1;
	}
	$number = 20;
    }
    if($number > 20 && $line !~ /^\s*$/){
	if($first_paragraph < 1){
	    $first_paragraph = 1;
	    print "\\noindent ",$line,"\n\n";
	} else {
	    print $line,"\n\n";
	}
    }
}
print "\\newpage{}\n";
