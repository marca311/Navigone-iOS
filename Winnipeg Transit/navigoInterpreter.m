//
//  navigoInterpreter.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-07.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "navigoInterpreter.h"
#import "XMLParser.h"
#import "MSUtilities.h"
#include "apiKeys.h"

@implementation navigoInterpreter

+(NSData *)getXMLFileForSearchedItem:(NSString *)query
{
    NSData *resultXMLFile = [[NSData alloc]init];
    int tries = 0;
    do {
        if ([self entryIsBlank:query] == YES) return nil;
        else {
            query = [self replaceInvalidCharacters:query];
            tries = tries + 1;
            query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSString *queryURL = [NSString stringWithFormat: @"http://api.winnipegtransit.com/locations:%@?api-key=%@", query, transitAPIKey];
#if TARGET_IPHONE_SIMULATOR
            NSLog(query);
            NSLog(queryURL);
#endif
            NSURL *checkURL = [[NSURL alloc]initWithString:queryURL];
            resultXMLFile = [NSData dataWithContentsOfURL:checkURL];
        }
    } while (resultXMLFile == nil);
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Tries: %i",tries);
#endif
    
    return resultXMLFile;
    
}//getXMLFileForSearchedItem

+(BOOL)queryIsError:(NSData *)dataFile
{
    if (dataFile == NULL) {
        return YES;
    }
    TBXML *mainFile = [XMLParser loadXmlDocumentFromData:dataFile];
    TBXMLElement *rootElement = [XMLParser getRootElement:mainFile];
    if ((rootElement = rootElement->firstChild)) {
        return NO;
    } else {
        return YES;
    }
}//queryIsError

+(NSString *)replaceInvalidCharacters:(NSString *)theString
{
    NSCharacterSet *theSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@- "];
    theSet = [theSet invertedSet];
    theString = [[theString componentsSeparatedByCharactersInSet:theSet ]componentsJoinedByString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"*" withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    return theString;
}

+(NSArray *)getAddressInfoFromQuery:(NSString *)query
{
    NSData *data = [[NSData alloc]initWithData:[self getXMLFileForSearchedItem:query]];
    TBXML *theFile = [XMLParser loadXmlDocumentFromData:data];
    TBXMLElement *theElement = [XMLParser getRootElement:theFile];
    TBXMLElement *theElementChild = [XMLParser extractUnknownChildElement:theElement];
    NSString *addressReadable = [self getAddressNameFromElement:theElementChild];
    NSString *addressKey = [self getAddressKeyFromElement:theElementChild];
    NSArray *result = [[NSArray alloc]initWithObjects:addressReadable, addressKey, nil];
    return result;
}//getAddressInfoFromElement

+(NSString *)getAddressKeyFromElement:(TBXMLElement *)theElement
{
    TBXMLElement *theElementChild = theElement;
    NSString *locationType = [[NSString alloc]initWithFormat:@"%@",[XMLParser getElementName:theElementChild]];
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
    return result;
}

+(NSString *)getAddressNameFromElement:(TBXMLElement *)theElement
{
    NSString *result;
    TBXMLElement *theElementChild = theElement;
    NSString *locationType = [XMLParser getElementName:theElementChild];
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

+(NSArray *)getQuerySuggestions:(NSString *)query
{
    //Makes the suggestion array for the suggestions table

    if (![MSUtilities isQueryBlank:query])
    {
        NSMutableArray *result = [[NSMutableArray alloc]init];
        NSData *queryXML = [self getXMLFileForSearchedItem:query];
        if ([self queryIsError:queryXML] == YES) {
            NSArray *result = [[NSArray alloc]initWithObjects: nil];
            return result;
        }
        TBXML *theFile = [XMLParser loadXmlDocumentFromData:queryXML];
        TBXMLElement *theElement = [XMLParser getRootElement:theFile];
        TBXMLElement *theElementChild = [XMLParser extractUnknownChildElement:theElement];
        do {
            NSString *addressName = [self getAddressNameFromElement:theElementChild];
            //Replaces any ampersand placeholders
            addressName = [MSUtilities fixAmpersand:addressName];
            NSString *addressKey = [self getAddressKeyFromElement:theElementChild];
            NSArray *elementArray = [[NSArray alloc]initWithObjects:addressName, addressKey, nil];
            [result addObject:elementArray];
        } while ((theElementChild = theElementChild->nextSibling));
        return result;
    } else {
        NSArray *result = [[NSArray alloc]initWithObjects: nil];
        return result;
    }
}//getQuerySuggestions

+ (NSString *)timeFormatForServer:(NSDate *)timeObject
{
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"HH:mm"];
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
    //Test to find out if removing options fixes inconsistencies
    //NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&api-key=%@",origin,destination,time,date,mode,easyMode,[self getAPIKey]];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/trip-planner?origin=%@&destination=%@&time=%@&date=%@&mode=%@&easy-access=%@&walk-speed=%@&max-walk-time=%@&min-transfer-wait=%@&max-transfer-wait=%@&api-key=%@",origin,destination,time,date,mode,easyMode,walkSpeed,maxWalkTime,minTransferWait,maxTransferWait,transitAPIKey];
    NSURL *queryURL = [[NSURL alloc]initWithString:urlString];
    NSData *result = [[NSData alloc]initWithContentsOfURL:queryURL];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Query URL: %@",urlString);
#endif
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

+(NSString *)getRouteData:(NSData *)xmlFile
{
    TBXMLElement *rootElement = [self getRootElement:xmlFile];
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *primaryResults = [navigoInterpreter getPrimaryResults:rootElement];
    [result setObject:[NSDate date] forKey:@"Entry time"];
    [result setObject:primaryResults forKey:@"Primary Results"];
    NSString *numberOfPlansString = [primaryResults objectForKey:@"Number Of Plans"];
    int numberOfPlans = [numberOfPlansString intValue];
    for (int i = 1; i < numberOfPlans+1; i++) {
        NSString *planNumber = [[NSString alloc]initWithFormat:@"Plan %i",i];
        NSString *planNumberString = [[NSString alloc]initWithFormat:@"%i",i];
        [result setObject:[self getPlanDetails:planNumberString :rootElement] forKey:planNumber];
    }
    return [self saveToFile:result];
    
}//getRouteData

+(NSString *)saveToFile:(NSDictionary *)dictionary
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"y-MM-dd-hh:mm:ss"];
    NSString *entryTime = [dateFormat stringFromDate:[dictionary objectForKey:@"Entry time"]];
    [MSUtilities saveDictionaryToFile:dictionary :entryTime];
    [MSUtilities checkCacheAge];
    [MSUtilities generateCacheDB];
    return entryTime;
}//saveToFile

