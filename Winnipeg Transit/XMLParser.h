//
//  XMLParser.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-03.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface XMLParser : NSObject 

//Loading methods
+(TBXML *)loadXmlDocumentFromFile:(NSString *)fileName;
+(TBXML *)loadXmlDocumentFromData:(NSData *)dataName;

//Getting root element
+(TBXMLElement *)getRootElement:(TBXML *)tbxmlName;

//Navigation Methods
+(TBXMLElement *)extractKnownChildElement:(NSString *)elementName:(TBXMLElement *)rootElement;
+(TBXMLElement *)extractUnknownChildElement:(TBXMLElement *)element;
+(TBXMLAttribute *)extractAttribute:(TBXMLElement *)element;

//Getting data Methods
+(NSString *)getElementName:(TBXMLElement *)element;
+(NSString *)getValueFromElement:(TBXMLElement *)element;
+(NSString *)getAttributeValue:(TBXMLAttribute *)attribute;

@end
