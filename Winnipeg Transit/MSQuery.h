//
//  MSSavedTrip.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRoute.h"

@interface MSQuery : NSObject
//This class stores only querying data

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *originKey;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSString *destinationKey;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *mode;

@end