+(NSMutableDictionary *)getPrimaryResults:(TBXMLElement *)rootElement
{
    //XML Location: Root of File
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *numberOfPlansString = [self getNumberOfPlans:rootElement];
    [result setObject:numberOfPlansString forKey:@"Number Of Plans"];
    int numberOfPlans = [numberOfPlansString intValue];
    rootElement = [XMLParser extractUnknownChildElement:rootElement];
    //XML Location: <Plan number="x">
    for (int i = 0; i < numberOfPlans; i++) {
        NSString *planNumber = [[NSString alloc]initWithFormat:@"Plan%i",i];
        [result setObject:[self getEasyAccess:rootElement] forKey:[NSString stringWithFormat:@"%@ Easy Access",planNumber]];
        [result setObject:[self getStartTime:rootElement] forKey:[NSString stringWithFormat:@"%@ Start Time",planNumber]];
        [result setObject:[self getEndTime:rootElement] forKey:[NSString stringWithFormat:@"%@ End Time",planNumber]];
        [result setObject:[self getTotalTime:rootElement] forKey:[NSString stringWithFormat:@"%@ Total Time",planNumber]];
        [result setObject:[self getWalkTime:rootElement] forKey:[NSString stringWithFormat:@"%@ Walk Time",planNumber]];
        [result setObject:[self getRideTime:rootElement] forKey:[NSString stringWithFormat:@"%@ Ride Time",planNumber]];
        [result setObject:[self getWaitTime:rootElement] forKey:[NSString stringWithFormat:@"%@ Wait Time",planNumber]];
        [result setObject:[self getListOfBuses:rootElement] forKey:[NSString stringWithFormat:@"%@ Buses",planNumber]];
        rootElement = rootElement->nextSibling;
    }
    return result;
}

+(NSString *)getNumberOfPlans:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    NSString *result = [[NSString alloc]init];
    do {
        result = [XMLParser getAttributeValue:[XMLParser extractAttribute:planLayer]];
    } while ((planLayer = planLayer->nextSibling));
