//
//  XMLParser.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface XMLParser : NSObject {
    BOOL easyAccess;
    NSString *startTime;
    NSString *endTime;
    NSNumber *totalTime;
    NSNumber *walkingTime;
    NSNumber *waitingTime;
    NSNumber *ridingTime;
    NSString *segmentType;
    NSString *segmentStartTime;
    NSString *segmentEndTime;
    
}

+(TBXML *)loadXmlDocumentFromFile:(NSString *)fileName;
+(TBXML *)loadXmlDocumentFromData:(NSData *)dataName:(NSString *)fileName;
+(TBXMLElement *)getRootElement:(TBXML *)tbxmlName;
+(TBXMLElement *)extractElementFromParent:(NSString *)elementName:(TBXMLElement *)rootElement;
+(NSString *)extractAttributeFromElement:(TBXMLElement *)element;

                                           

@end
