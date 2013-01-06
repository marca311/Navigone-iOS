//
//  MSUtilities.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSUtilities.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

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

+(NSArray *)getHumanArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"HumanArray.plist"];
    NSArray *result = [[NSArray alloc]initWithContentsOfFile:filePath];
    return result;
}

+(NSDictionary *)loadDictionaryWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileName = [[NSString alloc]initWithFormat:@"%@.plist",fileName];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSDictionary *result = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    return result;
}

+(void)generateCacheDB
{
    NSMutableDictionary *database = [[NSMutableDictionary alloc]init];
    NSFileManager *fileMan = [[NSFileManager alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *folderContents = [fileMan contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (int i = 0; i < [folderContents count]; i++) {
        NSString *currentFile = [folderContents objectAtIndex:i];
        if ([currentFile isEqual:@"CacheDatabase.plist"] || [currentFile isEqualToString:@"HumanArray.plist"] || [currentFile isEqualToString:@"Route1.plist"]) {
            
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
    else if ([firmwareVersion isEqualToString:@"4.0"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.0.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.0.2"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.5"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.6"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.6"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.7"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.8"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.9"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.2.10"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.3"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.3.1"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.3.2"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.3.3"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.3.4"]) return NO;
    else if ([firmwareVersion isEqualToString:@"4.3.5"]) return NO;
    else {return YES;}
}//firmwareIsHigherThanFour

/*
 Connectivity testing code pulled from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 */
+(BOOL)hasInternet
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    return NO;
}

+(BOOL)isQueryBlank:(NSString *)query
{
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([query isEqualToString:@""] || query == nil) {
        return YES;
    } else {
        return NO;
    }
}

@end
