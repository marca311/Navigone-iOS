//
//  MSLocationButton.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 1/5/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import "MSLocationButton.h"

@implementation MSLocationButton

@synthesize titleLabel, dataLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = frame.size.height;
        float width = frame.size.width;
        
        CGRect titleLabelFrame = CGRectMake(3, 0, width, 12);
        titleLabel = [[UILabel alloc]initWithFrame:titleLabelFrame];
        [titleLabel setFont:[UIFont systemFontOfSize:8]];
        [self addSubview:titleLabel];
        
        CGRect dataLabelFrame = CGRectMake(0, 0, width, height);
        dataLabel = [[UITextView alloc]initWithFrame:dataLabelFrame];
        [dataLabel setFont:[UIFont systemFontOfSize:10]];
        [dataLabel setBackgroundColor:[UIColor clearColor]];
        [dataLabel setEditable:NO];
        [dataLabel setScrollEnabled:NO];
        [self addSubview:dataLabel];
        
        //Test frame to show boundaries of button
        /*
        CALayer *layer = self.layer;
        layer.borderWidth = 2;
        layer.borderColor = [[UIColor blackColor] CGColor];
        layer.opacity = 0.9;
        layer.masksToBounds = YES; */
    }
    return self;
}

@end
