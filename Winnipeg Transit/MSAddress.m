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
    [self setKey];
    [self setHouseNumber];
    [self setStreetName];
    [self setStreetType];
    [self setStreetAbbr];
    return self;
}

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    key = [XMLParser getValueFromElement:keyElement];
}

-(void)setHouseNumber {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street-number" :rootElement];
    houseNumber = [XMLParser getValueFromElement:theElement];
}
-(void)setStreetName {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"name" :theElement];
    streetName = [XMLParser getValueFromElement:theElement];
}
-(void)setStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    streetType = [XMLParser getValueFromElement:theElement];
}
-(void)setStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    streetAbbr = [XMLParser getKnownAttributeData:@"abbr" :theElement];
}

@end
