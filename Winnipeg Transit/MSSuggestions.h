//
//  MSSuggestions.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-11.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSLocation.h"

@interface MSSuggestions : NSObject <NSCoding> {
    NSArray *locationArray;
    NSDate *timeStamp;
}

//Data querying method
-(id)initWithQuery:(NSString *)query;

//Timestamping methods
-(NSDate *)getDate;
-(BOOL)isYounger:(MSSuggestions *)otherSuggestions;

//Retrieving Data
-(MSLocation *)getLocationAtIndex:(NSUInteger)index;
-(NSUInteger)getNumberOfEntries;

//Class methods for the next button and other uses
+(NSArray *)getResultsFromQuery:(NSString *)query;

@end
