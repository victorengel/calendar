//
//  _8293calViewController.m
//  293 Calendar
//
//  Created by Victor Engel on 1/3/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//
#import "_8293calViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DayView.h"

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
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   if (component==0) {
      return [calPickerYearData count];
   }
   if (component==1) {
      return [calPickerMonthData count];
   }
   if (component==2) {
      return [calPickerAccData count];
   }
   return 0;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 3;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   NSString *selectedItem;
   if (component==0) {
      //Parse out the year from the selected item
      selectedItem = [NSString stringWithFormat:@"%@",[calPickerYearData objectAtIndex:[calPickerView selectedRowInComponent:component]]];
      // We now have a new 28/293 year. Calculate the new date from it.
      long newYear = [selectedItem longLongValue];
      if (newYear > self.year) {
         long elapsedYears = newYear - self.year;
         int acc = self.accumulator;
         long daysForward = 0;
         for (long i=1; i<=elapsedYears; i++) {
            daysForward += 365;
            acc += 71;
            if (acc >=293) {
               acc -= 293;
               daysForward += 1;
            }
         }
         double secondsForward = daysForward * 86400.0;
         NSDate *newDate = [NSDate dateWithTimeInterval:secondsForward sinceDate:self.displayedDate];
         [self showMonthContainingDate:newDate];
      } else if (newYear < self.year)
      {
         long elapsedYears = self.year - newYear;
         int acc = self.accumulator;
         long daysBackward = 0;
         for (long i=1; i<=elapsedYears; i++) {
            daysBackward += 365;
            acc -= 71;
            if (acc < 0) {
               acc += 293;
               daysBackward += 1;
            }
         }
         double secondsForward = -1.0 * daysBackward * 86400.0;
         NSDate *newDate = [NSDate dateWithTimeInterval:secondsForward sinceDate:self.displayedDate];
         [self showMonthContainingDate:newDate];
      }
   }
   if (component==1) {
      selectedItem = [NSString stringWithFormat:@"%@",[calPickerMonthData objectAtIndex:[calPickerView selectedRowInComponent:component]]];
      //Parse out the month from the selected item
      // We now have a new 28/293 month. Calculate the new date from it.
      int newMonth = [selectedItem intValue];
      // Always go forward.
      if (newMonth < self.month) newMonth += 13;
      if (newMonth > self.month) {
         int elapsedMonths = newMonth - self.month;
         int acc = self.accumulator;
         long daysForward = 0;
         for (long i=1; i<=elapsedMonths; i++) {
            daysForward += 28;
            acc += 28;
            if (acc >=293) {
               acc -= 293;
               daysForward += 1;
            }
         }
         double secondsForward = daysForward * 86400.0;
         NSDate *newDate = [NSDate dateWithTimeInterval:secondsForward sinceDate:self.displayedDate];
         [self showMonthContainingDate:newDate];
      }
   }
   if (component==2) {
      selectedItem = [NSString stringWithFormat:@"%@",[calPickerAccData objectAtIndex:[calPickerView selectedRowInComponent:component]]];
      //Parse out the month from the selected item
      // We now have a new 28/293 month. Calculate the new date from it.
      int newAcc = [selectedItem intValue];
      // Always go forward.
      if (newAcc != self.accumulator) {
         //Move forward a year at a time until the target accumulator is found.
         int acc = self.accumulator;
         long daysForward = 0;
         do {
            acc = acc+28;
            daysForward += 28;
            if (acc >=293) {
               acc -= 293;
               daysForward += 1;
            }
         } while (newAcc != acc);
         double secondsForward = daysForward * 86400.0;
         NSDate *newDate = [NSDate dateWithTimeInterval:secondsForward sinceDate:self.displayedDate];
         [self showMonthContainingDate:newDate];
      }
   }
   //   long selectedRow = [pickerView selectedRowInComponent:component];
   //NSString *selectedValue = [calPickerYearData objectAtIndex:selectedRow];
   //NSLog(@"dsr Selected value is %@>>>>>>>>",selectedValue);
   //
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   if (component==0) {
      //long selectedRow = [pickerView selectedRowInComponent:component];
      //      NSString *selectedValue = [calPickerYearData objectAtIndex:selectedRow];
      NSString *selectedYearString = [calPickerYearData objectAtIndex:row];
      if (row > [calPickerYearData count]-3) {
         //nearing the end of the array. Add more values.
         //long selectedRowOffset = selectedRow - row;
         long selectedYear = [[calPickerYearData objectAtIndex:[calPickerYearData count]-1] longLongValue];
         for (int i=0; i<=10; i++) {
            [calPickerYearData addObject:[NSString stringWithFormat:@"%ld",selectedYear+i+1]];
         }
         [calPickerView reloadAllComponents];
      }
      return selectedYearString;
   }
   if (component==1) {
      return [calPickerMonthData objectAtIndex:row];
   }
   if (component==2) {
      return [calPickerAccData objectAtIndex:row];
   }
   return @"";
}
-(NSDate *)epoch {
   long epoch = 1356048000;
   NSDate *returnValue = [NSDate dateWithTimeIntervalSince1970:epoch];
   return returnValue;
}
- (void)showMonthContainingDate:(NSDate*)d
{
   [self takedown];//Remove a previously displayed month, if present.
   self.displayedDate = d;
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
      day -= daysInMonth;
      month++;
      if (month>12) {
         month -= 13;
         year++;
      }
      acc += 28; if (acc>=293) acc -= 293;
      if (acc<28) daysInMonth = 29; else daysInMonth = 28;
   }
   [self displayMonthContainingDate:dayNumberToDisplay day:day month:month year:year dow:dow acc:acc gregDate:d];
   self.year = year;
   self.month = month;
   self.day = day;
   self.accumulator = acc;
   [self updatePickerArrays];
   [calPickerView reloadAllComponents];
   [self showHeading];
}
-(void)updatePickerArrays
{
   //Populate the picker arrays from the current values for the displayed month
   [calPickerYearData removeAllObjects];
   [calPickerMonthData removeAllObjects];
   [calPickerAccData removeAllObjects];
   int thisAccumulator;
   int thisMonth;
   for (int i=-1209; i<=1209; i++) {
      [calPickerYearData addObject:[NSString stringWithFormat:@"%ld",self.year+i]];
      thisMonth = self.month + i;
      while (thisMonth<0) thisMonth += 13;
      thisMonth = thisMonth % 13;
      [calPickerMonthData addObject:[NSString stringWithFormat:@"%d",thisMonth]];
      thisAccumulator = self.accumulator + i;
      while (thisAccumulator<0) thisAccumulator += 293;
      thisAccumulator = thisAccumulator % 293;
      //if (thisAccumulator>=293) thisAccumulator -= 293;
      [calPickerAccData addObject:[NSString stringWithFormat:@"%d",thisAccumulator]];
   }
   [calPickerView selectRow:1209 inComponent:0 animated:NO];
   [calPickerView selectRow:1209 inComponent:1 animated:NO];
   [calPickerView selectRow:1209 inComponent:2 animated:NO];
}
-(UILabel *)labelFromString:(NSString *)s
{
   UILabel *returnLabel = [[UILabel alloc] init];
   returnLabel.text = s;
   returnLabel.font = [UIFont boldSystemFontOfSize:30];
   [returnLabel sizeToFit];
   return returnLabel;
}
-(void)showHeading
{
   //Separate heading into its components
   //28/293 year
   UILabel *head1Label = [self labelFromString:[NSString stringWithFormat:@"Year: %ld ",self.year]];
   head1Label.tag = 1001;
   //28/293 month
   UILabel *head2Label = [self labelFromString:[NSString stringWithFormat:@"Month: %d ",self.month]];
   head2Label.tag = 1002;
   //28/293 accumulator
   UILabel *head3Label = [self labelFromString:[NSString stringWithFormat:@"Acc.: %d ",self.accumulator]];
   head3Label.tag = 1003;
   //Grogorian year
   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
   [dateFormat setTimeZone:currentTimeZone];
   [dateFormat setDateFormat:@"yyyy"];
   UILabel *head4Label = [self labelFromString:[NSString stringWithFormat:@"Greg. Year: %@",
                                                [dateFormat stringFromDate:self.displayedDate]]];
   head4Label.tag = 1004;
   //Combine the components
   UIView *headingView = [[UIView alloc] init];
   headingView.frame = CGRectMake(0, 0, head1Label.frame.size.width+head2Label.frame.size.width+head3Label.frame.size.width+head4Label.frame.size.width, head1Label.frame.size.height);
   float posX = 0.0;
   head1Label.frame = CGRectMake(0.0, 0.0, head1Label.bounds.size.width, head1Label.bounds.size.height);
   posX = posX + head1Label.frame.size.width * 1.125;//Add a little margin
   head2Label.frame = CGRectMake(posX, 0.0, head2Label.bounds.size.width, head2Label.bounds.size.height);
   posX = posX + head2Label.frame.size.width * 1.125;
   head3Label.frame = CGRectMake(posX, 0.0, head3Label.bounds.size.width, head3Label.bounds.size.height);
   posX = posX + head3Label.frame.size.width * 1.125;
   head4Label.frame = CGRectMake(posX, 0.0, head4Label.bounds.size.width, head4Label.bounds.size.height);
   
   [headingView addSubview:head1Label];
   [headingView addSubview:head2Label];
   [headingView addSubview:head3Label];
   [headingView addSubview:head4Label];
   //resize if necessary
   if (headingView.bounds.size.width > 0.8 * self.view.bounds.size.width) {
      float scale = 0.8 * self.view.bounds.size.width / headingView.bounds.size.width;
      headingView.transform = CGAffineTransformMakeScale(scale, scale);
   }
   headingView.tag = 1000;
   headingView.center = CGPointMake(self.view.bounds.size.width/2, 50.0);
   [self.view addSubview:headingView];
}
-(void)viewWillLayoutSubviews
{
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      //iPhone code goes here
   } else  {
      //ipad code goes here
      NSDate *dayToDisplay = self.displayedDate;
      [self showMonthContainingDate:dayToDisplay];
   }
}
-(void)viewWillAppear:(BOOL)animated
{
   NSDate *dayToDisplay = self.displayedDate;
   [self showMonthContainingDate:dayToDisplay];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   NSDate *dayToDisplay = self.displayedDate;
   [self showMonthContainingDate:dayToDisplay];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   //Start with nil arrays. Intialize them when the month is displayed.
   calPickerYearData = [[NSMutableArray alloc] initWithObjects: nil];
   calPickerMonthData = [[NSMutableArray alloc] initWithObjects: nil];
   calPickerAccData = [[NSMutableArray alloc]initWithObjects: nil];
   NSDate *dayToDisplay = [NSDate date];
   self.displayedDate = dayToDisplay;
}
- (IBAction)swipeIphone:(UISwipeGestureRecognizer *)sender {
   [self swipe:sender];
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
   //swipe right
   if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
      self.displayedDate = [NSDate dateWithTimeInterval:-28*86400 sinceDate:self.displayedDate];
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
      //Calculate the new date to display by adding number of days in the current month to the displayed date.
      self.displayedDate = [NSDate dateWithTimeInterval:(self.lastDayOfMonth+1)*86400 sinceDate:self.displayedDate];
      [self showMonthContainingDate:self.displayedDate];
   }
}
- (IBAction)swipeUp:(UISwipeGestureRecognizer *)sender {
   if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
      //Calculate the new date to display by adding number of days in the current month to the displayed date.
      int daysInYear = 365;
      int revAcc = (293+27-self.accumulator)%293;
      if (revAcc < 71) {
         daysInYear = 366;
      }
      self.displayedDate = [NSDate dateWithTimeInterval:daysInYear*86400 sinceDate:self.displayedDate];
      [self showMonthContainingDate:self.displayedDate];
   }
}
- (IBAction)swipeDown:(UISwipeGestureRecognizer *)sender {
   if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
      //Calculate the new date to display by adding number of days in the current month to the displayed date.
      int daysInYear = -365;
      int revAcc = (self.accumulator-28);
      if (revAcc<0) revAcc += 293;
      if (revAcc < 71) {
         daysInYear = -366;
      }
      self.displayedDate = [NSDate dateWithTimeInterval:daysInYear*86400 sinceDate:self.displayedDate];
      [self showMonthContainingDate:self.displayedDate];
   }
}
-(CGPoint) getDayCellDimensions {
   float dayWidth, dayHeight;     //Calculate size of day cells based on screen size and orientation.
   if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
      //do portrait work
      dayWidth = self.view.bounds.size.width/7;
      dayHeight = (self.view.bounds.size.height-100)/5;
   } else if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
      //do landscape work
      dayWidth = self.view.bounds.size.width/7;
      dayHeight = (self.view.bounds.size.height-100)/5;
   }
   return CGPointMake(dayWidth, dayHeight);
}