#if TARGET_IPHONE_SIMULATOR
    NSLog([NSString stringWithFormat:@"Result:%@",result]);
#endif
    return result;
}//getNumberOfPlans

+(NSString *)getEasyAccess:(TBXMLElement *)rootElement
{
    rootElement = [XMLParser extractUnknownChildElement:rootElement];
    NSString *result = [[NSString alloc]init];
    result = [XMLParser getValueFromElement:rootElement];
    return result;
}//getEasyAccess

+(NSDate *)getStartTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"times" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"start" :planLayer];
    NSString *resultString;
    resultString = [XMLParser getValueFromElement:planLayer];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *resultStringFormat = [[NSDateFormatter alloc]init];
    [resultStringFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *result;
    result = [resultStringFormat dateFromString:resultString];
    return result;
}//getStartTime

+(NSDate *)getEndTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"times" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"end" :planLayer];
    NSString *resultString;
    resultString = [XMLParser getValueFromElement:planLayer];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *resultStringFormat = [[NSDateFormatter alloc]init];
    [resultStringFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *result;
    result = [resultStringFormat dateFromString:resultString];
    return result;
}//getEndTime

+(NSString *)getTotalTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"times" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"durations" :planLayer];
    planLayer = [XMLParser extractKnownChildElement:@"total" :planLayer];
    NSString *result;
    result = [XMLParser getValueFromElement:planLayer];
    if ([result isEqualToString:@"-1436"]) {
        result = @"10";
    }
    return result;
}//getTotalTime

+(NSString *)getWalkTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"times" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"durations" :planLayer];
    planLayer = [XMLParser extractKnownChildElement:@"walking" :planLayer];
    NSString *result;
    result = [XMLParser getValueFromElement:planLayer];
    return result;
}//getWalkTime

+(NSString *)getRideTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"times" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"durations" :planLayer];
    planLayer = [XMLParser extractKnownChildElement:@"riding" :planLayer];
    NSString *result;
    result = [XMLParser getValueFromElement:planLayer];
    return result;
}//getRideTime

+(NSString *)getWaitTime:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"times" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"durations" :planLayer];
    planLayer = [XMLParser extractKnownChildElement:@"waiting" :planLayer];
    NSString *result;
    result = [XMLParser getValueFromElement:planLayer];
    return result;
}//getWaitTime

+(NSString *)getListOfBuses:(TBXMLElement *)rootElement
{
    NSMutableArray *buses = [[NSMutableArray alloc]init];
    NSString *result = [[NSString alloc]init];
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"segments" :rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"segment" :planLayer];
    NSString *segmentType = [[NSString alloc]init];
    while (planLayer->nextSibling) {
        segmentType = [XMLParser getAttributeValue:[XMLParser extractAttribute:planLayer]];
        if ([segmentType isEqualToString:@"ride"]) {
            TBXMLElement *segmentLayer = [XMLParser extractKnownChildElement:@"variant" :planLayer];
            segmentLayer = [XMLParser extractKnownChildElement:@"key" :segmentLayer];
            NSString *variantNumber = [[NSString alloc]init];
            variantNumber = [XMLParser getValueFromElement:segmentLayer];
            [buses addObject:[self getBusNumber:variantNumber]];
            planLayer = planLayer->nextSibling;
        } else {
            planLayer = planLayer->nextSibling;
        }
    }
    result = [buses description];
    //Improving Readability of results
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"( " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"   " withString:@""];
    return  result;
    
    
}//getListOfBuses

+(NSString *)getOrigin:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractKnownChildElement:@"segments" :rootElement];
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    planLayer = [XMLParser extractKnownChildElement:@"from" :planLayer];
    return nil;
    
    //This will be finished later
}//getOrigin

+(NSString *)getDestination:(TBXMLElement *)rootElement
{
    return nil;
    
    //This will be finished later
}//getDestination

#pragma mark - Get plan details

