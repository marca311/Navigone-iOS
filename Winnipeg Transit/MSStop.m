//
//  MSStop.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSStop.h"
#import "XMLParser.h"

@implementation MSStop

-(id)initWithElement:(TBXMLElement *)theElement {
    self = [super initWithElement:theElement];
    [self setKey];
    return self;
}

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    key = [XMLParser getValueFromElement:keyElement];

}

@end
