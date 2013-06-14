//
//  MSTrip.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-01-29.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "MSVariation.h"

@interface MSRoute : NSObject <NSCoding>
{
    NSString *origin;
    NSString *destination;
    NSDate *date;
    NSUInteger numberOfVariations;
    NSArray *variationArray;
    TBXMLElement *rootElement;
}

-(id)initWithElement:(TBXMLElement *)theElement;

-(NSUInteger)getNumberOfVariations;

-(NSArray *)getVariations;

-(MSVariation *)getVariationFromIndex:(NSUInteger)index;

@end