+(NSMutableDictionary *)getPlanDetails:(NSString *)planNumber :(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLevel = [XMLParser extractUnknownChildElement:rootElement];
    while (![planNumber isEqualToString:[XMLParser getAttributeValue:[XMLParser extractAttribute:planLevel]]]) {
        planLevel = planLevel->nextSibling;
    }
    NSString *numberOfSegments = [self getNumberOfSegments:planLevel];
    [result setObject:numberOfSegments forKey:@"Number Of Segments"];
    planLevel = [XMLParser extractKnownChildElement:@"segments" :planLevel];
    planLevel = [XMLParser extractUnknownChildElement:planLevel];
    //planLevel = [XMLParser extractUnknownChildElement:planLevel];
    for (int i = 0; i < [numberOfSegments intValue]; i++) {
        [result setObject:[self getSegmentDetails:i:planLevel] forKey:[NSString stringWithFormat:@"Segment %i",i]];
        planLevel = planLevel->nextSibling;
        
    }
    
    return result;
}//getPlanDetails

+(NSString *)getNumberOfSegments:(TBXMLElement *)rootElement
{
    TBXMLElement *planLevel = [XMLParser extractKnownChildElement:@"segments" :rootElement];
    planLevel = [XMLParser extractUnknownChildElement:planLevel];
    NSString *result = [[NSString alloc]init];
    int resultInt = 0;
    do {
        resultInt += 1;
    } while ((planLevel = planLevel->nextSibling));
    result = [NSString stringWithFormat:@"%i",resultInt];
#if TARGET_IPHONE_SIMULATOR
    NSLog([NSString stringWithFormat:@"Result:%@",result]);
#endif
    return result;
}//getNumberOfSegments

+(NSMutableDictionary *)getSegmentDetails:(int)segementNumber :(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    //[result setObject:@"Nomz" forKey:@"test"];
    NSString *segmentType = [self getSegmentType:rootElement];
    [result setObject:segmentType forKey:@"Segment Type"];
    [result setObject:[self getStartTime:rootElement] forKey:@"Segment Start Time"];
    [result setObject:[self getEndTime:rootElement] forKey:@"Segment End Time"];
    [result setObject:[self getTotalTime:rootElement] forKey:@"Segment Total Time"];
    [result setObject:[self getSegmentLocationInfo:segmentType :rootElement] forKey:@"Segment Location Info"];    
    return result;
}//getSegmentDetails

+(NSString *)getSegmentType:(TBXMLElement *)rootElement
{
    NSString *result = [XMLParser getAttributeValue:[XMLParser extractAttribute:rootElement]];
    return result;
}//getSegmentType

+(NSMutableDictionary *)getSegmentLocationInfo:(NSString *)segmentType :(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *child = [[NSMutableDictionary alloc]init];
    if ([segmentType isEqual:@"ride"]) {
        result = [self getRideInfo:rootElement];
        return result;
    } else {
        NSString *instructionType = [self getInstructionType:rootElement];
        [result setObject:instructionType forKey:@"LocationType"];
        //location: segment
        
        TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
        //location: times
        planLayer = planLayer->nextSibling;
        //location: from/to
        for (int i = 0; i <= 1; i++) {
            if ([instructionType isEqualToString:@"origin"]) {
                child = [self getOriginData:planLayer];
            } else if ([instructionType isEqualToString:@"destination"]) {
                child = [self getDestinationData:planLayer];
            } else if ([instructionType isEqualToString:@"stop"]) {
                child = [self getStopDetails:planLayer];
            }
            NSString *direction = [XMLParser getElementName:planLayer];
            [result setObject:child forKey:direction];
            if (i != 1) {
                while (![[XMLParser getElementName:planLayer]isEqualToString:@"to"]) {
                    planLayer = planLayer->nextSibling;
                }
                TBXMLElement *instructionLayer = [XMLParser extractUnknownChildElement:planLayer];
                instructionType = [XMLParser getElementName:instructionLayer];
            }
            
        }
        return result;
    }
}//getSegmentLocationInfo

+(NSString *)getInstructionType:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = planLayer->nextSibling;
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    NSString *result = [XMLParser getElementName:planLayer];
    return result;
}//getInstructionType

