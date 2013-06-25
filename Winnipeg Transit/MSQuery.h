//
//  MSSavedTrip.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRoute.h"

@interface MSQuery : NSObject <NSCoding> {
    NSString *name;
    MSLocation *origin;
    NSString *originKey;
    MSLocation *destination;
    NSString *destinationKey;
    //Pattern broken :(
    NSDate *date;
    NSString *mode;
    NSString *easyAccess;
    NSString *walkSpeed;
    NSString *maxWalkTime;
    NSString *minTransferWaitTime;
    NSString *maxTransferWaitTime;
    NSString *maxTransfers;
}
//This class stores only querying data and queries the server when prompted, returning an MSRoute

-(void)setOrigin:(MSLocation *)input;
-(void)setDestination:(MSLocation *)input;
-(void)setDate:(NSDate *)input;
-(void)setMode:(NSString *)input;
-(void)setEasyAccess:(NSString *)input;
-(void)setWalkSpeed:(NSString *)input;
-(void)setMaxWalkTime:(NSString *)input;
-(void)setMinTransferWaitTime:(NSString *)input;
-(void)setMaxTransferWaitTime:(NSString *)input;
-(void)setMaxTransfers:(NSString *)input;

-(NSString *)getOriginString;
-(NSString *)getDestinationString;
-(MSRoute *)getRoute;

@end
