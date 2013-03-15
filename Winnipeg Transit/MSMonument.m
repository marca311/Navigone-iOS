//
//  MSMonument.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSMonument.h"
#import "XMLParser.h"

@implementation MSMonument

-(id)initWithElement:(TBXMLElement *)theElement {
    self = [super initWithElement:theElement];
    [self getKey];
    return self;
}

-(void)getKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    NSString *keyNumber = [XMLParser getValueFromElement:keyElement];
    key = [NSString stringWithFormat:@"monuments/%@",keyNumber];
}

@end
