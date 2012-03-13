//
//  XMLParser.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"
#import "TBXML.h"

@implementation XMLParser

+(TBXML *)loadXmlDocumentFromFile:(NSString *)fileName {
    NSError *error;
    TBXML * tbxmlFile = [TBXML tbxmlWithXMLFile:fileName error:&error];
#if TARGET_IPHONE_SIMULATOR
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    } else {
        NSLog(@"%@", [TBXML elementName:tbxmlFile.rootXMLElement]);
    }
#endif
    return tbxmlFile;
}//loadXmlDocumentFromFile

+(TBXML *)loadXmlDocumentFromData:(NSData *)dataName :(NSString *)fileName{
    //has yet to be implemented
    return nil;
}//loadXmlDocumentFromData

+(TBXMLElement *)getRootElement:(TBXML *)tbxmlName {
    TBXMLElement * rootXMLElement = tbxmlName.rootXMLElement;
    return rootXMLElement;
}//getRootElement

+(TBXMLElement *)extractElementFromParent:(NSString *)elementName :(TBXMLElement *)rootElement {
    TBXMLElement *theElement = [TBXML childElementNamed:elementName parentElement:rootElement];
    return theElement;
}//extractElementFromParent

+(NSString *)extractAttributeFromElement:(TBXMLElement *)element {
    NSString *result;
    result = [TBXML textForElement:element];
    return result;
}//extractAttributeFromElement

@end
