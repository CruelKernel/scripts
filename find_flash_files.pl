#!/usr/bin/env perl

use warnings;
use strict;

sub read_file
{
	my @lines;
	my $file = shift;

	open(my $fh, "<", $file)
		or die "Can't read $file: $!";
	push @lines, $_ foreach <$fh>;
	close $fh;

	return wantarray ? @lines : join('', @lines);
}

my $str = read_file $ARGV[0];
my @files = read_file $ARGV[1];

my %PIT;

while ($str =~ m/^Partition\hName:\h+(?<partition>\w+)\n
		  Flash\hFilename:\h+(?<filename>(?:\w+\.(?:bin|img))|-)?$/gmx) {
	$PIT{$+{partition}} = $+{filename} if $+{filename} && $+{filename} ne '-';
}

my %FILES;
foreach (@files) {
	chomp;
	my $basename = substr($_, rindex($_, '/') + 1);
	$FILES{$basename} = $_;
}

foreach (keys %PIT) {
	my $fn = $PIT{$_};
	if ($FILES{$fn}) {
		$PIT{$_} = $FILES{$fn};
		delete $FILES{$fn};
	} else {
		warn "Can't find PIT $_ file $fn\n";
		delete $PIT{$_};
	}
}

foreach (keys %FILES) {
	warn "Can't find PIT to flash file $FILES{$_}\n";
}

my %prio = (
	BL => 1,
	AP => 2,
	CP => 3,
	CSC => 4
);

my $cmd = '';
foreach (sort {
		# 6 - strlen(files/)
		my $d1 = substr($PIT{$a}, 6, index($PIT{$a}, '/', 6) - 6);
		my $d2 = substr($PIT{$b}, 6, index($PIT{$b}, '/', 6) - 6);

		$prio{$d1} <=> $prio{$d2} || $a cmp $b
	} keys %PIT) {
	$cmd .= '--' . $_ . " $PIT{$_} ";
}

print $cmd . "\n";
