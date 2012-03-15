//
//  navigoInterpreter.m
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "navigoInterpreter.h"
#import "XMLParser.h"

@implementation navigoInterpreter

+(NSString *)getAPIKey {
    NSString *result = [[NSString alloc]initWithString:@""];
    return result;
}

+(NSData *)getXMLFileForSearchedItem:(NSString *)query
{
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(query);
    query = [NSString stringWithFormat: @"http://api.winnipegtransit.com/locations:%@?api-key=%@", query, [navigoInterpreter getAPIKey]];
    NSLog(query);
    NSURL *checkURL = [[NSURL alloc]initWithString:query];
    NSData *resultXMLFile = [[NSData alloc]initWithContentsOfURL:checkURL];
    return resultXMLFile;
}//getXMLFileForSearchedItem

+(NSString *)getAddressKeyFromSearchedItem:(NSString *)searchedItem {
    NSData *data = [[NSData alloc]initWithData:[self getXMLFileForSearchedItem:searchedItem]];
    TBXML *theFile = [XMLParser loadXmlDocumentFromData:data];
    TBXMLElement *theElement = [XMLParser getRootElement:theFile];
    TBXMLElement *theElementChild = [XMLParser getUnknownChildElement:theElement];
    theElementChild = [XMLParser extractElementFromParent:@"key" :theElementChild];
    NSString *result = [XMLParser extractAttributeTextFromElement:theElementChild];
#if TARGET_IPHONE_SIMULATOR
    NSLog(result);
#endif
    return result;
}

+(NSData *)getXMLFileFromResults:(NSString *)origin :(NSString *)destination :(NSString *)date :(NSString *)time :(NSString *)mode :(BOOL)easyAccess :(int)walkSpeed :(int)maxWalkTime :(int)minTransferWait :(int)maxTransferWait :(int)maxTransfers
{
    
}//getXMLFileFromResults

@end
