//
//  MSLocationStep.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-22.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSLocationStep.h"

@implementation MSLocationStep

-(id)initWithLocation:(MSLocation *)input Time:(NSString *)inputTime {
    self = [super init];
    location = input;
    text = [location getHumanReadable];
    time = inputTime;
    return self;
}

@end
