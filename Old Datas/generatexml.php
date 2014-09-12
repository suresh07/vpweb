<?php
	$db_con=mysql_connect("localhost", "root", "mysql") or die("not connected to database");
	mysql_select_db("vp") or die ("no database");
	mysql_set_charset("utf8",$db_con);
	$result=mysql_query("select * from article") or die("querry failed".mysql_error());
	$file=fopen("vp.xml","w");
	
	$num_rows=mysql_num_rows($result);
	
	$count=0;
	$oldvol=1;$oldissue=1;
	
	for($i=0;$i<$num_rows;$i++)
	{
		$row=mysql_fetch_assoc($result);
		if($count++==0)
		{
			fwrite($file,"<vp>\n");
			fwrite($file,"\t<volume vnum=\"".$row['volume']."\">\n");
			fwrite($file,"\t\t<issue inum=\"".$row['issuenum']."\" month=\"".$row['month']."\" year=\"".$row['year']."\" theme=\"\">\n");
		}
		
		if($row['issuenum']!=$oldissue)
		{	
			fwrite($file,"\t\t</issue>\n");
			
			if($row['volume']!=$oldvol)
			{
				fwrite($file,"\t</volume>\n");
				fwrite($file,"\t<volume vnum=\"".$row['volume']."\">\n");
				$oldvol=$row['volume'];
			}
			
			$oldissue=$row['issuenum'];
			fwrite($file,"\t\t<issue inum=\"".$row['issuenum']."\" month=\"".$row['month']."\" year=\"".$row['year']."\" theme=\"\">\n");
		}
		
		fwrite($file,"\t\t\t<entry>\n");
		fwrite($file,"\t\t\t\t<title>".$row['title']."</title>\n");
		fwrite($file,"\t\t\t\t<feature>".$row['feature']."</feature>\n");
		fwrite($file,"\t\t\t\t<text></text>\n");
		fwrite($file,"\t\t\t\t<page>".$row['page']."</page>\n");
		
		$authid=$row['authid'];
		$result2=mysql_query("select * from author where authid=$authid") or die("Invalid Author Qurey");
		$row2=mysql_fetch_assoc($result2);
		
		fwrite($file,"\t\t\t\t<allauthors>\n");
		fwrite($file,"\t\t\t\t\t<author salut=\"".$row2['salutation']."\">".$row2['authorname']."</author>\n");
		fwrite($file,"\t\t\t\t</allauthors>\n");
		
		
		fwrite($file,"\t\t\t</entry>\n");
	}
	
	fwrite($file,"\t\t</issue>\n");
	fwrite($file,"\t</volume>\n");
	fwrite($file,"</vp>");
?>
