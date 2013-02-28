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
    NSUInteger variations = 1;
    while (rootElement->nextSibling) {
        variations++;
    }
    numberOfVariations = variations;
    
}

-(void)setVariationArray {
    
}

@end
