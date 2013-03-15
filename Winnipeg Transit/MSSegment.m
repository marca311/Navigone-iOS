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

+(MSLocation *)setLocationTypesFromElement:(TBXMLElement *)rootElement {
    TBXMLElement *theElement = [XMLParser extractKnownChildElement:@"from" :rootElement];
    TBXMLElement *childElement = [XMLParser extractUnknownChildElement:theElement];
    //if the location is the route origin/destination, go down one more level
    if ([[XMLParser getElementName:childElement] isEqualToString:@"origin"] || [[XMLParser getElementName:childElement] isEqualToString:@"destination"]) {
        childElement = [XMLParser extractUnknownChildElement:childElement];
    }
    NSString *locationType = [XMLParser getElementName:childElement];
    if ([locationType isEqualToString:@"address"]) {
        return [[MSAddress alloc]initWithElement:childElement];
    } else if ([locationType isEqualToString:@"stop"]) {
        return [[MSStop alloc]initWithElement:childElement];
    } else if ([locationType isEqualToString:@"monument"]) {
        return [[MSMonument alloc]initWithElement:childElement];
    } else if ([locationType isEqualToString:@"point"]) {
        return [[MSLocation alloc]initWithElement:childElement];
    } else if ([locationType isEqualToString:@"intersection"]) {
        return [[MSIntersection alloc]initWithElement:childElement];
    }
    return NULL;
}

@end
