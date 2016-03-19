//
//  MSMonument.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSAddress.h"

@interface MSMonument : MSLocation {
    NSString *key;
    NSString *monumentName;
    NSArray *monumentCatagories;
    MSAddress *monumentAddress;
}

-(id)initWithElement:(TBXMLElement *)theElement;

//Method for converting old location format to new
-(void)setKey:(NSString *)input;

-(NSString *)getHumanReadable;
-(NSString *)getServerQueryable;

@end
