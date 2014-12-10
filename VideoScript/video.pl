#Mark Evans
#video title cleaner
open(STR, "< strings.txt");
my @strings = <STR>;
close STR;
for (my $y = 0; $y <= $#strings; $y++){
	chomp($strings[$y]);
}
my @extn = ("avi","mkv","avi","mp4","wmv","flv","mov");
my $dir = "";
my @maindirs = glob "$dir\*";
#my @maindirs = "Movies";
for(my $j = 0;$j <= $#maindirs; $j++){
	if(-d $maindirs[$j]){
		opendir(DIR, $maindirs[$j]) or die "couldn't open $maindirs[$j]";
		while(my $file = readdir(DIR)){
			next if($file =~ /^\./);
			if(-f "$maindirs[$j]/$file"){#file
				foreach my $ext (@extn){
					if($file =~ m/${ext}$/){
						my $nname = renamefile($maindirs[$j],$file);
						rename "$maindirs[$j]/$file", "$maindirs[$j]/$nname" or print "couldn't rename";
					}
				}
			}elsif(-d "$maindirs[$j]/$file"){#dir
			#	print "dir: $file\n";
				my $nname = mvfile($maindirs[$j],$file);
				#rename "$maindirs[$j]/$file", "$maindirs[$j]/$nname" or die "couldn't rename";
			}
		}
		closedir(DIR);
		print "done dir \n\n";
	}
}
    
sub mvfile{
	my ($ddir, $vdir) = @_;
	my $nname = renamedir($ddir,$vdir);
	rename "$ddir/$vdir", "$ddir/$nname" or print "couldn't rename $ddir/$nname";
	$vdir = $nname;
	my $vidtext;
	unless($vdir =~ m/complete|season|Duology|Trilogy|Quadriology|Pentalogy|Hexalogy|Heptalogy|Octalogy/i){
		print "dir pass check 1: ".$vdir."\n";
		my @vids = ();
		my @fdirs = ();
		opendir(DIRA, "$ddir/$vdir") or die "couldn't open $ddir";
		while(my $fil = readdir(DIRA)){
			print "file in check 2:".$fil."\n";
			next if($fil =~ /^\./);
			next if($fil =~ /sample/i);
			if(-d $fil){push(@fdirs,$fil);next;};
			$vidext = substr($fil, -3);
			next unless ($vidext =~ m/avi|mkv|avi|mp4|wmv|flv|mov/);
			push (@vids, $fil);
			print "file pass check 2:".$fil."\n";
		}
		closedir(DIRA);
		if(scalar(@vids) == 1 && scalar(@fdirs) < 2){
			print $vids[0]." only good vid in $vdir \n";
			$vidext = substr($vids[0], -4);
			my $nvname = $vdir."$vidext";
			print "new name: $nvname\n\n";

			rename "$ddir/$vdir/$vids[0]","$ddir/$nvname";
			system('rmdir','/s/q',"$ddir\\$vdir");
	
		}else{print "wrong num of vids or dirs in $vdir\n\n";closedir(DIRA);};
		



	}else{print "dir doesn't match folder const\n\n";closedir(DIRA);};
	
}

sub renamefile{
	my ($path,$name) = @_;
	print $name."\n";
	my ($ex) = $name =~ m/(\.\w{3})$/;
	$name =~ s/\.\w{3}$//;
	foreach my $strin (@strings){
		$name =~ s/\Q$strin\E//i;
	}
	@name = split(/[\.\(\)\[\]_\s]+/,$name);
	for(my $k = 0; $k <= $#name;$k++){
		next if($name[$k] =~ m/^\./);
		if($name[$k] =~ m/((20|19)\d{2})/){
			$name[$k] = "(".$1.")";
		}elsif($name[$k] =~ m/(720|1080)/){
			$name[$k] = "[".$1."p]";
		}elsif($name[$k] =~ m/(s\d\de\d\d)/i){
			$name[$k] = uc($name[$k]);
		}else{
			$name[$k] = lc($name[$k]);
			$name[$k] = ucfirst($name[$k]);
		}
	}
	
	my $fname = join(' ',@name);
	$fname .= $ex;
	print $fname."\n";
	return $fname;
}

sub renamedir{
	my ($path,$name) = @_;
	print $name."\n";
	foreach my $strin (@strings){
		$name =~ s/\Q$strin\E//i;
	}
	@name = split(/[\.\(\)\[\]_\s]+/,$name);
	for(my $k = 0; $k <= $#name;$k++){
		next if($name[$k] =~ m/^\./);
		if($name[$k] =~ m/((20|19)\d{2})/){
			$name[$k] = "(".$1.")";
		}elsif($name[$k] =~ m/(720|1080)/){
			$name[$k] = "[".$1."p]";
		}elsif($name[$k] =~ m/(s\d\de\d\d)/i){
			$name[$k] = uc($name[$k]);
		}else{
			$name[$k] = lc($name[$k]);
			$name[$k] = ucfirst($name[$k]);
		}
	}
	
	my $fname = join(' ',@name);
	print $fname."\n";
	return $fname;
}
