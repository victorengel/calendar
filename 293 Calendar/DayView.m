//
//  DayView.m
//  293 Calendar
//
//  Created by Victor Engel on 1/9/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "DayView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DayView
+(DayView *)calendarDay:(int)d date:(NSDate *)date width:(float)w height:(float)h blank:(BOOL)blankFlag todayIs:(int)today sinceEpoch:(long)daysSinceEpoch
{
   //d is the day number in the month of the 28/293 calendar
   //date is the date of that day.
   DayView *frameView = [[DayView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
   [frameView setBackgroundColor:[UIColor lightGrayColor]];
   w = w*0.99;
   h = h*0.99;
   //daysSinceEpoch is the number of days that "today" is after the epoch. It is a special day if
   //daysSinceEpoch - 28 is a multiple of 294
   //float x = (daysSinceEpoch-28)/294.0;
   //float y = floorf(x);
   BOOL isSpecialDay = (daysSinceEpoch-28)/294.0 == floorf((daysSinceEpoch-28)/294.0);
   CGRect dayRect = CGRectMake(0, 0, w, h);
   NSString *notation = @"";
   UIView *dayToReturn = [[UIView alloc] initWithFrame:dayRect];
   if (blankFlag) {
      //Just make an empty cell.
   } else {
      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
      [dateFormat setDateFormat:@"MM-dd "];
      UILabel *dayNumber = [[UILabel alloc] init];
      dayNumber.text = [NSString stringWithFormat:@" %2d",d];
      dayNumber.tag = 1;//Identify the view containing the day number with tag 1.
      //NSLog(@"Width is %f",w);
      dayNumber.font = [UIFont boldSystemFontOfSize:w/8];
      dayNumber.frame = CGRectMake(0,0,w/2,h/5);
      [dayNumber sizeToFit];
      dayNumber.frame = CGRectMake(0,0,dayNumber.frame.size.width,dayNumber.frame.size.height);
      dayNumber.backgroundColor = [UIColor clearColor];
      UILabel *gregDate = [[UILabel alloc] init];
      gregDate.text = [dateFormat stringFromDate:date];
      gregDate.tag = 2;//Identify the view containing the Gregorian MM-DD with tag 2.
      //if (gregDate.text == @"01-01 ") {
      if ([gregDate.text rangeOfString:@"01-01"].location==0) {
         notation = @"G:New Year";
      }
      if ([gregDate.text rangeOfString:@"12-25"].location==0) {
         notation = @"Christmas";
      }
      if ([gregDate.text rangeOfString:@"02-02"].location==0) {
         notation = @"Groundhog Day";
      }
      if ([gregDate.text rangeOfString:@"02-12"].location==0) {
         notation = @"Lincoln's Birthday";
      }
      if ([gregDate.text rangeOfString:@"02-14"].location==0) {
         notation = @"Valentine's Day";
      }
      if ([gregDate.text rangeOfString:@"03-17"].location==0) {
         notation = @"St. Patrick's Day";
      }
      if ([gregDate.text rangeOfString:@"04-01"].location==0) {
         notation = @"April Fool's Day";
      }
      if ([gregDate.text rangeOfString:@"05-05"].location==0) {
         notation = @"Cinco de Mayo";
      }
      if ([gregDate.text rangeOfString:@"06-14"].location==0) {
         notation = @"Flag Day";
      }
      if ([gregDate.text rangeOfString:@"07-04"].location==0) {
         notation = @"Independence Day";
      }
      if ([gregDate.text rangeOfString:@"10-31"].location==0) {
         notation = @"Halloween";
      }
      gregDate.textAlignment = NSTextAlignmentRight;
      gregDate.frame = CGRectMake(w/2,0,w/2,h/5);
      gregDate.font = [UIFont systemFontOfSize:w/10];
      [gregDate sizeToFit];
      gregDate.frame = CGRectMake(w-gregDate.frame.size.width,0,gregDate.frame.size.width,gregDate.frame.size.height);
      gregDate.backgroundColor = [UIColor clearColor];
      CALayer *gregDateLayer = [gregDate layer];
      [gregDateLayer setBorderColor:[[UIColor whiteColor] CGColor]];
      [gregDateLayer setBorderWidth:0.0];
      [gregDate setTextColor:[UIColor blackColor]];
      if (isSpecialDay) {
         //Special Day
         notation = @"Special Day";
         [dayToReturn setBackgroundColor:[UIColor greenColor]];
         if (d==today) {
            //Today
            [dayToReturn setBackgroundColor:[UIColor yellowColor]];
         }
      } else {
         [dayToReturn setBackgroundColor:[UIColor whiteColor]];
         if (d==today) {
            //Today
            [dayToReturn setBackgroundColor:[UIColor redColor]];
         }
      }
      //dayNumber.center = CGPointMake(dayToReturn.bounds.size.width/4, dayToReturn.bounds.size.height/4);
      //gregDate.center = CGPointMake(dayToReturn.bounds.size.width*3/4, dayToReturn.bounds.size.height/4);
      //dayNumber.center = CGPointMake(w/4 ,h/4);
      //gregDate.center = CGPointMake(w*3/4,h/4);
      //Add notation to the day.
      if (notation != @"") {
         UILabel *notationLabel = [[UILabel alloc] init];
         notationLabel.text = notation;
         notationLabel.tag = 3;//Identify the view containing textual information with tag 3.
         notationLabel.font = [UIFont systemFontOfSize:w/9];
         [notationLabel sizeToFit];
         notationLabel.center = dayToReturn.center;
         //specialDayNotation.frame.origin.y = dayToReturn.bounds.size.height - specialDayNotation.frame.size.height;
         notationLabel.center = CGPointMake(notationLabel.center.x,dayToReturn.frame.size.height - notationLabel.frame.size.height);
         notationLabel.backgroundColor = [UIColor clearColor];
         //If notation is too big, reduce the size
         if (notationLabel.frame.size.width > dayToReturn.bounds.size.width) {
            //Scale the view
            CGSize labelSize = CGSizeMake(dayToReturn.bounds.size.width, dayToReturn.bounds.size.height);
            [notationLabel sizeThatFits:labelSize];
         }
         [dayToReturn addSubview:notationLabel];
      }
      
      [dayToReturn addSubview:dayNumber];
      [dayToReturn addSubview:gregDate];
      //[self.view addSubview:dayNumber];
      //[self.view addSubview:dayToReturn];
   }
   [frameView addSubview:dayToReturn];
   dayToReturn.center = frameView.center;
   return frameView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

/*
 Following is the .js code from http://the-light.com/cal/28293.js
 
 var moffset = new Array(0,-8,-15,-19,-20,-16,-9,0,9,16,20,19,15,0);
 var yoffset = new Array(0,4,7,8,7,4,0,-4,-7,-8,-7,-4,0);
 var meanmonth = 1447/49;
 var eln,fumno,fmo,yr,yac,ymo,baseacc,fadj,yadj,newacc,actime,DyTm,DN,err = 0;
 var yln,fumno2,fmo2,yr2,yac2,ymo2,baseacc2,fadj2,yadj2,newacc2,actime2,DyTm2,DN2,yrr = 0;
 function calculatenewmoontime(passed_date) {
 var lunarepoch = new Date(1890,0,21);
 lpassed_date = new Date();
 lunarepoch.setTime(lunarepoch.getTime() - lunarepoch.getTimezoneOffset()*60000);	//Lunar epoch is in UT
 lpassed_date.setTime(passed_date.getTime());
 lpassed_date.setHours(0,0,0,0);	//*First move to midnight, then adjust to UT
 lpassed_date.setTime(lpassed_date.getTime() - lpassed_date.getTimezoneOffset()*60000);
 timesinceepoch = lpassed_date.getTime() - lunarepoch;
 meanlunations = timesinceepoch/((meanmonth)*millisecsperday);
 eln = Math.floor(meanlunations);
 //* eln is the lunation occurring before lpassed_date -- eln+1 would be the next lunation.
 //If there is any lunation at all in the rendered month, it will be one of these two
 eln ++;
 yln = eln + 1;
 fumno = (Math.floor((eln - 13)%251/14)+18)%18;	fumno2 = (Math.floor((yln - 13)%251/14)+18)%18;
 fmo = (((251+eln-7)%251)+8)%14;									fmo2 = (((251+yln-7)%251)+8)%14;
 yr = Math.floor((eln+13)*19/235)+1889;					yr2 = Math.floor((yln+13)*19/235)+1889;
 yac = (13+eln*19)%235;													yac2 = (13+yln*19)%235;
 ymo = Math.floor(yac/19);												ymo2 = Math.floor(yac2/19);
 err = Math.floor(eln/850)*-1;										yrr = Math.floor(yln/850)*-1;
 baseacc = (eln*26+err)%49;											baseacc2 = (yln*26+err)%49;
 fadj = moffset[fmo];														fadj2 = moffset[fmo2];
 yadj = yoffset[ymo];														yadj2 = yoffset[ymo2];
 newacc = baseacc+fadj+yadj;											newacc2 = baseacc2+fadj2+yadj2;
 actime = newacc%49;															actime2 = newacc2%49;
 DyTm = Math.floor(meanmonth*eln) + newacc/49;		DyTm2 = Math.floor(meanmonth*yln) + newacc2/49;
 DN = Math.floor(DyTm);													DN2 = Math.floor(DyTm2);
 elndate = new Date();
 elndate.setTime(lunarepoch.getTime()+DyTm*millisecsperday);
 elnmidnight = new Date(0);
 elnmidnight.setTime(elndate.getTime());
 elnmidnight.setUTCHours(0,0,0,0);
 intHours = elndate.getUTCHours();
 if (intHours<10) {fmtime = "0"+intHours+":"} else {fmtime = intHours+":"}
 intMinutes = elndate.getUTCMinutes();
 if (intMinutes<10) {fmtime = fmtime + "0"+intMinutes+":"} else {fmtime = fmtime + intMinutes+":"}
 intSeconds = elndate.getUTCSeconds();
 if (intSeconds<10) {fmtime = fmtime + "0"+intSeconds} else {fmtime = fmtime + intSeconds}
 fmtime = fmtime + "&nbsp;UT<br>Cy.F.Y.Ac=<br> " + fumno + "." + fmo + "." + ymo + "." + baseacc;
 return fmtime;
 }
 function specialday() {
 //* This function displays an explanation for SPECIAL DAY
 specialexpWin = window.open('', 'specialexp', 'dependent=yes, width=400, height=300, titlebar=no, scrollbars, resizable');
 specialexpWin.document.clear();
 specialexptext = '<html><body><b>Special Day</b> occurs once every 294 days. A special day always occurs in a leap month. One could think of these special days as leap days, rather than placing the leap day always at the end of the month. The Special Day always occurs the number of days from the end of the month indicated by the accumulator. The accumulator is a measure of how many days have elapsed from the last special day to the last day of the month.';
 specialexptext = specialexptext + '</body></html>';
 specialexpWin.document.write(specialexptext);
 specialexpWin.document.close();
 }
 function newmoon(passed_datestr) {
 passed_date = new Date(passed_datestr);
 resetvariables = calculatenewmoontime(passed_date);
 //* This function displays an explanation for how newmoon is calculated
 newmoonexpWin = window.open('', 'newmoonexp', 'dependent=yes, width=900, height=600, titlebar=no, scrollbars, resizable');
 newmoonexpWin.document.clear();
 dc = '<html>'
 dc = dc + '<body>New moon is calculated using integer arithmetic as described below. Here is a listing of the current values of the variables used, a brief description, formula for deriving values for next lunation, and the values for next lunation.<br>';
 dc = dc + '<table border=1>';
 dc = dc + '<tr><td><b>Variable</b><td><b>Current Value</b><td><b>Description</b><td><b>Calculation (to get value for next ELN)</b><td><b>Next Value</b>';
 dc = dc + '<tr><td>ELN<td>'+eln+'<td>Engel Lunation Number -- Epoch is midnight UT 21 January 1890. Value is 0 at epoch.<td>+ 1<td>'+yln;
 dc = dc + '<tr><td>FMo<td>' + fmo+'<td>Number of month within the fumocy.<td>+ 1 mod 14<td>'+fmo2;
 dc = dc + '<tr><td>Fum<td>' + fumno+'<td>Number of the fumocy within the current 251 month cycle.<td>If next Fmo &lt; current Fmo then increment mod 18<td>'+fumno2;
 dc = dc + '<tr><td>YAcc<td>' + yac+'<td>Accumulator used to reckon the year based upon the lunation number. A simple ratio of 19 years/235 months (the Metonic Cycle ratio) is used here.<td>+19 mod 235<td>'+yac2;
 dc = dc + '<tr><td>YMo<td>' + ymo+'<td>Lunar Month within the year.<td>+ 1 (but resets to 0 when YAcc exceeds limit<td>'+ymo2;
 dc = dc + '<tr><td>Year<td>' + yr+'<td>Gregorian year number (boundaries of year are slightly different than in the Gregorian calendar because of the choice of epoch)<td>Increments when Ymo turns 0<td>'+yr2;
 dc = dc + '<tr><td>Acc<td>' + baseacc +'<td>Main accumulator used to track the mean lunar month of 29 26/49 days.<td>+ 26 mod 49<td>'+baseacc2;
 dc = dc + '<tr><td>Fadj<td>' + fadj +'<td>Adjustment to apply to Acc based upon value of Fmo<td>Lookup Fmo<font size=-1>th</font> value of 0, -8, -15, -19, -20, -16, -9, 0, 9, 16, 20, 19, 15, 0<td>'+fadj2;
 dc = dc + '<tr><td>Yadj<td>' + yadj +'<td>Adjustment to apply to Acc based upon value of YMo<td>Lookup Ymo<font size=-1>th</font> value of 0, 4, 7, 8, 7, 4, 0, -4, -7, -8, -7, -4<td>'+yadj2;
 dc = dc + '<tr><td>AccAdj<td>' + newacc +'<td>Adjusted accumulator<td>Acc+Fadj+Yadj<td>'+newacc2;
 dc = dc + '<tr><td>Time<td>' + actime +'<td>This is the time of day of the lunation expressed in 49th days<td>AddAdj mod 49<td>'+actime2;
 dc = dc + '<tr><td>Day#<td>' + DN +'<td>Day# since epoch<td>+30 if next Time &lt; Time -- +29 if next Time &gt; Time<td>'+DN2;
 dc = dc + '<tr><td>DayTime<td>' + DyTm +'<td>This is the fractional number of days since epoch<td>Day# + Time<td>'+DyTm2;
 dc = dc + '<tr><td>Err<td>' + err +'<td>Accumulated error since epoch.<td>For the current example, floor(ELN/850) is used.<td>'+yrr;
 dc = dc + '</table>';
 dc = dc + '</ul>';
 dc = dc + '<b>Definitions</b><br>';
 dc = dc + '<table><tr valign=top><td align=top>Lunation<td><font size=-1>Time it takes the moon to orbit the earth once, relative to the position of the sun. This corresponds to the cycle of the phases of the moon that we are used to.</font>';
 dc = dc + '<tr valign=top><td><a href="http://www.wikipedia.org/wiki/Fumocy">Fumocy</a><td><font size=-1>Short of FUll MOon CYcle. This is the beat period between the <a href="http://www.wikipedia.org/wiki/Synodic_month">synodic month</a> and the <a href="http://www.wikipedia.org/wiki/Anomalistic_month">anomalistic month</a> and is approximately 411.78 days.</font>';
 dc = dc + '<tr valign=top><td>Accumulator<td><font size=-1>An accumulator is a way to approximate a rational number using integers. For some rational number, N/M, increment a variable by M mod N for each step in the sequence. The result is a cycle that decreases in value, on average, every N/M steps.</font>';
 dc = dc + '<tr valign=top><td>Year<td><font size=-1>For the purposes of these calculations, the tropical year (relevant to our seasons) and anomalistic year (needed for the yearly adjustments, above) are both approximated using the Metonic Cycle ratio. </font>';
 newmoonexpWin.document.write(dc);
 newmoonexpWin.document.close();
 }
 function DecimaltoAnother(A, radix) {
 var hex = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
 s = "";
 while (A >= radix) {
 s += hex[A % radix];  // remainder
 A = Math.floor(A / radix); // quotient, rounded down
 }
 s = hex[A]+s;
 return s;
 }
 function DisplayDay(sequential,gregorian,comment,cellheight,cellwidth) {
 daystring='';
 if (cellheight==10) {
 daystring = daystring+'<font size="-2">'+gregorian+'</font><br>';
 daystring = daystring+sequential;
 } else {
 daystring = daystring+('<div height='+cellheight+'>');
 daystring = daystring+('<table border=0>');
 daystring = daystring+('<tr valign="top" height='+(cellheight-10)+'>');
 daystring = daystring+('<td><font size="-2">'+comment+'</font></td>');
 daystring = daystring+('<tr valign="bottom" height=10>');
 daystring = daystring+('<td align="left" width='+(cellwidth-10)+'><font size="-2">'+gregorian+'</font></td>');
 daystring = daystring+('<td align="right" width=10><b>'+sequential+'</b></td>');
 daystring = daystring+('</table>');
 daystring = daystring+('</div>');
 }
 return daystring
 }
 function DisplayCalendar(passed_date,showtoday,cellheight,cellwidth) {
 //* Calculate MMDDYY values for today
 mm = 0;
 dd = 0;
 yy = 0;
 seq = 0;
 utdaystart = new Date();
 utdayend = new Date();
 millisecsperday = 24*60*60*1000;
 step = 0-millisecsperday;
 var current  = (passed_date.getTime()-1356048000000)-(passed_date.getTimezoneOffset()*60000)+1;
 if (current>0) {
 positive=1; negative=0;
 step = millisecsperday;
 } else {
 positive=0; negative=1;
 step = 0-millisecsperday;
 }
 var leapday = 0;
 debugstring = "";
 if (positive == 1) {
 leapday = 28; //* Year 0 has a leap day
 for (var timeiter = 0;timeiter + 1000*60*60*3 <= current;timeiter = timeiter + step) {
 dd += 1;
 seq += 1;
 if (dd > leapday) {
 accum = accum + 28;
 mm++;
 leapday = 27;
 dd = 0;
 if (mm == 13) {
 mm = 0;
 yy++;
 }
 if (accum >= 293) {
 accum = accum - 293;
 leapday = 28;
 }
 }
 }
 } else {
 for (var timeiter = 0; timeiter >= current; timeiter = timeiter + step) {
 if (leapday==1) {
 leapday=0;
 }
 dd -= 1;
 seq -= 1;
 if (dd < 0) {
 accum = accum-28;
 if (accum < 0) {
 accum = accum + 293;
 }
 if (accum < 28) {
 leapday = 1;
 }
 if (leapday == 1) {
 dd = 28;
 } else {
 dd = 27;
 }
 mm = mm - 1;
 if (mm == -1) {
 mm = 12;
 yy = yy - 1;
 }
 }
 }
 }
 //* Now seq should be the number of days since date 0
 dd should be the date within the month
 Now adjust seq so that it points to the beginning of the month
 if (positive == 1) {seq = seq - dd;}
 else {seq = seq - dd;}
 passed_date.setTime(passed_date.getTime()-(dd*millisecsperday));
 dispstr=calculatenewmoontime(passed_date)
 calday = 0;
 if (positive == 1) {
 dow = (seq+5)%7;
 } else {
 dow = 6+(seq-1)%7;
 }
 //* Now dow should be the day of the week of the first day in the current month
 cs=cs+('<div align=center>');
 cs=cs+('<table border=1 cellspacing=0>');
 cs=cs+('<TR ><TD COLSPAN=7 ALIGN="center" BGCOLOR="#999999">');
 cs=cs+('<FONT SIZE="+1">Month:');
 cs=cs+('<b><font color="#000066">'+mm+'</font></b>&nbsp;&nbsp;&nbsp;Year:');
 cs=cs+('<b><font color="#000066">'+yy+'</font></b>&nbsp;&nbsp;&nbsp;Accum:');
 cs=cs+('<b><font color="#000066">'+(accum)+'</font></B></FONT></TD></TR>');
 if (cellheight==10) {
 chs='';
 cs=cs+('<TR><TD width=40 BGCOLOR="#CCCCCC" align="center">Sun');
 cs=cs+('<TD width=40 BGCOLOR="#CCCCCC" align="center">Mon');
 cs=cs+('<TD width=40 BGCOLOR="#CCCCCC" align="center">Tue');
 cs=cs+('<TD width=40 BGCOLOR="#CCCCCC" align="center">Wed');
 cs=cs+('<TD width=40 BGCOLOR="#CCCCCC" align="center">Thu');
 cs=cs+('<TD width=40 BGCOLOR="#CCCCCC" align="center">Fri');
 cs=cs+('<TD width=40 BGCOLOR="#CCCCCC" align="center">Sat</tr>\n');
 } else {
 chs='height='+cellheight;
 cs=cs+('<TR><TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Sunday');
 cs=cs+('<TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Monday');
 cs=cs+('<TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Tuesday');
 cs=cs+('<TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Wednesday');
 cs=cs+('<TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Thursday');
 cs=cs+('<TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Friday');
 cs=cs+('<TD width='+cellwidth+' BGCOLOR="#CCCCCC" align="center">Saturday</tr>\n');
 }
 cs=cs+('<tr '+chs+'>');
 for (var i=0;i<dow;i++) {
 cs=cs+('<td></td>');
 }
 finished=0;
 if (accum<28) {
 maxday=28;
 } else {
 maxday=27;
 }
 for (var i=0;i<=maxday;i++) {
 if (i==dd & showtoday==1) {
 colorspec = 'bgcolor="#ff0000"';
 if ((28-accum == i)&(i>0)) {
 colorspec = 'bgcolor="#ffff00"';
 }
 
 } else {
 colorspec = '';
 cm = DecimaltoAnother((255 - 6*passed_date.getMonth()),16);
 cd = DecimaltoAnother((255 - 3*passed_date.getDate()),16);
 cy = DecimaltoAnother((255 - passed_date.getFullYear()%100),16);
 colorspec = 'bgcolor="#'+cm+cd+cy+'"';
 if ((28-accum == i)&(i>0)) {
 colorspec = 'bgcolor="#00ff00"';
 }
 }
 cs=cs+('<td '+colorspec+'>');
 if (cellheight==10) {
 breaks = '<br><br><br><br><br>';
 } else {
 breaks = ''
 };
 comment = breaks;
 if (positive == 1) {
 dow = (seq+5)%7;
 } else {
 dow = 6+(seq-1)%7;
 }
 if (cellheight!=10) {
 if (i==28) {
 comment = 'Leapday'+breaks;
 }
 if (passed_date.getMonth()==0) {
 if (passed_date.getDate()==1) comment='Gregorian New Year\'s Day'+breaks;
 }
 if ((mm==0)&(i==0)) {
 comment='New Year\'s Day'+breaks;
 }
 if (passed_date.getMonth()==10) {
 if (dow==4) {
 if ((passed_date.getDate()>=22)&(passed_date.getDate()<=28)) {
 comment='Thanksgiving'+breaks;
 }
 }
 if (dow==2) {
 if ((passed_date.getDate()<=8)&(passed_date.getDate()>1)) {
 comment='Election Day'+breaks;
 }
 }
 }
 if (passed_date.getMonth()==9) {
 if (passed_date.getDate()==31) comment='Halloween'+breaks;
 }
 if (passed_date.getMonth()==11) {
 if (passed_date.getDate()==25) comment='Christmas'+breaks;
 }
 utdaystart.setTime(passed_date.getTime());
 utdaystart.setHours(0,0,0,0);
 utdaystart.setTime(utdaystart.getTime() - utdaystart.getTimezoneOffset()*60000);
 utdayend.setTime(utdaystart.getTime() + millisecsperday);
 if (utdaystart.getTime() <= elnmidnight.getTime()) {
 if (utdayend.getTime() > elnmidnight.getTime()) {
 passed_datestr = "'"+passed_date+"'";
 jstest="if(window.name=='parent'){newmoon("+passed_datestr+")}else{opener.newmoon("+passed_datestr+")}"
 if (comment=="") {
 comment= '<a href="javascript:'+jstest+'">New Moon</a>: '+fmtime
 } else {
 comment = comment+"<br>"+'<a href="javascript:'+jstest+'">New Moon</a>: d'+fmtime
 }
 }
 }
 if ((28-accum == i)&(i>0)) {
 jstest="if(window.name=='parent'){specialday()}else{opener.specialday()}"
 comment = '<a href="javascript:'+jstest+'">SPECIAL DAY</a>';
 }
 }
 ds=DisplayDay(i,(passed_date.getMonth()+1)+'/'+passed_date.getDate(),comment,cellheight,cellwidth);
 cs=cs+ds;
 if (dow==6) {
 cs=cs+('</tr>\n');
 if (i<maxday) {
 cs=cs+('<tr '+chs+'>');
 }
 }
 seq++;
 passed_date.setTime(passed_date.getTime()+millisecsperday);
 }
 if (dow!=6) {
 cs=cs+('</tr>\n');
 }
 cs=cs+('</table>');
 cs=cs+('</div>');
 return dd;
 }
 function RenderCalendar() {
 var millisecsperday = 24*60*60*1000;
 accum = 0;
 calDate = new Date(document.forms[0].elements(0).value+' 02:00:00'); // Specify 2:00 AM to avoid daylight savings problems
 newWin = window.open('', 'cal', 'dependent=yes, width=900, height=700, titlebar=no, scrollbars, resizable');
 newWin.window.name = "child"
 cs='<HTML><BODY>';
 dd=DisplayCalendar(calDate,1,90,110);
 newWin.document.clear();
 newWin.document.write(cs+"</BODY></HTML>");
 newWin.document.close();
 }
 function RenderYearlyCalendar() {
 var millisecsperday = 24*60*60*1000;
 accum = 0;
 calDate = new Date(document.forms[1].elements(0).value+' 02:00:00');
 passdate = calDate.getTime();
 newWin = window.open('', 'cal', 'dependent=yes, width=350, height=700, titlebar=no, scrollbars, resizable');
 cs='';
 for (var monthi=0; monthi<13; monthi++) {
 dd=DisplayCalendar(calDate,0,10,10);
 if (dd<15) {
 passdate=passdate+((29)*millisecsperday);
 calDate.setTime(passdate);
 } else {
 passdate=passdate+((15)*millisecsperday);
 calDate.setTime(passdate);
 }
 accum = 0;
 }
 newWin.document.clear();
 newWin.document.write(cs);
 newWin.document.close();
 }
 */
