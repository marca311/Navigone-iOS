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

@end
