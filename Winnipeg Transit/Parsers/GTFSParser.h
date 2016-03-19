//
//  GTFSParser.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/26/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSLocation.h"

@interface GTFSParser : NSObject

+(NSArray *)getLineArrayForRoute:(NSString *)route andOrigin:(MSLocation *)origin andDestination:(MSLocation *)destination;

@end
