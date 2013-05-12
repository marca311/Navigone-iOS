//
//  MSUtilities.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUtilities : NSObject

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary :(NSString *)fileName;

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary :(NSString *)fileName;

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray :(NSString *)fileName;

+(void)saveArrayToFile:(NSArray *)savedArray :(NSString *)fileName;

+(BOOL)fileExists:(NSString *)fileName;

+(NSArray *)getHumanArray;

+(NSDictionary *)loadDictionaryWithName:(NSString *)fileName;

+(NSArray *)loadArrayWithName:(NSString *)fileName;

+(void)generateCacheDB;

+(void)checkCacheAge;

+(void)deleteFileWithName:(NSString *)fileName;

+(NSString *)getFirmwareVersion;

+(BOOL)firmwareIsHigherThanFour;

+(void)presentViewController:(UIViewController *) theViewController withParent:(UIViewController *) parentViewController;

+(BOOL)hasInternet;

+(BOOL)isQueryBlank:(NSString *)query;

+(NSString *)fixAmpersand:(NSString *)ampString;

+(NSDate *)getDateFromServerString:(NSString *)input;

@end
