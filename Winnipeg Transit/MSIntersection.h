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
}

-(id)initWithElement:(TBXMLElement *)theElement;

@end
