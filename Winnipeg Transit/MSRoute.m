//
//  MSTrip.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-01-29.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSRoute.h"

@implementation MSRoute

-(id)initWithElement:(TBXMLElement *)theElement {
    rootElement = theElement;
    [self setNumberOfVariations];
    return self;
}

-(void)setOrigin {
    //code to set origin
}

-(void)setDestination {
    //code to set destination
}

-(void)setDate {
    
}

-(void)setNumberOfVariations {
    TBXMLElement *theElement = rootElement;
    NSUInteger variations = 1;
    while ((theElement = theElement->nextSibling)) {
        variations++;
    }
    numberOfVariations = variations;
    
}

-(void)setVariationArray {
    TBXMLElement *theElement = rootElement;
    NSMutableArray *variations = [[NSMutableArray alloc]init];
    for (int i=0; i < numberOfVariations; i++) {
        MSVariation *variation = [[MSVariation alloc]initWithElement:theElement];
        [variations addObject:variation];
    }
    variationArray = variations;
}

@end
