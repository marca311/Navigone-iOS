//
//  MSLocation.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSLocation.h"
#import "XMLParser.h"

@implementation MSLocation

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setCoordinates];
    [self setUTM];
    [self setHumanReadable];
    converted = TRUE;
    return self;
}

-(void)setName:(NSString *)input {
    name = input;
}
-(void)setKey:(NSString *)input {
    //This is supposed to be blank, and MSLocation doesn't have a key variable, but all its subclasses do.
    //(Except MSStop)
}

-(void)setCoordinates {
    [self setLatitude];
    [self setLongitude];
}
-(void)setLatitude {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" :rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"geographic" :centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"latitude" :centreElement];
    latitude = [XMLParser getValueFromElement:childElement];

}
-(void)setLongitude {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" :rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"geographic" :centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"longitude" :centreElement];
    longitude = [XMLParser getValueFromElement:childElement];
}
-(void)setUTM {
    [self setUtmZone];
    [self setUtmX];
    [self setUtmY];
}
-(void)setUtmZone {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" :rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"utm" :centreElement];
    utmZone = [XMLParser getKnownAttributeData:@"zone" Element:centreElement];
}
-(void)setUtmX {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" :rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"utm" :centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"x" :centreElement];
    utmX = [XMLParser getValueFromElement:childElement];
}
-(void)setUtmY {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" :rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"utm" :centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"y" :centreElement];
    utmY = [XMLParser getValueFromElement:childElement];
}

-(void)setHumanReadable {
    NSString *result = [self getGeoHumanReadable];
    name = result;
}


//Getter methods
-(NSString *)getName {
    return name;
}
-(NSString *)getHumanReadable {
    return name;
}
-(NSString *)getGeoHumanReadable {
    NSString *result = [[NSString alloc]initWithFormat:@"Coordinates: %@, %@", latitude, longitude];
    return result;
}
-(NSString *)getUtmHumanReadable {
    NSString *result = [[NSString alloc]initWithFormat:@"UTM Coordinates: %@, %@", utmX, utmY];
    return result;
}
-(NSString *)getGeoServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"geo/%@,%@", latitude, longitude];
    return result;
}
-(NSString *)getUtmServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"utm/%@,%@", utmX, utmY];
    return result;
}

@end
