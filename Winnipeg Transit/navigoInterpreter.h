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

#pragma mark - Get segment details

+(NSMutableDictionary *)getSegmentDetails:(int)segementNumber:(TBXMLElement *)rootElement;

+(NSString *)getSegmentType:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getSegmentLocationInfo:(NSString *)segmentType:(TBXMLElement *)rootElement;

+(NSString *)getInstructionType:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getOriginData:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getStopData:(TBXMLElement *)rootElement;

+(NSMutableDictionary *)getRideInfo:(TBXMLElement *)rootElement;

+(NSString *)getBusNumber:(TBXMLElement *)rootElement;

+(NSString *)getVariantName:(NSString *)variantKey;

+(NSString *)getStopNumber:(TBXMLElement *)rootElement;

+(NSString *)getStopName:(TBXMLElement *)rootElement;

+(NSString *)getSegmentFromCoordinates:(TBXMLElement *)rootElement;

+(NSString *)getSegmentToCoordinates:(TBXMLElement *)rootElement;

//I will use the previous address interpreting system to get location names and stuff   

@end
