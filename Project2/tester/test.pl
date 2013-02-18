#!/usr/bin/env perl
use 5.16.2;
use strict;
use warnings;
use IPC::Open3;
use IO::Select;

my $argc = @ARGV;
if($argc < 1) {
	say "Need to pass in filename.";
	exit -1;
}

my @tests = (-5,-5.5,-.03,0,1,4,2.1);
my @answers = (1,1,1,0,0,0,0);
my @strAns = ("The value is not negative.","The value is negative.");
my $numCorrect =0;
my $numTests = @tests;
while(@tests){
	my $currtest = shift @tests;
	my $currans = $strAns[shift @answers];
	my $pid = open3(\*WRITE, \*READ,\*ERROR,$ARGV[0]);

	my $sel = new IO::Select();

	$sel->add(\*READ);
	$sel->add(\*ERROR);
	print WRITE "$currtest\n";
	my $buf='';
	sysread(READ,$buf,4096);
	chomp($buf);
	if($buf eq $currans){
		say "$currtest: is correct";
		++$numCorrect;
	}else {
		say "$currtest: $currans!=$buf";
	}
	my $exists = kill 0, $pid;
	kill 1,$pid  if($exists);
}
say "PASSED!" if($numCorrect==$numTests);
say "FAILED!" if($numCorrect!=$numTests);
