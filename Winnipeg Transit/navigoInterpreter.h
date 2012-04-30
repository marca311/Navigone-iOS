//
//  navigoInterpreter.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-07.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

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

+(NSMutableDictionary *)getPrimaryResults:(TBXMLElement *)rootElement;

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

+(NSMutableDictionary *)getSegmentDetails:(TBXMLElement *)rootElement;

+(NSString *)getSegmentType:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getSegmentLengths:(TBXMLElement *)rootElement;

+(NSString *)getSegmentStartTime:(TBXMLElement *)rootElement;

+(NSString *)getSegmentEndTime:(TBXMLElement *)rootElement;

+(NSString *)getSegmentFromCoordinates:(TBXMLElement *)rootElement;

+(NSString *)getSegmentToCoordinates:(TBXMLElement *)rootElement;

+(NSString *)getSegmentFromStop:(TBXMLElement *)rootElement;

+(NSString *)getSegmentToStop:(TBXMLElement *)rootElement;
//I will use the previous address interpreting system to get location names and stuff   

@end
