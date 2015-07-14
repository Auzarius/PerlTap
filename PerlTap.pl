################################################################
#
#				PerlTap v0.7.2.4
# PerlTap - Viryanet Ticket fast copy program
# For use under permission of Anthony P. and/or Ian B.
# This program does not belong to Frontier, but was made for
# use with Frontier Viryanet systems to increase efficiency.
# Code & Logic:: Anthony P.
# Formulas & Concept:: Ian B.
#
################################################################
#!/usr/bin/perl
use strict;
#use warnings;
use Time::HiRes qw ( sleep );
use Win32;
use Win32::Clipboard;
use Win32::Console::ANSI;
use Term::ANSIColor;
use lib 'modules';
use ptmod;
use pthtml;
my %perltap;
my ($CLIP,$data);
#&OS_Check();
&Bootup();

#______________AUTHORIZATION BLOCK______________#
#if ($perltap{username} =~ /^(jmn853|msl678|app629|dpg691|tab237|bnn463|arb062|tsc443|tll680|vff863|vam260|pjg930|ibb601|ter041|victoria.g.franklin|Anthony)$/i) 
#{
	&Make_Folders();
	&Start_Screen();
	my ($datestamp,$timestamp) = ptmod::TimeSplit();
	open LOGFILE,">>archive\\authorized\.ptf" or print "Writing to logfile failed.\n\n";
	print LOGFILE $perltap{realname}."(".$perltap{username}.") on ".
		$perltap{os_current}." using ".$perltap{version}." \@".$datestamp." ".$timestamp."\n";
	close(LOGFILE);
	system "title PerlTap ".$perltap{version}." - UPDATED: ".$perltap{update_time};
	&Win32::MsgBox("*  Added more Reporting Centers to the PerlTap database.\n" .
		"*  Updated several Reporting Centers with updated info.\n" .
		"*  Trimmed down the HTML code to help conform to the\n" .
		"    new more limited space in Viryanet.\n" .
		"** More fine tuning to the DSLDIG output\n" .
		"** If anyone would like a more detailed explanation, \n" .
		"    or would like to report a bug, please see me or email me at\n" .
		"    --anthony.pickelheimer\@ftr.com\n\n" .
		"Thanks!", 
	0|MB_ICONEXCLAMATION, "PerlTap - Updates \/ Fixes");
	&Authorized();
#}

# else { #Unauthorized user
	# system "title Unauthorized user!";
	# my ($datestamp,$timestamp) = ptmod::TimeSplit();
	# print color("Yellow"), " ####    PerlTap ".$perltap{version}."   ####\n\n";
	# print color("Red"), "You are not an authorized user!  Terminating program.\n\n";
	# print colored ['red on_white'], "Username: ".$perltap{username}, "\n\n" if $perltap{debug} eq "ON";
	# print color("Green"), "PerlTap - Viryanet Ticket fast copy program\n";
	# print color("Red"), "For use under permission of Anthony P. and/or Ian B.\n";
	# print color("Red"), "This program does not belong to Frontier, but was made for\n";
	# print color("Red"), "use with Frontier Viryanet systems to increase efficiency.\n";
	# print color("Cyan"), "Code & Logic:: Anthony P.\n";
	# print color("Cyan"), "Formulas & Concept:: Ian B.\n\n";
	# print color("White"), "\n\n";
	# open LOGFILE,">>archive\\unauthorized\.ptf";
	# print LOGFILE $perltap{username}." on ".$perltap{os_current}." unauthorized access! \@".$datestamp." ".$timestamp."\n";
	# close(LOGFILE);
	# sleep 5 and exit(0);
	#} #______________END AUTHORIZATION BLOCK______________#

