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
    MSLocation *origin;
    MSLocation *destination;
    NSDate *date;
    NSUInteger numberOfVariations;
    NSArray *variationArray;
    NSData *rootData;
    TBXMLElement *rootElement;
}

-(id)initWithData:(NSData *)theData andOrigin:(MSLocation *)theOrigin andDestination:(MSLocation *)theDestination;

-(NSUInteger)getNumberOfVariations;

-(NSArray *)getVariations;

-(MSVariation *)getVariationFromIndex:(NSUInteger)index;

@end
