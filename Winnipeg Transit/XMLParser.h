//
//  XMLParser.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-03.
//  Copyright (c) 2012 marca311. All rights reserved.
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
+(TBXML *)loadXmlDocumentFromData:(NSData *)dataName;
+(TBXMLElement *)getRootElement:(TBXML *)tbxmlName;
+(TBXMLElement *)extractElementFromParent:(NSString *)elementName:(TBXMLElement *)rootElement;
+(TBXMLElement *)getUnknownChildElement:(TBXMLElement *)element;
+(NSString *)getUnknownChildElementName:(TBXMLElement *)element;
+(NSString *)getUnknownChildElementValue:(TBXMLElement *)element;
+(NSString *)extractAttributeTextFromElement:(TBXMLElement *)element;

                                           

@end
