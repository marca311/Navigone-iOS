//
//  MSMonument.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-27.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSMonument.h"
#import "XMLParser.h"
#import "MSUtilities.h"

@implementation MSMonument

-(id)initWithElement:(TBXMLElement *)theElement {
    // Has no location constructor due to the MSAddress handling geographic vars
    rootElement = theElement;
    [self setKey];
    [self setMonumentName];
    [self setMonumentCatagories];
    [self setMonumentAddress];
    [self setHumanReadable];
    return self;
}

-(void)setKey:(NSString *)input {
    NSArray *inputArray = [input componentsSeparatedByString:@"/"];
    key = [inputArray objectAtIndex:1];
    converted = FALSE;
}

-(void)setKey {
    TBXMLElement *keyElement = [XMLParser extractKnownChildElement:@"key" RootElement:rootElement];
    key = [XMLParser getValueFromElement:keyElement];
}
-(void)setMonumentName {
    TBXMLElement *nameElement = [XMLParser extractKnownChildElement:@"name" RootElement:rootElement];
    monumentName = [XMLParser getValueFromElement:nameElement];
}
-(void)setMonumentCatagories {
    NSMutableArray *catagories = [[NSMutableArray alloc]init];
    TBXMLElement *catagoryElement = [XMLParser extractKnownChildElement:@"categories" RootElement:rootElement];
    catagoryElement = [XMLParser extractKnownChildElement:@"category" RootElement:catagoryElement];
    //Get first catagory
    [catagories addObject:[XMLParser getValueFromElement:catagoryElement]];
    //Get catagories til there are no more
    while ((catagoryElement = catagoryElement->nextSibling)) {
        [catagories addObject:[XMLParser getValueFromElement:catagoryElement]];
    }
    monumentCatagories = catagories;
}
-(void)setMonumentAddress {
    TBXMLElement *addressElement = [XMLParser extractKnownChildElement:@"address" RootElement:rootElement];
    monumentAddress = [[MSAddress alloc]initWithElement:addressElement];
}
-(void)setHumanReadable {
    NSString *address = [monumentAddress getHumanReadable];
    NSString *result = [[NSString alloc]initWithFormat:@"%@ (%@)", monumentName, address];
    result = [MSUtilities fixAmpersand:result];
    name = result;
}

//Getter methods
-(NSString *)getHumanReadable {
    return name;
}
-(NSString *)getServerQueryable {
    NSString *result = [[NSString alloc]initWithFormat:@"monuments/%@", key];
    return result;
}

#pragma mark - NSCoding section

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    key = [aDecoder decodeObjectForKey:@"key"];
    monumentName = [aDecoder decodeObjectForKey:@"monumentName"];
    monumentCatagories = [aDecoder decodeObjectForKey:@"monumentCatagories"];
    monumentAddress = [aDecoder decodeObjectForKey:@"monumentAddress"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:key forKey:@"key"];
    [aCoder encodeObject:monumentName forKey:@"monumentName"];
    [aCoder encodeObject:monumentCatagories forKey:@"monumentCatagories"];
    [aCoder encodeObject:monumentAddress forKey:@"monumentAddress"];
}


@end
