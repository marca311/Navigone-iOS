//
//  MSStop.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSLocation.h"

@interface MSStop : MSLocation {
    NSString *stopNumber;
    NSString *stopName;
}

-(id)initWithElement:(TBXMLElement *)theElement;

//This method doesn't have a key

-(NSString *)getHumanReadable;
-(NSString *)getServerQueryable;

@end
