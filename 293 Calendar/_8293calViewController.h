//
//  _8293calViewController.h
//  293 Calendar
//
//  Created by Victor Engel on 1/3/13.
//  Copyright (c) 2013 Victor Engel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _8293calViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>
{
   UIPickerView *calPickerView;
   NSMutableArray *calPickerYearData;
   NSMutableArray *calPickerMonthData;
   NSMutableArray *calPickerAccData;
}
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *pickerData;
//-(IBAction)PickerView:(id)sender;
@end
