//
//  MSIntersection.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-03-10.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSIntersection.h"
#import "XMLParser.h"
#import "MSUtilities.h"

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
    [self setHumanReadable];
    return self;
}

-(void)setKey:(NSString *)input {
    NSArray *inputArray = [input componentsSeparatedByString:@"/"];
    key = [inputArray objectAtIndex:1];
    converted = FALSE;
}

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" RootElement:rootElement];
    key = [XMLParser getValueFromElement:keyElement];
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
    if (theElement == NULL) {
        streetType = NULL;
    } else {
        streetType = [XMLParser getValueFromElement:theElement];
    }
}
-(void)setStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"street" RootElement:rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" RootElement:theElement];
    streetAbbr = [XMLParser getKnownAttributeData:@"abbr" Element:theElement];
}
-(void)setCrossStreetName {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" RootElement:rootElement];
    theElement = [XMLParser extractKnownChildElement:@"name" RootElement:theElement];
    crossStreetName = [XMLParser getValueFromElement:theElement];
    //Get rid of street type on the end of the name
    if (crossStreetType != NULL) {
        crossStreetName = [crossStreetName stringByReplacingOccurrencesOfString:crossStreetType withString:@""];
    }
}
-(void)setCrossStreetType {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" RootElement:rootElement];
    //If null, return null, then don't query abbr
    theElement = [XMLParser extractKnownChildElement:@"type" RootElement:theElement];
    if (theElement == NULL) {
        crossStreetType = NULL;
    } else {
        crossStreetType = [XMLParser getValueFromElement:theElement];
    }
}
-(void)setCrossStreetAbbr {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"cross-street" RootElement:rootElement];
    theElement = [XMLParser extractKnownChildElement:@"type" RootElement:theElement];
    crossStreetAbbr = [XMLParser getKnownAttributeData:@"abbr" Element:theElement];
}
-(void)setHumanReadable {
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
    result = [MSUtilities fixAmpersand:result];
    name = result;
}


//Getter methods
-(NSString *)getHumanReadable {
    return name;
}
-(NSString *)getServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"intersections/%@", key];
    return result;
}

#pragma mark - NSCoding section

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    key = [aDecoder decodeObjectForKey:@"key"];
    streetKey = [aDecoder decodeObjectForKey:@"streetKey"];
    streetName = [aDecoder decodeObjectForKey:@"streetName"];
    streetType = [aDecoder decodeObjectForKey:@"streetType"];
    streetAbbr = [aDecoder decodeObjectForKey:@"streetAbbr"];
    crossStreetKey = [aDecoder decodeObjectForKey:@"crossStreetKey"];
    crossStreetName = [aDecoder decodeObjectForKey:@"crossStreetName"];
    crossStreetType = [aDecoder decodeObjectForKey:@"crossStreetType"];
    crossStreetAbbr = [aDecoder decodeObjectForKey:@"crossStreetAbbr"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:key forKey:@"key"];
    [aCoder encodeObject:streetKey forKey:@"streetKey"];
    [aCoder encodeObject:streetName forKey:@"streetName"];
    [aCoder encodeObject:streetType forKey:@"streetType"];
    [aCoder encodeObject:streetAbbr forKey:@"streetAbbr"];
    [aCoder encodeObject:crossStreetKey forKey:@"crossStreetKey"];
    [aCoder encodeObject:crossStreetName forKey:@"crossStreetName"];
    [aCoder encodeObject:crossStreetType forKey:@"crossStreetType"];
    [aCoder encodeObject:crossStreetAbbr forKey:@"crossStreetAbbr"];
}

@end
