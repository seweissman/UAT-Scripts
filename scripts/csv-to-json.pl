open(FILEIN, "<$ARGV[0]");
$start = $ARGV[1];

my %thesaurus;
my @topnodes;
while($line = <FILEIN>){
    chomp $line;
    @line = split(",",$line);
    if($start && ($line[0] ne $start)){
	next;
    }
    #print "$line\n";
    if($#line >= 1){

	$parent = $line[$#line-1];
	$child = $line[$#line];
	if(!$thesaurus{$parent}){
	    $thesaurus{$parent} = {};
	}
	$thesaurus{$parent}->{$child} = 1;
    }elsif($#line == 0){
	push @topnodes,$line[0];
    }

}
# while ( my ($key, $value) = each(%thesaurus) ) {
#     print "$key => $value\n";
#     while ( my ($key1, $value1) = each(%$value) ) {
# 	print "$key1 => $value1\n";
#     }
# }

if($start){
    printthesaurus($start,0);
}else{
    print "{\"children\": [";    
    for(my $i=0; $i<=$#topnodes; $i++){
	printthesaurus($topnodes[$i],$i != $#topnodes);
    }
    print "]}";
}
#$children = $thesaurus{"Stellar astronomy"};
#print "$children\n";
#@keys = keys %{$children};
#print "$#keys\n";
#foreach $word (keys %thesaurus){
#    print "Word; $word\n";
#}

sub printthesaurus {
    my $root = $_[0];
    my $hasnext = $_[1];
    print "{\"name\": \"$root\"";

    my $children = $thesaurus{$root};
    if($children){
	print ", \"children\": [";

	my @keys = sort(keys(%{$children}));
	for(my $i=0; $i<=$#keys; $i++){
	    printthesaurus($keys[$i],$i != $#keys);
	}
    #while ( my ($key, $value) = each(%$children) ) {
#	
 #   }
	if($children){
	    print "]";
	}
    }
    print "}";
    if($hasnext){
	print ", ";
    }
}
