//
//  MSLocation.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class MSLocation;

@interface MSLocation : NSObject <NSCoding> {
    NSString *name;
    NSString *latitude;
    NSString *longitude;
    NSString *utmZone;
    NSString *utmX;
    NSString *utmY;
    TBXMLElement *rootElement;
    //Indicates whether instance uses new format of location storing
    Boolean converted;
}

-(id)initWithElement:(TBXMLElement *)theElement;

-(void)setName:(NSString *)input;
-(void)setKey:(NSString *)input; //Is blank for MSLocation, but not for all subclasses

-(NSString *)getKey; //Is blank for MSLocation, but not for all subclasses
-(NSString *)getName;
-(NSString *)getHumanReadable;
-(NSString *)getGeoHumanReadable;
-(NSString *)getUtmHumanReadable;
-(NSString *)getGeoServerQueryable;
-(NSString *)getUtmServerQueryable;

@end