+(NSMutableDictionary *)getRideInfo:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = planLayer->nextSibling;
    planLayer = [XMLParser extractKnownChildElement:@"key" :planLayer];
    NSString *variantNumber = [XMLParser getValueFromElement:planLayer];
    [result setObject:@"ride" forKey:@"LocationType"];
    [result setObject:variantNumber forKey:@"Variant Number"];
    planLayer = planLayer->nextSibling;
    NSString *fullVariantResults = [XMLParser getValueFromElement:planLayer];
    //fullVariantResults = [fullVariantResults stringByReplacingOccurrencesOfString:@" via " withString:@" to "];
    NSArray *array = [fullVariantResults componentsSeparatedByString:@" to "];
    if ([array count] == 1) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray addObject:[array objectAtIndex:0]];
        [tempArray addObject:@""];
        array = tempArray;
    }
    NSString *routeName = [array objectAtIndex:0];
    NSString *variantName = [array objectAtIndex:1];
    [result setObject:routeName forKey:@"Route Name"];
    [result setObject:variantName forKey:@"Variant Name"];
    NSString *routeNumber = [self getBusNumber:variantNumber];
    [result setObject:routeNumber forKey:@"Route Number"];
    NSString *humanReadable = [[NSString alloc]initWithFormat:@"%@ %@ (%@)",routeNumber,routeName,variantName];
    if ([[array objectAtIndex:1] isEqualToString:@""]) {
        humanReadable = [NSString stringWithFormat:@"(%@)",[array objectAtIndex:0]];
    }
    [result setObject:humanReadable forKey:@"Human Readable"];
    return result;
}//getRideInfo

+(NSString *)getBusNumber:(NSString *)variantNumber
{
    NSString *result = [[NSString alloc]init];
    NSArray *array = [variantNumber componentsSeparatedByString:@"-"];
    result = [array objectAtIndex:0];
    return result;
}//getBusNumber

+(NSString *)getSegmentCoordinates:(TBXMLElement *)rootElement
{
    NSString *result = [[NSString alloc]init];
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = planLayer->nextSibling;
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    NSString *latitude = [XMLParser getValueFromElement:planLayer];
    planLayer = planLayer->nextSibling;
    NSString *longitude = [XMLParser getValueFromElement:planLayer];
    result = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    return result;
}//getSegmentCoordinates

# pragma mark - Get Segment Address Details

+(NSMutableDictionary *)getOriginData:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result;
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    NSString *locationType = [XMLParser getElementName:planLayer];
    if ([locationType isEqualToString:@"monument"]) {
        result = [self getMonumentDetails:planLayer];
        [result setObject:@"Monument" forKey:@"Type"];
        return result;
    } else if ([locationType isEqualToString:@"address"]) {
        result = [self getAddressDetails:planLayer];
        [result setObject:@"Address" forKey:@"Type"];
    } else if ([locationType isEqualToString:@"intersection"]) {
        result = [self getIntersectionDetails:planLayer];
        [result setObject:@"Intersection" forKey:@"Type"];
    } else if ([locationType isEqualToString:@"point"]) {
        result = [self getPointDetails:planLayer];
        [result setObject:@"Point" forKey:@"Type"];
    }
    [result setObject:@"Origin" forKey:@"Static"];
    return result;
}//getOriginData

+(NSMutableDictionary *)getDestinationData:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result;
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    NSString *locationType = [XMLParser getElementName:planLayer];
    if ([locationType isEqualToString:@"monument"]) {
        result = [self getMonumentDetails:planLayer];
        [result setObject:@"Monument" forKey:@"Type"];
        return result;
    } else if ([locationType isEqualToString:@"address"]) {
        result = [self getAddressDetails:planLayer];
        [result setObject:@"Address" forKey:@"Type"];
    } else if ([locationType isEqualToString:@"intersection"]) {
        result = [self getIntersectionDetails:planLayer];
        [result setObject:@"Intersection" forKey:@"Type"];
    }
    [result setObject:@"Destination" forKey:@"Static"];
    return result;
}//getDestinationData

+(NSMutableDictionary *)getMonumentDetails:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = rootElement;
    TBXMLElement *monumentNameElement = [XMLParser extractKnownChildElement:@"name" :planLayer];
    NSString *monumentName = [XMLParser getValueFromElement:monumentNameElement];
    TBXMLElement *streetNumberElement = [XMLParser extractKnownChildElement:@"address" :planLayer];
    streetNumberElement = [XMLParser extractKnownChildElement:@"street-number" :streetNumberElement];
    NSString *houseNumber = [XMLParser getValueFromElement:streetNumberElement];
    TBXMLElement *streetNameElement = [XMLParser extractKnownChildElement:@"address" :planLayer];
    streetNameElement = [XMLParser extractKnownChildElement:@"street" :streetNameElement];
    streetNameElement = [XMLParser extractKnownChildElement:@"name" :streetNameElement];
    NSString *streetName = [XMLParser getValueFromElement:streetNameElement];
    NSString *humanReadable = [NSString stringWithFormat:@"%@ (%@ %@)",monumentName,houseNumber,streetName];
    [result setObject:humanReadable forKey:@"Human Readable"];
    [result setObject:monumentName forKey:@"Monument Name"];
    [result setObject:houseNumber forKey:@"Monument Address"];
    [result setObject:streetName forKey:@"Monument Street"];
    return result;
}//getMonumentDetails

