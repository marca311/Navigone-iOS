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
        TBXMLElement *theElementChild = [XMLParser extractUnknownChildElement:theElement];
        NSString *locationType = [[NSString alloc]initWithFormat:@"%@",[self getLocationTypeFromSearchedItem:theElementChild]];
        theElementChild = [XMLParser extractKnownChildElement:@"key" :theElementChild];
        NSString *result = [XMLParser getValueFromElement:theElementChild];
        if ([locationType isEqualToString:@"intersection"]) {
            NSArray *resultArray = [result componentsSeparatedByString:@":"];
            result = [resultArray objectAtIndex:0];
        }
        NSString *addressType = [[NSString alloc]init];
        if ([locationType isEqualToString:@"address"]) addressType = @"addresses";
        else if ([locationType isEqualToString:@"monument"]) addressType = @"monuments";
        else if ([locationType isEqualToString:@"intersection"]) addressType = @"intersections";
        result = [NSString stringWithFormat:@"%@/%@",addressType,result];
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
    TBXMLElement *theElementChild = [XMLParser extractUnknownChildElement:theElement];
    NSString *locationType = [self getLocationTypeFromSearchedItem:theElementChild];
    if ([locationType isEqualToString:@"address"]) {
        TBXMLElement *streetNumberElement = [XMLParser extractKnownChildElement:@"street-number" :theElementChild];
        NSString *houseNumber = [XMLParser getValueFromElement:streetNumberElement];
        TBXMLElement *streetNameElement = [XMLParser extractKnownChildElement:@"street" :theElementChild];
        streetNameElement = [XMLParser extractKnownChildElement:@"name" :streetNameElement];
        NSString *streetName = [XMLParser getValueFromElement:streetNameElement];
        result = [NSString stringWithFormat:@"%@ %@",houseNumber,streetName];
    } else if ([locationType isEqualToString:@"monument"]) {
        TBXMLElement *monumentNameElement = [XMLParser extractKnownChildElement:@"name" :theElementChild];
        NSString *monumentName = [XMLParser getValueFromElement:monumentNameElement];
        TBXMLElement *streetNumberElement = [XMLParser extractKnownChildElement:@"address" :theElementChild];
        streetNumberElement = [XMLParser extractKnownChildElement:@"street-number" :streetNumberElement];
        NSString *houseNumber = [XMLParser getValueFromElement:streetNumberElement];
        TBXMLElement *streetNameElement = [XMLParser extractKnownChildElement:@"address" :theElementChild];
        streetNameElement = [XMLParser extractKnownChildElement:@"street" :streetNameElement];
        streetNameElement = [XMLParser extractKnownChildElement:@"name" :streetNameElement];
        NSString *streetName = [XMLParser getValueFromElement:streetNameElement];
        result = [NSString stringWithFormat:@"%@ (%@ %@)",monumentName,houseNumber,streetName];
    } else if ([locationType isEqualToString:@"intersection"]) {
        TBXMLElement *firstStreetElement = [XMLParser extractKnownChildElement:@"street" :theElementChild];
        firstStreetElement = [XMLParser extractKnownChildElement:@"name" :firstStreetElement];
        NSString *firstStreetName = [XMLParser getValueFromElement:firstStreetElement];
        TBXMLElement *secondStreetElement = [XMLParser extractKnownChildElement:@"cross-street" :theElementChild];
        secondStreetElement = [XMLParser extractKnownChildElement:@"name" :secondStreetElement];
        NSString *secondStreetName = [XMLParser getValueFromElement:secondStreetElement];
        result = [NSString stringWithFormat:@"%@ @ %@",firstStreetName,secondStreetName];
    }
#if TARGET_IPHONE_SIMULATOR
    NSLog(result);
#endif
    return result;
}//getLocationNameFromSearchedItem

+(NSString *)getLocationTypeFromSearchedItem:(TBXMLElement *)element
{
    NSString *result = [XMLParser getElementName:element];
    NSLog(result);
    return result;
}//getLocationTypeFromSearchedItem

+ (NSString *)timeFormatForServer:(NSDate *)timeObject
{
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"HH:MM"];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",[serverFormat stringFromDate:timeObject]];
    return result;
}//timeFormatForServer

+ (NSString *)dateFormatForServer:(NSDate *)timeObject
{
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"y-MM-dd"];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",[serverFormat stringFromDate:timeObject]];
    return result;
}//dateFormatForServer

