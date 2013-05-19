//
//  MSMonument.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSMonument.h"
#import "XMLParser.h"

@implementation MSMonument

-(id)initWithElement:(TBXMLElement *)theElement {
    // Has no location constructor due to the MSAddress handling geographic vars
    rootElement = theElement;
    [self setKey];
    [self setMonumentName];
    [self setMonumentCatagories];
    [self setMonumentAddress];
    return self;
}

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" :rootElement];
    key = [XMLParser getValueFromElement:keyElement];
}
-(void)setMonumentName {
    TBXMLElement *nameElement = [XMLParser extractKnownChildElement:@"name" :rootElement];
    monumentName = [XMLParser getValueFromElement:nameElement];
}
-(void)setMonumentCatagories {
    NSMutableArray *catagories = [[NSMutableArray alloc]init];
    TBXMLElement *catagoryElement = [XMLParser extractKnownChildElement:@"categories" :rootElement];
    catagoryElement = [XMLParser extractKnownChildElement:@"category" :catagoryElement];
    //Get first catagory
    [catagories addObject:[XMLParser getValueFromElement:catagoryElement]];
    //Get catagories til there are no more
    while ((catagoryElement = catagoryElement->nextSibling)) {
        [catagories addObject:[XMLParser getValueFromElement:catagoryElement]];
    }
    monumentCatagories = catagories;
}
-(void)setMonumentAddress {
    TBXMLElement *addressElement = [XMLParser extractKnownChildElement:@"address" :rootElement];
    monumentAddress = [[MSAddress alloc]initWithElement:addressElement];
}

//Getter methods
-(NSString *)getHumanReadable {
    NSString *address = [monumentAddress getHumanReadable];
    NSString *result = [[NSString alloc]initWithFormat:@"%@ (%@)", monumentName, address];
    return result;
}
-(NSString *)getServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"monuments/%@", key];
    return result;
}

@end
