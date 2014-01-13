//
//  MSInfoBlock.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSInfoBox.h"
#import "MSLocationButton.h"
#import "MSTimeDateButton.h"
#import "MSUtilities.h"

@interface MSInfoBox ()

@property (nonatomic, retain) MSLocationButton *originButton;
@property (nonatomic, retain) MSLocationButton *destinationButton;
@property (nonatomic, retain) MSTimeDateButton *timeDateButton;

@end

@implementation MSInfoBox

@synthesize originButton, destinationButton, timeDateButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        
        /*
         Maybe make the buttons appear one at a time (on submit button press) or all at once if entry taken from history.
         On a similar note, maybe make the info box not actually show (alpha value) until the origin is submitted.
        */
        
        //Origin button initiation
        CGRect originButtonFrame = CGRectMake(5, 0, width-5, (height/4));
        originButton = [[MSLocationButton alloc]initWithFrame:originButtonFrame];
        [destinationButton addTarget:self action:@selector(originButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [originButton.titleLabel setText:@"Origin"];
        [self addSubview:originButton];
        
        //Destination button initiation
        CGRect destinationButtonFrame = CGRectMake(5, (height/4)+10, width-5, (height/4)-10);
        destinationButton = [[MSLocationButton alloc]initWithFrame:destinationButtonFrame];
        [destinationButton addTarget:self action:@selector(destinationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [destinationButton.titleLabel setText:@"Destination"];
        [self addSubview:destinationButton];
        
        //Time and Date button initiation
        CGRect timeDateButtonFrame = CGRectMake(5, (height/2)+10, width-5, (height/2)-10);
        timeDateButton = [[MSTimeDateButton alloc]initWithFrame:timeDateButtonFrame];
        [timeDateButton addTarget:self action:@selector(timeDateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:timeDateButton];
        
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
-(void)setDate:(NSDate *)date {
    [timeDateButton.timeLabel setText:[MSUtilities getTimeFormatForHuman:date]];
    [timeDateButton.dateLabel setText:[MSUtilities getDateFormatForHuman:date]];
}
-(void)setMode:(NSString *)mode {
    [timeDateButton.modeLabel setText:mode];
}

@end