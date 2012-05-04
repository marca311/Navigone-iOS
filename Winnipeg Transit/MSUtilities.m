//
//  MSUtilities.m
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSUtilities.h"

@implementation MSUtilities

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",documentsDirectory]];
    [savedDictionary writeToFile:filePath atomically:YES];
}//saveMutableDictionaryToFile

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",documentsDirectory]];
    [savedDictionary writeToFile:filePath atomically:YES]; 
}//saveDictionaryToFile

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",documentsDirectory]];
    [savedArray writeToFile:filePath atomically:YES];
}//saveMutableArrayToFile

+(void)saveArrayToFile:(NSArray *)savedArray:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",documentsDirectory]];
    [savedArray writeToFile:filePath atomically:YES];
}//saveArrayToFile

+(NSString *)getFirmwareVersion
{
    UIDevice *theDevice = [UIDevice currentDevice];
    NSString *result = [theDevice systemVersion];
    return result;
}//getFirmwareVersion

+(BOOL)firmwareIsHigherThanFour
{
    NSString *firmwareVersion = [self getFirmwareVersion];
    if ([firmwareVersion isEqualToString:@"2.0"]) return NO;
    else if ([firmwareVersion isEqualToString:@"2.0.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"2.0.2"]) return NO; 
    else if ([firmwareVersion isEqualToString:@"2.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"2.2"]) return NO;
    else if ([firmwareVersion isEqualToString:@"2.2.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"3.0"]) return NO;
    else if ([firmwareVersion isEqualToString:@"3.0.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"3.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"3.1.2"]) return NO;
    else if ([firmwareVersion isEqualToString:@"3.1.3"]) return NO;
    else {return YES;}
}//firmwareIsHigherThanFour

@end
