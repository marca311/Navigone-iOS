//
//  SubmitButton.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-07-22.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "SubmitButton.h"

@implementation SubmitButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//Checks the current field that the submit button is on
-(int)checkCurrentLocation
{
    int result;
    CGRect location = self.frame;
    int y = location.origin.y;
    switch (y) {
        case 37:
            result = 1;
            break;
        case 84:
            result = 2;
            break;
        case 170:
            result = 3;
            break;
            
        default:
            result = 5;
            break;
    }
    return result;
}

-(void)nextButtonLocation
{
    int currentField = [self checkCurrentLocation];
    CGRect resultLocation;
    resultLocation = self.frame;
    switch (currentField) {
        case 1:
            resultLocation.origin.y = 86;
            break;
        case 2:
            resultLocation.origin.y = 172;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
