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

-(NSData *)getXMLFileForSearchedItem:(NSString *)query
{
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"
    NSURL *checkURL;
    NSData *resultXMLFile = [[NSData alloc]initWithContentsOfURL:<#(NSURL *)#>
}//getXMLFileForSearchedItem

-(NSString *)getAddressKeyFromXMLFile:(NSData *)XMLFile {
    
}

-(NSData *)getXMLFileFromResults:(NSString *)origin :(NSString *)destination :(NSString *)date :(NSString *)time :(NSString *)mode :(BOOL)easyAccess :(int)walkSpeed :(int)maxWalkTime :(int)minTransferWait :(int)maxTransferWait :(int)maxTransfers
{
    
}//getXMLFileFromResults

@end
