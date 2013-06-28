//
//  MSSegment.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSSegment.h"
#import "MSUtilities.h"
#import "MSLocationStep.h"
#import "MSMovingStep.h"

@implementation MSSegment

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setSegment];
    return self;
}

-(void)setSegment {
    [self setType];
    [self setTimes];
    if ([type isEqualToString:@"ride"]) {
        [self setBusVariant];
        [self setBusNumber];
        [self setRouteName];
        [self setVariantDestination];
    } else {
        [self setLocations];
    }
}
-(void)setType {
    type = [XMLParser getKnownAttributeData:@"type" Element:rootElement];
}

-(void)setTimes {
    TBXMLElement *timesElement = [XMLParser extractKnownChildElement:@"times" RootElement:rootElement];
    TBXMLElement *durationsElement = [XMLParser extractKnownChildElement:@"durations" RootElement:timesElement];
    TBXMLElement *timeElement = [XMLParser extractKnownChildElement:@"total" RootElement:durationsElement];
    totalTime = [[XMLParser getValueFromElement:timeElement] intValue];
    if ([type isEqualToString:@"walk"]) {
        timeElement = [XMLParser extractKnownChildElement:@"walking" RootElement:durationsElement];
        walkingTime = [[XMLParser getValueFromElement:timeElement] intValue];
    } else if ([type isEqualToString:@"transfer"]) {
        timeElement = [XMLParser extractKnownChildElement:@"waiting" RootElement:durationsElement];
        waitingTime = [[XMLParser getValueFromElement:timeElement] intValue];
        timeElement = [XMLParser extractKnownChildElement:@"walking" RootElement:durationsElement];
        walkingTime = [[XMLParser getValueFromElement:timeElement] intValue];
    } else if ([type isEqualToString:@"ride"]) {
        timeElement = [XMLParser extractKnownChildElement:@"riding" RootElement:durationsElement];
        ridingTime = [[XMLParser getValueFromElement:timeElement] intValue];
    }
    timeElement = [XMLParser extractKnownChildElement:@"start" RootElement:timesElement];
    startTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timesElement]];
    timeElement = [XMLParser extractKnownChildElement:@"stop" RootElement:timesElement];
    endTime = [MSUtilities getDateFromServerString:[XMLParser getValueFromElement:timesElement]];
}

-(void)setLocations {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"from" RootElement:rootElement];
    fromLocation = [MSSegment setLocationTypesFromElement:workingElement];
    workingElement = [XMLParser extractKnownChildElement:@"to" RootElement:rootElement];
    toLocation = [MSSegment setLocationTypesFromElement:workingElement];
}

//This method is accessed in other classes
+(MSLocation *)setLocationTypesFromElement:(TBXMLElement *)rootElement {
    TBXMLElement *childElement = rootElement;
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

-(void)setBusVariant {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"variant" RootElement:rootElement];
    workingElement = [XMLParser extractKnownChildElement:@"key" RootElement:workingElement];
    busVariant = [XMLParser getValueFromElement:workingElement];
}
-(void)setBusNumber {
    NSArray *stringArray = [busVariant componentsSeparatedByString:@"-"];
    busNumber = [stringArray objectAtIndex:0];
}
-(void)setRouteName {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"variant" RootElement:rootElement];
    workingElement = [XMLParser extractKnownChildElement:@"name" RootElement:workingElement];
    NSString *fullString = [XMLParser getValueFromElement:workingElement];
    NSArray *stringArray = [fullString componentsSeparatedByString:@" to "];
    routeName = [stringArray objectAtIndex:0];
}
-(void)setVariantDestination {
    TBXMLElement *workingElement = [XMLParser extractKnownChildElement:@"variant" RootElement:rootElement];
    workingElement = [XMLParser extractKnownChildElement:@"name" RootElement:workingElement];
    NSString *fullString = [XMLParser getValueFromElement:workingElement];
    NSArray *stringArray = [fullString componentsSeparatedByString:@" to "];
    variantDestination = [stringArray objectAtIndex:1];
}

//Getter methods
-(NSString *)getType {
    return type;
}
-(NSString *)getBusNumber {
    return busNumber;
}
-(NSArray *)getHumanReadable {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    if ([type isEqualToString:@"walk"]) {
        [result addObject:[[MSLocationStep alloc]initWithLocation:fromLocation Time:[MSUtilities getTimeFormatForServer:startTime]]];
        NSString *middleString = [NSString stringWithFormat:@"Walk %i%@",walkingTime,[MSUtilities getMinutePlural:walkingTime]];
        [result addObject:[[MSMovingStep alloc]initWithFromLocation:fromLocation ToLocation:toLocation Text:middleString]];
        [result addObject:[[MSLocationStep alloc]initWithLocation:toLocation Time:[MSUtilities getTimeFormatForServer:endTime]]];
    } else if ([type isEqualToString:@"transfer"]) {
        if ((walkingTime > 0) && (waitingTime == 0)) {
            [result addObject:[[MSLocationStep alloc]initWithLocation:fromLocation Time:[MSUtilities getTimeFormatForServer:startTime]]];
            NSString *middleString = [NSString stringWithFormat:@"Walk %i%@",walkingTime,[MSUtilities getMinutePlural:walkingTime]];
            [result addObject:[[MSMovingStep alloc]initWithFromLocation:fromLocation ToLocation:toLocation Text:middleString]];
            [result addObject:[[MSLocationStep alloc]initWithLocation:toLocation Time:[MSUtilities getTimeFormatForServer:endTime]]];
        } else if ((waitingTime > 0) && (walkingTime == 0)) {
            NSString *waitString = [NSString stringWithFormat:@"Wait %i%@ at %@",waitingTime,[MSUtilities getMinutePlural:waitingTime],[toLocation getHumanReadable]];
            [result addObject:[[MSMovingStep alloc]initWithFromLocation:fromLocation ToLocation:toLocation Text:waitString]];
        } else if ((waitingTime > 0) && (walkingTime > 0)) {
            [result addObject:[fromLocation getHumanReadable]];
            NSString *walkString = [NSString stringWithFormat:@"Walk %i%@",walkingTime,[MSUtilities getMinutePlural:walkingTime]];
            [result addObject:[[MSMovingStep alloc]initWithFromLocation:fromLocation ToLocation:toLocation Text:walkString]];
            NSString *waitString = [NSString stringWithFormat:@"Wait %i%@ at %@",waitingTime,[MSUtilities getMinutePlural:waitingTime],[toLocation getHumanReadable]];
            [result addObject:[[MSMovingStep alloc]initWithFromLocation:fromLocation ToLocation:toLocation Text:waitString]];
        }
    } else if ([type isEqualToString:@"ride"]) {
        NSString *rideString = [NSString stringWithFormat:@"Ride %@ %@ (%@)",busNumber,routeName,variantDestination];
        [result addObject:[[MSMovingStep alloc]initWithFromLocation:fromLocation ToLocation:toLocation Text:rideString]];
    }
    //Returns an array with MSStep subclass intstance(s)
    return result;
}
@end
