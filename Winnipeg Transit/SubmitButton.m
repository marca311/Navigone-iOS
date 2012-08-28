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
    int x = location.origin.x;
    int y = location.origin.y;
    switch (x) {
        case 39:
            result = 1;
            break;
        case 86:
            result = 2;
            break;
            
        default:
            result = 7;
            break;
    }
}

-(void)nextButtonLocation
{
    NSInteger *currentField = [self checkCurrentLocation];
    CGRect resultLocation;
    resultLocation = self.frame;
    [UIView beginAnimations:nil context:nil];
    resultLocation.origin.x = 
    
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
