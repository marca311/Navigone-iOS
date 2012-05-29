//
//  MSUtilities.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSUtilities.h"

@implementation MSUtilities

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedDictionary writeToFile:filePath atomically:YES];
}//saveMutableDictionaryToFile

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedDictionary writeToFile:filePath atomically:YES]; 
}//saveDictionaryToFile

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedArray writeToFile:filePath atomically:YES];
}//saveMutableArrayToFile

+(void)saveArrayToFile:(NSArray *)savedArray:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedArray writeToFile:filePath atomically:YES];
}//saveArrayToFile

+(void)generateCacheDB
{
    NSMutableDictionary *database = [[NSMutableDictionary alloc]init];
    NSFileManager *fileMan = [[NSFileManager alloc]init];
    int routeNumber = 1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *folderContents = [fileMan contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (int i = 0; i < [folderContents count]; i++) {
        NSString *currentFile = [folderContents objectAtIndex:i];
        if ([currentFile isEqual:@"CacheDatabase.plist"]) {
            
        } else if ([currentFile hasSuffix:@".plist"]) {
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:currentFile];
            NSDictionary *routeFile = [[NSDictionary alloc]initWithContentsOfFile:filePath];
            currentFile = [currentFile stringByReplacingOccurrencesOfString:@".plist" withString:@""];
            [database setObject:[routeFile objectForKey:@"Entry time"] forKey:currentFile];
        }
    }
/*    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Route%i.plist",routeNumber]];
    while ([fileMan fileExistsAtPath:filePath] == YES) {
        NSDictionary *routeFile = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        [database setObject:[routeFile objectForKey:@"Entry time"] forKey:[NSString stringWithFormat:@"Route%i",routeNumber]];
        routeNumber += 1;
        filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Route%i.plist",routeNumber]];
    } */
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"CacheDatabase.plist"];
    [database writeToFile:dbPath atomically:YES];
}//generateCacheDB

+(void)checkCacheAge
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"CacheDatabase.plist"];
    NSDictionary *dataBase = [[NSDictionary alloc]initWithContentsOfFile:dbPath];
}//checkCacheAge

+(void)deleteOldSavedRoutes
{
    
}//deleteOldSavedRoutes

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
