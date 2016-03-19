//
//  MSAddress.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSAddress.h"
#import "XMLParser.h"
#import "MSUtilities.h"

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
    [self setHumanReadable];
    return self;
}

-(void)setKey:(NSString *)input {
    NSArray *inputArray = [input componentsSeparatedByString:@"/"];
    key = [inputArray objectAtIndex:1];
    converted = FALSE;
}

/*
 Extra if statements represent when the street has no type/abbreviation element.
 Examples are: WestGate, Kingsway, etc.
*/

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" RootElement:rootElement];
    key = [XMLParser getValueFromElement:keyElement];
}

-(void)setHouseNumber {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street-number" RootElement:rootElement];
    houseNumber = [XMLParser getValueFromElement:theElement];
}
-(void)setStreetName {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" RootElement:rootElement];
    theElement = [XMLParser extractKnownChildElement:@"name" RootElement:theElement];
    streetName = [XMLParser getValueFromElement:theElement];
    //Get rid of street type on the end of the name
    if (streetType != NULL) {
        streetName = [streetName stringByReplacingOccurrencesOfString:streetType withString:@""];
    }
}
-(void)setStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" RootElement:rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" RootElement:theElement];
    if (theElement != NULL) {
        streetType = [XMLParser getValueFromElement:theElement];
    }
}
-(void)setStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" RootElement:rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" RootElement:theElement];
    streetAbbr = [XMLParser getKnownAttributeData:@"abbr" Element:theElement];
}
-(void)setHumanReadable {
    NSString *result;
    if (streetType == NULL) {
        result = [[NSString alloc]initWithFormat:@"%@ %@", houseNumber, streetName];
    } else {
        result = [[NSString alloc]initWithFormat:@"%@ %@%@", houseNumber, streetName, streetAbbr];
    }
    result = [MSUtilities fixAmpersand:result];
    name = result;
}

//Getter methods
-(NSString *)getLatitude {
    return latitude;
}
-(NSString *)getLongitude {
    return longitude;
}
-(NSString *)getUtmZone {
    return utmZone;
}
-(NSString *)getUtmX {
    return utmX;
}
-(NSString *)getUtmY {
    return utmY;
}

-(NSString *)getHumanReadable {
    return name;
}
-(NSString *)getServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"addresses/%@", key];
    return result;
}

#pragma mark - NSCoding section

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    key = [aDecoder decodeObjectForKey:@"key"];
    houseNumber = [aDecoder decodeObjectForKey:@"houseNumber"];
    streetName = [aDecoder decodeObjectForKey:@"streetName"];
    streetType = [aDecoder decodeObjectForKey:@"streetType"];
    streetAbbr = [aDecoder decodeObjectForKey:@"streetAbbr"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:key forKey:@"key"];
    [aCoder encodeObject:houseNumber forKey:@"houseNumber"];
    [aCoder encodeObject:streetName forKey:@"streetName"];
    [aCoder encodeObject:streetType forKey:@"streetType"];
    [aCoder encodeObject:streetAbbr forKey:@"streetAbbr"];
}

@end
