//
//  MSMovingStep.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-22.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSStep.h"
#import "MSLocation.h"

@interface MSMovingStep : MSStep {
    MSLocation *from;
    MSLocation *to;
    NSArray *shapeArray;
}

-(id)initWithFromLocation:(MSLocation *)fromInput ToLocation:(MSLocation *)toInput Text:(NSString *)textInput;

@end
