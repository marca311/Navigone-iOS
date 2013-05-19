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
    [self setStreetType];
    if (streetType != NULL) {
        [self setStreetAbbr];
    }
    [self setStreetName];
    return self;
}

/*
 Extra if statements represent when the street has no type/abbreviation element.
 Examples are: WestGate, Kingsway, etc.
*/

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
    //Get rid of street type on the end of the name
    if (streetType != NULL) {
        streetName = [streetName stringByReplacingOccurrencesOfString:streetType withString:@""];
    }
}
-(void)setStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    if (theElement != NULL) {
        streetType = [XMLParser getValueFromElement:theElement];
    }
}
-(void)setStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    streetAbbr = [XMLParser getKnownAttributeData:@"abbr" Element:theElement];
}

//Getter methods
-(NSString *)getHumanReadable {
    NSString *result;
    if (streetType == NULL) {
        result = [[NSString alloc]initWithFormat:@"%@ %@", houseNumber, streetName];
    } else {
        result = [[NSString alloc]initWithFormat:@"%@ %@%@", houseNumber, streetName, streetAbbr];
    }
    
    return result;
}
-(NSString *)getServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"addresses/%@", key];
    return result;
}

@end
