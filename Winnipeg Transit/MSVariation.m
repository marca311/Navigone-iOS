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
    theElement = [XMLParser extractKnownChildElement:@"segments" :theElement];
    theElement = [XMLParser extractKnownChildElement:@"segment" :theElement];
    NSUInteger segments = 0;
    while ((theElement = theElement->nextSibling)) {
        segments++;
    }
    numberOfSegments = segments;
}

-(void)setTimes {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"times" :rootElement];
    TBXMLElement *timeElement = [XMLParser extractKnownChildElement:@"total" :workingElement];
    totalTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"walking" :workingElement];
    walkingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"waiting" :workingElement];
    waitingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"walking" :workingElement];
    walkingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"riding" :workingElement];
    ridingTime = [XMLParser getValueFromElement:timeElement];
    timeElement = [XMLParser extractKnownChildElement:@"start" :workingElement];
    startTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:workingElement]];
    timeElement = [XMLParser extractKnownChildElement:@"stop" :workingElement];
    endTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timeElement]];
}

-(void)setSegmentArray {
    NSMutableArray *segments = [[NSMutableArray alloc]init];
    TBXMLElement *theElement = rootElement;
    theElement = [XMLParser extractKnownChildElement:@"segments" :theElement];
    theElement = [XMLParser extractKnownChildElement:@"segment" :theElement];
    for (int i=0; i<numberOfSegments; i++) {
        MSSegment *segment = [[MSSegment alloc]initWithElement:theElement];
        [segments addObject:segment];
    }
    segmentArray = segments;
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
