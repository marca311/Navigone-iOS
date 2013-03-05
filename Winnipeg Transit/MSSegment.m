//
//  MSSegment.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSSegment.h"

@implementation MSSegment

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    return self;
}

-(void)setLocationTypes {
    //Only called if segment type is not a ride
    if (![type isEqualToString:@"ride"]) {
        TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"from" :rootElement];
        TBXMLElement *childElement = [XMLParser extractUnknownChildElement:theElement];
        if ([[XMLParser getElementName:childElement] isEqualToString:@"origin"]) {
            childElement = [XMLParser extractUnknownChildElement:childElement];
        }
    }
}

@end
