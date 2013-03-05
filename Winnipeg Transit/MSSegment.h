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

@interface MSSegment : NSObject {
    NSString *type;
    NSDate *startTime;
    NSDate *endTime;
    NSString *totalTime;        //Usually only two of these time variables are used
    NSString *walkingTime;
    NSString *waitingTime;
    NSString *ridingTime;
    //MSLocation *fromLocation;   //Neither MSLocation variables are used if segment is a "ride" segment
    //MSLocation *toLocation;
    
    TBXMLElement *rootElement;
}

-(id)initWithElement:(TBXMLElement *)theElement;

@end
