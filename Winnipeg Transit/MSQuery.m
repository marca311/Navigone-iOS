//
//  MSSavedTrip.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSQuery.h"
#import "apiKeys.h"
#import "PlaceViewController.h"
#import "MSUtilities.h"

@implementation MSQuery

-(void)setOrigin:(MSLocation *)input {
    origin = input;
}
-(void)setDestination:(MSLocation *)input {
    destination = input;
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

-(NSString *)getOriginString {
    return [origin getHumanReadable];
}
-(NSString *)getDestinationString {
    return [destination getHumanReadable];
}

//Adds origin and destination entries to Search History
-(void)addEntriesToHistory {
    [PlaceViewController addEntryToFile: origin];
    [PlaceViewController addEntryToFile: destination];
}

-(MSRoute *)getRoute {
    NSString *serverOrigin = [origin getServerQueryable];
    NSString *serverDestination = [destination getServerQueryable];
    NSString *serverTime = [MSUtilities getTimeFormatForServer:date];
    NSString *serverDate = [MSUtilities getDateFormatForServer:date];
    
    /*NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&walk-speed=%@&max-walk-time=%@&min-transfer-wait=%@&max-transfer-wait=%@&max-transfers=%@&api-key=%@",
                           serverOrigin,serverDestination,serverTime,serverDate,mode,easyAccess,walkSpeed,maxWalkTime,minTransferWaitTime,maxTransferWaitTime,maxTransfers,transitAPIKey]; */
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&api-key=%@",
                           serverOrigin,serverDestination,serverTime,serverDate,mode,transitAPIKey];
    NSURL *queryURL = [[NSURL alloc]initWithString:urlString];
    NSLog(urlString);
    NSData *xmlData = [[NSData alloc]initWithContentsOfURL:queryURL];
    //If there is a problem with the results, send back null.
    if ([MSUtilities queryIsError:xmlData]) {
        return NULL;
    }
    [self addEntriesToHistory];
    MSRoute *result = [[MSRoute alloc]initWithData:xmlData];
    return result;
}


@end
