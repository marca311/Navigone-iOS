//
//  navigoViewLibrary.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-16.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "navigoViewLibrary.h"
#import "MSUtilities.h"

@implementation navigoViewLibrary


+(UIToolbar *)accessoryView:(UIView *)view
{
	UIToolbar *pickerBar;
    pickerBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, 44.0f)];
	pickerBar.tintColor = [UIColor darkGrayColor];
	
	NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closePicker:)];
	[items addObject:doneButton];
	pickerBar.items = items;	
	
	return pickerBar;
}//accessoryView

+(UITextField *)timePickerInputFormat:(UIView *)parentView
{
    UITextField *result = [[UITextField alloc]init];
    result.inputView = [self openTimePicker];
    result.inputAccessoryView = [self accessoryView:parentView]; 
}//timePickerInputFormat

+(UITextField *)datePickerInputFormat:(UIView *)parentView
{
    UITextField *result = [[UITextField alloc]init];
    result.inputView = [self openDatePicker];
    result.inputAccessoryView = [self accessoryView:parentView];
}//datePickerInputFormat

+(UIDatePicker *)openTimePicker
{
    if ([MSUtilities firmwareIsHigherThanFour] == YES) {
        UIDatePicker *timePicker = [[UIDatePicker alloc]init];
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        timePicker.datePickerMode = 2;
        
        [timePicker setDate:[NSDate date]];
        
        timePicker.datePickerMode = UIDatePickerModeTime;
        [timePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
}//openTimePicker

+(UIDatePicker *)openDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
}//openDatePicker

+(NSString *)timeFromNSDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *result = [formatter stringFromDate:date];
    return result;
}//timeFromNSDate

+(NSString *)dateFromNSDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"ccc, MMMM dd"];
    NSString *result = [formatter stringFromDate:date];
    return result;
}//timeFromNSDate

@end
