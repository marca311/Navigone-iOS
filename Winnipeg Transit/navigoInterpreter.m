//
//  navigoInterpreter.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-07.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "navigoInterpreter.h"
#import "XMLParser.h"

@implementation navigoInterpreter

+(NSString *)getAPIKey {
    NSString *result = [[NSString alloc]initWithString:@"VzHTwXmEnjQ0vUG0U3y9"];
    return result;
}

//Need to add failsafe for when url comes up without and xml

+(NSData *)getXMLFileForSearchedItem:(NSString *)query
{
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(query);
    query = [NSString stringWithFormat: @"http://api.winnipegtransit.com/locations:%@?api-key=%@", query, [navigoInterpreter getAPIKey]];
    NSLog(query);
    NSURL *checkURL = [[NSURL alloc]initWithString:query];
    NSData *resultXMLFile = [[NSData alloc]initWithContentsOfURL:checkURL];
    if ([resultXMLFile ) {
        <#statements#>
    }
    return resultXMLFile;
}//getXMLFileForSearchedItem

+(NSString *)getAddressKeyFromSearchedItem:(NSString *)searchedItem
{
    NSData *data = [[NSData alloc]initWithData:[self getXMLFileForSearchedItem:searchedItem]];
    TBXML *theFile = [XMLParser loadXmlDocumentFromData:data];
    TBXMLElement *theElement = [XMLParser getRootElement:theFile];
    TBXMLElement *theElementChild = [XMLParser getUnknownChildElement:theElement];
    NSString *locationType = [[NSString alloc]initWithFormat:@"%@",[self getLocationTypeFromSearchedItem:theElementChild]];
    theElementChild = [XMLParser extractElementFromParent:@"key" :theElementChild];
    NSString *result = [XMLParser extractAttributeTextFromElement:theElementChild];
    if ([locationType isEqualToString:@"intersection"]) {
        NSArray *resultArray = [result componentsSeparatedByString:@":"];
        result = [resultArray objectAtIndex:0];
    }
#if TARGET_IPHONE_SIMULATOR
    NSLog(result);
#endif
    return result;
}

+(NSString *)getLocationNameFromSearchedItem:(NSString *)searchedItem
{
    NSString *result;
    NSData *data = [[NSData alloc]initWithData:[self getXMLFileForSearchedItem:searchedItem]];
    TBXML *theFile = [XMLParser loadXmlDocumentFromData:data];
    TBXMLElement *theElement = [XMLParser getRootElement:theFile];
    TBXMLElement *theElementChild = [XMLParser getUnknownChildElement:theElement];
    NSString *locationType = [self getLocationTypeFromSearchedItem:theElementChild];
    if ([locationType isEqualToString:@"address"]) {
        TBXMLElement *streetNumberElement = [XMLParser extractElementFromParent:@"street-number" :theElementChild];
        NSString *houseNumber = [XMLParser extractAttributeTextFromElement:streetNumberElement];
        TBXMLElement *streetNameElement = [XMLParser extractElementFromParent:@"street" :theElementChild];
        streetNameElement = [XMLParser extractElementFromParent:@"name" :streetNameElement];
        NSString *streetName = [XMLParser extractAttributeTextFromElement:streetNameElement];
        result = [NSString stringWithFormat:@"%@ %@",houseNumber,streetName];
    } else if ([locationType isEqualToString:@"monument"]) {
        TBXMLElement *monumentNameElement = [XMLParser extractElementFromParent:@"name" :theElementChild];
        NSString *monumentName = [XMLParser extractAttributeTextFromElement:monumentNameElement];
        TBXMLElement *streetNumberElement = [XMLParser extractElementFromParent:@"address" :theElementChild];
        streetNumberElement = [XMLParser extractElementFromParent:@"street-number" :streetNumberElement];
        NSString *houseNumber = [XMLParser extractAttributeTextFromElement:streetNumberElement];
        TBXMLElement *streetNameElement = [XMLParser extractElementFromParent:@"address" :theElementChild];
        streetNameElement = [XMLParser extractElementFromParent:@"street" :streetNameElement];
        streetNameElement = [XMLParser extractElementFromParent:@"name" :streetNameElement];
        NSString *streetName = [XMLParser extractAttributeTextFromElement:streetNameElement];
        result = [NSString stringWithFormat:@"%@ (%@ %@)",monumentName,houseNumber,streetName];
    } else if ([locationType isEqualToString:@"intersection"]) {
        TBXMLElement *firstStreetElement = [XMLParser extractElementFromParent:@"street" :theElementChild];
        firstStreetElement = [XMLParser extractElementFromParent:@"name" :firstStreetElement];
        NSString *firstStreetName = [XMLParser extractAttributeTextFromElement:firstStreetElement];
        TBXMLElement *secondStreetElement = [XMLParser extractElementFromParent:@"cross-street" :theElementChild];
        secondStreetElement = [XMLParser extractElementFromParent:@"name" :secondStreetElement];
        NSString *secondStreetName = [XMLParser extractAttributeTextFromElement:secondStreetElement];
        result = [NSString stringWithFormat:@"%@ @ %@",firstStreetName,secondStreetName];
    }
#if TARGET_IPHONE_SIMULATOR
    NSLog(result);
#endif
    return result;
}//getLocationNameFromSearchedItem

+(NSString *)getLocationTypeFromSearchedItem:(TBXMLElement *)element
{
    NSString *result = [XMLParser getUnknownChildElementName:element];
    NSLog(result);
    return result;
}//getLocationTypeFromSearchedItem

+(NSString *)getOrigin:(NSString *)originString
{
    NSString *result = [navigoInterpreter getAddressKeyFromSearchedItem:originString];
    return result;
}

+(NSString *)getDestination:(NSString *)destinationString
{
    NSString *result = [navigoInterpreter getAddressKeyFromSearchedItem:destinationString];
    return result;
}

+(NSData *)getXMLFileFromResults:(NSString *)origin :(NSString *)destination :(NSString *)date :(NSString *)time :(NSString *)mode :(BOOL)easyAccess :(int)walkSpeed :(int)maxWalkTime :(int)minTransferWait :(int)maxTransferWait :(int)maxTransfers
{
    NSString *originString = [self getOrigin:origin];
    NSString *destinationString = [self getDestination:destination];
    NSString *dateString;
}//getXMLFileFromResults

@end