+(NSData *)getXMLFileFromResults:(NSArray *)queryArray
{
    NSString *origin = [[NSString alloc]init];
    NSString *destination = [[NSString alloc]init];
    NSString *time = [[NSString alloc]init];
    NSString *date = [[NSString alloc]init];
    NSString *mode = [[NSString alloc]init];
    NSString *easyMode = [[NSString alloc]init];
    NSString *walkSpeed = [[NSString alloc]init];
    NSString *maxWalkTime = [[NSString alloc]init];;
    NSString *minTransferWait = [[NSString alloc]init];
    NSString *maxTransferWait = [[NSString alloc]init];
    NSString *maxTransfers = [[NSString alloc]init];
    NSString *objectFromIndex = [[NSString alloc]init];
    for (int itemsInArray = 0; itemsInArray < 11; itemsInArray++) {
        objectFromIndex = [queryArray objectAtIndex:itemsInArray];
        NSLog(objectFromIndex);
        switch (itemsInArray) {
            case 0:
                origin = objectFromIndex;
                break;
            case 1:
                destination = objectFromIndex;
                break;
            case 2:
                time = objectFromIndex;
                break;
            case 3:
                date = objectFromIndex;
                break;
            case 4:
                mode = objectFromIndex;
                break;
            case 5:
                easyMode = objectFromIndex;
                break;
            case 6:
                walkSpeed = objectFromIndex;
                break;
            case 7:
                maxWalkTime = objectFromIndex;
                break;
            case 8:
                minTransferWait = objectFromIndex;
                break;
            case 9:
                maxTransferWait = objectFromIndex;
                break;
            case 10:
                maxTransfers = objectFromIndex;
                break;
        }
    }
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&walk-speed=%@&max-walk-time=%@&min-transfer-wait=%@&max-transfer-wait=%@&max-transfers=%@&api-key=%@",origin,destination,time,date,mode,easyMode,walkSpeed,maxWalkTime,minTransferWait,maxTransferWait,maxTransfers,[self getAPIKey]];
    NSLog(urlString);
    NSURL *queryURL = [[NSURL alloc]initWithString:urlString];
    NSData *result = [[NSData alloc]initWithContentsOfURL:queryURL];
    return result;
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
    NSString *result = [[NSString alloc]init];
    if (theBool == YES){ result = @"true"; }
    else { result = @"false"; }
    return result;
}//stringForBool

#pragma mark - Analyzing the result XML

+(TBXMLElement *)getRootElement:(NSData *)xmlFile
{
    TBXML *navigoResult = [XMLParser loadXmlDocumentFromData:xmlFile];
    TBXMLElement *result = [XMLParser getRootElement:navigoResult];
    return result;
}//getRootElement

+(NSArray *)getPrimaryResults:(TBXMLElement *)rootElement
{
    //NSInteger *numberOfPlans = [self getNumberOfPlans:rootElement];
}

+(NSString *)getNumberOfPlans:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    //planLayer = [XMLParser extractUnknownChildElement:planLayer];
    //NSInteger *result;
    NSString *result = [[NSString alloc]init];
    do {
        result = [XMLParser getAttributeValue:[XMLParser extractAttribute:planLayer]];
    } while ((planLayer = planLayer->nextSibling));
    NSLog([NSString stringWithFormat:@"Result:%@",result]);
    return result;
}//getNumberOfPlans

+(NSString *)getEasyAccess:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    NSString *result = [[NSString alloc]init];
    result = [XMLParser getValueFromElement:planLayer];
    return result;
}//getEasyAccess

+(NSDate *)getStartTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"times" :planLayer];
    planLayer = [XMLParser extractKnownChildElement:@"start" :planLayer];
    NSString *resultString;
    resultString = [XMLParser getValueFromElement:planLayer];
    NSDateFormatter *resultStringFormat = [[NSDateFormatter alloc]init];
    [resultStringFormat setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSDate *result = [[NSDate alloc]init];
    result = [resultStringFormat dateFromString:resultString];
}//getStartTime

+(NSString *)getEndTime:(TBXMLElement *)rootElement
{
    
}//getEndTime

+(NSString *)getTotalTime:(TBXMLElement *)rootElement
{
    
}

+(NSString *)getWalkTime:(TBXMLElement *)rootElement
{
    
}

+(NSString *)getRideTime:(TBXMLElement *)rootElement
{
    
}

+(NSString *)getWaitTime:(TBXMLElement *)rootElement
{
    
}



@end
