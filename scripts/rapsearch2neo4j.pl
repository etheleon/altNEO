#!/usr/bin/env perl 
use strict;
use DBI;
my $dbh = DBI->connect(
#    "dbi:SQLite:dbname=/Users/uesu/sqlpleasure/test.db", #local
        "dbi:SQLite:dbname=/export2/home/uesu/sequencing.output/data/gi_taxid_prot.db","","",  #db file, user, pwd
        { RaiseError => 1 },) || die $DBI::errstr;

#input
#HWI-ST884:57:1:1101:13989:75421#0/1     gi|163754271|ref|ZP_02161394.1| 56.6667 30      13      0   99       10      55      84      -0.14   37.7354

if($#ARGV != 1) { 
    print "Usage: rapsearch2neo4j.pl rapsearch edges.tsv\n";
    exit;}

open(EDGES, "> $ARGV[1]") || die $!;
print EDGES "readid:string:readID\tgi:int:giid\tread2gi\tlogevalue\tbitscore\tpair\n";

open(INPUT, "$ARGV[0]") || die $!; 
while(<INPUT>) { 
if(/ref/){
chomp;
my @a=split("\t");

$a[0]=~/(^.+)\/(\d)$/;
my $readID=$1;
my $pair=$2;
$a[1]=~/^gi\|(\d+)/;
my $giid=$1;

#checks if the gi in the database
  my $sth = $dbh->prepare("SELECT COUNT(*) FROM ( SELECT * from gi2taxid where gi=$giid);");
            $sth->execute();
                my $rownum = $sth->fetchrow();
if($rownum != 0) { 
my $identity=$a[2];
my $logevalue=$a[10];
my $bitscore=$a[11];

print EDGES "$readID\t$giid\tlink\t$logevalue\t$bitscore\t$pair\n";
}}} 
