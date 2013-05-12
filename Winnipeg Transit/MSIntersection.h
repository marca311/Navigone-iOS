//
//  MSIntersection.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-03-10.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSLocation.h"

@interface MSIntersection : MSLocation {
    NSString *key;
    NSString *streetKey;
    NSString *streetName;
    NSString *streetType;
    NSString *streetAbbr;
    NSString *crossStreetKey;
    NSString *crossStreetName;
    NSString *crossStreetType;
    NSString *crossStreetAbbr;
}

-(id)initWithElement:(TBXMLElement *)theElement;

-(NSString *)getHumanReadable;
-(NSString *)getServerQueryable;

@end
