//
//  DayView.h
//  293 Calendar
//
//  Created by Victor Engel on 1/9/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayView : UIView
+(DayView *)calendarDay:(int)d date:(NSDate *)date width:(float)w height:(float)h blank:(BOOL)blankFlag todayIs:(int)today sinceEpoch:(long)daysSinceEpoch;
@end
