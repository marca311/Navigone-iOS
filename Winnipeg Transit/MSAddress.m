//
//  MSAddress.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSAddress.h"
#import "XMLParser.h"

@implementation MSAddress

-(id)initWithElement:(TBXMLElement *)theElement {
    self = [super initWithElement:theElement];
    [self getKey];
    return self;
}

-(void)getKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    NSString *keyNumber = [XMLParser getValueFromElement:keyElement];
    key = [NSString stringWithFormat:@"addresses/%@",keyNumber];
}

@end
