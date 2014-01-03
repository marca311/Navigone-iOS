//
//  MSSeparator.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-12.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSSeparator.h"

@implementation MSSeparator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *fileName = [[NSBundle mainBundle]pathForResource:@"separator" ofType:@"png"];
        UIImage *separator = [[UIImage alloc]initWithContentsOfFile:fileName];
        self.image = separator;
    }
    return self;
}

-(void)moveSeparatorUp {
    CGRect currentPosition = self.frame;
    currentPosition.origin.y = currentPosition.origin.y - 20;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    self.frame = currentPosition;
    [UIView commitAnimations];
}//moveSeparatorUp

@end
