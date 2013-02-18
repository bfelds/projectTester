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

my @tests = (-1,100,0,1,2,3,4,5,6,7,8,3.4,11.1);
my @answers = (-2,200,0,2,4,6,8,10,12,14,16,6.8,22.2);
my $numCorrect =0;
my $numTests = @tests;
while(@tests){
	my $currtest = shift @tests;
	my $currans = shift @answers;
	my $pid = open3(\*WRITE, \*READ,\*ERROR,$ARGV[0]);

	my $sel = new IO::Select();

	$sel->add(\*READ);
	$sel->add(\*ERROR);
	print WRITE "$currtest\n";
	my $buf='';
	sysread(READ,$buf,4096);
	if($buf==$currans){
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
