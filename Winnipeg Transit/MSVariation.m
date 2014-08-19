//
//  MSVariation.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSVariation.h"
#import "MSUtilities.h"

@implementation MSVariation

- (id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setNumberOfSegments];
    [self setTimes];
    [self setSegmentArray];
    return self;
}

#pragma mark - Setter methods

- (void)setNumberOfSegments {
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractKnownChildElement:@"segments" RootElement:theElement];
    theElement = [XMLParser extractKnownChildElement:@"segment" RootElement:theElement];
    NSUInteger segments = 1;
    while ((theElement = theElement->nextSibling)) {
        segments++;
    }
    numberOfSegments = segments;
}

- (void)setTimes {
    TBXMLElement *timesElement = [XMLParser extractKnownChildElement:@"times" RootElement:rootElement];
    TBXMLElement *durationsElement = [XMLParser extractKnownChildElement:@"durations" RootElement:timesElement];
    TBXMLElement *timeElement = [XMLParser extractKnownChildElement:@"total" RootElement:durationsElement];
    totalTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"walking" RootElement:durationsElement];
    if (timeElement != NULL) walkingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"waiting" RootElement:durationsElement];
    if (timeElement != NULL) waitingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"walking" RootElement:durationsElement];
    if (timeElement != NULL) walkingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"riding" RootElement:durationsElement];
    if (timeElement != NULL) ridingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"start" RootElement:timesElement];
    startTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timeElement]];
    timeElement = [XMLParser extractKnownChildElement:@"end" RootElement:timesElement];
    endTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timeElement]];
}

- (void)setSegmentArray {
    NSMutableArray *segments = [[NSMutableArray alloc]init];
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractKnownChildElement:@"segments" RootElement:theElement];
    theElement = [XMLParser extractKnownChildElement:@"segment" RootElement:theElement];
    for (int i=0; i<numberOfSegments; i++) {
        MSSegment *segment = [[MSSegment alloc]initWithElement:theElement];
        [segments addObject:segment];
        if (i < numberOfSegments) theElement = theElement->nextSibling;
    }
    segmentArray = segments;
}

- (void)setSegmentArray:(NSArray *)input {
    segmentArray = input;
}

#pragma mark - Getter methods

- (NSInteger)getNumberOfSegments {
    return [segmentArray count];
}
- (NSArray *)getSegmentArray {
    return segmentArray;
}
- (NSString *)getTotalTime {
    return totalTime;
}
- (NSString *)getWalkingTime {
    return walkingTime;
}
- (NSString *)getStartTime {
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"HH:mm"];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",[serverFormat stringFromDate:startTime]];
    return result;
}
- (NSString *)getEndTime {
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"HH:mm"];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",[serverFormat stringFromDate:endTime]];
    return result;
}
- (NSString *)getBuses {
    NSString *result;
    NSMutableArray *busList = [[NSMutableArray alloc]init];
    //Goes through list of segments and gets ride segments
    for (int i = 0; i < [segmentArray count]; i++) {
        MSSegment *segment = [segmentArray objectAtIndex:i];
        if ([[segment getType] isEqualToString:@"ride"]) {
            //Add bus number to array
            [busList addObject:[segment getBusNumber]];
        }
    }
    //Checks to see if there are buses in the variation, if there aren't then it returns "Walking Route"
    if (busList.count == 0) return @"Walking Route";
    //Turn array into string
    result = [busList description];
    //Improve readability of results
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"( " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"   " withString:@""];
    return result;
}

- (MSSegment *)getSegmentAtIndex:(NSUInteger)index {
    return [segmentArray objectAtIndex:index];
}
- (NSArray *)getHumanReadable {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int i = 0; i < numberOfSegments; i++) {
        NSArray *currentSegement = [[segmentArray objectAtIndex:i]getHumanReadable];
        for (int x = 0; x < [currentSegement count]; x++) {
            [result addObject:[currentSegement objectAtIndex:x]];
        }
    }
    return result;
}

@end
