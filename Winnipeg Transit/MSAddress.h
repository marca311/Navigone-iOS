//
//  MSAddress.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSLocation.h"

@interface MSAddress : MSLocation {
    NSString *key;
    NSString *houseNumber;
    NSString *streetName;
    NSString *streetType;
    NSString *streetAbbr;
}

-(id)initWithElement:(TBXMLElement *)theElement;

//Method for converting old location format to new
-(void)setKey:(NSString *)input;

//MSAddress has all these to allow MSMonument to have these locally
-(NSString *)getLatitude;
-(NSString *)getLongitude;
-(NSString *)getUtmZone;
-(NSString *)getUtmX;
-(NSString *)getUtmY;

-(NSString *)getHumanReadable;
-(NSString *)getServerQueryable;

@end
