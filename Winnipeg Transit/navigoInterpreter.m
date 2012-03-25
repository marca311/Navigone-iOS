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
    NSData *resultXMLFile = [[NSData alloc]init];
    int tries = 0;
    do {
        if ([self entryIsBlank:query] == YES) return nil;
        else {
            tries = tries + 1;
            query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSString *queryURL = [NSString stringWithFormat: @"http://api.winnipegtransit.com/locations:%@?api-key=%@", query, [navigoInterpreter getAPIKey]];
#if TARGET_IPHONE_SIMULATOR
            NSLog(query);
            NSLog(queryURL);
#endif
            NSURL *checkURL = [[NSURL alloc]initWithString:queryURL];
            resultXMLFile = [NSData dataWithContentsOfURL:checkURL];
        }
    } while (resultXMLFile == nil);
    
    //while ([self queryIsNotError:resultXMLFile] == NO);
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Tries: %i",tries);
#endif
    return resultXMLFile;
    
}//getXMLFileForSearchedItem

+(BOOL)queryIsNotError:(NSData *)dataFile
{
    NSData *errorPage = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"error_page" ofType:@"html"]];
    NSData *notSearchable = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"not_searchable_error" ofType:@""]];
    if ([dataFile isEqualToData:notSearchable] == YES || [dataFile isEqualToData:errorPage] == YES) {
        NSLog(@"Error, retry");
        return NO;
    } else {
        return YES;
    }
}//queryIsNotError

+(NSString *)getAddressKeyFromSearchedItem:(NSString *)searchedItem
{
    if ([self getXMLFileForSearchedItem:searchedItem] == nil) return nil;
    else {
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

+(NSData *)getXMLFileFromResults:(NSArray *)queryArray
{
    NSString *origin;
    NSString *destination;
    NSString *time;
    NSString *date;
    NSString *easyMode;
    NSString *walkSpeed;
}//getXMLFileFromResults
         
+(BOOL)entryIsBlank:(NSString *)stringToCheck
{
    stringToCheck = [stringToCheck stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([stringToCheck isEqualToString:@""]) {
        return YES;
    }
    else return NO;
}//entryIsBlank

+(NSString *)serverModeString:(NSString *)humanModeString
{
    NSString *result = [humanModeString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    result = [result lowercaseString];
    return result;
}//serverModeString

+(NSString *)stringForBool:(BOOL)theBool
{
    NSString *result;
    if (theBool == YES) result = [[NSString alloc]initWithFormat:@"true"];
    else result = [[NSString alloc]initWithFormat:@"false"];
}//stringForBool

@end
