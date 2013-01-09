//
//  _8293calViewController.m
//  293 Calendar
//
//  Created by Victor Engel on 1/3/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import "_8293calViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface _8293calViewController ()
@property NSDate *firstDayOfDisplayedMonth;  //date of the first day in the displayed month
@property NSDate *lastDayOfDisplayedMonth;   //date of the last day in the displayed month
@property NSDate *displayedDate;             //date of the focused day
@property long year;                         //year number for the displayed month
@property int month;                         //month number for the displayed month
@property int day;                           //day number of the focused day in the displayed month
@property int lastDayOfMonth;                //number of days in the displayed month
@property int accumulator;                   //accumulator for the displayed month
@property (strong, nonatomic) UIPopoverController* datePopover;

@end

@implementation _8293calViewController


-(NSDate *)epoch {
   long epoch = 1356048000;
   NSDate *returnValue = [NSDate dateWithTimeIntervalSince1970:epoch];
   return returnValue;
}
-(BOOL)isEquinox:(NSDate *)d
{
   //Return true if it is the equinox
   /*
   BOOL returnValue = NO;
   NSDate *eqDate;
   eqDate = [NSDateComponents ]
   2000-03-20 07:35
   2001-03-20 13:31
   2002-03-20 19:16
   2003-03-21 01:00
   2004-03-20 06:49
   2005-03-20 12:33
   2006-03-20 18:26
   2007-03-21 00:07
   2008-03-20 05:48
   2009-03-20 11:44
   2010-03-20 17:32
   2011-03-20 23:21
   2012-03-20 05:14
   2013-03-20 11:02
   2014-03-20 16:57
   2015-03-20 22:45
   2016-03-20 04:30
   2017-03-20 10:28
   2018-03-20 16:15
   2019-03-20 21:58
   2020-03-20 03:50
    */
   return NO;
}
-(UIView *)calendarDay:(int)d date:(NSDate *)date width:(float)w height:(float)h blank:(BOOL)blankFlag todayIs:(int)today sinceEpoch:(long)daysSinceEpoch
{
   //d is the day number in the month of the 28/293 calendar
   //date is the date of that day.
   UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
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
      //NSLog(@"Width is %f",w);
      dayNumber.font = [UIFont boldSystemFontOfSize:w/8];
      dayNumber.frame = CGRectMake(0,0,w/2,h/5);
      [dayNumber sizeToFit];
      dayNumber.frame = CGRectMake(0,0,dayNumber.frame.size.width,dayNumber.frame.size.height);
      dayNumber.backgroundColor = [UIColor clearColor];
      UILabel *gregDate = [[UILabel alloc] init];
      gregDate.text = [dateFormat stringFromDate:date];
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
- (void)showMonthContainingDate:(NSDate*)d
{
   [self takedown];
   self.displayedDate = d;
   NSLog(@"showMonthContainingDate: self.displayedDate = %@",self.displayedDate);
   NSDate *epoch = [self epoch];
   NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
   NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:epoch];
   NSDate *localEpoch = [NSDate dateWithTimeInterval:-1*currentGMTOffset sinceDate:epoch];
   NSTimeInterval timeSinceLocalEpoch = [d timeIntervalSinceDate:localEpoch];
   double daysSinceLocalEpoch = timeSinceLocalEpoch / 24/60/60;
   long dayNumberToDisplay = floor(daysSinceLocalEpoch);
   int year = 0;
   int month = 0;
   long day = dayNumberToDisplay;
   int dow = (dayNumberToDisplay-2)%7;//epoch is on Friday.
                                      //NSLog(@"Day of the week is %d",dow);
   // One complete cycle is 364*294 days (293 years)
   long daysInCycle = 364*294;
   while (day > daysInCycle) {
      year += 293;
      day -= daysInCycle;
   }
   while (day < 0) {
      year -= 293;
      day += daysInCycle;
   }
   // We now have a day within a 293 year cycle.
   int acc = 0;
   // acc is the accumulator for the month being processed
   int daysInMonth;
   if (acc<28) daysInMonth = 29; else daysInMonth = 28;
   while (day >= daysInMonth) {
      //Update values appropriately for another month to elapse
      //NSLog(@"Acc: %3d Month: %2d Year: %d Day: %ld",acc,month,year,day);
      day -= daysInMonth;
      month++;
      if (month>12) {
         month -= 13;
         year++;
      }
      acc += 28; if (acc>=293) acc -= 293;
      if (acc<28) daysInMonth = 29; else daysInMonth = 28;
   }
   //NSLog(@"Acc: %3d Month: %2d Year: %d Day: %ld",acc,month,year,day);
   //NSLog(@"Year: %d Month: %d Day: %ld Acc: %d MonthLength: %d DOW:%d",year,month,day,acc,daysInMonth,dow);
   //NSLog(@"displayDate:%ld day:%ld month:%d year:%d dow:%d acc:%d gregDate:%@",dayNumberToDisplay,day,month,year,dow,acc,d);
   [self displayDate:dayNumberToDisplay day:day month:month year:year dow:dow acc:acc gregDate:d];
   self.year = year;
   self.month = month;
   self.day = day;
   self.accumulator = acc;
   //NSLog(@"Calling showHEading");
   [self showHeading];
   //Bring date picker to front if it exists
   for (UIDatePicker *datePicker in self.view.subviews) {
      if (datePicker.tag == 999) {
         [self.view bringSubviewToFront:datePicker];
      }
   }
}
-(void)showHeading
{
   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   //
   NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
   [dateFormat setTimeZone:currentTimeZone];
   //
   [dateFormat setDateFormat:@"yyyy"];
   NSLog(@"About to use self.displayedDate: %@",self.displayedDate);
   NSString *gregorianYear = [dateFormat stringFromDate:self.displayedDate];
   NSLog(@"Calculated Gregorian year: %@ from date %@",gregorianYear,self.displayedDate);
   NSString *headingString = [NSString stringWithFormat:@"Year: %ld Month: %d Acc.: %d Greg. Year: %@",self.year,self.month,self.accumulator,gregorianYear];
   UILabel *headingLabel = [[UILabel alloc] init];
   headingLabel.text = headingString;
   headingLabel.font = [UIFont boldSystemFontOfSize:30];
   [headingLabel sizeToFit];
   headingLabel.center = self.view.center;
   headingLabel.center = CGPointMake(self.view.bounds.size.width/2, 50.0);
   if (headingLabel.bounds.size.width > 0.8 * self.view.bounds.size.width) {
      float scale = 0.8 * self.view.bounds.size.width / headingLabel.bounds.size.width;
      headingLabel.font = [UIFont boldSystemFontOfSize:30*scale];
      [headingLabel sizeToFit];
      headingLabel.center = self.view.center;
      NSLog(@"Set center x-coord. to %f",self.view.bounds.size.width/2);
      NSLog(@"Heading width is %f",headingLabel.bounds.size.width);
      headingLabel.center = CGPointMake(self.view.bounds.size.width/2, 50.0);
   }
   [self.view addSubview:headingLabel];
}
-(void)viewWillLayoutSubviews
{
   NSLog(@"viewWillLayoutSubviews");
   NSDate *dayToDisplay = self.displayedDate;
   [self showMonthContainingDate:dayToDisplay];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   NSDate *dayToDisplay = [NSDate date];
   self.displayedDate = dayToDisplay;
   NSLog(@"viewDidLoad self.displayedDate = %@",self.displayedDate);
   //NSLog(@"Calling showMOnthContainingDate from viewWillLayoutSubvuews");
}
- (IBAction)swipeIphone:(UISwipeGestureRecognizer *)sender {
   [self swipe:sender];
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
   //swipe right
   if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
      //NSLog(@"Swipe right");
      //Calculate the new date to display by adding number of days in the current month to the displayed date.
      //[self takedown];
      //NSLog(@"Calculate new date from %d days after %@",-28*86400,self.displayedDate);
      self.displayedDate = [NSDate dateWithTimeInterval:-28*86400 sinceDate:self.displayedDate];
      NSLog(@"swipe Resulting date is %@",self.displayedDate);
      //NSLog(@"Calling showMonthContainingDate from swipe");
      [self showMonthContainingDate:self.displayedDate];
   }
}
- (IBAction)swipeLeftIphone:(UISwipeGestureRecognizer *)sender {
   [self swipeLeft:sender];
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      //iPhone code goes here
   } else  {
      //ipad code goes here
   }
}
- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
   if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
      //NSLog(@"Swipe left");
      //Calculate the new date to display by adding number of days in the current month to the displayed date.
      //[self takedown];
      //NSLog(@"Calculate new date from %d days after %@",self.lastDayOfMonth+1,self.displayedDate);
      self.displayedDate = [NSDate dateWithTimeInterval:(self.lastDayOfMonth+1)*86400 sinceDate:self.displayedDate];
      NSLog(@"swipeLeft Resulting date is %@",self.displayedDate);
      //NSLog(@"Calling showMonthContainingDate from swipeLeft");
      [self showMonthContainingDate:self.displayedDate];
   }
}
-(void)displayDate:(long)date day:(int)d month:(int)m year:(long)year dow:(int)dow acc:(int)acc gregDate:(NSDate *)dayToDisplay
{
   UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 216, 320, 216)];
   [datePicker setDate:[NSDate date]];  //This is the default
   [datePicker setHidden:NO];
   [self.view addSubview:datePicker];

   //Explanation of the arguments.
   /*
    date Number of days since epoch corresponding to day being displayed.
    d    Day number in current month of the day being displayed.
    m    Month number of the month containing the day being displayed.
    year Year number of the day being displayed.
    dow  Day of the week of the day being displayed
    acc  Accumulator for the month
    jdayToDisplay date object containing the date being displayed.
    */
   long offset = 0;
   long sequentialDayNumber ;
   int startOfWeek = d - dow;
   offset = dow;
   //offset is the number of days prior to date represented by startOfWeek.
   //Now find the first day on or before day 0 of the current month
   //NSLog(@"startOfWeek %d offset %ld",startOfWeek, offset);
   while (startOfWeek > 0) {
      startOfWeek -= 7;
      offset += 7;
      //NSLog(@"startOfWeek %d offset %ld",startOfWeek, offset);
   }
   int lastDayOfMonth = 27;
   if (acc<28) lastDayOfMonth = 28;
   self.lastDayOfMonth = lastDayOfMonth;
   NSString *thisWeek = @"";
   float dayWidth, dayHeight;
   if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
      //do portrait work
      dayWidth = self.view.bounds.size.width/7;
      dayHeight = (self.view.bounds.size.height-100)/5;
      NSLog(@"Device is in portrait - w: %f h: %f",self.view.bounds.size.width,self.view.bounds.size.height);
   } else if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
      //do landscape work
      //NSLog(@"Device is in landscape");
      dayWidth = self.view.bounds.size.width/7;
      dayHeight = (self.view.bounds.size.height-100)/5;
      NSLog(@"Device is in landscape - w: %f h: %f",self.view.bounds.size.width,self.view.bounds.size.height);
   }
   //NSLog(@"View bounds are %@",NSStringFromCGRect(self.view.bounds));
   //   float dayWidth = self.view.bounds.size.width/7;
   //   float dayHeight = self.view.bounds.size.height/5;
   //if (dayWidth < dayHeight) dayHeight = dayWidth;
   //if (dayHeight < dayWidth) dayWidth = dayHeight;
   //NSLog(@"Day width and height are %f, %f",dayWidth,dayHeight);
   float yPos = dayHeight/2 + 100;
   NSDate *gregDate;
   do {
      for (int dayno = 0; dayno<7; dayno++) {
         gregDate = [NSDate dateWithTimeInterval:86400*(dayno-offset) sinceDate:dayToDisplay];
         sequentialDayNumber = dayno - offset + date;
         //NSLog(@"###### gregDate is %@ dayno-offset is %ld dayToDisplay is %@",gregDate,dayno-offset,dayToDisplay);
         int calendarDay = dayno + startOfWeek;
         if ((calendarDay < 0)||(calendarDay > lastDayOfMonth)) {
            // blank day
            thisWeek = [thisWeek stringByAppendingString:@"** "];
            //NSLog(@"calendarDay:%d date:%@",calendarDay,gregDate);
            UIView *calendarDayView = [self calendarDay:calendarDay date:gregDate width:dayWidth height:dayHeight blank:YES todayIs:d sinceEpoch:sequentialDayNumber];
            calendarDayView.center = CGPointMake(dayno*dayWidth+dayWidth/2, yPos);
            [self.view addSubview:calendarDayView];
         } else {
            if (calendarDay == 0) {
               self.firstDayOfDisplayedMonth = gregDate;
            } else if (calendarDay == lastDayOfMonth) {
               self.lastDayOfDisplayedMonth = gregDate;
            }
            thisWeek = [thisWeek stringByAppendingString:[NSString stringWithFormat:@"%02d ",calendarDay]];
            UIView *calendarDayView = [self calendarDay:calendarDay date:gregDate width:dayWidth height:dayHeight blank:NO todayIs:d sinceEpoch:sequentialDayNumber];
            calendarDayView.center = CGPointMake(dayno*dayWidth+dayWidth/2, yPos);
            //NSLog(@"Add view centered at (%f,%f) with size (%f,%f)",calendarDayView.center.x,calendarDayView.center.y,calendarDayView.frame.size.width,calendarDayView.frame.size.height);
            //[calendarDayView setBackgroundColor:[UIColor lightGrayColor]];
            [self.view addSubview:calendarDayView];
         }
      }
      yPos += dayHeight;
      offset -= 7;
      //NSLog(@"%@\n",thisWeek);
      thisWeek = @"";
      startOfWeek += 7;
   } while (startOfWeek < 29);
}
//Date picker not in popover (iPhone does not use popovers)
-(void)iphoneSelectADate: (CGPoint)p
{
   //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 216, 320, 216)];
   //[datePicker setDate:[NSDate date]];  //This is the default
   //[datePicker setHidden:NO];
   //[self.view addSubview:datePicker];
   for (UIDatePicker *datePicker in self.view.subviews) {
      if ([datePicker isKindOfClass:[UIDatePicker class]]) {
         [datePicker setHidden:NO];
         [self.view bringSubviewToFront:datePicker];
      }
   }
}

