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

//I have yet to implement either of these

+(UIDatePicker *)openTimePicker;

-(void)openDatePicker;

-(void)dismissTimePicker;

-(void)dismissDatePicker;

+(NSString *)timeFromNSDate:(NSDate *)date;

+(NSString *)dateFromNSDate:(NSDate *)date;

-(IBAction)timePickerChanged:(id)sender;;

@end
