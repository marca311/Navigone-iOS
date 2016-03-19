//
//  MSSuggestions.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-11.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSSuggestions.h"
#import "MSUtilities.h"
#import "apiKeys.h"
#import "TBXML.h"
#import "XMLParser.h"
#import "MSSegment.h"

@implementation MSSuggestions

#pragma mark Querying methods
-(id)initWithQuery:(NSString *)query {
    timeStamp = [NSDate date];
    NSData *xmlData = [MSSuggestions getXMLFileForSearchedItem:query];
    locationArray = [MSSuggestions processLocationsFromData:xmlData];
    return self;
}

+(NSData *)getXMLFileForSearchedItem:(NSString *)query
{
    NSData *resultXMLFile = [[NSData alloc]init];
    do {
        if ([MSUtilities isQueryBlank:query] == YES) return nil;
        else {
            query = [self replaceInvalidCharacters:query];
            query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSString *queryURL = [NSString stringWithFormat: @"http://api.winnipegtransit.com/locations:%@?api-key=%@", query, transitAPIKey];
            NSURL *checkURL = [[NSURL alloc]initWithString:queryURL];
            resultXMLFile = [NSData dataWithContentsOfURL:checkURL];
        }
    } while (resultXMLFile == nil);
    
    return resultXMLFile;
    
}//getXMLFileForSearchedItem

+(NSString *)replaceInvalidCharacters:(NSString *)theString
{
    NSCharacterSet *theSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@- "];
    theSet = [theSet invertedSet];
    theString = [[theString componentsSeparatedByCharactersInSet:theSet ]componentsJoinedByString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"*" withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    return theString;
}

+(NSArray *)processLocationsFromData:(NSData *)theData {
    if ([MSUtilities queryIsError:theData] == YES) {
        NSArray *result = [[NSArray alloc]initWithObjects: nil];
        return result;
    }
    TBXML *xmlFile = [XMLParser loadXmlDocumentFromData:theData];
    TBXMLElement *rootElement = [xmlFile rootXMLElement];
    TBXMLElement *locationElement = [XMLParser extractUnknownChildElement:rootElement];
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    do {
        MSLocation *currentLocation = [MSSegment setLocationTypesFromElement:locationElement];
        [locations addObject:currentLocation];
    } while ((locationElement = locationElement->nextSibling));
    return locations;
}

#pragma mark - Timestamping methods
-(NSDate *)getDate {
    return timeStamp;
}
-(BOOL)isYounger:(MSSuggestions *)otherSuggestions {
    NSDate *youngestDate = [timeStamp laterDate:[otherSuggestions getDate]];
    if ([youngestDate isEqualToDate:timeStamp]) return YES;
    return NO;
}

#pragma mark - Data retreval methods
-(MSLocation *)getLocationAtIndex:(NSUInteger)index {
    return [locationArray objectAtIndex:index];
}
-(NSUInteger)getNumberOfEntries {
    return [locationArray count];
}

#pragma mark - Class methods for the next button and other uses
+(NSArray *)getResultsFromQuery:(NSString *)query {
    NSData *data = [self getXMLFileForSearchedItem:query];
    NSArray *result = [self processLocationsFromData:data];
    return result;
}

@end
