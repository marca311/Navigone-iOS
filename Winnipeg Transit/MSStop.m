//
//  MSStop.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSStop.h"
#import "XMLParser.h"
#import "MSUtilities.h"

@implementation MSStop

-(id)initWithElement:(TBXMLElement *)theElement {
    self = [super initWithElement:theElement];
    [self setStopNumber];
    [self setStopName];
    return self;
}

-(void)setStopNumber {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" RootElement:rootElement];
    stopNumber = [XMLParser getValueFromElement:keyElement];
}
-(void)setStopName {
    TBXMLElement *nameElement = [XMLParser extractKnownChildElement:@"name" RootElement:rootElement];
    stopName = [XMLParser getValueFromElement:nameElement];
    stopName = [MSUtilities fixAmpersand:stopName];
}

//Getter methods
-(NSString *)getHumanReadable {
    return stopName;
}
-(NSString *)getServerQueryable {
    return stopNumber;
}

@end
