//
//  navigoViewLibrary.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-16.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSUtilities.h"

@interface navigoViewLibrary : NSObject

+(UIToolbar *)accessoryView:(UIView *)view;

+(UITextField *)timePickerInputFormat:(UIView *)parentView;

+(UITextField *)datePickerInputFormat:(UIView *)parentView;

+(UIDatePicker *)openTimePicker;

+(UIDatePicker *)openDatePicker;

+(NSString *)timeFromNSDate:(NSDate *)date;

+(NSString *)dateFromNSDate:(NSDate *)date;

+(UIAlertView *)dataMissing;

+(NSArray *)getModeArray;

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1;

+(NSString *)sendTime:(NSArray *)array;

@end
