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

+(TBXMLElement *)getRootElement:(TBXML *)tbxmlName {
    TBXMLElement * rootXMLElement = tbxmlName.rootXMLElement;
    return rootXMLElement;
}//getRootElement

+(TBXMLElement *)extractElementFromParent:(NSString *)elementName :(TBXMLElement *)rootElement {
    TBXMLElement *theElement = [TBXML childElementNamed:elementName parentElement:rootElement];
    return theElement;
}//extractElementFromParent

+(TBXMLElement *)getUnknownChildElement:(TBXMLElement *)element {
    TBXMLElement *child;
    NSString *result;
    child = element->firstChild;
    result = [TBXML elementName:element];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", [TBXML elementName:element]);
#endif
    return child;
}

+(NSString *)getUnknownChildElementName:(TBXMLElement *)element {
    TBXMLElement *child;
    NSString *result;
    @try {
        child = element->firstAttribute;
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
        result = [TBXML elementName:element];
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"%@", [TBXML elementName:element]);
#endif
        return result;
    }

}//getUnknownChildElementName

+(NSString *)getUnknownChildElementValue:(TBXMLElement *)element {
    TBXMLElement *child;
    NSString *result;
    child = element->firstAttribute;
    result = [TBXML attributeValue:element];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", [TBXML attributeValue:element]);
#endif
    return result;
}

+(NSString *)extractAttributeTextFromElement:(TBXMLElement *)element {
    NSString *result;
    result = [TBXML textForElement:element];
#if TARGET_IPHONE_SIMULATOR
    if (result == @"") NSLog(@"No Data");
#endif
    return result;
}//extractAttributeFromElement

@end
