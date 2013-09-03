//
//  MSQuery.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSQuery.h"
#import "apiKeys.h"
#import "SearchHistoryViewController.h"
#import "MSUtilities.h"
#import "QueryHistoryViewController.h"

@implementation MSQuery

#pragma mark - NSCoding section
-(id)initWithCoder:(NSCoder *)aDecoder {
    name = [aDecoder decodeObjectForKey:@"name"];
    origin = [aDecoder decodeObjectForKey:@"origin"];
    originKey = [aDecoder decodeObjectForKey:@"originKey"];
    destination = [aDecoder decodeObjectForKey:@"destination"];
    destinationKey = [aDecoder decodeObjectForKey:@"destinationKey"];
    date = [aDecoder decodeObjectForKey:@"date"];
    mode = [aDecoder decodeObjectForKey:@"mode"];
    easyAccess = [aDecoder decodeObjectForKey:@"easyAccess"];
    walkSpeed = [aDecoder decodeObjectForKey:@"walkSpeed"];
    maxWalkTime = [aDecoder decodeObjectForKey:@"maxWalkTime"];
    minTransferWaitTime = [aDecoder decodeObjectForKey:@"minTransferWaitTime"];
    maxTransferWaitTime = [aDecoder decodeObjectForKey:@"maxTransferWaitTime"];
    maxTransfers = [aDecoder decodeObjectForKey:@"maxTransfers"];
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:origin forKey:@"origin"];
    [aCoder encodeObject:originKey forKey:@"originKey"];
    [aCoder encodeObject:destination forKey:@"destination"];
    [aCoder encodeObject:destinationKey forKey:@"destinationKey"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeObject:mode forKey:@"mode"];
    [aCoder encodeObject:easyAccess forKey:@"easyAccess"];
    [aCoder encodeObject:walkSpeed forKey:@"walkSpeed"];
    [aCoder encodeObject:maxWalkTime forKey:@"maxWalkTime"];
    [aCoder encodeObject:minTransferWaitTime forKey:@"minTransferWaitTime"];
    [aCoder encodeObject:maxTransferWaitTime forKey:@"maxTransferWaitTime"];
    [aCoder encodeObject:maxTransfers forKey:@"maxTransfers"];
}

-(void)setNameFromString:(NSString *)input {
    name = input;
}
-(void)setOrigin:(MSLocation *)input {
    origin = input;
    originKey = [origin getServerQueryable];
}
-(void)setDestination:(MSLocation *)input {
    destination = input;
    destinationKey = [destination getServerQueryable];
}
-(void)setDate:(NSDate *)input {
    date = input;
}
-(void)setMode:(NSString *)input {
    NSString *result = [input stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    result = [result lowercaseString];
    mode = result;
}
-(void)setEasyAccess:(NSString *)input {
    easyAccess = input;
}
-(void)setWalkSpeed:(NSString *)input {
    walkSpeed = input;
}
-(void)setMaxWalkTime:(NSString *)input {
    maxWalkTime = input;
}
-(void)setMinTransferWaitTime:(NSString *)input {
    minTransferWaitTime = input;
}
-(void)setMaxTransferWaitTime:(NSString *)input {
    maxTransferWaitTime = input;
}
-(void)setMaxTransfers:(NSString *)input {
    maxTransfers = input;
}
-(void)setName {
    NSString *nameString = [NSString stringWithFormat:@"%@ to %@",[origin getHumanReadable], [destination getHumanReadable]];
    name = nameString;
}

#pragma mark - Getter Methods
-(MSLocation *)getOrigin {
    return origin;
}
-(NSString *)getOriginKey {
    return originKey;
}
-(MSLocation *)getDestination {
    return destination;
}
-(NSString *)getDestinationKey {
    return destinationKey;
}
-(NSString *)getOriginString {
    return [origin getHumanReadable];
}
-(NSString *)getDestinationString {
    return [destination getHumanReadable];
}

//Adds origin and destination entries to Search History and Query History
-(void)addEntriesToHistory {
    [SearchHistoryViewController addEntryToFile: origin];
    [SearchHistoryViewController addEntryToFile: destination];
    [QueryHistoryViewController addEntryToFile:self];
}

-(MSRoute *)getRoute {
    [self setName];
    NSString *serverOrigin = [origin getServerQueryable];
    NSString *serverDestination = [destination getServerQueryable];
    NSString *serverTime = [MSUtilities getTimeFormatForServer:date];
    NSString *serverDate = [MSUtilities getDateFormatForServer:date];
    
    /*NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&walk-speed=%@&max-walk-time=%@&min-transfer-wait=%@&max-transfer-wait=%@&max-transfers=%@&api-key=%@",
                           serverOrigin,serverDestination,serverTime,serverDate,mode,easyAccess,walkSpeed,maxWalkTime,minTransferWaitTime,maxTransferWaitTime,maxTransfers,transitAPIKey]; */
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&api-key=%@",
                           serverOrigin,serverDestination,serverTime,serverDate,mode,transitAPIKey];
    NSURL *queryURL = [[NSURL alloc]initWithString:urlString];
    NSData *xmlData = [[NSData alloc]initWithContentsOfURL:queryURL];
    //If there is a problem with the results, send back null.
    NSLog(urlString);
    if ([MSUtilities queryIsError:xmlData]) {
        return NULL;
    }
    [self addEntriesToHistory];
    MSRoute *result = [[MSRoute alloc]initWithData:xmlData andOrigin:origin andDestination:destination];
    return result;
}

-(NSString *)getHumanReadable {
    return name;
}

#pragma mark - Other Methods

-(void)saveToFile {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"y-MM-dd-hh:mm:ss"];
    NSString *entryTime = [dateFormat stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"QUERY_%@.route",entryTime];
    NSData *route = [NSKeyedArchiver archivedDataWithRootObject:self];
    [route writeToFile:fileName atomically:NO];
}

-(BOOL)isEqualToQuery:(MSQuery *)query {
    NSString *otherOrigin = [query getOriginKey];
    NSString *otherDestination = [query getDestinationKey];
    if ([originKey isEqualToString:otherOrigin] && [destinationKey isEqualToString:otherDestination]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

@end
