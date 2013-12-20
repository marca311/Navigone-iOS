//
//  SubmitButton.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-07-22.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "SubmitButton.h"
#import "MSUtilities.h"

@implementation SubmitButton

-(id)init {
    self = [super init];
    currentLocation = 1;
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        currentLocation = 1;
    }
    return self;
}

//Checks the current field that the submit button is on
-(int)checkCurrentLocation {
    return currentLocation;
}

-(void)nextButtonLocation {
    int currentField = [self checkCurrentLocation];
    CGRect resultLocation;
    resultLocation = self.frame;
    switch (currentField) {
        case 1:
            resultLocation.origin.y += 50;
            currentLocation = 2;
            break;
        case 2:
            resultLocation.origin.y = 50;
            currentLocation = 3;
            break;
        case 3:
            break;
            
        default:
            break;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = resultLocation;
    [UIView commitAnimations];
}

@end
