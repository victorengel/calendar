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
/*-(IBAction)PickerView:(id)sender
{
   pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
   //pickerView.delegate = self;
}*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   NSLog(@"pickerView:numberOfRowsInComponent:");
   return [calPickerData count]; //hard code for now -- will need to calculate per component eventually.
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   NSLog(@"numberOfComponentsInPickerView:");
   return 1; //start out with a 1 component picker for now.
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   NSLog(@"pickerView:didSelectRow:inComponent:");
   //
   NSString *selectedItem = [NSString stringWithFormat:@"%@",[calPickerData objectAtIndex:[calPickerView selectedRowInComponent:0]]];
   NSLog(@"Selected item: %@",selectedItem);
   //
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   NSLog(@"pickerView:titleForRow:forComponent:");
   return [calPickerData objectAtIndex:row];
   NSLog(@"pickerView:titleForRow:");
}
-(NSDate *)epoch {
   NSLog(@"epoch");
   long epoch = 1356048000;
   NSDate *returnValue = [NSDate dateWithTimeIntervalSince1970:epoch];
   return returnValue;
}
- (void)showMonthContainingDate:(NSDate*)d
{
   NSLog(@"showMonthContainingDate");
   [self takedown];//Remove a previously displayed month, if present.
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
   [self displayMonthContainingDate:dayNumberToDisplay day:day month:month year:year dow:dow acc:acc gregDate:d];
   self.year = year;
   self.month = month;
   self.day = day;
   self.accumulator = acc;
   [self showHeading];
}
-(UILabel *)labelFromString:(NSString *)s
{
   NSLog(@"labelFromString");
   UILabel *returnLabel = [[UILabel alloc] init];
   returnLabel.text = s;
   returnLabel.font = [UIFont boldSystemFontOfSize:30];
   [returnLabel sizeToFit];
   return returnLabel;
}
-(void)showHeading
{
   NSLog(@"showHeading");
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
   NSLog(@"viewWillLayoutSubview");
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      //iPhone code goes here
   } else  {
      //ipad code goes here
      NSLog(@"#######viewWillLayoutSubviews");
      NSDate *dayToDisplay = self.displayedDate;
      [self showMonthContainingDate:dayToDisplay];
   }
}
-(void)viewWillAppear:(BOOL)animated
{
   NSLog(@"######viewWillAppear");
   NSDate *dayToDisplay = self.displayedDate;
   [self showMonthContainingDate:dayToDisplay];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   NSLog(@"######willAnimateRotationToInterfaceOrientation");
   NSDate *dayToDisplay = self.displayedDate;
   [self showMonthContainingDate:dayToDisplay];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   calPickerData = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
   NSDate *dayToDisplay = [NSDate date];
   self.displayedDate = dayToDisplay;
}
- (IBAction)swipeIphone:(UISwipeGestureRecognizer *)sender {
   NSLog(@"swipeIphone");
   [self swipe:sender];
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
   NSLog(@"swipe");
   //swipe right
   if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
      self.displayedDate = [NSDate dateWithTimeInterval:-28*86400 sinceDate:self.displayedDate];
      [self showMonthContainingDate:self.displayedDate];
   }
}
- (IBAction)swipeLeftIphone:(UISwipeGestureRecognizer *)sender {
   NSLog(@"swipeLeftIphone");
   [self swipeLeft:sender];
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      //iPhone code goes here
   } else  {
      //ipad code goes here
   }
}
- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
   NSLog(@"swipeLeft");
   if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
      //Calculate the new date to display by adding number of days in the current month to the displayed date.
      self.displayedDate = [NSDate dateWithTimeInterval:(self.lastDayOfMonth+1)*86400 sinceDate:self.displayedDate];
      [self showMonthContainingDate:self.displayedDate];
   }
}
-(CGPoint) getDayCellDimensions {
   NSLog(@"getDayCellDimensions");
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
   NSLog(@"###The calculated cell dimensions are %f,%f",dayWidth,dayHeight);
   return CGPointMake(dayWidth, dayHeight);
}

-(void)displayMonthContainingDate:(long)date day:(int)d month:(int)m year:(long)year dow:(int)dow acc:(int)acc gregDate:(NSDate *)dayToDisplay
{
   NSLog(@"displayMonthContainingDate:day:month:year:dow:acc:gregDate:");
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
   NSLog(@"selectAMonth");
   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      calPickerView.delegate = self;
      calPickerView.dataSource = self;
      calPickerView.showsSelectionIndicator = YES;
      [self.view addSubview:calPickerView];
   } else  {
      UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
      UIView *popoverView = [[UIView alloc] init];   //view
      popoverView.backgroundColor = [UIColor blackColor];
      [popoverView addSubview:calPickerView];
      calPickerView = [[UIPickerView alloc] init];
      calPickerView.delegate = self;
      calPickerView.dataSource = self;
      calPickerView.showsSelectionIndicator = YES;
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
   NSLog(@"selectADate");
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
   NSLog(@"tap:");
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
                  NSLog(@"Found a subview %@",dayElement.text);
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
               NSLog(@"head4 frame is %@",NSStringFromCGRect(headingLabel.frame));
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  NSLog(@"The heading was tapped");
                  tapRequestsDatePicker = YES;
               }
            } else if (headingLabel.tag == 1001) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  NSLog(@"The 28/293 year was tapped");
                  tapRequestsYearPicker = YES;
               }
            } else if (headingLabel.tag == 1002) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  NSLog(@"The 28/293 month was tapped");
                  tapRequestsMonthPicker = YES;
               }
            } else if (headingLabel.tag == 1003) {
               if (CGRectContainsPoint(headingLabel.frame, [sender locationInView:dayCell])) {
                  NSLog(@"The 28/293 accumulator was tapped");
                  tapRequestsAccPicker = YES;
               }
            }
         }
      }
   }
   if (tapRequestsDatePicker) {
      [self selectADate:[sender locationInView:self.view]];
   }
   if (tapRequestsMonthPicker) {
      [self selectAMonth:[sender locationInView:self.view]];
   }
}
- (void)pickerChanged:(id)sender
{
   NSLog(@"pickerChanged:");
   NSLog(@"value: %@",[sender date]);
   self.displayedDate = [sender date];
   NSLog(@"Updated date is %@",self.displayedDate);
   [self showMonthContainingDate:[sender date]];
}
-(void)takedown
{
   //remove displayed month
   NSLog(@"Takedown");
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
   NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
