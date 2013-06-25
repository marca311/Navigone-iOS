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

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setNumberOfSegments];
    [self setTimes];
    [self setSegmentArray];
    return self;
}

-(void)setNumberOfSegments {
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractKnownChildElement:@"segments" RootElement:theElement];
    theElement = [XMLParser extractKnownChildElement:@"segment" RootElement:theElement];
    NSUInteger segments = 0;
    while ((theElement = theElement->nextSibling)) {
        segments++;
    }
    numberOfSegments = segments;
}

-(void)setTimes {
    TBXMLElement *timesElement = [XMLParser extractKnownChildElement:@"times" RootElement:rootElement];
    TBXMLElement *durationsElement = [XMLParser extractKnownChildElement:@"durations" RootElement:timesElement];
    TBXMLElement *timeElement = [XMLParser extractKnownChildElement:@"total" RootElement:durationsElement];
    totalTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"walking" RootElement:durationsElement];
    walkingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"waiting" RootElement:durationsElement];
    waitingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"walking" RootElement:durationsElement];
    walkingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"riding" RootElement:durationsElement];
    ridingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"start" RootElement:timesElement];
    startTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timesElement]];
    timeElement = [XMLParser extractKnownChildElement:@"stop" RootElement:timesElement];
    endTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timesElement]];
}

-(void)setSegmentArray {
    NSMutableArray *segments = [[NSMutableArray alloc]init];
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractKnownChildElement:@"segments" RootElement:theElement];
    theElement = [XMLParser extractKnownChildElement:@"segment" RootElement:theElement];
    for (int i=0; i<numberOfSegments; i++) {
        MSSegment *segment = [[MSSegment alloc]initWithElement:theElement];
        [segments addObject:segment];
    }
    segmentArray = segments;
}

-(NSString *)getStartTime {
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"HH:mm"];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",[serverFormat stringFromDate:startTime]];
    return result;
}
-(NSString *)getEndTime {
    NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
    [serverFormat setDateFormat:@"HH:mm"];
    NSString *result = [[NSString alloc]initWithFormat:@"%@",[serverFormat stringFromDate:endTime]];
    return result;
}
-(NSString *)getBuses {
    NSString *result;
    NSMutableArray *busList = [[NSMutableArray alloc]init];
    //Goes through list of segments and gets ride segments
    for (MSSegment *segment in segmentArray) {
        if ([[segment getType] isEqualToString:@"ride"]) {
            //Add bus number to array
            [busList addObject:[segment getBusNumber]];
        }
    }
    //Turn array into string
    result = [busList description];
    //Improve readability of results
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"( " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"   " withString:@""];
    return result;
}

#pragma mark - Getter methods
-(MSSegment *)getSegmentAtIndex:(NSUInteger)index {
    return [segmentArray objectAtIndex:index];
}
-(NSArray *)getHumanReadable {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int i = 0; i < numberOfSegments; i++) {
        NSArray *currentSegement = [segmentArray objectAtIndex:i];
        for (int x = 0; x < [currentSegement count]; x++) {
            [result addObject:[currentSegement objectAtIndex:x]];
        }
    }
    return result;
}

@end
