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

+(UIDatePicker *)openTimePicker
{
    if ([MSUtilities firmwareIsHigherThanFour] == YES) {
        NSLog(@"Yoos!");
    }
    
        
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"
    
    UIDatePicker *timePicker = [[UIDatePicker alloc]init];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    timePicker.datePickerMode = 2;
    [timePicker setDate:[NSDate date]];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

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
    [formatter setDateFormat:@"ccc, dd MMMM"];
    NSString *result = [formatter stringFromDate:date];
    return result;
}//timeFromNSDate

@end
