package ptmod;
#!/usr/bin/perl
#time module
use 5.10.0;
use strict;
#use warnings;
use dbnpanxx;
use dboffice;
my %OFFICE = dboffice::ASSEMBLE_HASH();
my %NPA = dbnpanxx::ASSEMBLE_HASH();


sub TimeFull #Full time display Month_Day_Year Hr_Min_Sec_AM/PM
{ 
    my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
    my @months = qw`January February March April May June July August September
        October November December`;
    my @days = qw`Sun Mon Tue Wed Thu Fri Sat`;
    my @ext = qw`st nd rd th`;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    my $ap;
    $ap = '_AM' if $hour < 12;
    $ap = '_PM' if $hour > 11;
    if ( $sec < 10 && $sec >= 0 ) { $sec = '0'.$sec; }
    if ( $min < 10 ) { $min = '0' . $min; }
    if ( $hour > 12 ) { $hour = $hour - 12; }
    if ( $hour == 0 ) { $hour = 12; }
    if ( $mday =~ /^(1|21|31)$/ ) { $mday = $mday . $ext[0]; }
	elsif ( $mday =~ /^(2|22)$/ ) { $mday = $mday . $ext[1]; }
    elsif ( $mday =~ /^(3|23)$/ ) { $mday = $mday . $ext[2]; }
    else { $mday = $mday . $ext[3]; }
    $year = $year + 1900;
    my $day = $days[$wday] . '_';
    my $date = $months[$mon] . '_' . $mday . '_' . $year;
    $time = $hour . '_' . $min . '_' . $sec;
	my $clock = $date.' '.$time.$ap;
    return $clock;
}
	
sub TimeFullx #Full time display Month_Day_Year Hr_Min_Sec_AM/PM
{ 
    my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
    my @months = qw`January February March April May June July August September
        October November December`;
    my @days = qw`Sun Mon Tue Wed Thu Fri Sat`;
    my @ext = qw`st nd rd th`;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    my $ap;
    $ap = ' AM' if $hour < 12;
    $ap = ' PM' if $hour > 11;
    if ( $sec < 10 && $sec >= 0 ) { $sec = '0'.$sec; }
    if ( $min < 10 ) { $min = '0' . $min; }
    if ( $hour > 12 ) { $hour = $hour - 12; }
    if ( $hour == 0 ) { $hour = 12; }
    if ( $mday =~ /^(1|21|31)$/ ) { $mday = $mday . $ext[0]; }
	elsif ( $mday =~ /^(2|22)$/ ) { $mday = $mday . $ext[1]; }
    elsif ( $mday =~ /^(3|23)$/ ) { $mday = $mday . $ext[2]; }
    else { $mday = $mday . $ext[3]; }
    $year = $year + 1900;
    my $day = $days[$wday] . '_';
    my $date = $months[$mon] . ' ' . $mday . ', ' . $year;
    $time = $hour . ':' . $min;
	my $clock = $date.' '.$time.$ap;
    return $clock;
}

sub TimeSplit #Split time MM/DD/YEAR & Hr:Min:Sec
{ 
    my ($timestamp) = shift;
    my $time;
	
    if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
	my @months = (1,2,3,4,5,6,7,8,9,10,11,12);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    my $ap;
    $ap = ' AM' if $hour < 12;
    $ap = ' PM' if $hour > 11;
    if ( $sec < 10 && $sec >= 0 ) { $sec = '0'.$sec; }
    if ( $min < 10 ) { $min = '0' . $min; }
    if ( $hour > 12 ) { $hour = $hour - 12; }
    if ( $hour == 0 ) { $hour = 12; }
    $year = $year + 1900;
    my $date = $months[$mon] . '/' . $mday . '/' . $year;
    $time = $hour . ':' . $min . ':' . $sec;
	my $clock = $time.$ap;
    return ($date,$clock);
}
	
sub TimeDate #Normal Date MM/DD/YEAR
{ 
    my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
	my @months = (1,2,3,4,5,6,7,8,9,10,11,12);
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    $year = $year + 1900;
    my $date = $months[$mon] . "_" . $mday . "_" . $year;
	my $clock = $date;
    return $clock;
}
	
sub TimeDatex #Normal Date Month/DD/YEAR
{ 
	my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
    my @months = qw`January February March April May June July August September
        October November December`;
    my @days = qw`Sun Mon Tue Wed Thu Fri Sat`;
    my @ext = qw`st nd rd th`;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    my $ap;
    $ap = '_AM' if $hour < 12;
    $ap = '_PM' if $hour > 11;
    if ( $sec < 10 && $sec >= 0 ) { $sec = '0'.$sec; }
    if ( $min < 10 ) { $min = '0' . $min; }
    if ( $hour > 12 ) { $hour = $hour - 12; }
    if ( $hour == 0 ) { $hour = 12; }
    if ( $mday =~ /^(1|21|31)$/ ) { $mday = $mday . $ext[0]; }
	elsif ( $mday =~ /^(2|22)$/ ) { $mday = $mday . $ext[1]; }
    elsif ( $mday =~ /^(3|23)$/ ) { $mday = $mday . $ext[2]; }
    else { $mday = $mday . $ext[3]; }
    $year = $year + 1900;
    my $day = $days[$wday] . '_';
    my $date = $months[$mon] . " " . $mday . ", " . $year;
	my $clock = $date;
    return $clock;
}

sub MilFull #Military time YYYYMMDD HHMM
{ 
	my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
	my @months = (1,2,3,4,5,6,7,8,9,10,11,12);
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    if ( $min < 10 ) { $min = '0' . $min; }
    $year = $year + 1900;
    my $date = $year.$months[$mon].$mday;
	my $clock = $date.'_'.$hour.$min;
    return $clock;
}
	
sub MilDate #Military date YYYYMMDD
{ 
	my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
	my @months = (1,2,3,4,5,6,7,8,9,10,11,12);
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
    $year = $year + 1900;
    my $date = $year.$months[$mon].$mday;
	my $clock = $date;
    return $clock;
}

sub FormatDate 
{
	my ($year,$month,$day) = @_;
	$month = int($month);
	my @months = qw`null Jan Feb Mar Apr May Jun Jul Aug Sep
        Oct Nov Dec`;
	$month = $months[$month];
	my $clock = $month." ".$day." ".$year;
	return $clock;
}

