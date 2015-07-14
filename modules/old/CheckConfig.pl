################################################################
#
# Config.txt file checker for PerlTap
# You can use this to rebuild your config file
# If your config file is out of date, delete it and
# run this program to rebuild it with current info
#
################################################################
#!/usr/bin/perl
use strict;
use warnings;
use Win32::Clipboard;
my $CLIP = Win32::Clipboard;
my ($v_formulas) = V_Formulas_Set();
my ($xl_formulas) = XL_Formulas_Set();
my $username = Win32::LoginName();

#if ($username =~ /^(jmn853|msl678|app629|dpg691|tab237|bnn463|arb062|tsc443|tll680|vff863|vam260|pjg930|ibb601|ter041|victoria.g.franklin|Anthony)$/i) {
	&TestConfig();
	#}
	
#else {
	#print "UNAUTHORIZED USER! TERMINATING PROGRAM!\n\n";
	#sleep 6;
	#die;
	#}

sub TestConfig {
	open CFG,"<config\\config\.txt" or &MakeConfig();
	my ($config) = <CFG>;
	print "Format: ".$config."\n\n";
	if ($config) {
		$config =~ s/_/\t/g;
		$config =~ s/#Date/MM\/DD\/YYYY/i unless $config !~ /#Date/i;
		$config =~ s/#Phone/2604155555/i unless $config !~ /#Phone/i;
		$config =~ s/#CallID/4155050/i unless $config !~ /#CallID/i;
		$config =~ s/#ReportCode/DSLDL/i unless $config !~ /#ReportCode/i;
		$config =~ s/#Tested/N/i unless $config !~ /#Tested/i;
		$config =~ s/#CommonCause/514897/i unless $config !~ /#CommonCause/i;
		$config =~ s/#ReportDate/1\/31\/2013/i unless $config !~ /#ReportDate/;
		$config =~ s/#Callout/Excel(CalloutFormula)/i unless $config !~ /#Callout/i;
		$config =~ s/#OOS/Y/i unless $config !~ /#OOS/i;
		$config =~ s/#TicketType/TT/i unless $config !~ /#TicketType/i;
		$config =~ s/#TroubleType/RO/i unless $config !~ /#TroubleType/i;
		$config =~ s/#DSLAM/DSLAMCLLI/i unless $config !~ /#DSLAM/i;
		$config =~ s/#CBR/CustCBR/i unless $config !~ /#CBR/i;
		$config =~ s/#Customer/CustName/i unless $config !~ /#Customer/i;
		$config =~ s/#Vformulas/$v_formulas/i unless $config !~ /#Vformulas/i;
		$config =~ s/#XLformulas/$xl_formulas/i unless $config !~ /#XLformulas/i;
		chomp($config);
		}
	print "Data: ".$config."\n\n";
	print "You can paste the data into excel to see if it matches your spreadsheet,\nthe file template has been loaded to the clipboard.\n\n";
	$CLIP->Set($config);
	close(CFG);
	system "Pause";
	exit(0);
	}

sub MakeConfig {
	system "mkdir config";
	system "cls";
	open CFG,">config\\config\.txt" or die $!;
	print CFG "#Date_#Phone_#CallID_#Customer_#CBR_#ReportCode_#ReportDate_#DSLAM_#Vformulas\n
Codes: 
#CallID
#Callout
#CBR
#CommonCause
#Customer
#Date
#DSLAM
#OOS
#Phone
#ReportCode
#ReportDate
#Tested
#TicketType
#TroubleType
#Vformulas


There must be an underscore after each code, otherwise it will put them in the same cell.  As formated in the default:

#Date_#Phone_#CallID_#Customer_#CBR_#ReportCode_#ReportDate_#DSLAM_#Vformulas

CSV Modes are 1 - \"Day\", 2 - \"Month\", 3 - \"Year\"
Wildcards are PT_Kill, PT_Kill(), Quotes(), and TogglePTFreeze 
- These wildcards must be surrounded with %'s
- Example: %PT_Kill%
- PT_Kill() - You can put a username or version here inside the parenthesis
- Quotes() - Quote number 1 - 366

%Config_File%
UPDATED: June 4th, 2013 01:31 PM
VERSION: v0.7.1.1
CCMODE : 2
TBMODE : 1
LOGGING: ON
DEBUG  : OFF
BETALIST: \n";
	close(CFG);
	&TestConfig();
	}
	
sub V_Formulas_Set { #Sets the Vlookup formulas from the excel spreadsheet
	my ($v_routed_to) = '=IF(RC[-8]=0,"",VLOOKUP(RC[5],TestResults!R1C1:R46C5,2,FALSE))';
	my ($v_saved) = '=IF(RC[-9]=0,"",VLOOKUP(RC[4],TestResults!R1C1:R46C5,3,FALSE))';
	my ($v_closed_time) = '=IF(RC[-10]=0,"",(IF(RC[-1]="y",RC[-15],"")))';
	my ($v_test) = '=IF(RC[-11]=0,"",VLOOKUP(RC[2],TestResults!R1C1:R46C5,4,FALSE))';
	my ($v_com_cause) = '=IF(RC[-12]=0,"",VLOOKUP(RC[1],TestResults!R1C1:R46C5,5,FALSE))';
	my ($v_formulas) = $v_routed_to."\t".$v_saved."\t".$v_closed_time."\t".$v_test."\t".$v_com_cause;
	return $v_formulas;
	}
	
	
sub XL_Formulas_Set { #Sets the XL replacement formulas to substitute Vlookup
	my ($xl_routed_to) = '=IF(RC14="Assignment - possible programming issue.","Assignment",IF(OR(RC14="CC - Called customer, RNA/Busy.",RC14="CC - Leave VM or Message",RC14="CC - Still issue, reentered ticket",RC14="CC - Working ok",RC14="CC -Walk through Modem reset"),"CallBack CC",IF(OR(RC14="Cancel - Invalid Report",RC14="Closed - Cancelled TT email.",RC14="Closed - Reached Answering Machine on Call back",RC14="Closed - Working OK ",RC14="HSI Congestion Area"),"Closed",IF(OR(RC14="Field -  Physical issue/damage to outside plant.",RC14="Field - IW/jack issue",RC14="Field - Line tests Field condition (ground, short , open, cross)",RC14="Field - ROH and ROH Short, RNA or Busy on call",RC14="Field - TOK , Needs field visit (possibly customer requested)",RC14="Field - TOK, RNA or Busy, VM or CLEC",RC14="HSI - route to field"),"Field",IF(RC14="HSI Investigation","HSI INVEST","--")))))';
	my ($xl_saved) = '=IF(RC14<>"",IF(OR(RC9="Field",RC9="--"),"N","Y"),"--")';
	my ($xl_closed_time) = '=IF(RC14<>"",IF(RC[-1]="Y",RC1,""),"--")';
	my ($xl_test) = '=IF(RC14<>"",IF(RC[-3]="CallBack CC","N","Y"),"--")';
	my ($xl_com_cause) = '=IF(RC14<>"",IF(RC[-1]="Y","N","Y"),"--")';
	my ($xl_formulas) = $xl_routed_to."\t".$xl_saved."\t".$xl_closed_time."\t".$xl_test."\t".$xl_com_cause;
	return $xl_formulas;
	}
	
exit(0);