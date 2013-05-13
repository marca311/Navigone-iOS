//
//  MSSegment.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "XMLParser.h"
#import "MSLocation.h"
#import "MSAddress.h"
#import "MSMonument.h"
#import "MSStop.h"
#import "MSIntersection.h"

@interface MSSegment : NSObject {
    NSString *type;
    NSDate *startTime;
    NSDate *endTime;
    int totalTime;        //Usually only two of these time variables are used
    int walkingTime;
    int waitingTime;
    int ridingTime;
    MSLocation *fromLocation;   //Neither MSLocation variables are used if segment is a "ride" segment
    MSLocation *toLocation;
    NSString *busVariation;
    NSString *busNumber;
    NSString *routeName;
    NSString *variationDestination;
    
    TBXMLElement *rootElement;
}

-(id)initWithElement:(TBXMLElement *)theElement;

+(MSLocation *)setLocationTypesFromElement:(TBXMLElement *)rootElement;

-(NSArray *)getHumanReadable;

@end
