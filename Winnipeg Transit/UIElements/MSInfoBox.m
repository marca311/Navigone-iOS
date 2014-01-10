//
//  MSInfoBlock.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSInfoBox.h"
#import "MSLocationButton.h"

@interface MSInfoBox ()

@property (nonatomic, retain) MSLocationButton *originButton;
@property (nonatomic, retain) MSLocationButton *destinationButton;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *modeLabel;

@end

@implementation MSInfoBox

@synthesize originButton, destinationButton, timeLabel, dateLabel, modeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        
        CGRect originButtonFrame = CGRectMake(5, 0, width -5, 40);
        originButton = [[MSLocationButton alloc]initWithFrame:originButtonFrame];
        [originButton.titleLabel setText:@"Origin"];
        [self addSubview:originButton];
        
        CGRect destinationButtonFrame = CGRectMake(5, 50, width, 40);
        destinationButton = [[MSLocationButton alloc]initWithFrame:destinationButtonFrame];
        [destinationButton.titleLabel setText:@"Destination"];
        [self addSubview:destinationButton];
        
        //Creates frame with rounded corners around the view
        CALayer *layer = self.layer;
        layer.backgroundColor = [[UIColor whiteColor]CGColor];
        layer.borderWidth = 2;
        layer.borderColor = [[UIColor whiteColor] CGColor];
        layer.cornerRadius = 10;
        layer.opacity = 0.9;
        layer.masksToBounds = YES;
    }
    return self;
}

-(void)setOriginLocation:(MSLocation *)location {
    [originButton.dataLabel setText:[location getHumanReadable]];
}
-(void)setDestinationLocation:(MSLocation *)location {
    [destinationButton.dataLabel setText:[location getHumanReadable]];
}
-(void)setMode:(NSString *)mode {
    //Nothing yet
}
-(void)setDate:(NSDate *)date {
    //Nothing yet
}

@end