//Date picker in popover
-(void)selectADate: (CGPoint)p
{
   UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
   
   UIView *popoverView = [[UIView alloc] init];   //view
   popoverView.backgroundColor = [UIColor blackColor];
   
   UIDatePicker *datePicker=[[UIDatePicker alloc]init];//Date picker
   datePicker.frame=CGRectMake(0,44,320, 216);
   datePicker.datePickerMode = UIDatePickerModeDate;
   [datePicker setTag:10];
   datePicker.date = self.displayedDate;
   [datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
   [popoverView addSubview:datePicker];
   
   popoverContent.view = popoverView;
   UIPopoverController * popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
   //popoverController.delegate=self;
   self.datePopover = popoverController;
   [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
   CGRect popoverLocation = CGRectMake(p.x-160, p.y-200, 320, 216);
   [popoverController presentPopoverFromRect:popoverLocation inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];//tempButton.frame where you need you can put that frame//
}
- (IBAction)tapIphone:(UITapGestureRecognizer *)sender {
   [self tap:sender];
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
   //tap gesture recognizer
   //Assume the user tapped on a day cell.
   for (UIView *dayCell in self.view.subviews) {
      if (CGRectContainsPoint(dayCell.frame, [sender locationInView:self.view])) {
         //found the cell that was touched.
         //NSLog(@"Found a view containing the touch with coords. %@",NSStringFromCGRect(dayCell.frame));
         for (UIView *insideView in dayCell.subviews) {
            for (UILabel *dayElement in insideView.subviews) {
               //found a subview of the day cell.
               if ([dayElement isKindOfClass:[UILabel class]]) {
                  NSLog(@"Found a subview %@",dayElement.text);
               }
            }
         }
      }
      if ([dayCell isKindOfClass:[UILabel class]]) {
         // This is the heading label.
         UILabel * headingLabel = (UILabel *) dayCell;
         if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:self.view])) {
            NSLog(@"The heading was tapped");
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
               //iPhone code goes here
               [self iphoneSelectADate:[sender locationInView:self.view]];
            } else  {
               [self selectADate:[sender locationInView:self.view]];
            }
            /*CGRect pickerFrame = CGRectMake(0,0,320,216);
            UIDatePicker *myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
            [myPicker addTarget:self action:@selector(pickerChanged:)               forControlEvents:UIControlEventValueChanged];
            myPicker.hidden = NO;
            myPicker.tag = 999;
            [[[headingLabel superview] superview] addSubview:myPicker];
            [[[headingLabel superview] superview] bringSubviewToFront:myPicker];
            */
         }
      }
   }
}
- (void)pickerChanged:(id)sender
{
   NSLog(@"value: %@",[sender date]);
   self.displayedDate = [sender date];
   NSLog(@"Updated date is %@",self.displayedDate);
   [self showMonthContainingDate:[sender date]];
}
-(void)takedown
{
   //remove displayed month
   //NSLog(@"Takedown");
   for (UIView *dayFrame in self.view.subviews) {
      //NSLog(@"   Takedown");
      for (UIView *dayCell in dayFrame.subviews) {
         for (UILabel *label in dayCell.subviews) {
            [label removeFromSuperview];
         }
         [dayCell removeFromSuperview];
      }
      [dayFrame removeFromSuperview];
   }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