sub FormatNumeric 
{
	my ($year,$month,$day) = @_;
	my @months = qw`null Jan Feb Mar Apr May Jun Jul Aug Sep
        Oct Nov Dec`;
	
	for (0..$#months) 
	{
		$month = $#months if $month == $months[$_];
	}
	
	$day = $day =~ s/^0//;
	my $clock = $month."\/".$day."\/".$year;
	return $clock;
}

sub Get_Month #Full time display Month_Day_Year Hr_Min_Sec_AM/PM
{
    my ($timestamp) = shift;
    my $time;
    
	if ($timestamp) 
	{
        $time = $timestamp;
    } else {
        $time = time;
    }
	
    my @months = qw`January February March April May June July August September
        October November December`;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime($time);
	$year = $year + 1900;
	my $month = $months[$mon];
    return ($month,$year);
}
	
sub Get_Quote 
{
	my $q = shift;
	my $randquote;
	my %quotes = (
		1		=>	'"How do you get a sweet little 80-year-old lady to say the F word? Get another sweet little 80-year-old lady to yell \'BINGO!\'" - Unknown',
		2		=>	'"When I die, I want to die like my grandfather who died peacefully in his sleep. Not screaming like all the passengers in his car." - Will Rogers',
		3		=>	'"Politicians and diapers have one thing in common. They should both be changed regularly, and for the same reason." - José Maria de Eça de Queiroz',
		4		=>	'"Nothing sucks more than that moment during an argument when you realize you\'re wrong" - Unknown',
		5		=>	'"Knowledge is knowing a tomato is a fruit; Wisdom is not putting it in a fruit salad." - Brian Gerald O\'Driscoll',
		6		=>	'"Some cause happiness wherever they go; others whenever they go" - Oscar Wilde',
		7		=>	'"Better to remain silent and be thought a fool, than to speak and remove all doubt." - Abraham Lincoln (paraphrase from the Bible, \'Proverbs\' 17:28)',
		8		=>	'"The shinbone is a device for finding furniture in a dark room." - Unknown',
		9		=>	'"The hardest thing in the world to understand is income taxes." - Albert Einstein',
		10		=>	'"I don\'t suffer from insanity; I enjoy every minute of it." - Unknown',
		11		=>	'"Patience is something you admire in the driver behind you, but not in one ahead." - Bill McGlashen',
		12		=>	'"Women who seek to be equal with men lack ambition." - Marilyn Monroe',
		13		=>	'"The only mystery in life is why the kamikaze pilots wore helmets" - Al McGuire',
		14		=>	'"When I was a boy of fourteen, my father was so ignorant I could hardly stand to have the old man around. But when I got to be twenty-one, I was astonished at how much he had learned in seven years." - Mark Twain',
		15		=>	'"Why is the place you drive on is a parkway, and the place you park on is the driveway?" - Unknown',
		16		=>	'"If you die in an elevator, be sure to push the up button." - Sam Levenson',
		17		=>	'"If you think nobody cares if you\'re alive, try missing a couple of payments." - Earl Wilson',
		18		=>	'"Men marry women with the hope they will never change. Women marry men with the hope they will change. Invariably they are both disappointed." - Albert Einstein',
		19		=>	'"The quickest way to double your money is to fold it over and put it back in your pocket." - Will Rogers',
		20		=>	'"I couldn\'t repair your brakes, so I made your horn louder." - Steven Wright',
		21		=>	'"Before you criticize someone, you should walk a mile in their shoes. That way when you criticize them, you are a mile away from them and you have their shoes." - Jack Handey',
		22		=>	'"Children: You spend the first 2 years of their life teaching them to walk and talk. Then you spend the next 16 telling them to sit down and shut-up." - Unknown',
		23		=>	'"If evolution is fact, why do mothers only have two hands?" - Milton Berle',
		24		=>	'"I dream of a better tomorrow, where chickens can cross the road and not be questioned about their motives." - Unknown',
		25		=>	'"I am going to call my kids Ctrl, Alt and Delete. Then if they muck up I will just hit them all at once." - Unknown',
		26		=>	'"By working faithfully eight hours a day you may eventually get to be boss and work twelve hours a day." - Robert Frost',
		27		=>	'"People often say that motivation doesn\'t last. Well, neither does bathing – that\'s why we recommend it daily." - Zig Ziglar',
		28		=>	'"I asked God for a bike, but I know God doesn\'t work that way. So I stole a bike and asked for forgiveness." - Emo Philips',
		29		=>	'"A bank is a place that will lend you money if you can prove that you don\'t need it." - Bob Hope',
		30		=>	'"A friend is someone who will bail you out of jail. A best friend is the one sitting next to you saying \'boy was that fun.\'" - The Maugles',
		31		=>	'"People who think they know everything are a great annoyance to those of us who do." - Isaac Asimov',
		32		=>	'"Why does a woman work ten years to change a man\'s habits and then complain that he\'s not the man she married?" - Barbra Streisand',
		33		=>	'"You want a friend in Washington? Get a dog." - Harry S. Truman',
		34		=>	'"We live in a society where pizza gets to your house before the police." - Unknown',
		35		=>	'"If I agreed with you we\'d both be wrong." - Unknown',
		36		=>	'"My mother never saw the irony in calling me a son-of-a-bitch." - Jack Nicholson',
		37		=>	'"Having sex is like playing bridge. If you don\'t have a good partner, you\'d better have a good hand." - Woody Allen',
		38		=>	'"The early bird might get the worm, but the second mouse gets the cheese." - Unknown',
		39		=>	'"Evening news is where they begin with \'Good evening\', and then proceed to tell you why it isn\'t." - Unknown',
		40		=>	'"To steal ideas from one person is plagiarism. To steal from many is research." - Wilson Mizner',
		41		=>	'"Three words guaranteed to humiliate men everywhere: \'Hold my purse.\'" - Unknown',
		42		=>	'"I didn\'t fight my way to the top of the food chain to be a vegetarian." - Unknown',
		43		=>	'"A computer once beat me at chess, but it was no match for me at kick boxing." - Emo Philips',
		44		=>	'"Men have two emotions: hungry and horny. If you see him without an erection, make him a sandwich." - Unknown',
		45		=>	'"The sole purpose of a child\'s middle name, is so he can tell when he\'s really in trouble." - Unknown',
		46		=>	'"Always borrow money from a pessimist. He won\'t expect it back." - Oscar Wilde',
		47		=>	'"Hospitality: making your guests feel like they\'re at home, even if you wish they were." - Unknown',
		48		=>	'"My opinions may have changed, but not the fact that I am right." - Ashleigh Brilliant',
		49		=>	'"I discovered I scream the same way whether I\'m about to be devoured by a great white shark or if a piece of seaweed touches my foot." - Axel Rose',
		50		=>	'"You are such a good friend that if we were on a sinking ship together and there was only one life jacket... I\'d miss you heaps and think of you often." - Unknown',
		51		=>	'"Why does someone believe you when you say there are four billion stars, but check when you say the paint is wet?" - Unknown',
		52		=>	'"A bargain is something you don\'t need at a price you can\'t resist." - Franklin Jones',
		53		=>	'"If at first you don\'t succeed, skydiving is not for you!" - Henny Youngman',
		54		=>	'"You know the world is going crazy when the best rapper is a white guy, the best golfer is a black guy, the tallest guy in the NBA is Chinese, the Swiss hold the America\'s Cup, France is accusing the U.S. of arrogance, Germany doesn\'t want to go to war, and the three most powerful men in America are named \'Bush\', \'Dick\', and \'Colon\'." - Chris Rock',
		55		=>	'"When you go into court, you are putting your fate into the hands of people who weren\'t smart enough to get out of jury duty." - Norm Crosby',
		56		=>	'"The big difference between sex for money and sex for free is that sex for money usually costs a lot less." - Brendan Behan',
		57		=>	'"Keep the dream alive: Hit the snooze button." - Unknown',
		58		=>	'"A stockbroker urged me to buy a stock that would triple its value every year. I told him, \'At my age, I don\'t even buy green bananas.\'" - Claude Pepper',
		59		=>	'"I always take life with a grain of salt, ...plus a slice of lemon, ...and a shot of tequila." - Unknown',
		60		=>	'"The only way the French are going in is if we tell them we found truffles in Iraq." - Dennis Miller',
		61		=>	'"The best argument against democracy is a five-minute conversation with the average voter." - Winston Churchill',
		62		=>	'"It\'s strange, isn\'t it. You stand in the middle of a library and go aaaaagghhhh\' and everyone just stares at you. But you do the same thing on an aeroplane, and everyone joins in." - Tommy Cooper',
		63		=>	'"Why didn\'t Noah swat those two mosquitoes?" - Unknown',
		64		=>	'"The trouble with being punctual is that nobody\'s there to appreciate it." - Franklin P. Jones',
		65		=>	'"I have to exercise early in the morning before my brain figures out what I\'m doing." - Unknown',
		66		=>	'"God gave us our relatives; thank God we can choose our friends." - Ethel Mumford',
		67		=>	'"A graduation ceremony is an event where the commencement speaker tells thousands of students dressed in identical caps and gowns that \'individuality\' is the key to success." - Robert Purvis',
		68		=>	'"The human brain is a wonderful thing. It starts working the moment you are born, and never stops until you stand up to speak in public." - George Jessel',
		69		=>	'"America is a country where half the money is spent buying food, and the other half is spent trying to lose weight." - Unknown',
		70		=>	'"Isn\'t having a smoking section in a restaurant like having a peeing section in a swimming pool?" - Unknown',
		71		=>	'"Never go to bed angry, stay awake and plot your revenge." - Unknown',
		72		=>	'"I\'m at the age where I want two girls. In case I fall asleep they will have someone to talk to." - Rodney Dangerfield',
		73		=>	'"If aliens are watching us through telescopes, they\'re going to think the dogs are the leaders of the planet. If you see two life forms, one of them\'s making a poop, the other one\'s carrying it for him, who would you assume is in charge?" - Jerry Seinfeld',
		74		=>	'"Bisexuality immediately doubles your chances for a date on Saturday night." - Rodney Dangerfield',
		75		=>	'"As you get older three things happen. The first is your memory goes, and I can\'t remember the other two." - Norman Wisdom',
		76		=>	'"How is it one careless match can start a forest fire, but it takes a whole box to start a campfire?" - Unknown',
		77		=>	'"Men reach their sexual peak at eighteen. Women reach theirs at thirty-five. Do you get the feeling that God is playing a practical joke?" - Rita Rudner',
		78		=>	'"If women ran the world we wouldn\'t have wars, just intense negotiations every 28 days." - Robin Williams',
		79		=>	'"By the time a man realizes that his father was right, he has a son who thinks he\'s wrong." - Charles Wadsworth',
		80		=>	'"A citizen of America will cross the ocean to fight for democracy, but won\'t cross the street to vote in a national election." - Bill Vaughan',
		81		=>	'"To err is human, to blame it on somebody else shows management potential." - Unknown',
		82		=>	'"I have enough money to last me the rest of my life, unless I buy something." - Jackie Mason',
		83		=>	'"Duct tape is like the force. It has a light side, a dark side, and it holds the universe together." - Oprah Winfrey',
		84		=>	'"Money can\'t buy love, but it improves your bargaining position." - Christopher Marlowe',
		85		=>	'"Experience is that marvellous thing that enables you to recognize a mistake when you make it again." - Franklin P. Jones',
		86		=>	'"Sometimes the road less traveled is less traveled for a reason." - Jerry Seinfeld',
		87		=>	'"Dogs have masters. Cats have staff." - Unknown',
		88		=>	'"Why do people keep running over a string a dozen times with their vacuum cleaner, then reach down, pick it up, examine it, then put it down to give their vacuum one more chance?" - Unknown',
		89		=>	'"It\'s true hard work never killed anybody, but I figure, why take the chance?" - Ronald Reagan',
		90		=>	'"A celebrity is someone who works hard all his life to become known and then wears dark glasses to avoid being recognized." - Fred Allen',
		91		=>	'"They keep saying the right person will come along, I think mine got hit by a truck." - Unknown',
		92		=>	'"See, the problem is that God gives men a brain and a penis, and only enough blood to run one at a time." - Robin Williams',
		93		=>	'"First the doctor told me the good news: I was going to have a disease named after me." - Steve Martin',
		94		=>	'"I hope that after I die, people will say of me: \'That guy sure owed me a lot of money.\'" - Jack Handy',
		95		=>	'"Never go to a doctor whose office plants have died." - Erma Bombeck',
		96		=>	'"Life\'s disappointments are harder to take when you don\'t know any swear words." - Unknown',
		97		=>	'"The best way to lie is to tell the truth, carefully edited truth." - Unknown',
		98		=>	'"At every party there are two kinds of people: those who want to go home and those who don\'t. The trouble is, they are usually married to each other." - Ann Landers',
		99		=>	'"If you do a job too well, you will get stuck with it." - Unknown',
		100		=>	'"Make yourself at home... clean my kitchen." - Unknown',
		101		=>	'"Results! Why, man, I have gotten a lot of results I know several thousand things that won\'t work." - Thomas A. Edison  (1847 - 1931) - USA',
		102		=>	'"If you would cure anger, do not feed it. Say to yourself: I used to be angry every day; then ever other day; now only every third or fourth day When you reach thirty days offer a sacrifice of thanksgiving to the gods." - Epictetus (55 AD - 135 AD)',
		103		=>	'"My evil genius Procrastination has whispered m to tarry til a more \'convenient season." - Mary Todd Lincoln (1818 - 1882)',
		104		=>	'"Never let the demands of tomorrow interfere with the pleasures and excitement of today." - Meredith Willson (1902 - 1984) - San Francisco CA USA',
		105		=>	'"Once we believe in ourselves, we can rise curiosity, wonder, spontaneous delight, to any experience that reveals the human spirit." - E. E. Cummings (1894 - 1962) - USA',
		106		=>	'"Elections are won by men and women chiefly because, most people vote against somebody rather than for somebody." - Franklin Adams (1881 - 1960) - USA',
		107		=>	'"Courage without conscience is a wild roaming beast." - Colonel, Robert G. Ingersoll - Civil War (b.1833- d.1899) - USA',
		108		=>	'"I tore myself away from the safe comfort of certainties through my love for the truth; and truth rewarded me." - Simone de Beauvoir - (1908 - 1986) - FRANCE',
		109		=>	'"The universe is a big place, perhaps the biggest." - Kilgore Trout - (Philip Jose Farmer)',
		110		=>	'"Some editors are failed writers but so are most writers." - T. S. Eliot (1888 - 1965) - England',
		111		=>	'"The man who goes alone can start today, but he who travels with another must wait till that other is ready." - Henry David Thoreau - (1817 - 1862) - USA',
		112		=>	'"I think there is a world market for maybe five computers." - Thomas Watson - (1874 - 1956) - Chairman of IBM, 1943 - USA',
		113		=>	'"I think it would be a good idea. When asked what he thought of Western civilization." - Mahatma Gandhi - (1869 - 1948) - India',
		114		=>	'"First they ignore you, then they laugh at you then they fight you, then you win." - Mahatma Gandhi (1869 - 1948) - India',
		115		=>	'"There are two ways of constructing a software design; one way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult." - C. A. R. Hoare',
		116		=>	'"Each problem that I solved became a rule which served afterwards to solve other problems." - Rene Descartes - (1596 - 1650) - \'Discours de la Methode\'',
		117		=>	'"Everybody pities the weak, jealousy you have to earn." - Arnold Schwarzenegger - (1947 - )',
		118		=>	'"Talent does what it can, genius does what it must." - Edward George Bulwer Lytton - (1803 - 1873)',
		119		=>	'"There is a country in Europe where multiple-choice tests are illegal." - Henry David Thoreau (1817 - 1862)',
		120		=>	'"There are no facts, only interpretations." - Friedrich Nietzsche (1844 - 1900)',
		121		=>	'"I have often regretted my speech, never my silence." - Xenocrates - (396 - 314 BC)',
		122		=>	'"It was the experience of mystery -- even if mixed with fear -- that engendered religion." - Albert Einstein (1879 - 1955) - USA',
		123		=>	'"While we are postponing, life speeds by." - Seneca (3BC - 65AD)',
		124		=>	'"He that loses his conscience has nothing left that is worth keeping. Therefore, be sure you look to that and in the next place look to your health; And if you have it Praise God and value it next to a good conscience." - Izaak Walton - (1593 - 1683) - England',
		125		=>	'"Honor has not to be won; It has only not to be lost." - Arthur Schopenhauer (1788 - 1860) - Germany',
		126		=>	'"I feel sorry for people who don\'t drink. When they wake up in the morning, that\'s as good as they\'re going to feel all day." - Frank Sinatra',
		127		=>	'"A successful man is one who makes more money than his wife can spend. A successful woman is one who can find such a man." - Lana Turner',
		128		=>	'"I believe that if life gives you lemons, you should make lemonade... And try to find somebody whose life has given them vodka, and have a party." - Ron White',
		129		=>	'"A word to the wise ain\'t necessary - it\'s the stupid ones that need the advice." - Bill Cosby',
		130		=>	'"Behind every great man is a woman rolling her eyes." - Jim Carey',
		131		=>	'"I feel sorry for people who don\'t drink. When they wake up in the morning, that\'s as good as they\'re going to feel all day." - Frank Sinatra',
		132		=>	'"Do not take life too seriously. You will never get out of it alive." - Elbert Hubbard',
		133		=>	'"A day without sunshine is like, you know, night." - Steve Martin',
		134		=>	'"A government that robs Peter to pay Paul can always depend on the support of Paul." - George Bernard Show',
		135		=>	'"When you are courting a nice girl an hour seems like a second. When you sit on a red-hot cinder a second seems like an hour. That\'s relativity." - Albert Einstein',
		136		=>	'"Go to Heaven for the climate, Hell for the company." - Mark Twain',
		137		=>	'"Wine is constant proof that God loves us and loves to see us happy." - Benjamin Franklin',
		138		=>	'"As a child my family\'s menu consisted of two choices: take it or leave it." - Buddy Hackett',
		139		=>	'"Between two evils, I always pick the one I never tried before." - Mae West',
		140		=>	'"Get your facts first, then you can distort them as you please." - Mark Twain',
		141		=>	'"People who think they know everything are a great annoyance to those of us who do." - Isaac Asimov',
		142		=>	'"Housework can\'t kill you, but why take a chance? - Phyllis Diller',
		143		=>	'"Any girl can be glamorous. All you have to do is stand still and look stupid." - Hedy Lamarr',
		144		=>	'"I have six locks on my door all in a row. When I go out, I lock every other one. I figure no matter how long somebody stands there picking the locks, they are always locking three." - Elayne Boosler',
		145		=>	'"My fake plants died because I did not pretend to water them." - Mitch Hedberg',
		146		=>	'"A two-year-old is kind of like having a blender, but you don\'t have a top for it." - Jerry Seinfeld',
		147		=>	'"A lot of people are afraid of heights. Not me, I\'m afraid of widths." - Steven Wright',
		148		=>	'"All right everyone, line up alphabetically according to your height." - Casey Stengel',
		149		=>	'"My grandmother started walking five miles a day when she was sixty. She\'s ninety-seven now, and we don\'t know where the hell she is." - Ellen DeGeneres',
		150		=>	'"I always wanted to be somebody, but now I realize I should have been more specific." - Lily Tomlin',
		151		=>	'"Always end the name of your child with a vowel, so that when you yell the name will carry." - Bill Cosby',
		152		=>	'"A scholar who cherishes the love of comfort, is not fit to be deemed a scholar. - Lao-Tzu (c.570 - c.490 BC)"',
		153		=>	'"After I\'m dead I\'d rather have people ask why I have no monument, than why I have one. - Cato the Elder - (234 - 149 BC) - a.k.a. Marcus Porcius Cato"',
		154		=>	'"Dancing is silent poetry. - Simonides (556 - 468 BC)"',
		155		=>	'"We are not retreating, we are advancing in another direction. - General Douglas MacArthur - (1880 - 1964) - United States Military Warmonger"',
		156		=>	'"Interesting - I use a Mac to help me design the next Cray. - Seymoure Cray - (1925 - 1996) - When he was told that Apple had bought a Cray Super-Computer to help them design the next Mac. - USA"',
		157		=>	'"The man who does not read good books has no advantage over the man who cannot read them. - Mark Twain - (1835 - 1910) - USA"',
		158		=>	'"Few things are harder to put up with than a good example. - Mark Twain - (1835 - 1910) - USA"',
		159		=>	'"I have never let my schoolin\' interfere with my education. - Mark Twain - (1835 - 1910) - USA"',
		160		=>	'"Always do right - this will gratify some, and astonish the rest. - Mark Twain - (1835 - 1910) - USA"',
		161		=>	'"Denial ain\'t just a river in Egypt - Mark Twain. - (1835 - 1910) - USA"',
		162		=>	'"It\'s not the size of the dog in the fight, it\'s the size of the fight in the dog. - Mark Twain - (1835 - 1910) - USA"',
		163		=>	'"Wagner\'s music is better than it sounds. - Mark Twain - (1835 - 1910) - USA"',
		164		=>	'"Be kind, for everyone you meet is fighting a hard battle. - Plato - (427 - 347 BC) - Greek Philosopher"',
		165		=>	'"The direction in which education starts a man, will determine his future. - Plato - (427 - 347 BC) - Greek Philosopher"',
		166		=>	'"You are young, my son, and, as the years go by, time will change and even reverse man of your present opinions. Refrain therefor awhile from setting yourself up as a judge of the highest matters. - Plato - (427 - 347 BC) - Greek Philosopher"',
		167		=>	'"Wise men talk because they have something to say; fools, because they have to say something. - Plato - (427 - 347 BC) - Greek Philosopher"',
		168		=>	'"He who is of a calm and happy nature will hardly feel the pressure of age, but to him who is of an opposite disposition, youth and age are an equal burden. - Plato - (427 - 347 BC) - Greek Philosopher"',
		169		=>	'"People are like dirt. They can either nourish you and help you grow as a person, or they can stunt your growth and make you wilt and die. - Plato - (427 - 347 BC) - Greek Philosopher"',
		170		=>	'"We can easily forgive a child who is afraid of the dark; the real tragedy of life is when men are afraid of the light. - Plato - (427 - 347 BC) - Greek Philosopher"',
		171		=>	'"The man who makes everything that leads to happiness depend upon himself, and not upon other men, has adopted the very best place for living happily. - Plato - (427 - 347 BC) - Greek Philosopher"',
		172		=>	'"Never discourage anyone.....who continually makes progress, no matter how slow. - Plato - (427 - 347 BC) - Greek Philosopher"',
		173		=>	'"Where there is love there is life. - M Gandhi - (1869 - 1948) - Leader of India"',
		174		=>	'"A \'No\' uttered from the deepest conviction is better than a \'Yes\' merely uttered to please or worse, to avoid trouble. - M Gandhi - (1869 - 1948) - Leader of India"',
		175		=>	'"I suppose leadership at one time meant muscles but today it means getting along with people. - M Gandhi - (1869 - 1948) - Leader of India"',
		176		=>	'"Persistent questioning and healthy inquisitiveness are the first requisite for acquiring learning of any kind. - M Gandhi - (1869 - 1948) - Leader of India"',
		177		=>	'"Life is really simple, but we insist on making it complicated. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		178		=>	'"Virtue is not left to stand alone. He who practices it will have it. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		179		=>	'"Only the wisest and stupidest of men never change. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		180		=>	'"Respect yourself and others will respect you. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		181		=>	'"The wheel of fortune turns around incessantly and who can say to himself, \'I shall today be uppermost. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		182		=>	'"Learning without thought is labor, lost thought without learning is perilous. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		183		=>	'"The superior man is modest in his speech, but exceeds in his actions. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		184		=>	'"Ability will never catch up with the demand for it. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		185		=>	'"A fool despises good counsel but a wise man takes it to heart - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		186		=>	'"Our greatest glory is not in never falling, but in rising every time we fall. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		187		=>	'"When it is obvious that the goal cannot be reached, don\'t adjust the goals, adjust the action steps. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		188		=>	'"Silence is a friend who will never betray. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		189		=>	'"A journey of a thousand miles begins with a single step. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		190		=>	'"Be not ashamed of mistakes, and thus make them crimes. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		191		=>	'"When you are laboring for others, let it be with the same zeal as if it were for yourself. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		192		=>	'"Age doesn\'t matter, unless you\'re cheese. - John Paul Getty (1892 - 1976) - American Industrialist"',
		193		=>	'"There are one hundred men seeking security to one able man who is willing to risk his fortune. - John Paul Getty (1892 - 1976) - American Industrialist"',
		194		=>	'"Everything has its beauty, but not everyone sees it. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		195		=>	'"Before you embark on a journey of revenge, dig two graves. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		196		=>	'"When you see a man of worth, think of how you may emulate him. When you see one who is unworthy, examine yourself. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		197		=>	'"Wealth and rank are what men desire, but unless they be obtained in the right way, they may not be possessed. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		198		=>	'"Better a diamond with a flaw, than a pebble without. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		199		=>	'"Success depends upon previous preparation, and without such preparation there is sure to be failure. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		200		=>	'"Ignorance is the night of the mind, but a night without a moon and stars. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		201		=>	'"You cannot open a boot without learning something - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		202		=>	'"If a man takes no thought about what is distant, he will find sorrow near at hand. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		203		=>	'"Forget injuries, never forget kindnesses. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		204		=>	'"What you do not want done to yourself, do not do to others. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		205		=>	'"When anger rises, think of the consequences. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		206		=>	'"The superior man is satisfied and composed, the mean man is always full of distress. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		207		=>	'"Study the past if you would define the future. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		208		=>	'"The man of virtue makes the difficult to be overcome his first business, and success only a subsequent consideration. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		209		=>	'"By three methods we may learn wisdom First, by reflection, which is noblest Second, by imitation, which is easiest and third by experience, which is the bitterest. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		210		=>	'"He who will not economize will have to agonize. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		211		=>	'"They must often change who would be constant in happiness or wisdom. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		212		=>	'"I will not grieve that men do not know me; I will grieve that I do not know men. - Confucius- (551 - 479 BC) - Chinese Philosopher"',
		213		=>	'"Mans natures are alike, it is their habits that carry them far apart. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		214		=>	'"To be able under all circumstance to practice five things constitute perfect virtue; these five thing are gravity, generosity of soul sincerity, earnestness and kindness. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		215		=>	'"It does not matter how slowly you go so long as you do not stop. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		216		=>	'"He who speaks without modesty will fin it difficult to make his words good. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		217		=>	'"To go too far is as bad as to fall short. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		218		=>	'"Choose a job you love, and you will never have to work a day in your life. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		219		=>	'"I hear and I forget. I see and I remember. I do and I understand. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		220		=>	'"Wherever you go, go with all your heart. - Confucius - (551 - 479 BC) - Chinese Philosopher"',
		221		=>	'"Feel kindly toward everyone, but be intimate only with the virtuous. - Confucius -(551 - 479 BC) - Chinese Philosopher"',
		222		=>	'"Everyone thinks of changing the world, but no one thinks of changing himself. - Leo Tolstoy - (1828 - 1910) - Russia"',
		223		=>	'"Change is as inexorable as time yet nothing meets with more resistance. - Benjamin Disraeli - (1804 - 1881) - Canadian MP"',
		224		=>	'"If you don\'t like something, change it, If you can\'t change it, change your attitude. Don\'t complain. - Maya Angelou - (1928 - ) - USA"',
		225		=>	'"The world hates change, yet it is the only thing that has brought progress. - Charles F. Kettering - (1876 - 1958) - American Inventor - USA"',
		226		=>	'"Rather than wishing for change, you first must be prepared to change. - Catherine Pulsifer - Canadian Entrepreneur"',
		227		=>	'"Everyone can think of the one thing that would make life better for them. But people are not so quick to answer the second question: \'What are you doing to make that change come true?\' - Catherine Pulsifer - Canadian Entrepreneur"',
		228		=>	'"If CON is the the opposite of PRO, does that mean that CONgress is the opposite of PROgress. - Don Gallagher - (1946 - ) - USA Comedian"',
		229		=>	'"Since when is \'public safety the root password to the Constitution. - C. D. Tavares - USA"',
		230		=>	'"For every new mouth to feed there are two hands to produce. - Peter T. Bauer - (1915 - )"',
		231		=>	'"Politicians are the same all over. They promise to build a bridge where there is no river. - Nikita Khrushchev - (1894 - 1971) - USSR"',
		232		=>	'"The illegal we do immediately. The unconstitutional takes a bit longer. - Henry Kissinger - (1923 - ) - USA"',
		233		=>	'"No man has ever ruled other men for their own good. - George D. Herron - (1862 - 1925) - USA"',
		234		=>	'"Man is free at the moment he wishes to be. - Voltaire - (1694 - 1778) - France"',
		235		=>	'"The measure of a man\'s real character, is what he would do if he thought he would never be found out. - Lord MacCaully - (1800 - 1859) - England"',
		236		=>	'"Even the tiniest initial deviation from the truth is subsequently multiplied a thousand-fold. - Aristotle - (384 - 322 BC) - Greece"',
		237		=>	'"If you protect a man from their own folly, you you will soon have a nation of fools. - William Penn - (1644 - 1718) - USA"',
		238		=>	'"It\'s not the oath that makes us believe the man, but the man the oath. - Aeschylus - (525 - 456 BC) - GREECE"',
		239		=>	'"The language of Truth is always simple and unadorned. - Ammianus Marcellinus - (4th Century) - Rome"',
		240		=>	'"I want to die peacefully in my sleep like my Grandfather; Not screaming in terror like his passengers. - Jim Larkin - (1875 - 1947) - Dublin, Ireland"',
		241		=>	'"The budget should be balanced, the Treasure should be refilled, public debt should be reduced, the arrogance of officialdom should be tempered and controlled, and the assistance to foreign lands should be curtailed lest Rome become bankrupt. - Cicero - (63 BC - )"',
		242		=>	'"A Lifetime of Happiness: If you desire an hour\'s happiness, take a nap. If you desire a day\'s happiness, go fishing. If you desire a month\'s happiness, get married. If you desire a year\'s happiness, inherit a fortune. If you desire a lifetime\'s happiness, help someone else. - Chinese Proverb - China"',
		243		=>	'"A government with the policy to rob Peter to pay Paul can be assured of the support of Paul. - George Bernard Shaw - (1856 - 1950)"',
		244		=>	'"When you step on a snake or brush against it, its venom can kill you. But a slanderer\'s venom is of another type -- It enters the ears of one person and destroys another. - Sanskrit Verse (Before 1000 BC) - India"',
		245		=>	'"It is often easier for our children to obtain a gun than it is to find a good school - Joycelyn Elder - Maybe that\'s because guns are sold at a profit while schools are provided by the government. - David Boaz Executive VP - Cato Institute - USA"',
		246		=>	'"When buying and selling are controlled by legislation, the first things to be bought and sold are legislators. - P.J. O\'Rourke - (Nov. 14, 1947) - Toledo, Ohio USA"',
		247		=>	'"Just as a flower gives out its fragrance to anyone who cares to approach it and attend to the pleasant odor, so LOVE from within us radiates towards everybody and manifests itself as spontaneous acts of kindness. - Ramdas - (1884 - 1963) - India"',
		248		=>	'"If anyone can demonstrate to me and convince me that I am thinking or acting incorrectly, I will happily change; For I wish to know the truth, which never caused injury to anyone. - Marcus Aurelius - (121 - 180 AD) - Rome"',
		249		=>	'"I would rather live in a society which treated children as adults than one which treated adults as children. - Lizard"',
		250		=>	'"There is no underestimating the intelligence of the American public. - H.L. Mencken"',
		251		=>	'"The whole aim of practical politics is to keep the populace alarmed (and hence clamorous to be led to safety) by menacing it with an endless series of hobgoblins, all of them imaginary. - H.L. Mencken"',
		252		=>	'"Ask yourself whether or not you are happy, and you cease to be so. - John Stuart Mill - (1806 - 1873) - England"',
		253		=>	'"One of the penalties for refusing to participate in politics is that you end up being governed by your inferiors. - Plato - (427 - 348 BC) - Greece"',
		254		=>	'"An election is nothing more than a advanced auction of stolen goods. - Ambrose Bierce - (1842 - 1914) - American Journalist"',
		255		=>	'"Every individual necessarily labors to render the annual revenue of society as great as he can. He generally neither intends to promote the public interest, nor knows how much he is promoting it. He intends only his own gain, and he is, in this, as in many other cases, led by an invisible hand to promote an end which was not part of his intention. - Adam Smith - (June 1723 - July 1790) - Wealth of Nations"',
		256		=>	'"When you come upon a path that brings benefit and happiness to all; Follow this course, just as the mood journeys through the stars. - The Buddha - (563 - 483 BC) - India"',
		257		=>	'"You need only reflect that one of the best ways to get yourself a reputation as a dangerous citizen these days, is to go about repeating the very phrases which our founding fathers used in the struggle for independence. - Charles Austin Beard, Historian"',
		258		=>	'"The conclusion is thus inescapable that the history concept, and wording of the 2nd Amendment to the Constitution of the United States, as well as it\'s interpretation by every major commentator and court in the first half-century after its ratification, indicates that what is protected is an individual right of a private citizen to own and carry firearms in a peaceful manner. - United States Senate - 2nd Session - (Feb 1982) - 97th Congress"',
		259		=>	'"I do not fear computers. I fear the lack of them. - Isaac Asimov - (1920 - 1992) - USA"',
		260		=>	'"Part of the inhumanity of the computer is that, once it is competently programmed and working smoothly, it is completely honest. - Isaac Asimov - (1920 - 1992) - USA"',
		261		=>	'"Computer science is no more about computers, than astronomy is about telescopes. - Edsger Dijkstra - (1930 - 2002) - Holland"',
		262		=>	'"The Internet is not just one thing, it\'s a collection of things - of numerous communications networks that all speak the same digital language. - Jim Clark - American Billionaire"',
		263		=>	'"The digital revolution is far more significant than the invention of writing or even of printing. - Douglas Engelbart - (Jan. 30, 1925) - Inventor of the Computer Mouse"',
		264		=>	'"I think it\'s fair to say that personal computers have become the most empowering tool we\'ve ever created.. They\'re tools of communication, and creativity, and they can be shaped by their user. - Bill Gates - Founder/CEO: Microsoft Inc - USA"',
		265		=>	'"Computers are magnificent tools for the realization of our dreams, but no machine can replace the human spark of spirit, compassion, love, and understanding. - Louis V. Gerstner (B. March 1, 1942) - New York, USA"',
		266		=>	'"The real danger is not that computers will begin to think like men but, that men will begin to think like computers. - Sydney J. Harris"',
		267		=>	'"I think computer viruses should count as life. I think it says something about human nature that the only form of life we have created so far is purely destructive. We\'ve created life in our own image. - Stephen Hawking (Jan. 1942 - ) - British theoretical physicist"',
		268		=>	'"Supercomputers will achieve one human brain capacity by 2010, and personal computers will do so by about 2020. - Ray Kurzweil - (Feb. 12, 1948 - )"',
		269		=>	'"Home computers are being called upon to perform many new functions, including the consumption of homework formerly known as ...It was eaten by the dog. - Doug Larson"',
		270		=>	'"If two friends ask you to judge a dispute, do no accept, because you will lose one friend. On the other hand, if two strangers come to you with the same request; accept! - You will gain one friend. - St. Augustine of Hippo - (354 - 430 AD) - North Africa"',
		271		=>	'"Computing is not about computers any more. It\'s about living. - Nicholas Negroponte - (Dec. 1, 1943 - )"',
		272		=>	'"The good news about computers is that they do what you tell them to do. The \'bad news\' is that they do what you tell them to do. - Ted Nelson (1937 - ) - American sociologist/philosopher"',
		273		=>	'"To err is human - and to blame it on a computer is even more so. - Robert Orben - (Mar. 4, 1927 - ) - American Magician"',
		274		=>	'"People think computers will keep them from making mistakes. They\'re wrong. With computers you make mistakes faster. - (1939 - 2003) - Adam Osborne - American Author/software publisher"',
		275		=>	'"Courage without a conscience is a wild beast. - (1833 - 1899) - Robert C. Ingersoll"',
		276		=>	'"The tiniest deviation from the truth is subsequently multiplied a thousand-fold. - (3854 - 322 BC) - Aristotle"',
		277		=>	'"No one\'s perfect; and we\'re ALL Perfect examples. - Unknown"',
		278		=>	'"Bend like a willow tree, and you will never be uprooted. - Yoshida Kenko - (1283 - c.1351) - Japan"',
		279		=>	'"A wise man will hear council, and grow; He will acknowledge his own ignorance. - King Solomon"',
		280		=>	'"Hasten slowly and soon, you will reach your destination. - Milarepa (1052 - 1135) - Tibet"',
		281		=>	'"A child is counted as wise when she listens to her parents. - King Solomon"',
		282		=>	'"Son: Do not follow a foolish man into his own trouble, he wants the company to witness his own pride and arrogance. He will beat and rob and perhaps kill; but don\'t follow his way. The Trap set for the innocent will always catch the foolish man in his own folly. - King Solomon"',
		283		=>	'"Forgiveness is the FIRST form of Love. - Reinhold Niebuhr (1892 - 1971) - USA"',
		284		=>	'"A \'Thing\' is not necessarily false because it is badly or poorly expressed; nor is a \'Thing\' true because it is expressed magnificently. - Saint Augustine of Hippo (354 - 430) - North Africa"',
		285		=>	'"Patience is the companion of wisdom. - Saint Augustine of Hippo (354 - 430) - North Africa"',
		286		=>	'"No mirror ever became iron; NO bread ever became wheat; No ripened grape ever became sour fruit. Mature yourself and be secure from a change for the worse. - Become the Light - Jalal Ad - (1207 - 1273) - Persia"',
		287		=>	'"A hero is no braver than an ordinary man. But he is braver five minutes longer. - Ralph Waldo Emerson (1803 - 1883) - USA"',
		288		=>	'"A man with noble thoughts is never alone. - Phillip Sidney - (1554 - 1586) - England"',
		289		=>	'"A wise man sees as much as he ought to, not as much as he can. - Michael De Montaigne - (1533 - 1592)"',
		290		=>	'"In my view, whatever is done without display and without the public as a witness, is most praiseworthy Not that the public eye should be entirely avoided; for good actions deserve to be placed in the light. - The greatest theater for virtue is conscience. - Marcus Tillius Cicero - (106 - 43 BC) - Rome"',
		291		=>	'"It is cowardice to perceive what is right, and not do it. - Confucius (551 - 479 BC) - Rome"',
		292		=>	'"The heart of a mother is a deep abyss at the bottom of which you will always find forgiveness. - Honore De Balzac (1799 - 1850) - France"',
		293		=>	'"Candor With Consideration: It is good to be truthful with others, but honesty should be exercised with care and wherever possible using words that are respectful to the person and sensitive to the issue at hand. - Daniel Faradai - (1963 - ) - Canada"',
		294		=>	'"Accomplishing the impossible means only that the boss will add it to your regular duties. - Doug Larson - USA"',
		295		=>	'"Don\'t waste yourself in rejection, nor bark against the bad, but chant the beauty of the good. - Ralph Waldo Emmerson - (1803 - 1882) - USA"',
		296		=>	'"There is not a single true work of art that has not in the end, added to the inner freedom of each person who has known and loved it. - Albert Camus - (1913 - 1969) - France"',
		297		=>	'"What is art? It is the response of man\'s creative SOUL to the call of the real. - Rabindranath Tagore - (1861 - 1941) - India"',
		298		=>	'"Have nothing in your house that you do not know to be useful, or do not believe to be beautiful. - William Morris - (1834 - 1896) - England"',
		299		=>	'"First know who you are, then dress accordingly. - Epictetus - (55 - 135 AD) - Greece"',
		300		=>	'"Work to live, or live to work. - Unknown"',
		301		=>	'"Fear less, hope more; Whine less, breathe more, Talk less, say more; Hate less, love more; And all good things are yours. - Swedish Proverb"',
		302		=>	'"Be faithful in small things; it is in them that you will find your strength. - Mother Teresa  (1910 - 1997) - Macedonia/India"',
		303		=>	'"We make a living by what we get. We make a LIFE by what we give. - Winston Churchill - (1874 - 1965) - England"',
		304		=>	'"Anticipate charity by preventing poverty; help you fellow man who is in reduced circumstances, either with a substantial gift, or a sum of money, or by teaching him a trade, or by finding him some means of employment so that he may earn an honest living and not be obliged to pursue the grim option of begging for charity: This is the highest rung and summit of charity. - Rabbi Moses Ben Maimon - (1135 - 1204) - Spain"',
		305		=>	'"In Charity there is no excess. - Francis Bacon - (1561 - 1626) - England"',
		306		=>	'"If you desire to take from a thing first you must give to it. - Laozi - (6th Century BC) - China"',
		307		=>	'"A heretic is a man who sees with his own eyes. - Gotthold Ephraim Lessing - (1729 - 1781) - Germany"',
		308		=>	'"Life has taught us that love does not consist in gazing at each others beauty, but in looking outward together in the same direction. - Antone De Saint Exupery - (1900 - 1944) - France"',
		309		=>	'"In everyone\'s life, at some time, our inner fire goes out. It\'s then rekindled by an encounter with another human being. - Albert Schweitzer - (1875 - 1965) - France"',
		310		=>	'"Consider how the suffering caused by your anger and grief is often much greater than the suffering cause by the very things for which you are angry and aggrieved. - Marcus Aurelius - (121 - 180) - Rome"',
		311		=>	'"If Passion drives you, then allow Reason to hold the reins. - Benjamin Franklin - (1706 - 1790) - United States of America"',
		312		=>	'"Moderation is the silken string which runs through the Pearl Chain of all virtues. - Bishop Hall - (1574 - 1656) - England"',
		313		=>	'"Complete abstinence is easier than perfect moderation. - Saint Augustine of Hippo (354 - 430) - North Africa"',
		314		=>	'"All men, by their nature, desire knowledge. - Aristotle - (384 - 322 BC) - Greece"',
		315		=>	'"Knowledge is merely brilliance in the organization of ideas. It is not true Wisdom. The truly wise go beyond knowledge. - Confucius - (551 - 479 BC) - China"',
		316		=>	'"Deep in their hearts, most people wish to be understood and to be cherished. - Buddha - (563 - 483 BC) - India"',
		317		=>	'"Make it your habit to listen carefully to what other people say and, as far as possible, be inside the mind of the person speaking. - Marcus Aurelius - (121 - 180) - Rome"',
		318		=>	'"Quarrels would not last long if the fault was only on one side - Francois, Duc De La Rocherfoucauld - (1613 - 1680) - France"',
		319		=>	'"Never stop because you are afraid: You are never so likely to be wrong. - Fridtjof Nansen - (1861 - 1930) - Norway"',
		320		=>	'"Grief is the agony of an instant, the indulgence of Grief is the blunder of a life. - Benjamin Disraeli - (1804 - 1881) - England"',
		321		=>	'"Reject your sense of injury, and the injury itself disappears. - Marcus Aurelius - (121 - 180) - Rome"',
		322		=>	'"Many a man fails to become a good thinker, only for the reason that his memory is too good. - Friedrich Wilhelm Nietzsche - (1844 - 1900) - Germany"',
		323		=>	'"The reality of another person rests not in what she reveals to you, but what she cannot reveal to you Therefore, if you would understand her, listen not to what she says, but rather to what she does not say. - Kahlil Hibran - (1833 - 1931) - Lebanon/USA"',
		324		=>	'"It is one of the most common mistakes; to consider that the limit of our power of perception is also the limit of all there is to perceive. - Charles Webster Leadbeater - (1847 - 1934) - England"',
		325		=>	'"We cannot change anything until we accept it. Condemnation does not liberate: it oppresses. - Carl Gustav Jung - (1875 - 1961) - Switzerland"',
		326		=>	'"What is done for you - allow it to be done. What you must do yourself - make sure you do it. - Ibrahim Ibn Al-Khawwas - (9th Century BC) - Iraq"',
		327		=>	'"To gain serenity we must live in the present, and to do this we need to learn to conquer the destructiveness of the mind, which is constantly reaching forward and backward in time. - Eckhart Tolle - (1948 - ) - Germany"',
		328		=>	'"The secret of health for both mind and body is not to mourn for the past, worry about the future, or anticipate troubles; but to live in the present moment wisely and earnestly. - The Buddha - (563 - 483 BC) - India"',
		329		=>	'"Worry comes from NOT facing unpleasant possibilities. - Bertrand Russell - (1872 - 1970) - England"',
		330		=>	'"We are fools whether we dance or not; So we may as well dance. - Japanese Proverb - Japan"',
		331		=>	'"Woe to the man whose heart has not learned while young to hope, to love - and to put its trust in life. - Joseph Conrad - (1857 - 1924) - USA"',
		332		=>	'"I believe that the first test of a really great man is his humility. I don\'t mean by humility, doubt of his power. But really great men have a curious feeling that the greatness is not of them, but through them. And they see something divine in every other man and are endlessly foolishly, incredibly, merciful. - John Ruskin - (1819 - 1900) - England"',
		333		=>	'"No man is born hating another person... People learn to hate; thus they can be taught to love - for love comes more naturally to the human heart. - Nelson Mandela - (1818 - ?) - South Africa"',
		334		=>	'"Reason can wrestle fear and overthrow it. - Euripides - (480 - 406 BC) - Greece"',
		335		=>	'"Our chief affliction is what we live not according to the light of reason, but after a fashion of others. - Seneca - (4 BC - 65 AD) - Rome"',
		336		=>	'"We should take care not to make the intellect our goal. It has, of course, powerful muscles, but no personality. - Albert Einstein - (1879 - 1955) - Germany/US"',
		337		=>	'"The heart of a man is made to reconcile the most glaring contradiction. - David Hume - (1711 - 1776)"',
		338		=>	'"The urge to conform is strong in most of us, but if society were entirely made up of conformists, life would be very dull. To be genuinely different and original is a gift to be treasured in ourselves and in others. It\'s not easy to be out of step, and not all different ideas are good, but through the ages it is the non-conformists who have stimulated progress. - Pearls of Wisdom - (2008) - USA"',
		339		=>	'"The highest result of education is tolerance. - Helen Keller - (1880 - 1968) - USA"',
		340		=>	'"People get the History they deserve. - Charles De Gaulle - (1890 - 1970) - France"',
		341		=>	'"The Past is a Lighthouse; not a Harbor. - Russia"',
		342		=>	'"When you shut your doors, and it is dark inside, remember never to say that you are alone, because you are not alone, your Guardian Spirit is inside with you. And what need do they have of light. - Epictetus - (55 - 135 AD) - Greece"',
		343		=>	'"Life exists in the universe only because the Carbon atom possesses certain exceptional properties. - James Jeans - (1887 - 1946) - England"',
		344		=>	'"If a man does not keep pace with his companions, perhaps it is because he hears a different drummer. Let him step to the music which he hears, however measured, or far away. - Henry David Thoreau - (1817 - 1862) - USA"',
		345		=>	'"As rain falls equally on the Just and the Unjust; do not burden your heart with judgments, but rain your kindness equally on all Mankind. - The Buddha (563 - 483 BC) - India"',
		346		=>	'"No act of kindness, no matter how small, is ever wasted. - Aesop - (620 - 560 BC) - Greece"',
		347		=>	'"I believe we are free, within limits, and yet there is an unseen hand, a Guiding Light, that drives us on. - Rabindranath Tagore - (1861 - 1941) - India"',
		348		=>	'"If we have listening ears, God speaks to us in our own language; Whatever that language is. - M. Gandhi - (1869 - 1948) - India"',
		349		=>	'"To a generous soul, every task is noble. - Euripides - (480 - 406 BC) - Rome"',
		350		=>	'"True charity occurs only when there are no notions of giving, giver, or gift. - Buddha - (563 - 483 BC) - India"',
		351		=>	'"Every man feels instinctively that all the beautiful sentiments in the world weigh less than a single action of love. - James Russell Lowell - (1819 - 1891) - USA"',
		352		=>	'"When you are good to others, you are best to yourself. - Benjamin Franklin - (1706 - 1790) - USA"',
		353		=>	'"We lie loudest when we lie to ourselves. - Eric Hoffer - (1902-1983) - USA"',
		354		=>	'"We can\'t help everyone, but everyone can help someone - Ronald Reagan - (1911-2004) - USA"',
		355		=>	'"On neither the sun, nor death, can a man look fixedly.- Francois de La Rochefoucauld - (1613-1821) - French"',
		356		=>	'"Life\'s greatest happiness is to be convinced we are loved. - Victor Hugo - (1802-1885) - French"',
		357		=>	'"The art of being wise is the art of knowing what to overlook. - William James - (1842-1910) - USA"',
		358		=>	'"If the education and studies of children were suited to their inclinations and capacities, many would be made useful members of society that otherwise would make no figure in it. - Samuel Richardson - (1689-1761) - English"',
		359		=>	'"Speak softly and carry a big stick; you will go far. - Theodore Roosevelt - (1858-1919) - USA"',
		360		=>	'"The only man who never makes a mistake is the man who never does anything. - Theodore Roosevelt - (1858-1919) - USA"',
		361		=>	'"Opinions are made to be changed - or how is truth to be got at? - Lord Byron - (1788-1824) - British"',
		362		=>	'"Our constitution protects aliens, drunks and U.S. Senators. - Will Rogers - (1879-1935) - USA"',
		363		=>	'"It is like the seed put in the soil - the more one sows, the greater the harvest. - Orison Swett Marden - (1850-1924) - USA "',
		364		=>	'"The way to get on in the world is to be neither more nor less wise, neither better nor worse than your neighbours. - William Hazlitt - (1778-1830) - English "',
		365		=>	'"Lovers have a way of using this word, nothing, which implies exactly the opposite. - Honore De Balzac - (1799-1850) - French"',
		366		=>	'"That is what we are supposed to do when we are at our best - make it all up - but make it up so truly that later it will happen that way. - Ernest Hemingway - (1899-1961) - USA"',
		);
		
	if ($q and int($q) and $q < 367 and $q > 0) 
	{
		$randquote = "Quote #".$q."\n".$quotes{$q};
	} else {
			my $i = int(rand(366)) + 1;
			$randquote = "Quote #".$i."\n".$quotes{$i};
	}
	
	return $randquote;
}
	
	
sub Office_Convert 
{
	my %perltap = @_;
	
	if ($OFFICE{$perltap{office}}{RC} =~ /\S+/) 
	{
		$perltap{rep_center} = $OFFICE{$perltap{office}}{RC};
		$perltap{vn_exchange} = $OFFICE{$perltap{office}}{VNEXCHANGE};
		$perltap{LAM} = $OFFICE{$perltap{office}}{LAM};
		$perltap{exchange} = $OFFICE{$perltap{office}}{EXCHANGE};
		$perltap{town} = $OFFICE{$perltap{office}}{TOWN};
		$perltap{state} = $OFFICE{$perltap{office}}{STATE};
	} else {
		$perltap{rep_center} = $perltap{office};
		$perltap{vn_exchange} = "No Match";
		$perltap{LAM} = "No Match";
		$perltap{exchange} = "No Match";
		$perltap{town} = " ";
		$perltap{state} = " "
	}
		
	return(%perltap);
}
	
	
sub NPA_Convert 
{
	my %perltap = @_;
	my $match = $perltap{npa}.$perltap{nxx};
	
	if ($NPA{$match}{RC} =~ /\S+/) 
	{
		$perltap{rep_center} = $NPA{$match}{RC};
		$perltap{vn_exchange} = $NPA{$match}{VNEX};
		$perltap{LAM} = $NPA{$match}{LAM};
		$perltap{exchange} = $NPA{$match}{EX};
		$perltap{tech_sup} = $NPA{$match}{TS};
		$perltap{offnum} = $NPA{$match}{OFFNUM};
		$perltap{cellnum} = $NPA{$match}{CELLNUM};
	} else {
		$perltap{rep_center} = $perltap{npa}.$perltap{nxx};
		$perltap{vn_exchange} = "No Match";
		$perltap{LAM} = $perltap{npa}.$perltap{nxx};
		$perltap{exchange} = "No Match";
		$perltap{town} = "No Match";
		$perltap{tech_sup} = "void"
	}
		
	return(%perltap);
}

	
1;