-(void)displayMonthContainingDate:(long)date day:(int)d month:(int)m year:(long)year dow:(int)dow acc:(int)acc gregDate:(NSDate *)dayToDisplay
{
   //Display the month in the 28/293 calendar containing date dayToDisplay.
   
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

   long offset = 0;               //offset is the number of days prior to date represented by startOfWeek.
   long sequentialDayNumber ;
   int startOfWeek = d - dow;     //Find the start of the week containing dayToDisplay.
   offset = dow;
                                  //Now find the first day on or before day 0 of the current month
   while (startOfWeek > 0) {
      startOfWeek -= 7;
      offset += 7;
   }
                                  //At this point, startOfWeek is the last Sunday on or before dayToDisplay.
   int lastDayOfMonth = 27;       //Determine last day of month from accumulator.
   if (acc<28) lastDayOfMonth = 28;
   self.lastDayOfMonth = lastDayOfMonth;
   CGPoint dayDimensions = [self getDayCellDimensions];
   float dayWidth = dayDimensions.x;
   float dayHeight = dayDimensions.y;
   float yPos = dayHeight/2 + 100;
   NSDate *gregDate;
   do {
      for (int dayno = 0; dayno<7; dayno++) {
         gregDate = [NSDate dateWithTimeInterval:86400*(dayno-offset) sinceDate:dayToDisplay];
         sequentialDayNumber = dayno - offset + date;
         int calendarDay = dayno + startOfWeek;
         if ((calendarDay < 0)||(calendarDay > lastDayOfMonth)) {
            // blank day
            DayView *calendarDayView = [DayView calendarDay:calendarDay date:gregDate width:dayWidth height:dayHeight blank:YES todayIs:d sinceEpoch:sequentialDayNumber];
            calendarDayView.center = CGPointMake(dayno*dayWidth+dayWidth/2, yPos);
            [self.view addSubview:calendarDayView];
         } else {
            if (calendarDay == 0) {
               self.firstDayOfDisplayedMonth = gregDate;
            } else if (calendarDay == lastDayOfMonth) {
               self.lastDayOfDisplayedMonth = gregDate;
            }
            DayView *calendarDayView = [DayView calendarDay:calendarDay date:gregDate width:dayWidth height:dayHeight blank:NO todayIs:d sinceEpoch:sequentialDayNumber];
            calendarDayView.center = CGPointMake(dayno*dayWidth+dayWidth/2, yPos);
            [self.view addSubview:calendarDayView];
         }
      }
      //Adjust settings for the next week.
      yPos += dayHeight;
      offset -= 7;
      startOfWeek += 7;
   } while (startOfWeek < 29);
}
//Month picker
-(void)selectAMonth: (CGPoint)p
{
   /*Top of selectaDate:
    UIDatePicker *datePicker=[[UIDatePicker alloc]init];//Date picker
    datePicker.frame=CGRectMake(0,44,320, 216);
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setTag:10];
    datePicker.date = self.displayedDate;
    [datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self.view addSubview:datePicker];
    */
   NSLog(@"selectAMonth");
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      calPickerView = [[UIPickerView alloc] init];
      calPickerView.delegate = self;
      calPickerView.dataSource = self;
      calPickerView.showsSelectionIndicator = YES;
      [calPickerView reloadAllComponents];
      [calPickerView selectRow:1209 inComponent:0 animated:NO];
      [calPickerView selectRow:1209 inComponent:1 animated:NO];
      [calPickerView selectRow:1209 inComponent:2 animated:NO];
      [self.view addSubview:calPickerView];
   } else  {
      UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
      UIView *popoverView = [[UIView alloc] init];   //view
      popoverView.backgroundColor = [UIColor blackColor];
      calPickerView = [[UIPickerView alloc] init];
      calPickerView.delegate = self;
      calPickerView.dataSource = self;
      calPickerView.showsSelectionIndicator = YES;
      [calPickerView reloadAllComponents];
      [calPickerView selectRow:1209 inComponent:0 animated:NO];
      [calPickerView selectRow:1209 inComponent:1 animated:NO];
      [calPickerView selectRow:1209 inComponent:2 animated:NO];
      [popoverView addSubview:calPickerView];
      popoverContent.view = popoverView;
      UIPopoverController * popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
      self.datePopover = popoverController;
      [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
      CGRect popoverLocation = CGRectMake(p.x-160, p.y-200, 320, 216);
      [popoverController presentPopoverFromRect:popoverLocation inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];//tempButton.frame where you need you can put that frame//
   }

}
//Date picker in popover
-(void)selectADate: (CGPoint)p
{
   UIDatePicker *datePicker=[[UIDatePicker alloc]init];//Date picker
   datePicker.frame=CGRectMake(0,44,320, 216);
   datePicker.datePickerMode = UIDatePickerModeDate;
   [datePicker setTag:10];
   datePicker.date = self.displayedDate;
   [datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      [self.view addSubview:datePicker];
   } else  {
      UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
      UIView *popoverView = [[UIView alloc] init];   //view
      popoverView.backgroundColor = [UIColor blackColor];
      [popoverView addSubview:datePicker];
      popoverContent.view = popoverView;
      UIPopoverController * popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
      self.datePopover = popoverController;
      [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
      CGRect popoverLocation = CGRectMake(p.x-160, p.y-200, 320, 216);
      [popoverController presentPopoverFromRect:popoverLocation inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];//tempButton.frame where you need you can put that frame//
   }
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
   //First check if a date picker is on screen, in which case dismiss it if tap is outside of date picker
   for (UIDatePicker *datePicker in self.view.superview.subviews) {
      if (datePicker.tag == 10) {
         if ([datePicker isKindOfClass:[UIDatePicker class]]) {
            [datePicker removeFromSuperview];
         }
      }
   }
   //tap gesture recognizer
   //Assume the user tapped on a day cell.
   BOOL tapRequestsDatePicker = NO;
   BOOL tapRequestsYearPicker = NO;
   BOOL tapRequestsMonthPicker = NO;
   BOOL tapRequestsAccPicker = NO;
   for (UIView *dayCell in self.view.subviews) {
      if (CGRectContainsPoint(dayCell.frame, [sender locationInView:self.view])) {
         //found the cell that was touched.
         //NSLog(@"Found a view containing the touch with coords. %@",NSStringFromCGRect(dayCell.frame));
         for (UIView *insideView in dayCell.subviews) {
            for (UILabel *dayElement in insideView.subviews) {
               //found a subview of the day cell.
               if ([dayElement isKindOfClass:[UILabel class]]) {
                  if (dayElement.tag == 1) {
                     //Only one item in this loop will get here since the month is tiled with views with tag 1.
                     int daySelected = [dayElement.text intValue];
                     long daysForward = daySelected - self.day;
                     if (daysForward == 0) {
                        //User tapped date already selected as current date. In this case, let's find the first special day for this month
                        //and day combination.
                        //int monthNumber = self.month;
                        int dayNumber = self.day;
                        int thisAcc = self.accumulator;
                        //int daysToEndOfMonth = 12;
                        int targetAccumulator = 28 - dayNumber; // the "special" anniversary is on a special day, all months containing
                                                                // a special day have a day 28.
                        if (targetAccumulator == thisAcc) {
                           //The day tapped is a special day. Go to the next special day.
                           daysForward = 294;
                        } else {
                           //Make an adjustment depending on whether the special day is before or after the target day in the current month.
                           if (thisAcc<28) {
                              daysForward += 1;
                           }
                           while (targetAccumulator != thisAcc) {
                              thisAcc += 71;
                              daysForward += 365;
                              if (thisAcc >= 293) {
                                 daysForward++;
                                 thisAcc -= 293;
                              }
                           }
                           daysForward--; //Since the day we're landing on is the special day, we don't need to add an extra day for it.
                        }
                        double secondsForward = 86400.0*daysForward;
                        NSDate *newDate = [NSDate dateWithTimeInterval:secondsForward sinceDate:self.displayedDate];
                        self.displayedDate = newDate;
                        [self showMonthContainingDate:newDate];
                        return; //If a day cell was tapped, then a picker was not selected nor was the header tapped, so return.
                     } else {
                        double secondsForward = 86400*daysForward;
                        NSDate *newDate = [NSDate dateWithTimeInterval:secondsForward sinceDate:self.displayedDate];
                        self.displayedDate = newDate;
                        [self showMonthContainingDate:newDate];
                        return; //If a day cell was tapped, then a picker was not selected nor was the header tapped, so return.
                     }
                  }
               }
            }
         }
      }
      //      if ([dayCell isKindOfClass:[UILabel class]]) {
      if (dayCell.tag == 1000) {
         // This is the heading label view.
         // Now check which component of the heading was tapped.
         for (UILabel *headingLabel in dayCell.subviews) {
            if (headingLabel.tag == 1004) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  tapRequestsDatePicker = YES;
               }
            } else if (headingLabel.tag == 1001) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  tapRequestsYearPicker = YES;
               }
            } else if (headingLabel.tag == 1002) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  tapRequestsMonthPicker = YES;
               }
            } else if (headingLabel.tag == 1003) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  tapRequestsAccPicker = YES;
               }
            }
         }
      }
   }
   if (tapRequestsDatePicker) {
      [self selectADate:[sender locationInView:self.view]];
   }
   if (tapRequestsMonthPicker||tapRequestsYearPicker||tapRequestsAccPicker) {
      [self selectAMonth:[sender locationInView:self.view]];
   }
}
- (void)pickerChanged:(id)sender
{
   self.displayedDate = [sender date];
   [self showMonthContainingDate:[sender date]];
}
-(void)takedown
{
   //remove displayed month
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
