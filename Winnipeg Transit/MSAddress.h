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
}

-(id)initWithElement:(TBXMLElement *)theElement;

@end
