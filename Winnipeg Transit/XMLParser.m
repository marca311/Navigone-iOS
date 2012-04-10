//
//  XMLParser.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-03.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "XMLParser.h"
#import "TBXML.h"

@implementation XMLParser

#pragma mark - Loading Methods

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

+(TBXML *)loadXmlDocumentFromData:(NSData *)dataName {
    NSError *error;
    TBXML * tbxml = [TBXML tbxmlWithXMLData:dataName error:&error];
#if TARGET_IPHONE_SIMULATOR
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    } else {
        NSLog(@"%@", [TBXML elementName:tbxml.rootXMLElement]);
    }
#endif
    return tbxml;
}//loadXmlDocumentFromData

#pragma mark - Getting root element

+(TBXMLElement *)getRootElement:(TBXML *)tbxmlName {
    TBXMLElement * rootXMLElement = tbxmlName.rootXMLElement;
    return rootXMLElement;
}//getRootElement

#pragma mark - Navigation Methods

+(TBXMLElement *)extractKnownChildElement:(NSString *)elementName :(TBXMLElement *)rootElement {
    TBXMLElement *theElement = [TBXML childElementNamed:elementName parentElement:rootElement];
    return theElement;
}//extractElementFromParent

+(TBXMLElement *)extractUnknownChildElement:(TBXMLElement *)element {
    TBXMLElement *child;
    NSString *result;
    if (element == nil) {
        return nil;
    }
    child = element->firstChild;
    result = [TBXML elementName:element];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", [TBXML elementName:element]);
#endif
    return child;
}

+(TBXMLAttribute *)extractAttribute:(TBXMLElement *)element
{
    TBXMLAttribute *result = element->firstAttribute;
    return result;
}//extractAttribute

#pragma mark - Retrieving value Methods

+(NSString *)getElementName:(TBXMLElement *)element {
    NSString *result;
    if (element == nil) {
        return nil;
    }
    result = [TBXML elementName:element];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", [TBXML elementName:element]);
#endif
    return result;
}//getUnknownChildElementName

+(NSString *)getValueFromElement:(TBXMLElement *)element {
    NSString *result;
    result = [TBXML textForElement:element];
#if TARGET_IPHONE_SIMULATOR
    if (result == @"") NSLog(@"No Data");
#endif
    return result;
}//getElementFromElement

+(NSString *)getAttributeValue:(TBXMLAttribute *)attribute {
    NSString *result;
    result = [TBXML attributeValue:attribute];
#if TARGET_IPHONE_SIMULATOR
    NSLog(result);
#endif
    return result;
}

@end
