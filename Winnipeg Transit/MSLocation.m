//
//  MSLocation.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSLocation.h"
#import "XMLParser.h"
#import "MSUtilities.h"

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
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" RootElement:rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"geographic" RootElement:centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"latitude" RootElement:centreElement];
    latitude = [XMLParser getValueFromElement:childElement];
}
-(void)setLongitude {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" RootElement:rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"geographic" RootElement:centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"longitude" RootElement:centreElement];
    longitude = [XMLParser getValueFromElement:childElement];
}
-(void)setUTM {
    [self setUtmZone];
    [self setUtmX];
    [self setUtmY];
}
-(void)setUtmZone {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" RootElement:rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"utm" RootElement:centreElement];
    utmZone = [XMLParser getKnownAttributeData:@"zone" Element:centreElement];
}
-(void)setUtmX {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" RootElement:rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"utm" RootElement:centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"x" RootElement:centreElement];
    utmX = [XMLParser getValueFromElement:childElement];
}
-(void)setUtmY {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" RootElement:rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"utm" RootElement:centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"y" RootElement:centreElement];
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
-(CLLocationCoordinate2D)getMapCoordinates {
    double latitudeDouble = [latitude doubleValue];
    double longitudeDouble = [longitude doubleValue];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitudeDouble, longitudeDouble);
    return location;
}

#pragma mark - NSCoding section

-(id)initWithCoder:(NSCoder *)aDecoder {
    name = [aDecoder decodeObjectForKey:@"name"];
    latitude = [aDecoder decodeObjectForKey:@"latitude"];
    longitude = [aDecoder decodeObjectForKey:@"longitude"];
    utmZone = [aDecoder decodeObjectForKey:@"utmZone"];
    utmX = [aDecoder decodeObjectForKey:@"utmX"];
    utmY = [aDecoder decodeObjectForKey:@"utmY"];
    converted = [aDecoder decodeBoolForKey:@"converted"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:latitude forKey:@"latitude"];
    [aCoder encodeObject:longitude forKey:@"longitude"];
    [aCoder encodeObject:utmZone forKey:@"utmZone"];
    [aCoder encodeObject:utmX forKey:@"utmX"];
    [aCoder encodeObject:utmY forKey:@"utmY"];
    [aCoder encodeBool:converted forKey:@"converted"];
}

@end
