#!/usr/bin/perl

@record=();
use DBI();

open(DATA,"<:utf8","vp.xml") or die("cannot open vp.xml");

my $dbh=DBI->connect("DBI:mysql:database=vp;host=localhost","root","mysql") or die $DBI::errstr;
$dbh->{'mysql_enable_utf8'} = 1;
$dbh->do('set names utf8');

$sth11=$dbh->prepare("CREATE TABLE article(title varchar(300), tkey varchar(5), feature varchar(100), authid int(10), akey varchar(5), volume varchar(50), year varchar(50), month varchar(250), issuenum int(2), page int(5)) ENGINE=MyISAM character set utf8 collate utf8_general_ci;");
$sth11->execute();
$sth11->finish(); 

$line=<DATA>;

while($line)
{

	chop($line);
	
	if($line =~ /<volume>(.*)<\/volume>/)
	{
		$volume = $1;
	}
	if($line =~ /<issuenum>(.*)<\/issuenum>/)
	{
		$issuenum = $1;
	}
	if($line =~ /<year>(.*)<\/year>/)
	{
		$year = $1;
	}
	if($line =~ /<month>(.*)<\/month>/)
	{
		$month = $1;
	}
	if($line =~ /<title tkey="(.*)">(.*)<\/title>/)
	{
		$tkey = $1;		
		$title = $2;
	}
	if($line =~ /<author akey="(.*)">(.*)<\/author>/)
	{
		$akey = $1;
		$author = $2;
	}
	if($line =~ /<page>(.*)<\/page>/)
	{
		$page = $1;		
	}
	if($line =~ /<feature>(.*)<\/feature>/)
	{
		$feature = $1;
	}
	if($line =~ /<salutation>(.*)<\/salutation>/)
	{
		$salutation = $1;
		insert_list($volume, $issuenum, $year, $month, $title, $author, $page, $feature, $salutation, $akey, $tkey);
	}
	
	$line = <DATA>;
}	

close(DATA);

sub insert_list
{
	my ($volume, $issuenum, $year, $month, $title, $author, $page, $feature, $salutation, $akey, $tkey)=@_;

	if($author ne "")
	{
		$sth=$dbh->prepare("select authid from author where authorname='$author' and salutation='$salutation'");
		$sth->execute();
			
		my $ref = $sth->fetchrow_hashref();
		
		$authid = $ref->{'authid'};
		$sth->finish();
	}
	else
	{
		$authid = 0;
	}
		
	$sth1=$dbh->prepare("insert into article values('$title','$tkey','$feature','$authid','$akey','$volume','$year','$month','$issuenum','$page')");
	$sth1->execute();
	
	$sth1->finish();

}

$dbh->disconnect();
