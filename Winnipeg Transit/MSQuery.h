//
//  MSSavedTrip.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRoute.h"

@interface MSQuery : NSObject {
    NSString *name;
    NSString *origin;
    NSString *originKey;
    NSString *destination;
    NSString *destinationKey;
    //Pattern broken :(
    NSDate *date;
    NSString *mode;
}
//This class stores only querying data

-(void)setOrigin:(NSString *)input;
-(void)setDestination:(NSString *)input;

@end