+(NSMutableDictionary *)getStopDetails:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = [XMLParser extractKnownChildElement:@"key" :planLayer];
    [result setObject:[XMLParser getValueFromElement:planLayer] forKey:@"Stop Number"];
    planLayer = planLayer->nextSibling;
    [result setObject:[XMLParser getValueFromElement:planLayer] forKey:@"Stop Name"];
    planLayer = planLayer->nextSibling;
    NSString *coordinates = [self getSegmentCoordinates:planLayer];
    NSArray *array = [coordinates componentsSeparatedByString:@","];
    [result setObject:[array objectAtIndex:0] forKey:@"Longitude"];
    [result setObject:[array objectAtIndex:1] forKey:@"Latitude"];
    [result setObject:@"Stop" forKey:@"Type"];
    return result;
}//getStopDetails

+(NSMutableDictionary *)getAddressDetails:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = rootElement;
    TBXMLElement *streetNumberElement = [XMLParser extractKnownChildElement:@"street-number" :planLayer];
    NSString *houseNumber = [XMLParser getValueFromElement:streetNumberElement];
    TBXMLElement *streetNameElement = [XMLParser extractKnownChildElement:@"street" :planLayer];
    streetNameElement = [XMLParser extractKnownChildElement:@"name" :streetNameElement];
    NSString *streetName = [XMLParser getValueFromElement:streetNameElement];
    NSString *humanReadable = [NSString stringWithFormat:@"%@ %@",houseNumber,streetName];
    [result setObject:humanReadable forKey:@"Human Readable"];
    [result setObject:houseNumber forKey:@"Address Number"];
    [result setObject:streetName forKey:@"Street Name"];
    return result;
}//getAddressDetails

+(NSMutableDictionary *)getIntersectionDetails:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = rootElement;
    TBXMLElement *firstStreetElement = [XMLParser extractKnownChildElement:@"street" :planLayer];
    firstStreetElement = [XMLParser extractKnownChildElement:@"name" :firstStreetElement];
    NSString *firstStreetName = [XMLParser getValueFromElement:firstStreetElement];
    TBXMLElement *secondStreetElement = [XMLParser extractKnownChildElement:@"cross-street" :planLayer];
    secondStreetElement = [XMLParser extractKnownChildElement:@"name" :secondStreetElement];
    NSString *secondStreetName = [XMLParser getValueFromElement:secondStreetElement];
    NSString *humanReadable = [NSString stringWithFormat:@"%@ @ %@",firstStreetName,secondStreetName];
    [result setObject:humanReadable forKey:@"Human Readable"];
    [result setObject:firstStreetName forKey:@"First Street Name"];
    [result setObject:secondStreetName forKey:@"Second Street Name"];
    return result;
}//getIntersectionDetails

+(NSMutableDictionary *)getPointDetails:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    NSString *coordinates = [self getSegmentCoordinates:planLayer];
    NSArray *array = [coordinates componentsSeparatedByString:@","];
    [result setObject:coordinates forKey:@"Combined"];
    [result setObject:[array objectAtIndex:0] forKey:@"Longitude"];
    [result setObject:[array objectAtIndex:1] forKey:@"Latitude"];
    return result;
}//getPointDetails

#pragma mark - Produce Human Readable Results

