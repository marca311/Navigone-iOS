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

+(NSString *)getAddressKeyFromSearchedItem:(NSString *)searchedItem;

+(NSString *)getLocationNameFromSearchedItem:(NSString *)searchedItem;

+(NSString *)getLocationTypeFromSearchedItem:(TBXMLElement *)element;

+(NSString *)getOrigin:(NSString *)originString;

+(NSString *)getDestination:(NSString *)destinationString;

+(BOOL)entryIsBlank:(NSString *)stringToCheck;

//-(NSData *)getXMLFileFromResults:(NSString *)origin:(NSString *)destination:(NSString *)date:(NSString *)time:(NSString *)mode:(BOOL)easyAccess:(int)walkSpeed:(int)maxWalkTime:(int)minTransferWait:(int)maxTransferWait:(int)maxTransfers;

//-(NSString *)getTotalWalkTime

@end
