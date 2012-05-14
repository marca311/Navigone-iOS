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

+(NSMutableDictionary *)getPrimaryResults:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSString *numberOfPlansString = [self getNumberOfPlans:rootElement];
    [result setObject:numberOfPlansString forKey:@"NumberOfPlans"];
    //[result addObject:numberOfPlansString];
    int numberOfPlans = [numberOfPlansString intValue];
    rootElement = [XMLParser extractUnknownChildElement:rootElement];
    for (int i = 0; i < numberOfPlans; i++) {
        [result setObject:[NSString stringWithFormat:@"%i",i+1] forKey:@"Plan"];
        [result setObject:[self getEasyAccess:rootElement] forKey:[NSString stringWithFormat:@"easyAccess %i",i+1]];
        [result setObject:[self getStartTime:rootElement] forKey:[NSString stringWithFormat:@"startTime %i",i+1]];
        [result setObject:[self getEndTime:rootElement] forKey:[NSString stringWithFormat:@"endTime %i",i+1]];
        [result setObject:[self getTotalTime:rootElement] forKey:[NSString stringWithFormat:@"totalTime %i",i+1]];
        [result setObject:[self getWalkTime:rootElement] forKey:[NSString stringWithFormat:@"walkTime %i",i+1]];
        [result setObject:[self getRideTime:rootElement] forKey:[NSString stringWithFormat:@"rideTime %i",i+1]];
        [result setObject:[self getWaitTime:rootElement] forKey:[NSString stringWithFormat:@"waitTime %i",i+1]];
        //NSArray method, I'm trying the above dictionary method to see if it works better. I'm hoping it will be more readable.
        /*
        [result addObject:[self getEasyAccess:rootElement]];
        [result addObject:[self getStartTime:rootElement]];
        [result addObject:[self getEndTime:rootElement]];
        [result addObject:[self getTotalTime:rootElement]];
        [result addObject:[self getWalkTime:rootElement]];
        [result addObject:[self getRideTime:rootElement]];
        [result addObject:[self getWaitTime:rootElement]];
         */
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
    NSLog([NSString stringWithFormat:@"Result:%@",result]);
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

#pragma mark - Get plan details

+(NSMutableDictionary *)getPlanDetails:(NSString *)planNumber:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLevel = [XMLParser extractUnknownChildElement:rootElement];
    while (![planNumber isEqualToString:[XMLParser getAttributeValue:[XMLParser extractAttribute:planLevel]]]) {
        planLevel = planLevel->nextSibling;
    }
    NSString *numberOfSegments = [self getNumberOfSegments:planLevel];
    [result setObject:numberOfSegments forKey:@"NumberOfSegments"];
    [result setObject:[NSDate date] forKey:@"Entry time"];
    planLevel = [XMLParser extractKnownChildElement:@"segments" :planLevel];
    planLevel = [XMLParser extractUnknownChildElement:planLevel];
    //planLevel = [XMLParser extractUnknownChildElement:planLevel];
    for (int i = 0; i < [numberOfSegments intValue]; i++) {
        [result setObject:[self getSegmentDetails:i:planLevel] forKey:[NSString stringWithFormat:@"segment %i",i]];
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

+(NSMutableDictionary *)getSegmentDetails:(int)segementNumber:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    //[result setObject:@"Nomz" forKey:@"test"];
    NSString *segmentType = [self getSegmentType:rootElement];
    [result setObject:segmentType forKey:@"segmentType"];
    [result setObject:[self getStartTime:rootElement] forKey:@"segmentStartTime"];
    [result setObject:[self getEndTime:rootElement] forKey:@"segmentEndTime"];
    [result setObject:[self getTotalTime:rootElement] forKey:@"segmentTotalTime"];
    [result setObject:[self getSegmentLocationInfo:segmentType :rootElement] forKey:@"segmentLocationInfo"];
    
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
    if ([segmentType isEqual:@"ride"]) {
        result = [self getRideInfo:rootElement];
        return result;
    } else {
        [result setObject:[self getInstructionType:rootElement] forKey:@"LocationType"];
        return result;
    }
}//getSegmentLocationInfo

+(NSString *)getInstructionType:(TBXMLElement *)rootElement
{
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    //planLayer = [XMLParser extractUnknownChildElement:planLayer];
    planLayer = planLayer->nextSibling;
    //planLayer = planLayer->nextSibling;
    planLayer = [XMLParser extractUnknownChildElement:planLayer];
    if ([[XMLParser getElementName:planLayer]isEqual:@"origin"]) {
        return @"walk";
    } else if ([[XMLParser getElementName:planLayer]isEqual:@"stop"]) {
        return @"stop";
    }
    
}//getInstructionType

+(NSMutableDictionary *)getOriginData:(TBXMLElement *)rootElement
{
    
}//getOriginData

+(NSMutableDictionary *)getStopData:(TBXMLElement *)rootElement
{
    
}//getStopData

+(NSMutableDictionary *)getRideInfo:(TBXMLElement *)rootElement
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    TBXMLElement *planLayer = [XMLParser extractUnknownChildElement:rootElement];
    planLayer = planLayer->nextSibling;
    planLayer = [XMLParser extractKnownChildElement:@"key" :planLayer];
    NSString *variantNumber = [XMLParser getValueFromElement:planLayer];
    [result setObject:@"ride" forKey:@"LocationType"];
    [result setObject:variantNumber forKey:@"Variant Number"];
    [result setObject:[self getVariantName:variantNumber] forKey:@"Variant Name"];
    return result;
}//getRideInfo

+(NSString *)getBusNumber:(TBXMLElement *)rootElement
{
    
}//getBusNumber

+(NSString *)getVariantName:(NSString *)variantKey
{
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.winnipegtransit.com/variants/%@?usage=long&api-key=%@",variantKey,[self getAPIKey]];
    urlString = [urlString ];
    NSURL *variantURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://api.winnipegtransit.com/variants/%@?usage=long&api-key=%@",variantKey,[self getAPIKey]]];
    NSData *variantSearch = [[NSData alloc]initWithContentsOfURL:variantURL];
    TBXML *variantXML = [XMLParser loadXmlDocumentFromData:variantSearch];
    TBXMLElement *elementOfVariant = [XMLParser getRootElement:variantXML];
    elementOfVariant = [XMLParser extractKnownChildElement:@"name" :elementOfVariant];
    NSString *result = [XMLParser getValueFromElement:elementOfVariant];
    return result;
}//getVariantName

+(NSString *)getStopNumber:(TBXMLElement *)rootElement
{
    
}//getStopNumber

+(NSString *)getStopName:(TBXMLElement *)rootElement
{
    
}//getStopName

+(NSString *)getSegmentFromCoordinates:(TBXMLElement *)rootElement
{
    
}//getSegmentFromCoordinates

+(NSString *)getSegmentToCoordinates:(TBXMLElement *)rootElement
{
    
}//getSegmentToCoordinates

+(NSString *)getSegmentFromStop:(TBXMLElement *)rootElement
{
    
}//getSegmentFromStop

+(NSString *)getSegmentToStop:(TBXMLElement *)rootElement
{
    
}//getSegmentToStop

@end
