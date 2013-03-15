//
//  MSIntersection.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-03-10.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSIntersection.h"
#import "XMLParser.h"

@implementation MSIntersection

-(id)initWithElement:(TBXMLElement *)theElement {
    self = [super initWithElement:theElement];
    [self getKey];
    return self;
}

-(void)getKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    NSString *keyNumber = [XMLParser getValueFromElement:keyElement];
    key = [NSString stringWithFormat:@"intersections/%@",keyNumber];
}

@end