+(NSMutableArray *)makeHumanReadableResults:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSDictionary *primaryResults = [dictionary objectForKey:@"Primary Results"];
    int numberOfPlans = [[primaryResults objectForKey:@"Number Of Plans"]intValue];
    for (int p = 1; p <= numberOfPlans; p++) {
        NSMutableArray *planResult = [[NSMutableArray alloc]init];
        NSString *planName = [[NSString alloc]init];
        planName = [NSString stringWithFormat:@"Plan %i",p];
        NSDictionary *planDictionary = [[NSDictionary alloc]initWithDictionary:[dictionary objectForKey:planName]];
        int numberOfSegments = [[planDictionary objectForKey:@"Number Of Segments"]intValue];
        for (int s = 0; s <= numberOfSegments; s++) {
            NSString *segmentName = [[NSString alloc]init];
            segmentName = [NSString stringWithFormat:@"Segment %i",s];
            NSDictionary *segmentDictionary = [[NSDictionary alloc]initWithDictionary:[planDictionary objectForKey:segmentName]];
            NSArray *patternArray = [[NSArray alloc]init];
            patternArray = [self patternInterpreter:segmentDictionary];
            for (int p = 0; p < [patternArray count]; p++) {
                [planResult addObject:[patternArray objectAtIndex:p]];
            }
        }
        [result addObject:planResult];
    }
    return result;
}//makeHumanReadableResults

+(NSMutableArray *)humanReadableWalk:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *walkTime = [[NSString alloc]init];
    walkTime = [dictionary objectForKey:@"Segment Total Time"];
    NSString *text = [NSString stringWithFormat:@"Walk %@ minutes",walkTime];
    [result addObject:@"walk"];
    [result addObject:text];
    return result;
}//humanReadableWalk

+(NSMutableArray *)humanReadableRide:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *resultString = [[NSString alloc]init];
    NSDictionary *info = [[NSDictionary alloc]initWithDictionary:[dictionary objectForKey:@"Segment Location Info"]];
    resultString = [info objectForKey:@"Human Readable"];
    resultString = [NSString stringWithFormat:@"Ride: %@",resultString];
    NSMutableArray *child = [[NSMutableArray alloc]init];
    [child addObject:@"ride"];
    [child addObject:resultString];
    [result addObject:child];
    return result;
}//humanReadableRide

+(NSMutableArray *)humanReadableTransfer:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *transferTime = [[NSString alloc]init];
    transferTime = [dictionary objectForKey:@"Segment Total Time"];
    NSString *text = [NSString stringWithFormat:@"Transfer %@ minutes",transferTime];
    [result addObject:@"transfer"];
    [result addObject:text];
    return result;

}//humanReadableTransfer

+(NSMutableArray *)patternInterpreter:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *segmentType = [[NSString alloc]init];
    segmentType = [dictionary objectForKey:@"Segment Type"];
    if ([segmentType isEqualToString:@"ride"]) {
        result = [self humanReadableRide:dictionary];
        return result;
    } else {
        result = [self toFromInterpreter:dictionary];
        return result;
        
        //[result addObject:@"notRide"];
        //return result;
    }
}//patternInterpreter

+(NSString *)timeAdder:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"HH:mm";
    NSString *resultTime = [format stringFromDate:date];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",resultTime];
    return result;
}//timeAdder

+(NSMutableArray *)toFromInterpreter:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSDictionary *segmentLocationInfo = [[NSDictionary alloc]initWithDictionary:[dictionary objectForKey:@"Segment Location Info"]];
    NSDictionary *currentDictionary = [[NSDictionary alloc]initWithDictionary:[segmentLocationInfo objectForKey:@"from"]];
    NSString *currentTime = [[NSString alloc]init];
    currentTime = [self timeAdder:[dictionary objectForKey:@"Segment Start Time"]];
    for (int i = 0; i <= 1; i++) {
        NSString *locationType = [[NSString alloc]init];
        locationType = [currentDictionary objectForKey:@"Type"];
        if ([locationType isEqualToString:@"Address"]) {
            [result addObject:[self addressHInterpreter:currentDictionary:currentTime]];
        } else if ([locationType isEqualToString:@"Stop"]) {
            [result addObject:[self stopHInterpreter:currentDictionary:currentTime]];
        } else if ([locationType isEqualToString:@"Intersection"]) {
            [result addObject:[self intersectionHInterpreter:currentDictionary:currentTime]];
        } else if ([locationType isEqualToString:@"Monument"]) {
            [result addObject:[self monumentHInterpreter:currentDictionary:currentTime]];
        } else if ([locationType isEqualToString:@"Point"]) {
            [result addObject:[self pointHInterpreter:currentDictionary:currentTime]];
        }
        if (i == 1) {
            return result;
        }
        NSString *segmentMovementType = [[NSString alloc]init];
        segmentMovementType = [dictionary objectForKey:@"Segment Type"];
        if ([segmentMovementType isEqualToString:@"transfer"]) {
            [result addObject:[self humanReadableTransfer:dictionary]];
        } else if ([segmentMovementType isEqualToString:@"walk"]) {
            [result addObject:[self humanReadableWalk:dictionary]];
        }
        currentDictionary = [segmentLocationInfo objectForKey:@"to"];
        currentTime = [self timeAdder:[dictionary objectForKey:@"Segment End Time"]];
    }
    return nil;
}//toFromInterpreter

