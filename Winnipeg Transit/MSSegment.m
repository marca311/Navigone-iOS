//
//  MSSegment.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSSegment.h"
#import "MSUtilities.h"

@implementation MSSegment

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setSegment];
    return self;
}

-(void)setSegment {
    //settype
    //settimes
    if ([type isEqualToString:@"ride"]) {
        
    }
    //else setlocations
}
-(void)setType {
    type = [XMLParser getKnownAttributeData:@"type" :rootElement];
}

-(void)setTimes {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"times" :rootElement];
    TBXMLElement *timeElement = [XMLParser extractKnownChildElement:@"total" :workingElement];
    totalTime = [[XMLParser getValueFromElement:timeElement] intValue];
    if ([type isEqualToString:@"walk"]) {
        timeElement = [XMLParser extractKnownChildElement:@"walking" :workingElement];
        walkingTime = [[XMLParser getValueFromElement:timeElement] intValue];
    } else if ([type isEqualToString:@"transfer"]) {
        timeElement = [XMLParser extractKnownChildElement:@"waiting" :workingElement];
        waitingTime = [[XMLParser getValueFromElement:timeElement] intValue];
        timeElement = [XMLParser extractKnownChildElement:@"walking" :workingElement];
        walkingTime = [[XMLParser getValueFromElement:timeElement] intValue];
    } else if ([type isEqualToString:@"ride"]) {
        timeElement = [XMLParser extractKnownChildElement:@"riding" :workingElement];
        ridingTime = [[XMLParser getValueFromElement:timeElement] intValue];
    }
    timeElement = [XMLParser extractKnownChildElement:@"start" :workingElement];
    startTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:workingElement]];
    timeElement = [XMLParser extractKnownChildElement:@"stop" :workingElement];
    endTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timeElement]];
}

-(void)setLocations {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"from" :rootElement];
    fromLocation = [MSSegment setLocationTypesFromElement:workingElement];
    workingElement = [XMLParser extractKnownChildElement:@"to" :rootElement];
    toLocation = [MSSegment setLocationTypesFromElement:workingElement];
}

//This method is accessed in other classes
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

-(void)setBusVariation {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"variant" :rootElement];
    workingElement = [XMLParser extractKnownChildElement:@"key" :workingElement];
    busVariation = [XMLParser getValueFromElement:workingElement];
}
-(void)setBusNumber {
    NSArray *stringArray = [busVariation componentsSeparatedByString:@"-"];
    busNumber = [stringArray objectAtIndex:0];
}
-(void)setRouteName {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"variant" :rootElement];
    workingElement = [XMLParser extractKnownChildElement:@"name" :workingElement];
    NSString *fullString = [XMLParser getValueFromElement:workingElement];
    NSArray *stringArray = [fullString componentsSeparatedByString:@" to "];
    routeName = [stringArray objectAtIndex:0];
}
-(void)setVariationDestination {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"variant" :rootElement];
    workingElement = [XMLParser extractKnownChildElement:@"name" :workingElement];
    NSString *fullString = [XMLParser getValueFromElement:workingElement];
    NSArray *stringArray = [fullString componentsSeparatedByString:@" to "];
    variationDestination = [stringArray objectAtIndex:1];
}

//Getter method
-(NSArray *)getHumanReadable {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    if ([type isEqualToString:@"walk"]) {
        [result addObject:[fromLocation getHumanReadable]];
        NSString *middleString = [NSString stringWithFormat:@"Walk %i%@",walkingTime,[MSUtilities getMinutePlural:walkingTime]];
        [result addObject:middleString];
        [result addObject:[toLocation getHumanReadable]];
    } else if ([type isEqualToString:@"transfer"]) {
        if ((walkingTime > 0) && (waitingTime == 0)) {
            [result addObject:[fromLocation getHumanReadable]];
            NSString *middleString = [NSString stringWithFormat:@"Walk %i%@",walkingTime,[MSUtilities getMinutePlural:walkingTime]];
            [result addObject:middleString];
            [result addObject:[toLocation getHumanReadable]];
        } else if ((waitingTime > 0) && (walkingTime == 0)) {
            NSString *waitString = [NSString stringWithFormat:@"Wait %i%@ at %@",waitingTime,[MSUtilities getMinutePlural:waitingTime],[toLocation getHumanReadable]];
            [result addObject:waitString];
        } else if ((waitingTime > 0) && (walkingTime > 0)) {
            [result addObject:[fromLocation getHumanReadable]];
            NSString *walkString = [NSString stringWithFormat:@"Walk %i%@",walkingTime,[MSUtilities getMinutePlural:walkingTime]];
            [result addObject:walkString];
            NSString *waitString = [NSString stringWithFormat:@"Wait %i%@ at %@",waitingTime,[MSUtilities getMinutePlural:waitingTime],[toLocation getHumanReadable]];
            [result addObject:waitString];
        }
    } else if ([type isEqualToString:@"ride"]) {
        NSString *rideString = [NSString stringWithFormat:@"Ride %@ %@ (%@)",busNumber,routeName,variationDestination];
        [result addObject:rideString];
    }
    return result;
}
@end
