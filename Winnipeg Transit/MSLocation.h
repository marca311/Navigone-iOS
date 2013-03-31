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

@interface MSLocation : NSObject {
    NSString *latitude;
    NSString *longitude;
    NSString *utmZone;
    NSString *utmX;
    NSString *utmY;
    TBXMLElement *rootElement;
}


-(id)initWithElement:(TBXMLElement *)theElement;

@end