+(NSMutableArray *)pointHInterpreter:(NSDictionary *)dictionary :(NSString *)time
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *latitude =  [[NSString alloc]init];
    latitude = [dictionary objectForKey:@"Latitude"];
    NSString *longitude = [[NSString alloc]init];
    longitude = [dictionary objectForKey:@"Longitude"];
    [result addObject:@"point"];
    NSString *text = [NSString stringWithFormat:@"Coordinates: %@, %@",latitude, longitude];
    [result addObject:text];
    [result addObject:time];
    return result;
}//pointHInterpreter

+(NSMutableArray *)addressHInterpreter:(NSDictionary *)dictionary :(NSString *)time
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *text = [dictionary objectForKey:@"Human Readable"];
    [result addObject:@"address"];
    [result addObject:text];
    [result addObject:time];
    return result;
}//addressHInterpreter

+(NSMutableArray *)intersectionHInterpreter:(NSDictionary *)dictionary :(NSString *)time
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *text = [dictionary objectForKey:@"Human Readable"];
    [result addObject:@"intersection"];
    [result addObject:text];
    [result addObject:time];
    return result;
}//intersectionHInterpreter

+(NSMutableArray *)monumentHInterpreter:(NSDictionary *)dictionary :(NSString *)time
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *text = [dictionary objectForKey:@"Human Readable"];
    [result addObject:@"monument"];
    [result addObject:text];
    [result addObject:time];
    return result;
}//monumentHInterpreter

+(NSMutableArray *)stopHInterpreter:(NSDictionary *)dictionary :(NSString *)time
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *stopName = [[NSString alloc]init];
    NSString *stopNumber = [[NSString alloc]init];
    stopName = [dictionary objectForKey:@"Stop Name"];
    stopNumber = [dictionary objectForKey:@"Stop Number"];
    NSString *text = [NSString stringWithFormat:@"Bus Stop: %@ (%@)",stopName, stopNumber];
    [result addObject:stopNumber];
    [result addObject:text];
    [result addObject:time];
    return result;
}//stopHInterpreter

+(NSMutableArray *)planListMaker:(NSDictionary *)dictionary
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSDictionary *primaryResults = [dictionary objectForKey:@"Primary Results"];
    int numberOfPlans = [[primaryResults objectForKey:@"Number Of Plans"]intValue];
    [result addObject:[primaryResults objectForKey:@"Number Of Plans"]];
    for (int i = 0; i<numberOfPlans; i++) {
        NSMutableArray *secondary = [[NSMutableArray alloc]init];
        NSDate *startDate = [primaryResults objectForKey:[NSString stringWithFormat:@"Plan%i Start Time",i]];
        [secondary addObject:[self timeAdder:startDate]];
        NSDate *endDate = [primaryResults objectForKey:[NSString stringWithFormat:@"Plan%i End Time",i]];
        [secondary addObject:[self timeAdder:endDate]];
        NSString *buses = [primaryResults objectForKey:[NSString stringWithFormat:@"Plan%i Buses",i]];
        [secondary addObject:buses];
        [result addObject:secondary];
    }
    return result;
}//planListMaker

# pragma mark - Error Processing

+(void)displayConnectionError
{
    NSString *title = @"Error";
    NSString *message = @"There was an error connecting to the database, please try again";
    NSString *cancel = @"Okay";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles: nil];
    [alertView show];
}//displayConnectionError

+(void)displayDataError
{
    NSString *title = @"Error";
    NSString *message = @"There was an error processing the data, please report this to marcusjbdyck@gmail.com";
    NSString *cancel = @"Okay";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles: nil];
    [alertView show];
}//displayDataError

+(void)displayNoConnectionError
{
    NSString *title = @"Error";
    NSString *message = @"It appears you are not connected to the internet, please connect and try again";
    NSString *cancel = @"Okay";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles: nil];
    [alertView show];
}//displayNoConnectionError

@end
