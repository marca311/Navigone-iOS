//
//  MSLocationStep.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-22.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSStep.h"
#import "MSLocation.h"

@interface MSLocationStep : MSStep {
    MSLocation *location;
}

-(id)initWithLocation:(MSLocation *)input Time:(NSString *)inputTime;

@end
