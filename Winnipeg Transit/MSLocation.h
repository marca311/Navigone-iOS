//
//  MSLocation.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface MSLocation : NSObject

@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic)         TBXMLElement *rootElement;

-(id)initWithElement:(TBXMLElement *)theElement;

@end
