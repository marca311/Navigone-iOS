//
//  MSMovingStep.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-22.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSMovingStep.h"

@implementation MSMovingStep

-(id)initWithFromLocation:(MSLocation *)fromInput ToLocation:(MSLocation *)toInput Text:(NSString *)textInput {
    self = [super init];
    from = fromInput;
    to = toInput;
    text = textInput;
    return self;
}

@end
