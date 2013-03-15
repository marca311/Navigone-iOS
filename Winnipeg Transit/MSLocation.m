//
//  MSLocation.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSLocation.h"
#import "XMLParser.h"

@implementation MSLocation

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setCoordinates];
    return self;
}

-(void)setCoordinates {
    TBXMLElement *centreElement = [XMLParser extractKnownChildElement:@"centre" :rootElement];
    centreElement = [XMLParser extractKnownChildElement:@"geographic" :centreElement];
    TBXMLElement *childElement = [XMLParser extractKnownChildElement:@"latitude" :centreElement];
    latitude = [XMLParser getValueFromElement:childElement];
    childElement = [XMLParser extractKnownChildElement:@"longitude" :centreElement];
    longitude = [XMLParser getValueFromElement:childElement];
}

@end
