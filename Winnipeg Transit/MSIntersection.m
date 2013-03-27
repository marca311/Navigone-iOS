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
    [self setKey];
    [self setStreetName];
    [self setStreetType];
    [self setStreetAbbr];
    [self setCrossStreetName];
    [self setCrossStreetType];
    [self setCrossStreetAbbr];
    return self;
}

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    key = [XMLParser getValueFromElement:keyElement];
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
-(void)setCrossStreetName {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"name" :theElement];
    crossStreetName = [XMLParser getValueFromElement:theElement];
}
-(void)setCrossStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    crossStreetType = [XMLParser getValueFromElement:theElement];
}
-(void)setCrossStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    crossStreetAbbr = [XMLParser getKnownAttributeData:@"abbr" :theElement];
}


@end
