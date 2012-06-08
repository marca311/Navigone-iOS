//
//  navigoInterpreter.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-07.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"
#import "MSUtilities.h"

@interface navigoInterpreter : NSObject

+(NSString *)getAPIKey;

+(NSData *)getXMLFileForSearchedItem:(NSString *)query;

+(BOOL)queryIsNotError:(NSData *)dataFile;

+(NSString *)getAddressKeyFromSearchedItem:(NSString *)searchedItem;

+(NSString *)getLocationNameFromSearchedItem:(NSString *)searchedItem;

+(NSString *)getLocationTypeFromSearchedItem:(TBXMLElement *)element;

+(BOOL)entryIsBlank:(NSString *)stringToCheck;

+(NSString *)serverModeString:(NSString *)humanModeString;

+(NSString *)stringForBool:(BOOL)theBool;

+(NSString *)timeFormatForServer:(NSDate *)timeObject;

+(NSString *)dateFormatForServer:(NSDate *)timeObject;

+(NSData *)getXMLFileFromResults:(NSArray *)queryArray;

#pragma mark - Analyzing the result XMLFile

+(TBXMLElement *)getRootElement:(NSData *)xmlFile;

+(NSMutableDictionary *)getRouteData:(NSData *)xmlFile;

+(NSMutableDictionary *)getPrimaryResults:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getPlanResults:(NSString *)numberOfPlans:(TBXMLElement *)rootElement;

+(NSString *)getNumberOfPlans:(TBXMLElement *)rootElement;

+(NSString *)getEasyAccess:(TBXMLElement *)rootElement;

+(NSDate *)getStartTime:(TBXMLElement *)rootElement;

+(NSDate *)getEndTime:(TBXMLElement *)rootElement;

+(NSString *)getTotalTime:(TBXMLElement *)rootElement;

+(NSString *)getWalkTime:(TBXMLElement *)rootElement;

+(NSString *)getRideTime:(TBXMLElement *)rootElement;
 
+(NSString *)getWaitTime:(TBXMLElement *)rootElement;

#pragma mark - Get plan details

+(NSMutableDictionary *)getPlanDetails:(NSString *)planNumber:(TBXMLElement *)rootElement;

+(NSString *)getNumberOfSegments:(TBXMLElement *)rootElement;

#pragma mark - Get segment details

+(NSMutableDictionary *)getSegmentDetails:(int)segementNumber:(TBXMLElement *)rootElement;

+(NSString *)getSegmentType:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getSegmentLocationInfo:(NSString *)segmentType:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getSegmentPartDetails:(TBXMLElement *)rootElement;

+(NSString *)getInstructionType:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getStopData:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getRideInfo:(TBXMLElement *)rootElement;

+(NSString *)getBusNumber:(NSString *)variantNumber;

+(NSString *)getVariantName:(NSString *)variantKey;

+(NSString *)getSegmentCoordinates:(TBXMLElement *)rootElement;

# pragma mark - Get Segment Address Details

+(NSMutableDictionary *)getOriginData:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getDestinationData:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getMonumentDetails:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getStopDetails:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getAddressDetails:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getIntersectionDetails:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getPointDetails:(TBXMLElement *)rootElement;

#pragma mark - Produce Human Readable Results

+(NSMutableArray *)makeHumanReadableResults:(NSDictionary *)dictionary;

+(NSString *)humanReadableWalk:(NSDictionary *)dictionary;

+(NSMutableArray *)humanReadableRide:(NSDictionary *)dictionary;

+(NSString *)humanReadableTransfer:(NSDictionary *)dictionary;

+(NSMutableArray *)patternInterpreter:(NSDictionary *)dictionary;

+(NSString *)timeAdder:(NSDate *)date;

+(NSMutableArray *)toFromInterpreter:(NSDictionary *)dictionary;

+(NSString *)pointHInterpreter:(NSDictionary *)dictionary:(NSString *)time;

+(NSString *)addressHInterpreter:(NSDictionary *)dictionary:(NSString *)time;

+(NSString *)monumentHInterpreter:(NSDictionary *)dictionary:(NSString *)time;

+(NSString *)stopHInterpreter:(NSDictionary *)dictionary:(NSString *)time;

@end
