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
