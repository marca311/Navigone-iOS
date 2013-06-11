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
#import "XMLParser.h"
#import "MSLocation.h"
#import "MSAddress.h"
#import "MSIntersection.h"
#import "MSMonument.h"

@implementation MSUtilities

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary FileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedDictionary writeToFile:filePath atomically:YES];
}//saveMutableDictionaryToFile

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary FileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedDictionary writeToFile:filePath atomically:YES]; 
}//saveDictionaryToFile

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray FileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedArray writeToFile:filePath atomically:YES];
}//saveMutableArrayToFile

+(void)saveArrayToFile:(NSArray *)savedArray FileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    [savedArray writeToFile:filePath atomically:YES];
}//saveArrayToFile

+(BOOL)fileExists:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileMan = [[NSFileManager alloc]init];
    BOOL result = [fileMan fileExistsAtPath:filePath];
    return result;
}//checkFileExists

+(NSArray *)getHumanArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"HumanArray.plist"];
    NSArray *result = [[NSArray alloc]initWithContentsOfFile:filePath];
    return result;
}

+(NSDictionary *)loadDictionaryWithName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileName = [[NSString alloc]initWithFormat:@"%@.plist",fileName];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSDictionary *result = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    return result;
}

+(NSArray *)loadArrayWithName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileName = [[NSString alloc]initWithFormat:@"%@.plist",fileName];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSArray *result = [[NSArray alloc]initWithContentsOfFile:filePath];
    return result;
}

+(void)generateCacheDB {
    NSMutableArray *database = [[NSMutableArray alloc]init];
    NSFileManager *fileMan = [[NSFileManager alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *folderContents = [fileMan contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (int i = 0; i < [folderContents count]; i++) {
        NSString *currentFile = [folderContents objectAtIndex:i];
        if ([currentFile isEqual:@"CacheDatabase.plist"] || [currentFile isEqualToString:@"HumanArray.plist"] || [currentFile isEqualToString:@"Route1.plist"] || [currentFile isEqualToString:@"SearchHistory.plist"]) {
            
        } else if ([currentFile hasSuffix:@".plist"]) {
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:currentFile];
            NSDictionary *routeFile = [[NSDictionary alloc]initWithContentsOfFile:filePath];
            NSArray *theArray = [[NSArray alloc]initWithObjects:currentFile, [routeFile objectForKey:@"Entry time"], nil];
            [database addObject:theArray];
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

+(void)checkCacheAge {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"CacheDatabase.plist"];
    NSArray *dataBase = [[NSArray alloc]initWithContentsOfFile:dbPath];
    for (int i = 0; i < [dataBase count]; i++) {
        NSArray *currentArray = [dataBase objectAtIndex:i];
        NSDate *currentDate = [currentArray objectAtIndex:1];
        if ([currentDate timeIntervalSinceNow] < -604800) {
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[currentArray objectAtIndex:0]];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    //604800 seconds in a week
    
}//checkCacheAge

+(void)deleteFileWithName:(NSString *)fileName {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:filePath error:nil];
}

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

+(void)presentViewController:(UIViewController *) theViewController withParent:(UIViewController *) parentViewController
{
    if ([MSUtilities firmwareIsHigherThanFour]) {
        //iOS5 and higher only
        [parentViewController presentViewController:theViewController animated:YES completion:NULL];
    } else {
        //All others
        [parentViewController presentModalViewController:theViewController animated:YES];
    }
}

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

+(NSString *)fixAmpersand:(NSString *)ampString
{
    ampString = [ampString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return ampString;
}

+(NSDate *)getDateFromServerString:(NSString *)input {
    input = [input stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *resultStringFormat = [[NSDateFormatter alloc]init];
    [resultStringFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *result;
    result = [resultStringFormat dateFromString:input];
    return result;
}

+(NSString *)getMinutePlural:(int)timeUnit {
    if (timeUnit == 1) return @" minute";
    else return @" minutes";
}

+(BOOL)queryIsError:(NSData *)dataFile
{
    if (dataFile == NULL) {
        return YES;
    }
    TBXML *mainFile = [XMLParser loadXmlDocumentFromData:dataFile];
    TBXMLElement *rootElement = [XMLParser getRootElement:mainFile];
    if ((rootElement = rootElement->firstChild)) {
        return NO;
    } else {
        return YES;
    }
}

+(void)convertSearchHistory {
    if ([MSUtilities fileExists:@"SearchHistory.plist"]) {
        NSDictionary *theDictionary = [MSUtilities loadDictionaryWithName:@"SearchHistory"];
        NSArray *previousLocations = [theDictionary objectForKey:@"PreviousLocations"];
        //If object 0 is of NSArray type
        if ([previousLocations isKindOfClass:[NSArray class]]) {
            NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc]init];
            NSMutableArray *newPreviousLocations = [[NSMutableArray alloc]init];
            NSMutableArray *newSavedLocations = [[NSMutableArray alloc]init];
            //Convert Previous Locations
            for (NSArray *locationArray in previousLocations) {
                MSLocation *newLocation = [MSUtilities getLocationTypeFromKey:[locationArray objectAtIndex:1]];
                //Set new location name
                [newLocation setName:[locationArray objectAtIndex:0]];
                //Set new location key
                [newLocation setKey:[locationArray objectAtIndex:1]];
                [newPreviousLocations addObject:newLocation];
            }
            //Convert MSLocation arrays into NSData files to be stored in the file
            NSData *previous = [NSKeyedArchiver archivedDataWithRootObject:newPreviousLocations];
            [newDictionary setObject:previous forKey:@"PreviousLocations"];
            //Convert Saved Locations
            NSArray *savedLocations = [theDictionary objectForKey:@"SavedLocations"];
            for (NSArray *locationArray in savedLocations) {
                MSLocation *newLocation = [MSUtilities getLocationTypeFromKey:[locationArray objectAtIndex:1]];
                [newLocation setName:[locationArray objectAtIndex:0]];
                [newLocation setKey:[locationArray objectAtIndex:1]];
                [newSavedLocations addObject:newLocation];
            }
            //Same as above, converting MSLocations into NSData for storage
            NSData *saved = [NSKeyedArchiver archivedDataWithRootObject:newSavedLocations];
            [newDictionary setObject:saved forKey:@"SavedLocations"];
            [MSUtilities saveMutableDictionaryToFile:newDictionary FileName:@"SearchHistory"];
        }
    }
}
//Private method to determine what type of location the object is
+(MSLocation *)getLocationTypeFromKey:(NSString *)key {
    NSArray *keyArray = [key componentsSeparatedByString:@"/"];
    NSString *type = [keyArray objectAtIndex:0];
    if ([type isEqualToString:@"addresses"]) return [[MSAddress alloc]init];
    else if ([type isEqualToString:@"monuments"]) return [[MSMonument alloc]init];
    else if ([type isEqualToString:@"intersections"]) return [[MSIntersection alloc]init];
    else return [[MSLocation alloc]init];
}

@end
