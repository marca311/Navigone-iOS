//
//  MSLocation.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "MSRoute.h"

@interface MSLocation : NSObject {
    NSString *key;
    NSString *latitude;
    NSString *longitude;
    TBXMLElement *rootElement;
}

-(id)initWithElement:(TBXMLElement *)theElement;

@end
