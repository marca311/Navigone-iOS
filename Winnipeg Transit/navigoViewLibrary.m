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


//DEPREACIATED FOR NOW WHILE I FIGURE OUT WHY IT ISN'T WORKING


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
    return result;
}//timePickerInputFormat

+(UITextField *)datePickerInputFormat:(UIView *)parentView
{
    UITextField *result = [[UITextField alloc]init];
    result.inputView = [self openDatePicker];
    //result.inputAccessoryView = [self accessoryView:parentView];
    return result;
}//datePickerInputFormat

+(UIDatePicker *)openTimePicker
{
    if ([MSUtilities firmwareIsHigherThanFour] == YES) {
        NSLog(@"Good firmware");
        UIDatePicker *timePicker = [[UIDatePicker alloc]init];
        timePicker.datePickerMode = UIDatePickerModeTime;
        [timePicker setDate:[NSDate date]];
        timePicker.datePickerMode = UIDatePickerModeTime;
        [timePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
        return timePicker;
    }
}//openTimePicker

+(UIDatePicker *)openDatePicker
{
    if ([MSUtilities firmwareIsHigherThanFour] == YES) {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        return datePicker;
    }
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

+(UIAlertView *)dataMissing
{
    UIAlertView *result = [[UIAlertView alloc]initWithTitle:@"You missed something" message:@"It appears that you forgot to fill in one of the fields, nothing can happen until that problem is fixed. Thanks." delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
    return result;
}//dataMissing

+(NSArray *)getModeArray
{
    NSArray *result = [[NSArray alloc]initWithObjects:@"Depart Before", @"Depart After", @"Arrive Before", @"Arrive After", nil];
    return result;
}//getModeArray

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1{
    
    int w = img.size.width;
    
    int h = img.size.height; 
    
    //lon = h - lon;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
    
    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    
    CGContextSelectFont(context, "Arial", 18, kCGEncodingMacRoman);
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    
    
    
    //rotate text
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    
    CGContextShowTextAtPoint(context, 4, 52, text, strlen(text));
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
    
}

+(NSString *)sendPicture:(NSArray *)array
{
    
}//sendPicture

+(NSString *)sendTime:(NSArray *)array
{
    NSString *type = [[NSString alloc]initWithFormat:@"%@",[array objectAtIndex:0]];
    if ([type isEqualToString:@"walk"] || [type isEqualToString:@"transfer"] || [type isEqualToString:@"ride"]) {
        return @"";
    } else {
        return [array objectAtIndex:2];
    }
}//sendTime
/*
+(UIView *)greyOutAndActivity
{
    UIView *grey = [[UIView alloc]initWithFrame:[CGRectMake(0, 0, 25, 25)]]);
    grey.backgroundColor = [UIColor blackColor];
    grey.alpha = 0.5;
    return grey;
}//greyOutAndActivity*/

@end
