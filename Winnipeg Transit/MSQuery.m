//
//  MSSavedTrip.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSQuery.h"
#import "apiKeys.h"

@implementation MSQuery

-(void)setOrigin:(NSString *)input {
    origin = input;
}
-(void)setDestination:(NSString *)input {
    destination = input;
}
-(void)setDate:(NSDate *)input {
    date = input;
}
-(void)setMode:(NSString *)input {
    mode = input;
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

-(MSRoute *)getRoute {
    
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&walk-speed=%@&max-walk-time=%@&min-transfer-wait=%@&max-transfer-wait=%@&api-key=%@",origin,destination,time,date,mode,easyAccess,walkSpeed,maxWalkTime,minTransferWaitTime,maxTransferWaitTime,transitAPIKey];
    NSURL *queryURL = [[NSURL alloc]initWithString:urlString];
    return NULL;
}


@end
