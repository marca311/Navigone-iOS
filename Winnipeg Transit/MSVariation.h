//
//  MSVariation.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "XMLParser.h"
#import "MSSegment.h"

@interface MSVariation : NSObject {
    Boolean easyAccess;
    NSDate *startTime;
    NSDate *endTime;
    NSString *totalTime;
    NSString *walkingTime;
    NSString *waitingTime;
    NSString *ridingTime;
    
    TBXMLElement *rootElement;
    NSUInteger numberOfSegments;
    NSArray *segmentArray;
}

-(id)initWithElement:(TBXMLElement *)theElement;

@end
