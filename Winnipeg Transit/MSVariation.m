//
//  MSVariation.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSVariation.h"

@implementation MSVariation

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
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

@end
