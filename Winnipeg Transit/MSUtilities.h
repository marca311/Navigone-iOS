//
//  MSUtilities.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUtilities : NSObject

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary FileName:(NSString *)fileName;

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary FileName:(NSString *)fileName;

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray FileName:(NSString *)fileName;

+(void)saveArrayToFile:(NSArray *)savedArray FileName:(NSString *)fileName;

+(BOOL)fileExists:(NSString *)fileName;

+(NSArray *)getHumanArray;

+(NSDictionary *)loadDictionaryWithName:(NSString *)fileName;

+(NSArray *)loadArrayWithName:(NSString *)fileName;

+(void)generateCacheDB;

+(void)checkCacheAge;

+(void)deleteFileWithName:(NSString *)fileName;

+(NSString *)getFirmwareVersion;

+(BOOL)firmwareIsHigherThanFour;

+(BOOL)firmwareIsSevenOrHigher;

+(void)presentViewController:(UIViewController *) theViewController withParent:(UIViewController *) parentViewController;

+(BOOL)hasInternet;

+(BOOL)isQueryBlank:(NSString *)query;

+(NSString *)fixAmpersand:(NSString *)ampString;

+(NSDate *)getDateFromServerString:(NSString *)input;

+(NSString *)getMinutePlural:(int)timeUnit;

+(BOOL)queryIsError:(NSData *)dataFile;

+(void)convertSearchHistory;

+(NSString *)getTimeFormatForServer:(NSDate *)timeObject;

+(NSString *)getDateFormatForServer:(NSDate *)timeObject;

+(UIColor*)defaultSystemTintColor;

@end
