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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)checkIfIosSeven {
    if ([MSUtilities firmwareIsSevenOrHigher]) {
        firstLocation = 49;
        secondLocation = 96;
        thirdLocation = 182;
    } else {
        firstLocation = 37;
        secondLocation = 84;
        thirdLocation = 170;
    }
}

//Checks the current field that the submit button is on
-(int)checkCurrentLocation
{
    int result;
    [self checkIfIosSeven];
    CGRect location = self.frame;
    int y = location.origin.y;
    if (y == firstLocation) result = 1;
    else if (y == secondLocation) result = 2;
    else if (y == thirdLocation) result = 3;
    else {
        result = 5;
        NSLog(@"Button is in a non standard location");
    }
    return result;
}

-(void)nextButtonLocation
{
    [self checkIfIosSeven];
    int currentField = [self checkCurrentLocation];
    CGRect resultLocation;
    resultLocation = self.frame;
    switch (currentField) {
        case 1:
            resultLocation.origin.y = secondLocation;
            break;
        case 2:
            resultLocation.origin.y = thirdLocation;
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
