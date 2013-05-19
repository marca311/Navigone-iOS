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

/*
 Additional if statements relating to street types and abbreviations are for streets that don't have a type.
 Primary example being onramps.
*/

-(id)initWithElement:(TBXMLElement *)theElement {
    self = [super initWithElement:theElement];
    [self setKey];
    [self setStreetType];
    if (streetType != NULL) {
        [self setStreetAbbr];
    }
    [self setStreetName];
    
    [self setCrossStreetType];
    if (crossStreetType != NULL) {
        [self setCrossStreetAbbr];
    }
    [self setCrossStreetName];
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
    //Get rid of street type on the end of the name
    if (streetType != NULL) {
        streetName = [streetName stringByReplacingOccurrencesOfString:streetType withString:@""];
    }
}
-(void)setStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    if (theElement == NULL) {
        streetType = NULL;
    } else {
        streetType = [XMLParser getValueFromElement:theElement];
    }
}
-(void)setStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    streetAbbr = [XMLParser getKnownAttributeData:@"abbr" Element:theElement];
}
-(void)setCrossStreetName {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"name" :theElement];
    crossStreetName = [XMLParser getValueFromElement:theElement];
    //Get rid of street type on the end of the name
    if (crossStreetType != NULL) {
        crossStreetName = [crossStreetName stringByReplacingOccurrencesOfString:crossStreetType withString:@""];
    }
}
-(void)setCrossStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" :rootElement];
    //If null, return null, then don't query abbr
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    if (theElement == NULL) {
        crossStreetType = NULL;
    } else {
        crossStreetType = [XMLParser getValueFromElement:theElement];
    }
}
-(void)setCrossStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" :rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" :theElement];
    crossStreetAbbr = [XMLParser getKnownAttributeData:@"abbr" Element:theElement];
}

//Getter methods
-(NSString *)getHumanReadable {
    NSString *fullStreet;
    if (streetType == NULL) {
       fullStreet = [[NSString alloc]initWithFormat:@"%@", streetName];
    } else {
        fullStreet = [[NSString alloc]initWithFormat:@"%@%@", streetName, streetAbbr];
    }
    NSString *fullCrossStreet;
    if (crossStreetType == NULL) {
        fullCrossStreet = [[NSString alloc]initWithFormat:@"%@", crossStreetName];
    } else {
        fullCrossStreet = [[NSString alloc]initWithFormat:@"%@%@", crossStreetName, crossStreetAbbr];
    }
    NSString *result = [[NSString alloc]initWithFormat:@"%@ @ %@", fullStreet, fullCrossStreet];
    return result;
}
-(NSString *)getServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"intersections/%@", key];
    return result;
}

@end