#______________MAIN LOOP______________#
sub Authorized #Runs the main program loop if authorized
{ 
	while(1) #ProgramLoop to watch for matching strings
	{ 
		$CLIP->WaitForChange();
		sleep(0.20);
		$data = $CLIP->Get();
		my ($today) = ptmod::TimeDatex();
		
		if ($data =~ /ORIGINAL CALL NOTES/i and $data =~ /Notes Attached to Call/i) 
			#Runs the code to pull the info from the Call Ticket Page
		{ 
			&Compare_Date() if $perltap{report_log} eq "ON" and ($perltap{operating_time} ne $today);
			&Screen_Refresh(1);
			&CallTicket();
		}
		elsif ($data =~ /Common Cause Status/i and 
			$data =~ /Auto-attachment for this common cause is/i and 
			$data !~ /There are \d+ Common Causes matching that criteria./i) 
			#Runs the code to pull the info from the CC Maintenace Page
		{ 
			&Compare_Date() if $perltap{report_log} eq "ON" and ($perltap{operating_time} ne $today);
			&Screen_Refresh(1);
			&CC_Maintenance();
		}
		elsif ($data =~ /Common Cause Finder Utility/i and 
			$data =~ /Total Calls Found:/i and 
			$data =~ /CC Type to Create:/i) 
			#Runs the code to pull the info from the CC Finder Page
		{ 
			&Screen_Refresh(1);
			next if $perltap{filter_block} =~ /$perltap{username}|$perltap{realname}/i;
			print color("White"), "\nGathering data . . .\n";
			&CC_FinderBoard();
		}		
		elsif ($data =~ /Call Search Results/ and 
			$data =~ /Search Criteria/ and 
			$data =~ /View Results|Display only the total call count/ and 
			$data !~ /PENDING|ALLOCATED|REFERRED|COMPLETED/i) 
		{
			&Screen_Refresh(1);
			next if $perltap{filter_block} =~ /$perltap{username}|$perltap{realname}/i;
			&Testboard(1);
		}
		elsif ($data =~ /Search for Calls by Status/ and 
			$data =~ /Search Criteria/ and 
			$data =~ /Display only the total call count/ and 
			$data =~ /Call Id Action No Call Type/) 
		{
			&Screen_Refresh(1);
			next if $perltap{filter_block} =~ /$perltap{username}|$perltap{realname}/i;
			&Testboard(2);
		}	
		elsif ($data =~ /%Config_File%/i and $data =~ /#CallID/i) 
			#Sets custom config
		{ 
			&Screen_Refresh(1);
			&Custom_Config($data);
		}	
		elsif ($data =~ /Circuit Test/ and $data =~ /Summary:/ and 
			$data =~ /Frame TN/ and $data =~ /Outcome/) 
			#Grabs the LoopCare results
		{ 
			
			&Screen_Refresh(1);
			&LoopCare();
		}
		elsif ($data =~ /Welcome to Learning On-Line Assistant/i) 
			#Grabs the LOLA results
		{ 
			&Screen_Refresh(1);
			&LOLA();
		}
		elsif ($data =~ /Inet Portal/i and $data =~ /Total:/ and 
			$data =~ /Ticket:/) 
			#Grabs the InetPortal remarks
		{ 
			&Screen_Refresh(1);
			&InetRemarks();
		}
		elsif ($data =~ /%TogglePTFreeze%/i) 
			#Toggles a PerlTap WAIT state
		{ 
			&Screen_Refresh(1);
			&Pause_PerlTap;
		} else {		
			sleep(0.35);
		}
	}
} #______________END MAIN LOOP______________#

	
sub CallTicket #Recompiles the data from the Call Ticket in Viryanet
{ 
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	($perltap{cid}) = $data =~ /Notes Attached to Call    (\S+)/i if $data =~ /Notes Attached to Call    (\S+)/i;
	($perltap{ticket_type}) = $data =~ /   TYPE:  (\S+)/i if $data =~ /   TYPE:  (\S+)/i;
	($perltap{trouble_type}) = $data =~ /TICKET TYPE:  (\S+)/i if $data =~ /TICKET TYPE:  (\S+)/i;
	($perltap{report_code}) = $data =~ /REPORT CODE:  (\S+)/i if $data =~ /REPORT CODE:  (\S+)/i;
	($perltap{phone}) = $data =~ /PHONE:  (\S+)/ if $data =~ /PHONE:  (\S+)/;
	($perltap{cust_name}) = $data =~ /CUSTOMER NAME:  (.*)\r/i if $perltap{cust_name} !~ /\w+/i and $data =~ /CUSTOMER NAME:  (.*)\r/i;
	
	if (!$perltap{cust_name} or $perltap{cust_name} eq " " or 
		$perltap{cust_name} =~ /no line card name/i) 
	{
		$perltap{cust_name} = "N/A";
	}
	
	($perltap{cbr}) = $data =~ /CBR1:  (\d+)/i if $data =~ /CBR1:  (\d+)/i;
	($perltap{cbr}) = "N/A" if $data =~ /CBR1:  NONE/i or $perltap{cbr} eq " ";
	($perltap{report_date},$perltap{report_time}) = $data =~ /REPORT DATE\/TIME:  (\S+\s\S+\s\S+)(\s\S+:\S+)/i if $data =~ /REPORT DATE\/TIME:  (\S+\s\S+\s\S+)(\s\S+:\S+)/i;
	($perltap{commit_time}) = $data =~ /COMMITMENT DATE\/TIME:  (\S+\s\S+\s\S+\s\S+:\S+)/i if $data =~ /COMMITMENT DATE\/TIME:  (\S+\s\S+\s\S+)/i;
	($perltap{oos}) = $data =~ /OUT OF SERVICE:  (\S+)/i if $data =~ /OUT OF SERVICE:  (\S+)/i;
	($perltap{office}) = $data =~ /OFFICE:  (\S+)/ if $data =~ /OFFICE:  (\S+)/;
	($perltap{environment}) = $data =~ /OFFICE:  (\S+)/i if $data =~ /OFFICE:  (\S+)/i;
	($perltap{dslam}) = $data =~ /DSLAM CLLI CODE:  (\S+)/i if $data =~ /DSLAM CLLI CODE:  (\S+)/i;
	($perltap{ispusername}) = $data =~ /ISP USERNAME:  (\S+)/i if $data =~ /ISP USERNAME:  (\S+)/i;
	
	if ($data =~ /VERCODE_D: (.*)\n/i) 
	{
		($perltap{vercode}) = $data =~ /VERCODE_D: (.*)\n/i;
	} else {
		($perltap{vercode}) = "No test results available.";
	}
	
	($perltap{repeat}) = $data =~ /REPEAT:  (.*)\r/i if $data =~ /REPEAT:  (.*)\r/i;
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();
	%perltap = ptmod::Office_Convert(%perltap);

	if ($data =~ /COMMON CAUSE INFORMATION/i) 
	{
		($perltap{comcause}) = $data =~ /CC\#: (\d+)/i;
		($perltap{tested}) = "N";
		my $answer = Win32::MsgBox("Ticket#  ".$perltap{cid}."\nName:    ".
			$perltap{cust_name}."\nPhone# ".$perltap{phone}."\nCBR#     ".$perltap{cbr}.
			"\n\nThis ticket is part of a Common Cause!\n\nDo you want to copy this ticket anyways?\n", 
			4|MB_ICONEXCLAMATION, "PerlTap - Ticket# ".$perltap{cid});
		if ($answer != 6) 
		{
			$CLIP->Empty();
			print color("White"), "-----------------------------\n";
			print color("Yellow"), "#### Ticket copy was cancelled ####\n\n";
			print color("White"), "-----------------------------\n";
			return;
		}
		
	} else {
		($perltap{comcause}) = "N";
		($perltap{tested}) = "Y";
	}
		
	$perltap{newclip} = LoadClipConfig(1, %perltap);
	$perltap{newdb} = LoadClipConfig(2, %perltap);
	$perltap{database} = "date=". $perltap{datestamp} ."|time=". $perltap{timestamp} .
		"|repdate=". $perltap{report_date} ."|comdate=". $perltap{commit_time} ."|tn=". 
		$perltap{phone} ."|callid=". $perltap{cid} ."|cbr=". $perltap{cbr} ."|custname=". 
		$perltap{cust_name} ."|rcode=". $perltap{report_code} ."|state=".$perltap{state}.
		"|office=". $perltap{office} ."|rcenter=". $perltap{rep_center} ."|dslam=". 
		$perltap{dslam} ."|comcause=".$perltap{comcause} ."|username=". $perltap{username} .
		"|realname=". $perltap{realname} ."|type=CallTicket|copied=#";
	
	#$perltap{newclip} = $perltap{newclip}."\t\t".$perltap{ispusername};
	#$CLIP->Set($perltap{newclip}) unless $perltap{cid} eq " ";
	if ($perltap{cid} eq " ") 
	{
		print color("White"), "-----------------------------\n";
		print color("Yellow"), "#### No valid data retrieved ####\n\n";
		print color("White"), "-----------------------------\n";
		$CLIP->Empty();
		&Error_Report("The Call Ticket screen was not completely matched." , 1 , 
			$perltap{cid} , $perltap{phone} , $perltap{environment}, %perltap);
	} else {
		&Print_Info(1,%perltap);
		&DataLog(1,%perltap) if $perltap{report_log} eq "ON";
		#&PerlTap_Database(1,%perltap) if $perltap{report_log} eq "ON";
		$CLIP->Set($perltap{newclip}) if $perltap{report_log} ne "ON";
	}
	
	print colored ['red on_white'], $perltap{newclip}, "\n" if $perltap{debug} eq "ON";
}
	
	
sub CC_Maintenance #Grabs the necessary info from the CC Maintenance page
{ 
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	my (@cidlist,@rcodelist,@phonelist,@rdatelist,@custnamelist,@cbrlist,@tcountlist,
		@addresslist,@cdatelist,$dataformatA,$dataformatB);
	($perltap{tested},$perltap{cidcount}) = ("N",0);
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();	
	($perltap{comcause}) = $data =~ /Common Cause Id: (\S+)/i if $data =~ /Common Cause Id: (\S+)/i;
	($perltap{office}) = $data =~ /Office: (\S+)/i if $data =~ /Office: (\S+)/i;
	($perltap{leader}) = $data =~ /Lead Call Id: (\d+)/i if $data =~ /Lead Call Id: (\d+)/i;
	($perltap{status}) = $data =~ /Lead Status: (.*)\n/i if $data =~ /Lead Status: (.*)\n/i;
	($perltap{con_status}) = Format_Status($perltap{status});
	($perltap{env}) = $perltap{office} =~ /\S+_(\S+)/;
	%perltap = ptmod::Office_Convert(%perltap);
	my @ccdata = split /\r/,$data;
	
	for (0..$#ccdata) 
	{
		my ($cid,$tcount,$rcode,$phone,$custname,$street,$address,$rdate,$cdate,$cbr,
			$tyear,$tmonth,$tday,$bmonth,$bday,$byear) = 
			(undef,undef,undef,undef,undef,undef,undef,undef,undef);
		#($cid) = $ccdata[$_] =~ /            (\d+)\/\d/i if $ccdata[$_] =~ /            (\d+)\/\d/i;
		($cid,$tcount) = $ccdata[$_] =~ /            (\d+)\/(\d\d\d)/ if $ccdata[$_] =~ /            \d+\/\d\d\d/;
		($cid,$tcount) = $ccdata[$_] =~ /            (\d+)\/(\d\d)/ if $ccdata[$_] =~ /            \d+\/\d\d/ and !$cid;
		($cid,$tcount) = $ccdata[$_] =~ /            (\d+)\/(\d)/ if $ccdata[$_] =~ /            \d+\/\d/ and !$cid;
		
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (\S+\s\S+\s\S+\s\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i;
		($rcode,$phone,$custname,$$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (\S+\s\S+\s\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname; 
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (\S+\s\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname; 
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname; 
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname; 
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$street,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (.*)   (\d+) (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$street,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+       \w   (\w+)   (\d+) (.*)   (\S+) (.*?)   (\d+)\-(\d+)\-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+ \d+\:\d+   \d+\-\d+\-\d+ \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (\S+\s\S+\s\S+\s\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (\S+\s\S+\s\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (\S+\s\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (\S+\s\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (\S+\s\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (\S+)   (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$street,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (.*)   (\d+) (.*?)   (\d+)-(\d+)-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		($rcode,$phone,$custname,$street,$address,$tyear,$tmonth,$tday,$byear,$bmonth,$bday) = $ccdata[$_] =~ /\S+     \w+   \w   (\w+)   (\d+) (.*)   (\S+) (.*?)   (\d+)\-(\d+)\-(\d+) \d+\:\d+   (\d+)-(\d+)-(\d+) \d+\:\d+/i if !$custname;
		$street = "" if $address and !$street;
		$address = $street." ".$address."\n" if $address;
		($cbr) = $ccdata[$_] =~ / (\d+)    $/ if $phone and $ccdata[$_] =~ / (\d+)    $/;
		$cbr = "N/A" if $phone and !$cbr;
		$rdate = ptmod::FormatDate($tyear,$tmonth,$tday) if $rcode;
		$cdate = ptmod::FormatDate($byear,$bmonth,$bday) if $rcode;
		push(@cidlist,$cid) if $cid and $ccdata[$_] =~ /            (\d+)\/\d/i;
		push(@rcodelist,$rcode) if $rcode;
		push(@phonelist,$phone) if $phone;
		push(@rdatelist,$rdate) if $rdate;
		push(@cdatelist,$cdate) if $cdate;
		push(@custnamelist,$custname) if $custname;
		push(@cbrlist,$cbr) if $cbr;
		push(@tcountlist,$tcount) if $tcount;
		push(@addresslist,$address) if $address;
	}
	
	my ($rows,$count) = (1,1);
	(%perltap) = pthtml::CCF_HTML_HEAD("PerlTap Common Cause - ".$perltap{comcause},%perltap) if $perltap{htmlmode} eq "ON";
	
	for (0..$#cidlist) 
	{ 
		($perltap{cid},$perltap{phone},$perltap{report_code},$perltap{report_date},$perltap{cbr},$perltap{cust_name},
		$perltap{tcount},$perltap{address},$perltap{commit_date}) = ($cidlist[$_],$phonelist[$_],$rcodelist[$_],$rdatelist[$_],
		$cbrlist[$_],$custnamelist[$_],$tcountlist[$_],$addresslist[$_],$cdatelist[$_]);
		$dataformatA = LoadClipConfig(1, %perltap);
		$dataformatB = LoadClipConfig(2, %perltap);
		$perltap{newclip} 	.= $dataformatA."\n";
		$perltap{newdb} 	.= $dataformatB."\n";
		$perltap{cidlist} 	.= $perltap{cid} . "\n";
		$perltap{phonelist} .= $perltap{phone} . "\n";
		$perltap{cbrlist} 	.= $perltap{cbr} . "\n";
		$perltap{custnamelist} .= $perltap{cust_name} . "\n";
		($count,$rows,%perltap) = pthtml::CCM_HTML_BODY($count,$rows,%perltap) if $perltap{htmlmode} eq "ON";
		$perltap{database} .= "date=". $perltap{datestamp} ."|time=". $perltap{timestamp} ."|repdate=". 
			$perltap{report_date} ."|comdate=". $perltap{commit_date} ."|tn=". $perltap{phone} ."|callid=". 
			$perltap{cid} ."|cbr=". $perltap{cbr} ."|custname=". $perltap{cust_name} ."|rcode=". 
			$perltap{report_code} ."|state=".$perltap{state}."|office=". $perltap{office} ."|rcenter=". 
			$perltap{rep_center} ."|dslam=". $perltap{dslam} ."|comcause=". $perltap{comcause} ."|username=". 
			$perltap{username} ."|realname=". $perltap{realname} ."|type=CommonCause|copied=#\n";
	}
		
	$perltap{cidcount} = $#cidlist + 1;
	chomp($perltap{cidlist});
	chomp($perltap{phonelist});
	chomp($perltap{cbrlist});
	chomp($perltap{custnamelist});
	chomp($perltap{newclip});	
	
	#$CLIP->Set($perltap{newclip});
	&Print_Info(2,%perltap);
	&DataLog(2,%perltap) if $perltap{report_log} eq "ON" and $#cidlist == $#phonelist;
	#&PerlTap_Database(2,%perltap) if $perltap{report_log} eq "ON" and $#cidlist == $#phonelist;
	$CLIP->Set($perltap{newclip}) if $perltap{report_log} ne "ON" and $#cidlist == $#phonelist;
	
	if ($#cidlist != $#phonelist) 
	{
		print color("Yellow"), "An error with the information occured.  No data was written to the file.";
		print color("White"), " \n";
		&Error_Report("The Common Cause Maintenance Screen was not entirely matched." , 2 , 
			$#cidlist , $#phonelist , 0 ,%perltap);
	}
		
	if ($perltap{htmlmode} eq "ON" and $#cidlist == $#phonelist and $count > 1) 
	{
		(%perltap) = pthtml::CCM_HTML_CLOSE($count,%perltap);
		open REP,">".$perltap{userprofile}."\\Desktop\\PerlTapCCReport\.htm";
		print REP $perltap{ccfrep};
		close(REP);
		sleep 0.5 if $perltap{beta} =~ /$perltap{username}/i;
		system $perltap{userprofile}."\\Desktop\\PerlTapCCReport\.htm" if $perltap{beta} =~ /$perltap{username}/i;
	}

	if ($perltap{debug} eq "ON") 
	{
		for (0..$#cidlist) {
			print colored ['red on_white'], 'Cid: '.$cidlist[$_].'  rcode: '.$rcodelist[$_].'  phone: '.$phonelist[$_].'   rdate: '.$rdatelist[$_].'   cbr: '.$cbrlist[$_].'   name: '.$custnamelist[$_], "\n";
			}
		print "\n";
	}
}
	
	
sub CC_FinderBoard #Grabs the CC Finder Board for pasting and organization in Excel
{ 
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	my (@cidlist,@statuslist,@rcodelist,@cbrlist,@custlist,@officelist,@phonelist,
		@comcauselist,@rdatelist,@cdatelist,@tcountlist,$dataformat,$cidline);
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();
	my @ccdata = split /\r/,$data;
	
	if ($perltap{filter_mode} == 2) 
	{
		print color("White"), "Report code filter: ";
		$perltap{ccfilter} = <stdin>;
		print color("White"), "Status filter: ";
		$perltap{stfilter} = <stdin>;
		chomp($perltap{ccfilter});
		chomp($perltap{stfilter});
	}
		
	for (0..$#ccdata) 
	{
		my ($status,$rcode,$phone,$cid,$office,$cbr,$cust,$tcount,
			$comcause,$rdate,$cdate,$gwar) = (undef,undef,undef,undef,
			undef,undef,undef,undef,undef,undef,undef,undef);
		my ($ayear,$amonth,$aday,$atime,$byear,$bmonth,$bday,$btime);
		
		($cid,$tcount) = $ccdata[$_] =~ /   (\d+)\/(\d)  / if $ccdata[$_] =~ /   \d+\/\d  /;
		($cid,$tcount) = $ccdata[$_] =~ /   (\d+)\/(\d\d)  / if $ccdata[$_] =~ /   \d+\/\d\d  / and !$cid;
		($cid,$tcount) = $ccdata[$_] =~ /   (\d+)\/(\d\d\d)  / if $ccdata[$_] =~ /   \d+\/\d\d\d  / and !$cid;
		$cidline = $#ccdata + 1 if $cid;
		#($cid,$tcount) = "NO MATCH" if $ccdata[$_] =~ /   \d+\/\d/ and !$cid and $perltap{debug} eq "ON";
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+      (\S+ \S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+)  /;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+       (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+      (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+      (\S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+      (\S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+      (\S+ \S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+)  / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+       (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+      (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+      (\S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+      (\S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /Leader: \S+     (\S+ \S+ \S+ \S+)     (\S+)     \S+     (\S+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /Leader: \S+     (\S+ \S+ \S+)     (\S+)     \S+     (\S+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /Leader: \S+     (\S+ \S+)     (\S+)     \S+     (\S+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /Leader: \S+     (\S+)     (\S+)     \S+     (\S+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+     (\S+ \S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+)  / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+      (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+     (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+     (\S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]       \S+     (\S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+     (\S+ \S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+)  / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+      (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+     (\S+ \S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+     (\S+ \S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office,$rcode) = $ccdata[$_] =~ /\[\S+\]     \S+     \S+     (\S+)     (\S+)     \S+     (\S+|\d+) / if !$rcode;
		($status,$office) = $ccdata[$_] =~ /\[\S+\]       \S+       (\S+ \S+)     (\S+)     \S+         / if !$rcode;
		$rcode = "ERR" if $office and !$rcode;
		($status,$office,$rcode) = ("no match","no match","no match") if !$rcode and $cid and $#cidlist > $#rcodelist and $perltap{debug} eq "ON";
		#($tmonth,$tday,$tyear) = $ccdata[$_] =~ /(\d+)\/(\d+)\/(\d+) \d+:\d+     \d+\/\d+\/\d+ \d+:\d+ / if $ccdata[$_] =~ /(\d+\/\d+\/\d+) \d+:\d+     \d+\/\d+\/\d+ \d+:\d+ /;
		#$rdate = &ptmod::FormatDate($tyear,$tmonth,$tday) if $tyear and $ccdata[$_] =~ /(\d+)\/(\d+)\/(\d+) \d+:\d+     \d+\/\d+\/\d+ \d+:\d+ /;
		($amonth,$aday,$ayear,$atime,$bmonth,$bday,$byear,$btime) = $ccdata[$_] =~ /(\d+)\/(\d+)\/(\d+) (\d+:\d+)     (\d+)\/(\d+)\/(\d+) (\d+:\d+) / if $ccdata[$_] =~ /(\d+)\/(\d+)\/(\d+) (\d+:\d+)     (\d+)\/(\d+)\/(\d+) (\d+:\d+) /;
		$rdate = ptmod::FormatDate($ayear,$amonth,$aday) if $ayear and $ccdata[$_] =~ /(\d+)\/(\d+)\/(\d+) (\d+:\d+)     (\d+)\/(\d+)\/(\d+) (\d+:\d+) /;
		$rdate = $rdate." ".$atime if $rdate and $atime;
		$cdate = ptmod::FormatDate($byear,$bmonth,$bday) if $byear and $ccdata[$_] =~ /(\d+)\/(\d+)\/(\d+) (\d+:\d+)     (\d+)\/(\d+)\/(\d+) (\d+:\d+) /;
		$cdate = $cdate." ".$btime if $cdate and $btime;
		($rdate,$cdate) = ("no match","no match") if !$rdate and $cid and $#cidlist > $#rdatelist and $perltap{debug} eq "ON";
		
		($cbr) = $ccdata[$_] =~ /(\d\d\d\d\d\d\d\d\d\d) 0000/ if $rdate;
		($cbr) = $ccdata[$_] =~ /(\d\d\d\d\d\d\d\d\d\d) \d\d\d\d/ if $rdate and !$cbr;
		($cbr) = "N/A" if $rdate and !$cbr;
		($cbr) = "TN#".$cbr."#\/" if $cbr eq $phonelist[$#phonelist] and $cbr and $rdate;
		
		($phone,$cust) = $ccdata[$_] =~ /         (\d+)     (\S+ \S+ \S+)  \/$/ if $rcode eq "ERR";
		($phone,$cust) = $ccdata[$_] =~ /         (\d+)     (\S+ \S+)  \/$/ if $rcode eq "ERR" and !$phone;
		($phone,$cust) = $ccdata[$_] =~ /         (\d+)     (\S+)  \/$/ if $rcode eq "ERR" and !$phone;
		($phone,$cust) = ("--","--") if $rcode eq "ERR" and !$phone;
		
		($phone) = $ccdata[$_] =~ /\S+     (\d\d\d\d\d\d\d\d\d\d) .*?\// if $ccdata[$_] =~ /\S+     (\d\d\d\d\d\d\d\d\d\d) .*?\// and 
				$ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d 0000/ and $ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d \d\d\d\d/;
		($phone) = $ccdata[$_] =~ /\S+     (\d\d\d\d\d\d\d\d\d\d) .*?/ if $ccdata[$_] =~ /\S+     (\d\d\d\d\d\d\d\d\d\d) .*?/ and 
				$ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d 0000/ and $ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d \d\d\d\d/ and !$phone;
		($phone,$gwar) = $ccdata[$_] =~ / (\d\d\d\d\d\d\d\d\d\d) (LN|NR|NP|NL).*?\// if $ccdata[$_] =~ / (\d\d\d\d\d\d\d\d\d\d) (LN|NR|NP|NL).*?\// and $ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d 0000/ and $ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d \d\d\d\d/ and !$phone;
		($phone) = "N/A" if !$phone and $cid and $#cidlist > $#phonelist;
		($gwar,$cust) = $ccdata[$_] =~ / \d\d\d\d\d\d\d\d\d\d (LN|NR|NP|NL| ) \s+(.*)  \// if $ccdata[$_] =~ / \d\d\d\d\d\d\d\d\d\d (LN|NR|NP|NL| ) \s+(.*)  \// and $phone;
		($gwar,$cust) = $ccdata[$_] =~ / \d\d\d\d\d\d\d\d\d\d (LN|NR|NP|NL| ) \s+(.*) \// if $ccdata[$_] =~ / \d\d\d\d\d\d\d\d\d\d (LN|NR|NP|NL| ) \s+(.*)  \// and $phone and !$cust;
		($cust) = $ccdata[$_] =~ /\S+     \d\d\d\d\d\d\d\d\d\d     (.*)  \/$/ if $ccdata[$_] =~ /\S+     \d\d\d\d\d\d\d\d\d\d     (.*)  \/$/ and 
				$ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d 0000/ and $phone and !$cust and $ccdata[$_] !~ /           \d+     \S+  \/ /;
		($cust) = $ccdata[$_] =~ /\S+     \d\d\d\d\d\d\d\d\d\d     (.*)  \// if $ccdata[$_] =~ /\S+     \d\d\d\d\d\d\d\d\d\d     (.*)  \// and 
				$ccdata[$_] !~ / \d\d\d\d\d\d\d\d\d\d 0000/ and $phone and !$cust and $ccdata[$_] =~ /           \d+     \S+  \/ /;
		($cust) = "N/A" if $phone and !$cust;
		($comcause) = $ccdata[$_] =~ /   CC Id: (\d+)  / unless $comcause and $ccdata[$_] !~ / CC Id: (\d+) /;
		
		if ($ccdata[$_] =~ /\[notes\]/i and $ccdata[$_] !~ / CC Id: \d+ /i) 
		{
			($comcause) = "N" unless $comcause;
			($status,$office,$rcode) = ("--","--","--") unless $rcode;
		}
		
		if ($ccdata[$_] =~ /circuit/) 
		{
			&Win32::MsgBox("Copying circuits out of the Common Cause Finder is\ncurrently not supported!" .
				"(M6/NC Environments)\nThis operation will be aborted.", 0|MB_ICONERROR, 
				"PerlTap - Unsupported Information");
			$CLIP->Empty();
			print "\nOperation aborted due to unsupported information.\n";
			return;
		}
		
		if ($ccdata[$_] =~ /RO_/ and $ccdata[$_] =~ /_RO/ and $ccdata[$_] =~ /RO\d+/) 
		{
			&Win32::MsgBox("Copying this information out of the Common Cause Finder is\ncurrently not supported!" .
				"(RO Environment)\nThis operation will be aborted.", 0|MB_ICONERROR, 
				"PerlTap - Unsupported Information");
			$CLIP->Empty();
			print "\nOperation aborted due to unsupported information.\n";
			return;
		}
		
		push(@cidlist,$cid) if $cid;
		push(@statuslist,$status) if $status;
		push(@rcodelist,$rcode) if $rcode;
		push(@officelist,$office) if $office;
		push(@cbrlist,$cbr) if $cbr;
		push(@custlist,$cust) if $cust;
		push(@phonelist,$phone) if $phone;
		push(@comcauselist,$comcause) if $comcause;
		push(@rdatelist,$rdate) if $rdate;
		push(@cdatelist,$cdate) if $cdate;
		push(@tcountlist,$tcount) if $tcount;
	}
	
	my ($rows,$count) = (1,1);
	print $perltap{ccfilter}."\n".$perltap{stfilter}."\n" if $perltap{debug} eq "ON" and $perltap{htmlmode} eq "ON";;
	my @filter = split /,/, $perltap{ccfilter};
	my @status = split /,/, $perltap{stfilter};
	($perltap{cctotal}) = ($#phonelist + 1);
	(%perltap) = pthtml::CCF_HTML_HEAD("PerlTap CCFinder Report",%perltap) if $perltap{htmlmode} eq "ON";

	for (0..$#phonelist) 
	{
		($perltap{cid},$perltap{phone},$perltap{report_code},$perltap{report_date},$perltap{commit_date},
			$perltap{comcause},$perltap{dslam},$perltap{office},$perltap{cust_name},$perltap{cbr},$perltap{status},
			$perltap{tcount}) = ($cidlist[$_],$phonelist[$_],$rcodelist[$_],$rdatelist[$_],$cdatelist[$_],
			$comcauselist[$_],$officelist[$_],$officelist[$_],$custlist[$_],$cbrlist[$_],$statuslist[$_],$tcountlist[$_]);
		%perltap = ptmod::Office_Convert(%perltap);
		($dataformat) = LoadClipConfig(1, %perltap);
		$perltap{newclip} = $perltap{newclip} . $dataformat ."\t". $statuslist[$_] ."\t". $tcountlist[$_]."\n";
		
		if ($perltap{htmlmode} eq "ON") 
		{
			for (0..$#status) 
			{
				if ($perltap{status} =~ /$status[$_]/i) 
				{
					for (0..$#filter) 
					{
						if ($perltap{report_code} =~ /$filter[$_]/i and $perltap{ccfilter} !~ /ALL/i and $filter[$_] !~ /PHONE/i) 
						{
							($count,$rows,%perltap) = pthtml::CCF_HTML_BODY($count,$rows,%perltap);
							next;
						}
						elsif ($perltap{report_code} !~ /DSL/ and $filter[$_] =~ /PHONE/i) 
						{
							($count,$rows,%perltap) = pthtml::CCF_HTML_BODY($count,$rows,%perltap);
							next;
						}
						elsif ($perltap{ccfilter} eq "ALL") 
						{
							($count,$rows,%perltap) = pthtml::CCF_HTML_BODY($count,$rows,%perltap);
							next;
						}
					}
				}
			}
		}
	}
	
	$perltap{cidcount} = $#cidlist + 1;
	chomp($perltap{newclip});
	$CLIP->Set($perltap{newclip}) if $perltap{newclip} ne " ";
	&Print_Info(3,%perltap);
	print $count . "\n" if $perltap{debug} eq "ON";
	if ($perltap{htmlmode} eq "ON" and $count > 1) 
	{
		(%perltap) = pthtml::CCF_HTML_CLOSE($count,%perltap);
		open REP,">".$perltap{userprofile}."\\Desktop\\PerlTapFinderReport\.htm";
		print REP $perltap{ccfrep};
		close(REP);
		sleep 0.5;
		system $perltap{userprofile}."\\Desktop\\PerlTapFinderReport\.htm";
	} else {
		&Win32::MsgBox("There were no matches under the criteria set\n" .
				"in the config file.  Please either alter the\n" . 
				"set criteria, or wait for more tickets that\n" .
				"match that criteria.\n", 0|MB_ICONERROR, 
				"PerlTap - No Matches");
	}
	
	if ($#cidlist != $#statuslist or $#cidlist != $#phonelist) 
	{
		&Error_Report("The Common Cause Finder Screen was not entirely matched." , 3 ,
			$#cidlist , $#statuslist , $#phonelist, %perltap);
	}
	
	if ($perltap{debug} eq "ON") 
	{
		print colored ['red on_white'], 'Verification that all columns are the same length'; 
		print color("White"), " \n";
		print colored ['red on_white'], 'CallID: '.$#cidlist; print color("White"), " \n";
		print colored ['red on_white'], 'Status: '.$#statuslist; print color("White"), " \n";
		print colored ['red on_white'], "Rcode: \t".$#rcodelist; print color("White"), " \n";
		print colored ['red on_white'], 'Office: '.$#officelist; print color("White"), " \n";
		print colored ['red on_white'], "Cust: \t".$#custlist; print color("White"), " \n";
		print colored ['red on_white'], "Phone# \t".$#phonelist; print color("White"), " \n";
		print colored ['red on_white'], "CBR# \t".$#cbrlist; print color("White"), " \n";
		print colored ['red on_white'], "CC:   \t".$#comcauselist; print color("White"), " \n";
		print colored ['red on_white'], "Rdate: \t".$#rdatelist; print color("White"), " \n";
		print colored ['red on_white'], 'Count:  '.$#tcountlist; print color("White"), " \n\n";
		print colored ['red on_white'], '-----------------------------'; 
		print color("White"), " \n\n";
	}
}


sub Testboard 
{
	my %perltap = %perltap;
	my $TB = shift;
	%perltap = Set_PerlTap(%perltap);
	my (@cidlist,@rcodelist,@phonelist,@rdatelist,@custnamelist,@cdatelist,
		@tcountlist,$dataformat);
	($perltap{tested},$perltap{cidcount}) = ("N",0);
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();	
	
	my @ccdata = split /\r/,$data;
	
	if ($TB == 1) 
	{
		($perltap{ticket_total}) = $data =~ /Results \d+ to \d+ of (\d+)/i if $data =~ /Results \d+ to \d+ of (\d+)/i;
		for (0..$#ccdata) 
		{
			my ($cid,$tcount,$rcode,$phone,$custname,$rdate,$cdate) = (undef,
				undef,undef,undef,undef,undef,undef);
			my ($ayear,$amonth,$aday,$atime,$byear,$bmonth,$bday,$btime);
			($cid,$tcount) = $ccdata[$_] =~ / (\d+)\/(\d+)$/ if $ccdata[$_] =~ /  View\/Add Notes/;
			($phone,$custname) = $ccdata[$_] =~ /\S+ (\d+) (.*)   (YES|NO)?/ if $ccdata[$_] =~ /(MS|LF)/;
			($rcode,$bmonth,$bday,$byear,$btime,$amonth,$aday,$ayear,$atime) = $ccdata[$_] =~ /(\w+) (\d+)\/(\d+)\/(\d+) (\d+\:\d+ \w)  (\d+)\/(\d+)\/(\d+) (\d+\:\d+ \w)  \d+\/\d+\/\d+ \d+\:\d+ \w  TESTBOARD TROUBLE TICKET/ if $ccdata[$_] =~ /TESTBOARD/;
			($rdate) = ptmod::FormatDate($ayear,$amonth,$aday) if $ayear;
			($cdate) = ptmod::FormatDate($byear,$bmonth,$bday) if $byear;
			$rdate = $rdate." ".$atime if $rdate;
			$cdate = $cdate." ".$btime if $cdate;
			push(@cidlist,$cid) if $cid;
			push(@rcodelist,$rcode) if $rcode;
			push(@phonelist,$phone) if $phone;
			push(@rdatelist,$rdate) if $rdate;
			push(@custnamelist,$custname) if $custname;
			push(@cdatelist,$cdate) if $cdate;
			push(@tcountlist,$tcount) if $tcount;
		}
	}
	elsif ($TB == 2) 
	{
		($perltap{ticket_total}) = $data =~ /Total calls matching criteria:\s+(\d+)/ if $data =~ /Total calls matching criteria:\s+(\d+)/;
		for (0..$#ccdata) 
		{
			my ($cid,$tcount,$rcode,$phone,$custname,$rdate,$cdate) = (undef,
				undef,undef,undef,undef,undef,undef);
			my ($ayear,$amonth,$aday,$atime,$byear,$bmonth,$bday,$btime);
			#($cid,$tcount,$phone,$custname,$amonth,$aday,$ayear,$atime,$bmonth,$bday,$byear,$btime) = $ccdata[$_] =~ / (\d+)   (\d+)   \w+   \S+   \S+   \S+   (\d+) (.*)   Y   (\d+)\/(\d+)\/(\d+) (\d+\:\d+)   \d+\/\d+\/\d+ \d+\:\d+   (\d+)\/(\d+)\/(\d+) (\d+\:\d+)   \d+\/\d+\/\d+ \d+\:\d+   \d+\/\d+\/\d+ \d+\:\d+   \d+\:\d+   \w+  / if $ccdata[$_] =~ /IN|MI/ and $ccdata[$_] =~ /TESTBOARD/;
			#($cid,$tcount,$phone,$custname,$amonth,$aday,$ayear,$atime,$bmonth,$bday,$byear,$btime) = $ccdata[$_] =~ / (\d+)   (\d+)   \w+   \S+   \S+   \S+   (\d+) (.*)   N   (\d+)\/(\d+)\/(\d+) (\d+\:\d+)   \d+\/\d+\/\d+ \d+\:\d+   (\d+)\/(\d+)\/(\d+) (\d+\:\d+)   \d+\/\d+\/\d+ \d+\:\d+   \d+\/\d+\/\d+ \d+\:\d+   \d+\:\d+   \w+  / if $ccdata[$_] =~ /IN|MI/ and $ccdata[$_] =~ /TESTBOARD/ and !$cid;
			($cid,$tcount,$phone,$custname,$amonth,$aday,$ayear,$atime,$bmonth,$bday,$byear,$btime) = $ccdata[$_] =~/(\d+) (\d+) \w+ \w+ \S+ \S+ (\d+) (.*) Y (\d+)\/(\d+)\/(\d+) (\d+\:\d+) \d+\/\d+\/\d+ \d+\:\d+ (\d+)\/(\d+)\/(\d+) (\d+\:\d+) \d+\/\d+\/\d+ \d+\:\d+ \d+\/\d+\/\d+ \d+\:\d+ \d+\:\d+ \w+/ if $ccdata[$_] =~ /IN|MI/ and $ccdata[$_] =~ /TESTBOARD/;
			($cid,$tcount,$phone,$custname,$amonth,$aday,$ayear,$atime,$bmonth,$bday,$byear,$btime) = $ccdata[$_] =~/(\d+) (\d+) \w+ \w+ \S+ \S+ (\d+) (.*) N (\d+)\/(\d+)\/(\d+) (\d+\:\d+) \d+\/\d+\/\d+ \d+\:\d+ (\d+)\/(\d+)\/(\d+) (\d+\:\d+) \d+\/\d+\/\d+ \d+\:\d+ \d+\/\d+\/\d+ \d+\:\d+ \d+\:\d+ \w+/ if $ccdata[$_] =~ /IN|MI/ and $ccdata[$_] =~ /TESTBOARD/ and !$cid;
			
			$byear = "20" . $byear if $byear =~ /\d\d/ and $byear;
			($rcode) = "_" if $cid;
			($rdate) = ptmod::FormatDate($ayear,$amonth,$aday) if $ayear and $phone;
			($cdate) = ptmod::FormatDate($byear,$bmonth,$bday) if $byear and $phone;
			$rdate = $rdate." ".$atime if $rdate;
			$cdate = $cdate." ".$btime if $cdate;
			push(@cidlist,$cid) if $cid;
			push(@rcodelist,$rcode) if $rcode;
			push(@phonelist,$phone) if $phone;
			push(@rdatelist,$rdate) if $rdate;
			push(@custnamelist,$custname) if $custname;
			push(@cdatelist,$cdate) if $cdate;
			push(@tcountlist,$tcount) if $tcount;
		}
		#($perltap{ticket_total}) = $#cidlist + 1;
	} else {
		return;
	}
	
	my ($rows,$count) = (1,1);
	(%perltap) = pthtml::CCF_HTML_HEAD("PerlTap Testboard Results",%perltap) if $perltap{htmlmode} eq "ON";
	
	for (0..$#cidlist) 
	{ 
		($perltap{cid},$perltap{phone},$perltap{report_code},$perltap{report_date},
			$perltap{commit_date},$perltap{cust_name},$perltap{tcount}) = ($cidlist[$_],
			$phonelist[$_],$rcodelist[$_],$rdatelist[$_],$cdatelist[$_],$custnamelist[$_],
			$tcountlist[$_]);
		$dataformat = LoadClipConfig(1, %perltap);
		($perltap{npa},$perltap{nxx}) = $perltap{phone} =~ /(\d\d\d)(\d\d\d)\d\d\d\d/;
		%perltap = ptmod::NPA_Convert(%perltap);
		$perltap{newclip} = $perltap{newclip}.$dataformat."\n";
		$perltap{cidlist} = $perltap{cidlist} . $perltap{cid} . "\n";
		$perltap{phonelist} = $perltap{phonelist} . $perltap{phone} . "\n";
		#$perltap{cbrlist} = $perltap{cbrlist} . $perltap{cbr} . "\n";
		$perltap{custnamelist} = $perltap{custnamelist} . $perltap{cust_name} . "\n";
		($count,$rows,%perltap) = pthtml::TB_HTML_BODY($count,$rows,%perltap) if $perltap{htmlmode} eq "ON";
	}
		
	$perltap{cidcount} = $#cidlist + 1;
	chomp($perltap{cidlist});
	chomp($perltap{phonelist});
	chomp($perltap{cbrlist});
	chomp($perltap{custnamelist});
	chomp($perltap{newclip});	
	
	&Print_Info(5,%perltap);
	$CLIP->Set($perltap{newclip});
	
	if ($perltap{htmlmode} eq "ON" and $count > 1) 
	{
		(%perltap) = pthtml::TB_HTML_CLOSE($count,%perltap);
		open REP,">".$perltap{userprofile}."\\Desktop\\PerlTapTBReport\.htm";
		print REP $perltap{ccfrep};
		close(REP);
		sleep 0.5;
		system $perltap{userprofile}."\\Desktop\\PerlTapTBReport\.htm";
	}
	
	if ($#cidlist != $#phonelist) 
	{
		print color("Yellow"), "An error with the information occured.";
		print color("White"), " \n";
		&Error_Report("The TestBoard Screen was not entirely matched." , 2 , $#cidlist , $#phonelist , 0 ,%perltap);
	}
	
	if ($perltap{debug} eq "ON") 
	{
		for (0..$#cidlist) 
		{
			print colored ['red on_white'], 'Cid: '.$cidlist[$_].'  rcode: '.$rcodelist[$_].'  phone: '.$phonelist[$_].'   rdate: '.$rdatelist[$_].'   cdate: '.$cdatelist[$_].'   name: '.$custnamelist[$_], "\n";
		}
		print "\n";
	}
}

	
sub LoopCare 
{
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();
	$perltap{title} = "LoopCare Results";
	my @ccdata = split /\r/,$data;
	my ($count,$num,$end,$sum,$start);
	
	for (0..$#ccdata) 
	{
		$num ++;
		($perltap{vercode}) = $ccdata[$_] =~ /Outcome:  (\w+ \S+)/i if $ccdata[$_] =~ /Outcome:  (\w+ \S+)/i;
		$end = $num if $ccdata[$_] =~ /OBSERVED NOISE MARGIN/i;# and !$end;
		$end = $num - 2 if $ccdata[$_] =~ /Switch Id/i and !$end;
		$count = $num if $ccdata[$_] =~ /Summary:/i;
		$sum = $num - 1 if $ccdata[$_] !~ /\S+/ and $count and !$sum;
		$start = $sum + 1 if !$start and $sum;
		
		if ($data =~ /- LOOPX/ or $data =~ /- FULLX/) 
		{
			$perltap{count}{crafta} = $_ + 2 if $ccdata[$_] =~ /CRAFT: DC/;
			$perltap{count}{craftb} = $_ + 4 if $ccdata[$_] =~ /CRAFT: DC/;
			$perltap{count}{dcsiga} = $_ + 2 if $ccdata[$_] !~ /CRAFT: DC/ and $ccdata[$_] =~ / DC SIG/;
			$perltap{count}{dcsigb} = $_ + 4 if $ccdata[$_] !~ /CRAFT: DC/ and $ccdata[$_] =~ / DC SIG/;
			$perltap{count}{acsiga} = $_ + 2 if $ccdata[$_] =~ / AC SIG/;
			$perltap{count}{acsigb} = $_ + 4 if $ccdata[$_] =~ / AC SIG/;
			$perltap{count}{centra} = $_ + 1 if $ccdata[$_] =~ /CENTRAL OFFICE/;
			$perltap{count}{centrb} = $_ - 1 if $ccdata[$_] =~ /BALANCE/;
			($perltap{count}{balance}) = $ccdata[$_] =~ /CAPACITIVE (\d+) %/ if $ccdata[$_] =~ /CAPACITIVE (\d+) %/;
			($perltap{count}{length}) = $ccdata[$_] =~ /LOOP LENGTH = (\d+) FT/ if $ccdata[$_] =~ /LOOP LENGTH = (\d+) FT/;
		}
	}
		
	$start = $count if !$start;
	$end = $#ccdata - 5 if !$end;
	print colored ['white on_blue'], "CraftA: ".$perltap{count}{crafta}." CraftB: ".$perltap{count}{craftb}." DCSigA: ".$perltap{count}{dcsiga}." DCSigB: ".$perltap{count}{dcsigb}." ACSigA: ".$perltap{count}{acsiga}." ACSigB: ".$perltap{count}{acsigb}."\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Start: ".$start." End: ".$end."\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Count: ".$count." Sum: ".$sum."\n" if $perltap{debug} eq "ON";
	print color("White"), "_\n" if $perltap{debug} eq "ON";
	
	if ($sum) 
	{
		for ($count..$sum) 
		{
			$perltap{summary} .= $ccdata[$_] if $ccdata[$_] =~ /\S+/;
			$perltap{summaryclip} .= $ccdata[$_]."<br>" if $ccdata[$_] =~ /\S+/;
		}
	}
		
	pthtml::LOAD_ARR(@ccdata);
	
	if ($perltap{summary} !~ /FAILURE/i and $perltap{summary} !~ /INVALID\/INCOMPLETE CIRCUIT/i and 
		$perltap{summary} !~ /RT COMM FAIL/i and $perltap{summary} !~ /ERROR/i and 
		$perltap{summary} !~ /ROH$/ and $perltap{summary} !~ /Dispatch Decision: Screen/i and 
		$perltap{summary} !~ /BUSY/i and $perltap{summary} !~ /SYSTEM/i and 
		$perltap{summary} !~ /INTERCEPT/i and $perltap{summary} !~ /DEFECTIVE/i and 
		$perltap{summary} !~ /LINE IN USE/i) 
	{
		if ($data =~ /- DSLDIG/) 
		{
			$perltap{lctype} = "DSL";
			($perltap{dsl_service}) = $data =~ /SERVICE TYPE:   (\S+)/;
			($perltap{dsl_coding}) = $data =~ /LINE CODING:   (\S+)/;
			($perltap{dsl_type}) = $data =~ /LINE TYPE:   (.*) \r/;
			($perltap{errored_seconds}{near},$perltap{errored_seconds}{far}) = $data =~ /ERRORED SECONDS:   \S+ (\S+) \S+ \S+ (\S+) \S+ /;
			($perltap{link_loss}{near},$perltap{link_loss}{far}) = $data =~ /LOSS OF LINK:   \S+ (\S+) \S+ \S+ (\S+) \S+ /;
			($perltap{sync_loss}{near},$perltap{sync_loss}{far}) = $data =~ /LOSS OF SIGNAL:   \S+ (\S+) \S+ \S+ (\S+) \S+ /;
			($perltap{fec_event}{near},$perltap{fec_event}{far}) = $data =~ /FEC EVENTS:   \S+ (\S+) \S+ \S+ (\S+) \S+ /;
			($perltap{crc_anomaly}{near},$perltap{crc_anomaly}{far}) = $data =~ /CRC ANOMALIES:   \S+ (\S+) \S+ \S+ (\S+) \S+ /;
			
			for ($start..$end) 
			{
				chomp $perltap{results};
				$perltap{results} .= $ccdata[$_]."\n" if $ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /SERVICE TYPE:|SERVICE MODE:|xTU|STATUS|LINE CODING:|LINE TYPE:/i;
				(%perltap) = pthtml::LC_DSLDIG(%perltap) if $perltap{htmlmode} eq "ON";
			}
		}
		elsif ($data =~ /- LOOPX/ or $data =~ /- FULLX/) 
		{
			$perltap{lctype} = "LOOPX";
			(%perltap) = pthtml::LC_LOOPX(%perltap);
			
			for ($start..$end) 
			{
				chomp $perltap{results};
				$perltap{results} = $perltap{results}.$ccdata[$_]."\n" if $ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /SERVICE TYPE:|STATUS|LINE CODING:|LINE TYPE:/i;
			}
		} else {
			for ($start..$end) 
			{
				chomp $perltap{results};
				$perltap{results} = $perltap{results}.$ccdata[$_]."\n" if $ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /SERVICE TYPE:|STATUS|LINE CODING:|LINE TYPE:/i;
				$perltap{resultsclip} = $perltap{resultsclip}.$ccdata[$_]."<br>" if $ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /SERVICE TYPE:|STATUS|LINE CODING:|LINE TYPE:|CPE/i;
			}
		}
	} else {
		for ($start..$end) 
		{
			chomp $perltap{results};
			$perltap{results} = $perltap{results}.$ccdata[$_]."\n" if $ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /SERVICE TYPE:|STATUS|LINE CODING:|LINE TYPE:/i;
			$perltap{resultsclip} = $perltap{resultsclip}.$ccdata[$_]."<br>" if $ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /SERVICE TYPE:|STATUS|LINE CODING:|LINE TYPE:|CPE/i;
		}
	}
		
	chomp $perltap{results};
	$perltap{results} = "Loopcare Results:\n".$perltap{vercode}."\n".$perltap{summary}.$perltap{results}."\n\n";
	(%perltap) = pthtml::LC_COMPLETE(%perltap) if $perltap{htmlmode} eq "ON";
	&Print_Info(4,%perltap);
	
	if ($perltap{htmlmode} eq "ON") 
	{
		$CLIP->Set($perltap{resultsclip})
	} else {
		$CLIP->Set($perltap{results})
	}
}
	
	
sub LOLA 
{
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();
	$perltap{title} = "LOLA Results";
	my @ccdata = split /\r/,$data;
	my ($count,$num,$end);
	
	for (0..$#ccdata) 
	{
		$num ++;
		$count = $num + 1 if $ccdata[$_] =~ /Customer DSLAM:/i;
		$end = $num if $ccdata[$_] =~ /No relief information/i;
		$end = $num + 1 if $ccdata[$_] =~ /relief/i and !$end;
		$end = $num if $ccdata[$_] =~ /No Known Network Issue/i;
	}
		
	print colored ['red on_white'], "Start: ".$count." End: ".$end."\n" if $perltap{debug} eq "ON";
	print color("White"), "_\n" if $perltap{debug} eq "ON";
	
	for ($count..$end)
	{
		chomp $perltap{results};
		$perltap{results} = $perltap{results}.$ccdata[$_]."\n" if $ccdata[$_] =~ /\S+/;
		$perltap{resultsclip} = $perltap{resultsclip}.$ccdata[$_]."<br>" if $ccdata[$_] =~ /\S+/;
	}
	
	$perltap{resultsclip} =~ s/\n|\r//g;
	chomp $perltap{results};
	$perltap{results} = "LOLA Congestion Results:\n".$perltap{results}."\n\n";
	$perltap{resultsclip} = "<table border=\"1\" style=\"width:365px;font-size:90%;background-color:white\"><tr><th><b><a href=\"http://techhelp.northcentralnetworks.com/vsc/index.asp? \">LOLA Results:</a></b></th></tr><tr><td>".$perltap{resultsclip}."</td></tr></table>\n";
	&Print_Info(4,%perltap);
	
	if ($perltap{htmlmode} eq "ON") 
	{
		$CLIP->Set($perltap{resultsclip})
	} else {
		$CLIP->Set($perltap{results})
	}
}
	
	
sub InetRemarks 
{
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();
	$perltap{title} = "Inet Remarks";
	my @ccdata = split /\r/,$data;
	my ($count,$num,$end,$ihdrep,$date,$match,$table,$ihdrepb,$dateb);
	
	for (0..$#ccdata) 
	{
		$num ++;
		$count = $num + 3 if $ccdata[$_] =~ /Total:/i;
		($ihdrep,$date) = $ccdata[$_] =~ /(.*)  (\d+\-\w+\-\d+ \d+\:\d+\:\d+) \w+/i if $ccdata[$_] =~ /(.*)  (\d+\-\w+\-\d+ \d+\:\d+\:\d+) \w+/i and !$ihdrep;
	}
	
	($match) = $date =~ /(\d+\-\w+\-\d+)/i if $date;
	#print $match;
	$num = $count;
	
	for ($count..$#ccdata) 
	{
		$num ++ if $ccdata[$_] =~ /\S+/;
		#$end = $_ - 1 if $ccdata[$_] =~ /\d+  \S+\@\S+/ and !$end;
		$end = $_ - 2 if $ccdata[$_] =~ /\d+\-\w+\-\d+ \d+\:\d+\:\d+ \w+  / and 
			$ccdata[$_] !~ /$match/i and !$end;
		$end = $_ - 2 if $ccdata[$_] =~ /\d+\-\w+\-\d+ \d+\:\d+\:\d+ \w+  / and 
			$num - $count > 14 and !$end;
		$end = $_ - 4 if $ccdata[$_] =~ /Frontier, a Citizens Communications Company./i and !$end;
		$end = $_ - 1 if $num - $count > 25 and !$end;
		$end = $_ - 1 if $_ - $count > 50 and !$end;#and $#ccdata - 57 > $count 
	}
		
	$end = $#ccdata - 7 if !$end;
	#$end = $count + 50 if $#ccdata - $count > 50;
	print colored ['red on_white'], "Start: ".$count." End: ".$end."\n" if $perltap{debug} eq "ON";
	print color("White"), "_\n" if $perltap{debug} eq "ON";
	
	for ($count..$end) 
	{
		chomp $perltap{results};
		$perltap{results} = $perltap{results}.$ccdata[$_]."\n" if $ccdata[$_] =~ /\S+/;
		if ($ccdata[$_] =~ /\S+/ and $ccdata[$_] !~ /$match/ and 
			$ccdata[$_] !~ /^\n\d+\s+\S+\@\w+\.\w+\s+$/)
		{
			$perltap{resultsclip} .= $ccdata[$_]."<br>";
		}
		
		if ($ccdata[$_] =~ /(.*)  (\d+\-\w+\-\d+ \d+\:\d+\:\d+) \w+/i and 
			$ccdata[$_] =~ /\S+/ and $ccdata[$_] =~ /$match/)
		{
			($ihdrepb,$dateb) = $ccdata[$_] =~ /(.*)  (\d+\-\w+\-\d+ \d+\:\d+\:\d+) \w+/i;
		}
		
		if ($ccdata[$_] =~ /\S+/ and $ccdata[$_] =~ /$match/)
		{
			$perltap{resultsclip} .= "</td></tr><tr><td>IHD Rep: ".$ihdrepb.
				"</td></tr><tr><td>"."Date/Time: ".$dateb."</td></tr><tr><td>";
			$table = 1;
		}
	}
	
	$perltap{resultsclip} =~ s/\n|\r//g;
	chomp $perltap{results};
	$perltap{results} = "Inet Remarks:\nTaken by IHD rep: ".$ihdrep."\nDate/Time: ".
		$date."\n".$perltap{results}."\n\n";
	$perltap{resultsclip} = "<table border=\"1\"" .
		"\"bordercolor=\"gray\" style=\"width:365px;font-size:90%;background-color:lightgray\">" .
		"<tr><th><b>Inet Remarks:</b></th></tr><tr><td>IHD Rep: ".$ihdrep .
		"</td></tr><tr><td>Date\/Time: ".$date."</td></tr><tr><td>" .
		$perltap{resultsclip}."</td></tr></table>\n";
	
	&Print_Info(4,%perltap);
	if ($perltap{htmlmode} eq "ON") 
	{
		$CLIP->Set($perltap{resultsclip})
	} else {
		$CLIP->Set($perltap{results})
	}
}
	

sub Pause_PerlTap 
{
	my %perltap = %perltap;
	%perltap = Set_PerlTap(%perltap);
	$data = "";
	($perltap{datestamp},$perltap{timestamp}) = ptmod::TimeSplit();
	$perltap{title} = "PerlTap Pause Mode";
	&Print_Info(4,%perltap);
	
	until ($data =~ /%TogglePTFreeze%/i)
	{
		$CLIP->WaitForChange();
		$data = $CLIP->Get();
	}
		
	print color("White"), "-----------------------------\n";
	print color("Yellow"), "#### PerlTap is now able to copy again ####\n\n";
	print color("White"), "-----------------------------\n";
}
	
sub Compare_Date 
{
	my ($filedate) = ptmod::TimeDate();
	my ($today) = ptmod::TimeDatex();
	my ($month,$year) = ptmod::Get_Month();
	
	if ($perltap{operating_time} and $perltap{operating_time} ne $today) 
	{
		print "Make Dir::\n";
		system "mkdir archive";
		system "mkdir archive\\".$year;
		system "mkdir archive\\".$year."\\".$month;
		system "mkdir archive\\".$year."\\".$month."\\".$filedate;
		open FH,">>archive\\".$year."\\".$year."_ExcelData.csv";
		close(FH);
		open FH,">>archive\\".$year."\\".$month."\\".$filedate."\\".$filedate."_ExcelData\.csv";
		close(FH);
		open FH,">>archive\\".$year."\\".$month."\\".$month."_ExcelData\.csv";
		close(FH);
		sleep 4 if $perltap{debug} eq "ON";
		system "cls";
		($perltap{operating_time}) = $today;
	}
}
	
	
sub Screen_Refresh 
{
	my $mode = shift;
	$CLIP->Empty() if $mode == 1;
	my $last_updated = $perltap{update_time};
	my ($today) = ptmod::TimeDatex();
	&Check_Config_Info();
	&Load_Config() if $perltap{config_mode} == 1;
	
	if ($perltap{update_time} ne $last_updated and $perltap{update_time} ne "N/A") 
	{
		#($perltap{update}) = "New update!   ... ".$perltap{update_time}."\nPlease restart PerlTap!";
		#system "title NEW UPDATE AVAILABLE!  PerlTap ".$perltap{new_version}." - UPDATED: ".$perltap{update_time}
		my $answer = Win32::MsgBox("There is a new update available for PerlTap!\nPlease press OK to close the program.\nAfter you re-run the program, you can copy your ticket information." , MB_ICONINFORMATION, "UPDATE AVAILABLE! PerlTap ".$perltap{new_version}." - ".$perltap{update_time});
		exit(0);
	}
	
	system "cls";
	print color("Yellow"), " ####    PerlTap ".$perltap{version}."    ####\n";
	print color("Yellow"), "Running since ... ".$perltap{runtime}."\n";
	#print colored ['blue on_white'], $perltap{update}, "\n";
	print colored ['red on_white'], 'Newest update ... '.$perltap{update_time}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], 'Operating time... '.$perltap{operating_time}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], 'Current date  ... '.$today, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], 'Beta List     ... '.$perltap{beta}, "\n" if $perltap{debug} eq "ON";
	#print colored ['red on_white'], 'CSV Read Mode ... '.$perltap{csvread}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], 'CSV Read TB   ... '.$perltap{csvread}{tb}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], 'CSV Read CC   ... '.$perltap{csvread}{cc}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Report log = ".$perltap{report_log}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "HTML mode  = ".$perltap{htmlmode}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Filter mode= ".$perltap{filter_mode}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Filter block= ".$perltap{filter_block}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Config mode= ".$perltap{config_mode}, "\n" if $perltap{debug} eq "ON";
	print colored ['red on_white'], "Config info= ".$perltap{config_info}, "\n" if $perltap{debug} eq "ON";
	print color("Green"), "PerlTap - Viryanet Ticket fast copy program\n";
	print color("Red"), "For use under permission of Anthony P. and/or Ian B.\n";
	print color("Red"), "This program does not belong to Frontier, but was made for\n";
	print color("Red"), "use with Frontier Viryanet systems to increase efficiency.\n";
	print color("Cyan"), "Code & Logic:: Anthony P.\n";
	print color("Cyan"), "Formulas & Concept:: Ian B.\n";
}
	
	
sub Print_Info #Prints the Call Ticket results to the console for the user
{ 
	my ($mode,%perltap) = @_;
	
	if ($mode == 1) 
	{
		print color("White"), "-----------------------------\n";
		print color("White"), "Date: ".$perltap{datestamp}.' '.$perltap{timestamp}."\n" unless $perltap{datestamp} eq " ";
		print color("Yellow"), "  #### Call Ticket ####\n";
		print color("Red"), "CID        : ".$perltap{cid}."\n" if $perltap{cid} ne " " and $perltap{oos} =~ /Y/i;
		print color("Green"), "CID        : ".$perltap{cid}."\n" if $perltap{cid} ne " " and $perltap{oos} =~ /N/i;
		print color("White"), "CID        : ".$perltap{cid}."\n" if $perltap{cid} ne " " and $perltap{oos} !~ /(Y|N)/i;
		#print color("Yellow"), "TicketType: ".$perltap{ticket_type}."\n" unless $perltap{ticket_type} eq " ";
		#print color("Yellow"), "TroubleType: ".$perltap{trouble_type}."\n" unless $perltap{trouble_type} eq " ";
		print color("Green"), "Phone      : ".$perltap{phone}."\n" if $perltap{phone} ne " " and $perltap{environment} =~ /_MS/i;
		print color("Magenta"), "Phone      : ".$perltap{phone}."\n" if $perltap{phone} ne " " and $perltap{environment} =~ /_LF/i;
		print color("White"), "Phone      : ".$perltap{phone}."\n" if $perltap{phone} ne " " and $perltap{environment} !~ /_MS/i and $perltap{environment} !~ /_LF/i;
		print color("Yellow"), "ReportCode : ".$perltap{report_code}."\n" unless $perltap{report_code} eq "No Match" or $perltap{group} eq "OH";
		print color("Magenta"), "VN Exchange: ".$perltap{vn_exchange}."\n" unless $perltap{vn_exchange} eq "No Match" or $perltap{group} eq "OH";
		print color("Magenta"), "LAM        : ".$perltap{LAM}."\n" unless $perltap{LAM} eq "No Match" or $perltap{group} eq "OH";
		print color("Magenta"), "Exchange   : ".$perltap{exchange}."\n" unless $perltap{exchange} eq "No Match" or $perltap{group} eq "OH";
		print color("Magenta"), "Rep Center : ".$perltap{rep_center}."\n" unless $perltap{rep_center} eq " " or $perltap{group} eq "OH";
		print color("Magenta"), "Town       : ".$perltap{town}."\n" unless $perltap{town} eq "No Match" or $perltap{group} eq "OH";
		print color("Magenta"), "Office     : ".$perltap{office}."\n";
		print color("Cyan"), "Cus Name   : ".$perltap{cust_name}."\n" unless $perltap{cust_name} eq " ";
		print color("Cyan"), "Cus CBR    : ".$perltap{cbr}."\n" unless $perltap{cbr} eq " ";
		print color("Green"), "ReportDate : ".$perltap{report_date}.$perltap{report_time}."\n" unless $perltap{report_date} eq " ";
		print color("Green"), "CommitDate : ".$perltap{commit_time}."\n" unless $perltap{commit_time} eq " ";
		print color("Red"),"Common Cause: ".$perltap{comcause}."\n" unless $perltap{comcause} eq " " or $perltap{comcause} =~ /N/i;
		print color("Yellow"),"Repeat Type: ".$perltap{repeat}."\n" if exists $perltap{repeat};
		print color("White"),"TestResults: \n".$perltap{vercode}."\n";
		print color("White"), "\n-----------------------------\n";
	}
		
	if ($mode == 2) 
	{
		print color("White"), "-----------------------------\n";
		print color("White"), "Date: ".$perltap{datestamp}.' '.$perltap{timestamp}."\n" unless $perltap{datestamp} eq " ";
		print color("Yellow"), "  #### CC Maintenance ####\n";
		print color("Green"), "CC# ".$perltap{comcause}." copied to the clipboard.\n" if $perltap{comcause};
		print color("White"), "Tickets: (";
		print color("Cyan"), ($perltap{cidcount});
		print color("White"), ")\n";
		print color("Cyan"), $perltap{cidlist}."\n";
		print color("White"), "\n-----------------------------\n";
	}
		
	if ($mode == 3) 
	{
		print color("White"), "-----------------------------\n";
		print color("White"), "Date: ".$perltap{datestamp}.' '.$perltap{timestamp}."\n" unless $perltap{datestamp} eq " ";
		print color("Yellow"), "  #### CC Finder ####\n";
		print color("White"), "(";
		print color("Cyan"), $perltap{cidcount} if $perltap{cidcount} > 0;
		print color("White"), ")"; 
		print color("White"), " tickets copied to the clipboard.\n\n";
		print color("White"), "-----------------------------\n";
	}
	
	if ($mode == 4) 
	{
		print color("White"), "-----------------------------\n";
		print color("White"), "Date: ".$perltap{datestamp}.' '.$perltap{timestamp}."\n" unless $perltap{datestamp} eq " ";
		print color("Yellow"), "  #### ".$perltap{title}." ####\n\n";
		print color("White"), $perltap{results}."\n";
		print color("White"), "-----------------------------\n";
	}
		
	if ($mode == 5) 
	{
		print color("White"), "-----------------------------\n";
		print color("White"), "Date: ".$perltap{datestamp}.' '.$perltap{timestamp}."\n" unless $perltap{datestamp} eq " ";
		print color("Yellow"), "  #### TB Results ####\n";
		print color("White"), "Tickets: (";
		print color("Cyan"), ($perltap{cidcount});
		print color("White"), ") were copied.\n";
		print color("White"), "\n-----------------------------\n";
	}
		
	print color("Cyan"), "HTML Output is ".$perltap{htmlmode}.".\n\n";
}
	
	
sub LoadClipConfig 
	#Sets the line configuration from the config file using the gathered data
{ 
	my $config;
	my ($mode, %perltap) = @_;
	
	if ($perltap{config_mode} == 1) 
	{
		$config = Load_Config();
	} 
	elsif ($perltap{config_mode} != 1) 
	{
		$config = $perltap{config_info};
	}
		
	if ($config) 
	{
		#$config =~ s/_#Callout//i if $config =~ /#Callout/i and $perltap{comcause} eq "N";
		$config =~ s/_#Vformulas//i if $config =~ /_?#Vformulas/i and $mode == 2;
		$config =~ s/_/\t/g;
		$config =~ s/#Date/$perltap{datestamp}/i if $config =~ /#Date/i;
		$config =~ s/#Phone/$perltap{phone}/i if $config =~ /#Phone/i;
		$config =~ s/#CallID/$perltap{cid}/i if $config =~ /#CallID/i;
		$config =~ s/#ReportCode/$perltap{report_code}/i if $config =~ /#ReportCode/i;
		$config =~ s/#Tested/$perltap{tested}/i if $config =~ /#Tested/i;
		$config =~ s/#CommonCause/$perltap{comcause}/i if $config =~ /#CommonCause/i;
		$config =~ s/#ReportDate/$perltap{report_date}/i if $config =~ /#ReportDate/;
		$config =~ s/#Callout/$perltap{callout}/i if $config =~ /#Callout/i;
		$config =~ s/#OOS/$perltap{oos}/i if $config =~ /#OOS/i;
		$config =~ s/#TicketType/$perltap{ticket_type}/i if $config =~ /#TicketType/i;
		$config =~ s/#TroubleType/$perltap{trouble_type}/i if $config =~ /#TroubleType/i;
		$config =~ s/#DSLAM/$perltap{dslam}/i if $config =~ /#DSLAM/i;
		$config =~ s/#CBR/$perltap{cbr}/i if $config =~ /#CBR/i;
		$config =~ s/#Customer/$perltap{cust_name}/i if $config =~ /#Customer/i;
		$config =~ s/#Vformulas/$perltap{v_formulas}/i if $config =~ /#Vformulas/i and $mode == 1;
		$config =~ s/#Office/$perltap{office}/i if $config =~ /#Office/i;
		$config =~ s/#RepCenter/$perltap{rep_center}/i if $config =~ /#RepCenter/i;
		#$config =~ s/#XLformulas/$perltap{xl_formulas}/i if $config =~ /#XLformulas/i;
		chomp($config);
	}
		
	return $config;
}
	
	
sub DataLog #Logs the gathered data into files for later reference
{ 
	my ($mode,%perltap) = @_;
	my ($filedate) = ptmod::TimeDate();
	my ($month,$year) = ptmod::Get_Month();
	
	%perltap = Set_CSV_Pathing(%perltap);
	$perltap{CSV} = Format_CSV($mode,%perltap);
	
	if ($perltap{CSV} ne 'duplicate' and 
		$perltap{CSV} ne 'cancelled' and 
		$perltap{CSV} ne 'copied') 
	{
		$perltap{database} =~ s/copied=#/copied=original/g;
		$CLIP->Set($perltap{newclip});
		&PerlTap_Database($mode,%perltap);
		&Write_CSV(">>archive\\".$year."\\".$month."\\".$month."_ExcelData\.csv" , 
			$month."_ExcelData\.csv" , %perltap);
		&Write_CSV(">>archive\\".$year."\\".$year."_ExcelData\.csv" , 
			$year."_ExcelData\.csv" , %perltap);
		&Write_CSV(">>archive\\".$year."\\".$month."\\".$filedate."\\".$perltap{realname}."_".
			$filedate."_ExcelData\.csv" , $perltap{realname}."_".$filedate."_ExcelData\.csv" , %perltap);
		&Write_CSV(">>archive\\".$year."\\".$month."\\".$filedate."\\".$filedate."_ExcelData\.csv", 
			$filedate."_ExcelData\.csv", %perltap);
		#&pthtml::HTML_TAPSHEET($year,%perltap);
	}
	elsif ($perltap{CSV} eq 'duplicate') 
	{
		close(FH);
		print color("Yellow"), "Duplicate value(s) found!  Duplicate data was not written to the file.\n";
		print color("White"), "-----------------------------\n";
	}
	elsif ($perltap{CSV} eq 'cancelled') 
	{
		close(FH);
		print color("Yellow"), "Ticket copy was cancelled.  Duplicate data was not written to the file.\n";
		print color("White"), "-----------------------------\n";
	}
	elsif ($perltap{CSV} eq 'copied') 
	{
		close(FH);
		print color("Yellow"), "Ticket copy was successful.  Duplicate data was not written to the file.\n";
		print color("White"), "-----------------------------\n";
	}
		
	if ($perltap{debug} eq "ON") 
	{
		print colored ['red on_white'], ">>archive\\".$year."\\".$month."\\".$filedate."\\".
			$perltap{realname}."_".$filedate."_ExcelData\.csv", "\n";
		print colored ['red on_white'], ">>archive\\".$year."\\".$month."\\".$month."_ExcelData\.csv", "\n";
		print colored ['red on_white'], $perltap{CSV}, "\n";
		print color("White"), "-----------------------------\n";
	}
}
	
sub Set_CSV_Pathing 
{
	my (%perltap) = @_;
	my ($filedate) = ptmod::TimeDate();
	my ($month,$year) = ptmod::Get_Month();
	
	$perltap{temp}{year} = "archive\\".$year."\\".$year."_ExcelData\.csv";
	$perltap{temp}{month} = "archive\\".$year."\\".$month."\\".$month."_ExcelData\.csv";
	$perltap{temp}{day} = "archive\\".$year."\\".$month."\\".$filedate."\\".$filedate."_ExcelData\.csv";
	$perltap{path}{tb} = $perltap{temp}{year} if ($perltap{csvread}{tb} == 3);
	$perltap{path}{tb} = $perltap{temp}{month} if ($perltap{csvread}{tb} == 2);
	$perltap{path}{tb} = $perltap{temp}{day} if ($perltap{csvread}{tb} == 1);
	$perltap{path}{cc} = $perltap{temp}{year} if ($perltap{csvread}{cc} == 3);
	$perltap{path}{cc} = $perltap{temp}{month} if ($perltap{csvread}{cc} == 2);
	$perltap{path}{cc} = $perltap{temp}{day} if ($perltap{csvread}{cc} == 1);
	return %perltap;
}
	
	
sub Write_CSV 
{
	my ($path,$file,%perltap) = @_;
	open FH, $path or do {
		print color("Yellow"), "\nWriting to logfile failed!\nPlease close the file to correct the issue.\n";
		my $answer = Win32::MsgBox("Writing to ".$file." failed!\nPlease close the file to correct the issue.\n", 5|MB_ICONEXCLAMATION, "PerlTap - Writing to ".$file." failed!");
		if ($answer == 4) {
			#print "Trying again...\n";
			&Write_CSV($path,$file,%perltap);
			}
		else {
			close(FH);
			die $!;
			}
		close(FH);
		#print color("White"), "Successful!\n\n"
		};
	syswrite FH, $perltap{CSV}."\n";
	close(FH);
}
	
	
sub Format_CSV 
{
	my ($mode,%perltap) = @_;
	my ($csv,$comment);
	
	if ($mode == 1) 
	{
		open FH, '<', $perltap{path}{tb} or do {
			print color("Yellow"), "\nFailed to read from the file!\nPlease try again.\n";
			my $answer = Win32::MsgBox("Reading from ".$perltap{path}{tb}.
				" failed!\nPlease try again.\nMake sure the file is closed.\nRestarting PerlTap may correct this issue.\n\nPressing 'Cancel' will close PerlTap!\n", 
				5|MB_ICONEXCLAMATION, "PerlTap - Reading from ".$perltap{path}{tb}." failed!");
			if ($answer == 4) 
			{
				#print "Trying again...\n";
				&Format_CSV($mode,%perltap);
			} else {
				close(FH);
				die $!;
			}
			close(FH);
			#print color("White"), "Successful!\n\n"
		};
		while(my $line = <FH>)
		{
			my @filedata = split /\n/,$line;
			for (@filedata) 
			{
				if ($line =~ /$perltap{cid}/i) 
				{
					my $person = "";
					($person) = $line =~ /\S+\"\,\"(\w+)\"$/i;
					($person) = $line =~ /\s\"\,\"(\w+)\"$/i unless $person;
					($person) = $line =~ /\w+\,(\w+),,,,,,$/i unless $person;
					($person) = $line =~ /\w+\,(\w+)\,$/i unless $person;
					($person) = $line =~ /\w+\,(\w+)$/i unless $person;
					$person = Clean_Name($person);
					$person = "You" if $person =~ $perltap{realname};
					print $person." already copied this ticket. (".$perltap{cid}.")\n";
					my $answer = Win32::MsgBox("Ticket#  ".$perltap{cid}."\nName:    ".$perltap{cust_name}.
					"\nPhone# ".$perltap{phone}."\nCBR#     ".$perltap{cbr}.
					"\n\n$person already copied this ticket.\n\nDo you want to copy this ticket anyways?\n", 
					4|MB_ICONEXCLAMATION, "PerlTap - Ticket# ".$perltap{cid});
					
					if ($answer == 6) 
					{
						$CLIP->Set($perltap{newclip});
						$perltap{database} =~ s/copied=#/copied=duplicate/;
						&PerlTap_Database($mode,%perltap) if $person ne "You";
						return "copied";
					} else {
						return "cancelled";
					}
				}
			}
		}
		close(FH);
		
		my $cc = "";
		if ($perltap{comcause} eq "N") 
		{
			$cc = "CallTicket";
		}
		elsif ($perltap{comcause} =~ /\d+/) 
		{
			$cc = "CommonCause";
		} else {
			$cc = "CallTicket";
		}
		
		$csv = $perltap{newdb}."\t".$cc."\t".$perltap{realname} if $csv ne "duplicate";
		
		if ($csv and $csv ne "duplicate") 
		{
			$csv =~ s/"/\"\"/g;
			$csv =~ s/\t/\"\,\"/g;
			$csv = '"'.$csv.'"';
		}
	}
		
	elsif ($mode == 2) 
	{
		my @cid = split /\n/,$perltap{cidlist};
		my @phone = split /\n/,$perltap{phonelist};
		my @name = split /\n/,$perltap{custnamelist};
		my @cbr = split /\n/,$perltap{cbrlist};
		open FH, '<', $perltap{path}{cc} or do {
			print color("Yellow"), "\nFailed to read from the file!\nPlease try again.\n";
			my $answer = Win32::MsgBox("Reading from file".$perltap{path}{cc}.
				" failed!\nPlease try again.\nMake sure the file is closed.\nRestarting PerlTap may correct this issue.\n\nPressing 'Cancel' will close PerlTap!\n", 
				5|MB_ICONEXCLAMATION, "PerlTap - Reading from file".$perltap{path}{cc}." failed!");
			if ($answer == 4) 
			{
				#print "Trying again...\n";
				$perltap{retry}++;
				&Format_CSV($mode,%perltap);
			} else {
				close(FH);
				die $!;
			}
			close(FH);
			
			#print color("White"), "Successful!\n\n"
		};
		while(my $line = <FH>) 
		{
			my @filedata = split /\n/,$line;
			for (@filedata) 
			{
				for (0..$#cid) 
				{
					if ($line =~ /$cid[$_]/i and $line =~ /CommonCause/i) 
					{
						my $person = "";
						($person) = $line =~ /\S+\"\,\"(\w+)\"$/i;
						($person) = $line =~ /\s\"\,\"(\w+)\"$/i unless $person;
						($person) = $line =~ /\w+\,(\w+),,,,,,$/i unless $person;
						($person) = $line =~ /\w+\,(\w+)\,$/i unless $person;
						($person) = $line =~ /\w+\,(\w+)$/i unless $person;
						$person = Clean_Name($person);
						$person = "You" if $person =~ $perltap{realname};
						print $person." already copied this ticket. (".$cid[$_].")\n";
						$cid[$_] = "duplicate";
						$perltap{person} = $person if $person;
						$csv = "duplicate" if $person;
					}
				}
			}
		}
		close(FH);
		
		if ($csv eq "duplicate")
		{
			print $perltap{person}." already copied at least part of this common cause. (".
				$perltap{comcause}.")\n";
			my $answer = Win32::MsgBox("CC# ".$perltap{comcause}.
			"\n\n$perltap{person} already copied at least part of this common cause.\n\n".
			"Do you want to copy this common cause anyways?\n", 
			4|MB_ICONEXCLAMATION, "PerlTap - CC# ".$perltap{comcause});
			
			if ($answer == 6) 
			{
				$CLIP->Set($perltap{newclip});
				$perltap{database} =~ s/copied=#/copied=duplicate/g;
				&PerlTap_Database($mode,%perltap) if $perltap{person} ne "You";
			} else {
				$CLIP->Empty();
				return "cancelled";
			}
		}
		#for (0..$#cid) {print $cid[$_]."\n"};
		my @filedata = split /\n/,$perltap{newdb};
		$csv = "";
		for (0..$#filedata) 
		{
			if ($cid[$_] ne "duplicate") 
			{
				my $real_name = $perltap{realname};
				$filedata[$_] = $filedata[$_]."\tCommonCause\t".$real_name;
				$filedata[$_] =~ s/^\s//;
				$filedata[$_] =~ s/"/\"\"/g;
				$filedata[$_] =~ s/\t/\"\,\"/g;
				$csv .= '"'.$filedata[$_].'"'."\n";
			}
		}
		
		$csv = "duplicate" unless ($csv);
		chomp($csv);
		
		#if ($csv ne "duplicate") {
			#system "\"J:\\Auto Dialer Notification Modules\\Outage Notification IN\\CC Maintenance Dialer Tool IN.xlsm\"\r";
			#my $answer = Win32::MsgBox("CC MAINTENANCE AUTODIALER\nPlease paste the copied CC Maintenance page info into the \"Paste Sheet\"\nin the Auto-Dialer excel sheet.\nOnce the Auto-Dailer macro is complete, please wait a few seconds before \npressing the \"OK\" button.\nAfter you press \"OK\" you can paste the CC Maintenance information on the tapsheet.\nIf for some reason this does not work, just copy the CC Maintenance page again,\n select \"Yes\" and then press \"OK\".", 0|MB_ICONEXCLAMATION, "PerlTap - Copy CC Maintenance");
			#}
			#$CLIP->Set($perltap{newclip});
	} else {
		$csv = "duplicate";
	}
		
	return $csv;
	}
	
	
sub Clean_Name 
{
	my $data = shift;
	my $name;
	#Fort Wayne Common Cause Center
	$name = "Justin" if $data =~ /Justin/i;
	$name = "Maggie" if $data =~ /Maggie/i and !$name;
	$name = "Anthony" if $data =~ /Anthony/i and !$name;
	$name = "Dustin" if $data =~ /Dustin/i and !$name;
	$name = "Tannis" if $data =~ /Tannis/i and !$name;
	$name = "Brian" if $data =~ /Brian/i and !$name;
	$name = "Amy" if $data =~ /Amy/i and !$name;
	$name = "Terry" if $data =~ /Terry/i and !$name;
	$name = "Teresa" if $data =~ /Teresa/i and !$name;
	$name = "Victoria" if $data =~ /Victoria/i and !$name;
	$name = "Veronica" if $data =~ /Veronica/i and !$name;
	$name = "Paula" if $data =~ /Paula/i and !$name;
	$name = "Ian" if $data =~ /Ian/  and !$name;
	$name = "Tom" if $data =~ /Tom/i and !$name;
	#Ohio Common Cause Center
	$name = "Barbara" if $data =~ /Barbara/i and !$name;
	$name = "Brenda" if $data =~ /Brenda/i and !$name;
	$name = "Cassandra" if $data =~ /Cassandra/i and !$name;
	$name = "Cynthia" if $data =~ /Cynthia/i and !$name;
	$name = "Daniel" if $data =~ /Daniel/i and !$name;
	$name = "Donna" if $data =~ /Donna/i and !$name;
	$name = "Geraldine" if $data =~ /Geraldine/i and !$name;
	$name = "Heather" if $data =~ /Heather/i and !$name;
	$name = "Margaret" if $data =~ /Margaret/i and !$name;
	$name = "Rosemarie" if $data =~ /Rosemarie/i and !$name;
	$name = "Sarah" if $data =~ /Sarah/i and !$name;
	$name = "Stacey" if $data =~ /Stacey/i and !$name;
	$name = "Tammy" if $data =~ /Tammy/i and !$name;
	$name = "Valorie" if $data =~ /Valorie/i and !$name;
	#General Matching
	$name = $perltap{username} if $data =~ /$perltap{username}/i and !$name;
	$name = "Someone" unless $name =~ /\w+/;
	return $name;
}
	

sub Format_Status 
{
	my $status = shift;
	if ($status =~ /HOLD TESTBOARD/i)
	{
		$status = "HLD TB";
	}
	elsif ($status =~ /HOLD DISPATCH/i)
	{
		$status = "HLD DIS";
	}
	elsif ($status =~ /PENDING/i)
	{
		$status = "IR";
	}
	elsif ($status =~ /ALLOCATED/i)
	{
		$status = "IR";
	}
	elsif ($status =~ /TECH EN ROUTE/i)
	{
		$status = "IR";
	}
	elsif ($status =~ /TESTBOARD/i)
	{
		$status = "TB";
	}
	elsif ($status =~ /MCO/i)
	{
		$status = "HSI";
	}
	elsif (!$status)
	{
		$status = "IR";
	} else {
		$status =~ s/\r//;
		chomp($status);
	}

	return $status;
}
	
sub Username_Match #Changes the windows username to a real name for the log
{ 
	my $realname;
	#Fort Wayne Common Cause Center
	$realname = "Justin" if $perltap{username} =~ /jmn853/i;
	$realname = "Maggie" if $perltap{username} =~ /msl678/i;
	$realname = "Anthony" if $perltap{username} =~ /app629/i;
	$realname = "Dustin" if $perltap{username} =~ /dpg691/i;
	$realname = "Tannis" if $perltap{username} =~ /tab237/i;
	$realname = "Brian" if $perltap{username} =~ /bnn463/i;
	$realname = "Amy" if $perltap{username} =~ /arb062/i;
	$realname = "Terry" if $perltap{username} =~ /tsc443/i;
	$realname = "Teresa" if $perltap{username} =~ /tll680/i;
	$realname = "Victoria" if $perltap{username} =~ /vff863/i;
	$realname = "Veronica" if $perltap{username} =~ /vam260/i;
	$realname = "Paula" if $perltap{username} =~ /pjg930/i;
	$realname = "Ian" if $perltap{username} =~ /ibb601/i;
	$realname = "Tom" if $perltap{username} =~ /ter041/i;
	$realname = "Victoria" if $perltap{username} =~ /victoria.g.franklin/i;
	if ($realname) {$perltap{group} = "IN"} else {$perltap{group} = "OH"};
	#Ohio Common Cause Center
	$realname = "Barbara" if $perltap{username} =~ /bjm634/i;
	$realname = "Brenda" if $perltap{username} =~ /bsp831/i;
	$realname = "Cassandra" if $perltap{username} =~ /cjs754/i;
	$realname = "Cynthia" if $perltap{username} =~ /ccc835/i;
	$realname = "Daniel" if $perltap{username} =~ /dss890/i;
	$realname = "Donna" if $perltap{username} =~ /dpp999/i;
	$realname = "Geraldine" if $perltap{username} =~ /gal419/i;
	$realname = "Heather" if $perltap{username} =~ /hes094/i;
	$realname = "Margaret" if $perltap{username} =~ /mak291/i;
	$realname = "Rosemarie" if $perltap{username} =~ /rab933/i;
	$realname = "Sarah" if $perltap{username} =~ /sej609/i;
	$realname = "Stacey" if $perltap{username} =~ /srb278/i;
	$realname = "Tammy" if $perltap{username} =~ /tmw112/i;
	$realname = "Valorie" if $perltap{username} =~ /vjs881/i;
	#General Matching
	$perltap{realname} = $realname if $realname;
	$perltap{realname} = $perltap{username} if $perltap{realname} eq "";
}
	
	
sub Set_PerlTap #Sets blank values for data checking
{ 
	my (%perltap) = @_;
	$perltap{cid} = " ";
	$perltap{ticket_type} = " ";
	$perltap{trouble_type} = " ";
	$perltap{report_code} = " ";
	$perltap{phone} = " ";
	$perltap{cust_name} = " ";
	$perltap{cbr} = " ";
	$perltap{report_date} = " ";
	$perltap{report_time} = " ";
	$perltap{commit_time} = " ";
	$perltap{oos} = " ";
	$perltap{environment} = " ";
	$perltap{dslam} = " ";
	$perltap{comcause} = " ";
	$perltap{tested} = " ";
	$perltap{rep_center} = " " if $perltap{group} eq "OH";
	$perltap{LAM} = " " if $perltap{group} eq "OH";
	$perltap{vn_exchange} = " " if $perltap{group} eq "OH";
	$perltap{exchange} = " " if $perltap{group} eq "OH";
	$perltap{town} = " " if $perltap{group} eq "OH";
	#$perltap{retry} = 0;
	#$perltap{newclip} = " ";
	return(%perltap);
}
	
	
sub Load_Config #Loads the config file into a variable to cache it
{ 
	open CFG,"<config\\config\.txt" or 
		&Custom_Config("#Date_#Phone_#CallID_#Customer_#CBR_#ReportCode_#ReportDate_#DSLAM_#RepCenter_#Vformulas");
	$perltap{config_info} = <CFG>;
	close(CFG);
	return($perltap{config_info});
}
	
	
sub Custom_Config #Loads custom config from the clipboard
{ 
	my ($data) = shift;
	my (@filedata) = split '\n',$data;
	$perltap{config_info} = $filedata[0];
	$perltap{config_mode} = 2;
	my ($datestamp,$timestamp) = ptmod::TimeSplit();
	print color("White"), "-----------------------------\n";
	print color("White"), "Date: ".$datestamp.' '.$timestamp."\n";
	print color("Yellow"), "  #### Custom Config ####\n\n";
	print color("White"), "Custom config info loaded: \n\n";
	print color("Cyan"), $perltap{config_info}."\n\n";
	print color("White"), "-----------------------------\n";
}
	
	
sub Check_Config_Info #Checks the settings in the config file
{ 
	my ($num,$update_time,$new_version,$report_log,$debug,$ptkill,$quote,$begin,
		$csvreadpath,$tbcsvread,$cccsvread,$beta,$ccfilter,$stfilter,$html,
		$filtermode,$filterblock,@filedata) = (0);
	open CFG,"<config\\config\.txt";
	my $config = <CFG>;
	
	while(my $line = <CFG>) 
	{
		my @fdata = split /\n/,$line;
		for (@fdata) 
		{
			push(@filedata,$line);
		}
	}
	close(CFG);
	
	for (0..$#filedata)
	{
		$begin = $num if $filedata[$_] =~ /%Config_File%/i and !$begin;
		$num++;
	}
	
	$begin = 1 if !$begin;
	
	for ($begin..$#filedata) 
	{
		#print $filedata[$_];
		($update_time) = $filedata[$_] =~ /UPDATED: (\S+ \S+, \S+ \d+:\d+ \S+)/i if $filedata[$_] =~ /UPDATED: /i;
		($new_version) = $filedata[$_] =~ /VERSION: (\S+)/i if $filedata[$_] =~ /VERSION: (\S+)/i;
		($report_log) = $filedata[$_] =~ /LOGGING: (\w+)/i if $filedata[$_] =~ /LOGGING: (\w+)/i;
		($debug) = $filedata[$_] =~ /DEBUG  : (\w+)/i if $filedata[$_] =~ /DEBUG  : (\w+)/i;
		($quote) = $filedata[$_] =~ /%Quote\((\d+)\)%/i if $filedata[$_] =~ /%Quote\((\d+)\)%/i;
		($tbcsvread) = $filedata[$_] =~ /TBMODE : (\d)/i if $filedata[$_] =~ /TBMODE : (\d)/i;
		($cccsvread) = $filedata[$_] =~ /CCMODE : (\d)/i if $filedata[$_] =~ /CCMODE : (\d)/i;
		($html) = $filedata[$_] =~ /HTML   : (\w+)/i if $filedata[$_] =~ /HTML   : (\w+)/i;
		($ccfilter) = $filedata[$_] =~ /RCODE  : (.*)/i if $filedata[$_] =~ /RCODE  : (.*)/i;
		($stfilter) = $filedata[$_] =~ /STATUS : (.*)/i if $filedata[$_] =~ /STATUS : (.*)/i;
		($filterblock) = $filedata[$_] =~ /FBLOCK : (.*)/i if $filedata[$_] =~ /FBLOCK : (.*)/i;
		($filtermode) = $filedata[$_] =~ /FMODE  : (\d)/i if $filedata[$_] =~ /FMODE  : (\d)/i;
		#($csvreadtpath) = $filedata[$_] =~ /CSVMODE: (\d)/i if $filedata[$_] =~ /CSVMODE: (\w+)/i; #Year, Month or Day
		($beta) = $filedata[$_] =~ /BETALIST: (\S+)/i if $filedata[$_] =~ /BETALIST: (\S+)/i;
		
		if ($filedata[$_] =~ /^%PT_Kill/i) 
		{
			exit(0) if $filedata[$_] =~ /^%PT_Kill%$/i;
			($ptkill) = $filedata[$_] =~ /^%PT_Kill\((\S+)\)%/i if $filedata[$_] =~ /%PT_Kill\((\S+)\)%/i;
			exit(0) if $ptkill =~ /$perltap{username}|$perltap{realname}/i;
			exit(0) if ($ptkill =~ /^v0/ and $ptkill !~ /$perltap{version}/i);
		}
	}
	
	if ($tbcsvread and $tbcsvread > 0 and $tbcsvread < 4)
	{
		$perltap{csvread}{tb} = $tbcsvread;
	} else {
		$perltap{csvread}{tb} = 2;
	}
	
	if ($cccsvread and $cccsvread > 0 and $cccsvread < 4) 
	{
		$perltap{csvread}{cc} = $cccsvread;
	} else {
		$perltap{csvread}{cc} = 2;
	}
	
	if ($filtermode and $filtermode > 0 and $filtermode < 3) 
	{
		$perltap{filter_mode} = $filtermode;
	} else {
		$perltap{filter_mode} = 1;
	}
	
	if ($update_time) 
	{
		$perltap{update_time} = $update_time;
	} else {
		$perltap{update_time} = "N/A";
	}
	
	if ($new_version) 
	{
		$perltap{new_version} = $new_version;
	} else {
		$perltap{new_version} ="N/A";
	}
	
	if ($report_log and $report_log =~ /^(ON|OFF)$/i) 
	{
		$perltap{report_log} = $report_log;
	} else {
		$perltap{report_log} = "ON";
	}
	
	if ($html and $html =~ /^(ON|OFF)$/i) 
	{
		$perltap{htmlmode} = $html
	} else {
		$perltap{htmlmode} = "ON";
	}
	
	if ($debug and $debug =~ /^(ON|OFF)$/i) 
	{
		$perltap{debug} = $debug;
	} else {
		$perltap{debug} = "ON";
	}
	
	if ($beta) 
	{
		$perltap{beta} = $beta;
	} else {
		$perltap{beta} = "N/A"
	}
	
	if ($quote) 
	{
		$perltap{quote} = ptmod::Get_Quote($quote);
	}
	
	if ($filterblock)
	{
		$perltap{filter_block} = $filterblock;
	} else {
		$perltap{filter_block} = " ";
	}
	
	if ($ccfilter) 
	{
		chomp $ccfilter;
		if ($ccfilter =~ /SCRUB/) 
		{
			if ($ccfilter =~ /,SCRUB$/) 
			{
				$ccfilter =~ s/,SCRUB//;
				$ccfilter = $ccfilter.",NDT,CBC,CCO,BDR,DSLCC,DSLDL";
			}
			elsif ($ccfilter =~ /,SCRUB,/) 
			{
				$ccfilter =~ s/,SCRUB,/,NDT,CBC,CCO,BDR,DSLCC,DSLDL,/;
			}
			elsif ($ccfilter =~ /^SCRUB,/) 
			{
				$ccfilter =~ s/SCRUB,//;
				$ccfilter = "NDT,CBC,CCO,BDR,DSLCC,DSLDL,".$ccfilter;
			} else {
				$ccfilter = "NDT,CBC,CCO,BDR,DSLCC,DSLDL";
			}
		}
		$perltap{ccfilter} = $ccfilter;
	} else {
		$perltap{ccfilter} = "STOL,NSY,IW";
	}
	
	if ($stfilter) 
	{
		chomp $stfilter;
		$perltap{stfilter} = $stfilter;
	} else {
		$perltap{stfilter} = "TESTBOARD";
	}
}
	
	
sub Error_Report 
{
	my ($error , $mode , $cidnum , $matchnumA , $matchnumB, %perltap) = @_;
	if ($mode == 1) {
		my $answer = Win32::MsgBox("The following error/bug was encountered:\n".$error.
			"\n\nWould you like to report this bug/error?\n" , 
			4|MB_ICONERROR , "Perl Tap - Bug Report");
		if ($answer == 6) 
		{
			system "start outlook.exe \/c ipm\.note \/m \"mailto\:anthony.pickelheimer\@ftr.com?subject=PerlTap Bug Report ".
			$perltap{datestamp}." ".$perltap{timestamp}."\&body\=".$error."\%0ACID\: ".
			$cidnum."\%0APHONE\: ".$matchnumA."\%0AEnvironment: ".$matchnumB.
			"\%0A\%0AOTHER REMARKS ABOUT THIS ERROR:\%0A\%0A\"";
		}
	}
	
	if ($mode == 2) 
	{
		my $answer = Win32::MsgBox("The following error/bug was encountered:\n".$error."\n\nWould you like to report this bug/error?\n" , 4|MB_ICONERROR , "Perl Tap - Bug Report");
		if ($answer == 6) 
		{
			system "start outlook.exe \/c ipm\.note \/m \"mailto\:anthony.pickelheimer\@ftr.com?subject=PerlTap Bug Report ".
			$perltap{datestamp}." ".$perltap{timestamp}."\&body\=".$error."\%0ACID\: ".
			$cidnum."\%0APHONE\: ".$matchnumA."\%0ACC Number: ".$perltap{comcause}.
			"\%0A\%0AOTHER REMARKS ABOUT THIS ERROR:\%0A \"";
		}
	}
	
	if ($mode == 3) 
	{
		my $answer = Win32::MsgBox("The following error/bug was encountered:\n".$error."\n\nWould you like to report this bug/error?\n" , 4|MB_ICONERROR , "Perl Tap - Bug Report");
		if ($answer == 6) 
		{
			system "start outlook.exe \/c ipm\.note \/m \"mailto\:anthony.pickelheimer\@ftr.com?subject=PerlTap Bug Report ".
			$perltap{datestamp}." ".$perltap{timestamp}."\&body\=".$error."\%0ACID\: ".
			$cidnum."\%0APHONE\: ".$matchnumB."\%0ASTATUS: ".$matchnumA.
			"\%0A\%0AWHAT INFO WERE YOU SEARCHING WHEN THIS ERROR OCCURED?\%0AEnvironment: \%0ADistrict: \%0AState: \%0AReporting Center: \%0AExchange: \%0AOffice: \%0ATicket Type: \%0A\"";
		}
	}
}
	
	
sub Make_Folders #Checks/Makes folders and files necessary for PerlTap logging
{ 
	my ($filedate) = ptmod::TimeDate();
	my ($month,$year) = ptmod::Get_Month();
	my $status;
	&Screen_Format();
	$status = Screen_Format("OK.\n","mkdir archive");
	$status = Screen_Format($status."OK.\n","mkdir archive\\".$year);
	$status = Screen_Format($status."OK.\n","mkdir archive\\".$year."\\".$month);
	$status = Screen_Format($status."OK.\n","mkdir archive\\".$year."\\".$month."\\".$filedate);
	
	if ($perltap{report_log} eq "ON") 
	{
		open FH,">>archive\\".$year."\\".$year."_ExcelData.csv";
		close(FH);
		$status = Screen_Format($status."OK.\n");
		open FH,">>archive\\".$year."\\".$month."\\".$filedate."\\".$filedate."_ExcelData\.csv";
		close(FH);
		$status = Screen_Format($status."OK.\n");
		open FH,">>archive\\".$year."\\".$month."\\".$month."_ExcelData\.csv";
		close(FH);
		$status = Screen_Format($status."OK.\n");
		open FH,">>archive\\Master_Database.ptdb";
		close FH;
		$status = Screen_Format($status."OK.\n");
	}
	
	$status = Screen_Format($status."Checking Config...\n");
	open CFG,"<config\\config\.txt" or print color("Red"), 
		"Loading config file failed.
Please run the CheckConfig program to attempt to fix the issue.\n\n" and 
		sleep 8 and exit(0);
	close(CFG);
	$status = Screen_Format($status."Config file loaded successfully.\n");
	sleep 1;
	system "cls";
}
	
	
sub Screen_Format #Prints information to the screen during initial startup
{ 
	my ($status,$command) = @_;
	system $command if $command;
	system qw`cls`;
	print color("White"),
		"################################################################\n".
		"#\n".
		"#		PerlTap $perltap{version}\n".
		"# PerlTap - Viryanet Ticket fast copy program\n".
		"# For use under permission of Anthony P. and/or Ian B.\n".
		"# This program does not belong to Frontier, but was made for\n".
		"# use with Frontier Viryanet systems to increase efficiency.\n".
		"# Code & Logic:: Anthony P.\n".
		"# Formulas & Concept:: Ian B.\n".
		"#\n".
		"################################################################\n".
		"#\n".
		"# Running startup commands...\n".
		"#\n".
		"################################################################\n\n";
	print $status;
	return $status;
}
	
	
sub Start_Screen #Prints intructional information for the user
{ 
	system "cls";
	print color("Yellow"), "####    PerlTap ".$perltap{version}."   ####\n\n";
	print color("Cyan"), "Welcome, ".$perltap{realname}."! (".$perltap{username}.")\n\n";
	print colored['black on_white'], $perltap{quote}, "\n\n";
	print color("Green"), "PerlTap - Viryanet Ticket fast copy program\n";
	print color("Red"), "For use under permission of Anthony P. and/or Ian B.\n";
	print color("Red"), "This program does not belong to Frontier, but was made for\n";
	print color("Red"), "use with Frontier Viryanet systems to increase efficiency.\n";
	print color("Cyan"), "Code & Logic:: Anthony P.\n";
	print color("Cyan"), "Formulas & Concept:: Ian B.\n\n";
	print color("White"), "You can use this program to:\n";
	print color("Cyan"), "Copy Call Ticket information, Common Cause Maintenance board,
the entire Common Cause Finder Board, LoopCare Results,
LOLA Results, and the most recent remark(s) in Inet Portal.\n\n";
	print color("White"), "Ctrl + A: ";
	print color("Green"), "to highlight all information on the page\n";
	print color("White"), "Ctrl + C: ";
	print color("Green"), "to copy all selected information\n";
	print color("White"), "Ctrl + V: ";
	print color("Green"), "Pastes the copied information \(Formatted by PerlTap\)";
	print color("White"), "\n";
}
	
	
sub V_Formulas_Set #Sets the Vlookup formulas from the excel spreadsheet
{ 
	my ($v_routed_to) = '=IF(RC1=0,"",VLOOKUP(RC15,TestResults!R1C1:R46C5,2,FALSE))';
	my ($v_saved) = '=IF(RC1=0,"",VLOOKUP(RC15,TestResults!R1C1:R46C5,3,FALSE))';
	my ($v_closed_time) = '=IF(RC1=0,"",(IF(RC11="y",RC1,"")))';
	my ($v_test) = '=IF(RC1=0,"",VLOOKUP(RC15,TestResults!R1C1:R46C5,4,FALSE))';
	my ($v_com_cause) = '=IF(RC1=0,"",VLOOKUP(RC15,TestResults!R1C1:R46C5,5,FALSE))';
	my ($v_formulas) = $v_routed_to."\t".$v_saved."\t".$v_closed_time."\t".$v_test."\t".$v_com_cause;
	($perltap{v_formulas}) = $v_formulas;
}
	
	
sub XL_Formulas_Set #Sets the XL replacement formulas to substitute Vlookup
{ 
	my ($xl_routed_to) = '=IF(RC14="Assignment - possible programming issue.","Assignment",IF(OR(RC14="CC - Called customer, RNA/Busy.",RC14="CC - Leave VM or Message",RC14="CC - Still issue, reentered ticket",RC14="CC - Working ok",RC14="CC -Walk through Modem reset"),"CallBack CC",IF(OR(RC14="Cancel - Invalid Report",RC14="Closed - Cancelled TT email.",RC14="Closed - Reached Answering Machine on Call back",RC14="Closed - Working OK ",RC14="HSI Congestion Area"),"Closed",IF(OR(RC14="Field -  Physical issue/damage to outside plant.",RC14="Field - IW/jack issue",RC14="Field - Line tests Field condition (ground, short , open, cross)",RC14="Field - ROH and ROH Short, RNA or Busy on call",RC14="Field - TOK , Needs field visit (possibly customer requested)",RC14="Field - TOK, RNA or Busy, VM or CLEC",RC14="HSI - route to field"),"Field",IF(RC14="HSI Investigation","HSI INVEST","--")))))';
	my ($xl_saved) = '=IF(RC14<>"",IF(OR(RC9="Field",RC9="--"),"N","Y"),"--")';
	my ($xl_closed_time) = '=IF(RC14<>"",IF(RC[-1]="Y",RC1,""),"--")';
	my ($xl_test) = '=IF(RC14<>"",IF(RC[-3]="CallBack CC","N","Y"),"--")';
	my ($xl_com_cause) = '=IF(RC14<>"",IF(RC[-1]="Y","N","Y"),"--")';
	my ($xl_formulas) = $xl_routed_to."\t".$xl_saved."\t".$xl_closed_time."\t".$xl_test."\t".$xl_com_cause;
	($perltap{xl_formulas}) = $xl_formulas;
}
	
	
sub Bootup 
{
	my $runtime = ptmod::TimeFullx();
	my $operating_time = ptmod::TimeDatex();
	my ($datestamp,$timestamp) = ptmod::TimeSplit();
	my $homepath = `cd`;
	chomp $homepath;
	$CLIP = Win32::Clipboard;
	#$perltap{beta} = "Anthony";
	($perltap{version}) = "v0.7.2.4";
	($perltap{os_current}) = Win32::GetOSName(); #Gets the windows os version
	($perltap{username}) = Win32::LoginName();
	($perltap{config_mode}) = 1; #Sets to the default reloading config file mode
	($perltap{runtime}) = $runtime; #Sets the run time information to the perltap hash
	($perltap{operating_time}) = $operating_time; #Sets the operating time info for date comparison
	($perltap{callout}) = '=IF(AND(RC2<>"",RC8<>"N",ISTEXT(R[-1]C),R[-1]C<>""),RC2,"")'; #CC Maint callout formula
	($perltap{quote}) = ptmod::Get_Quote(); #Gets a random quote from the module
	($perltap{userprofile}) = $ENV{userprofile};
	$perltap{update_time} = "N/A"; #Null until a new update time is set in the config
	$perltap{report_log} = "ON"; #Allows reporting of data
	$perltap{new_version} = "N/A"; #Null until the version is changed in the config
	$perltap{debug} = "ON"; #Sets the debug option to OFF by default in case the config info is missing 

	# if ($homepath ne 'E:\\Other Files\\Programming\\_PerlTap_InDev' and 
		# $homepath ne 'J:\\COMMON CAUSE TEAM\\PerlTap') 
	# {
		# open LOGFILE,">>J:\\COMMON CAUSE TEAM\\PerlTap\\archive\\unauthorized\.ptf";
		# syswrite LOGFILE, $perltap{username}." on ".$perltap{os_current}.
			# " circumvention attempt! \[".$homepath."\] \@".$datestamp." ".$timestamp."\n";
		# close(LOGFILE);
		# exit(0);
	# }
		
	system "title Loading PerlTap ".$perltap{version};
	$CLIP->Empty();
	&Check_Config_Info(); #Checks the config file
	&V_Formulas_Set(); #Sets the V_Formulas variable
	&XL_Formulas_Set(); #Sets the XL_Formulas variable
	&Load_Config(); #Pulls the return data string from the config file
	&Username_Match(); #Sets the real name based on the current username
}
	
sub OS_Check 
{
	if ($^O !~ /ms/i and $^O !~ /win/i) 
	{
		system "cls";
		print color("Green"), "PerlTap - Viryanet Ticket fast copy program\n";
		print color("Red"), "For use under permission of Anthony P. and/or Ian B.\n";
		print color("Red"), "This program does not belong to Frontier, but was made for\n";
		print color("Red"), "use with Frontier Viryanet systems to increase efficiency.\n";
		print color("Cyan"), "Code & Logic:: Anthony P.\n";
		print color("Cyan"), "Formulas & Concept:: Ian B.\n\n";
		print color("White"), "You can use this program to:\n";
		print color("Cyan"), "Copy Call Ticket information, Common Cause Maintenance board,\nthe entire Common Cause Finder Board, LoopCare Results,\nLOLA Results, and the most recent remark(s) in Inet Portal.\n\n";
		print color("White"), "Ctrl + A: ";
		print color("Green"), "to highlight all information on the page\n";
		print color("White"), "Ctrl + C: ";
		print color("Green"), "to copy all selected information\n";
		print color("White"), "Ctrl + V: ";
		print color("Green"), "Pastes the copied information \(Formatted by PerlTap\)";
		print color("White"), "\n";
		print color("White"), "-----------------------------\n";
		print color("Yellow"), "#### Unsupported operating system! ####\n";
		print color("Yellow"), "#### Current OS: $^O ####\n";
		print color("Yellow"), "#### PerlTap will now be closed.  ####\n\n";
		print color("White"), "-----------------------------\n";
		sleep 5;
		exit(0);
	}
}
	
sub PerlTap_Database 
{
	my ($mode,%perltap) = @_;
	$perltap{database} .= "\n" if $mode == 1;
	open DB, '>>archive\\Master_Database.ptdb';
	syswrite DB, $perltap{database};
	close(DB);
}
	
exit(0);