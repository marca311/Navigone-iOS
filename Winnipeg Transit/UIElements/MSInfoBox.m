//
//  MSInfoBlock.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSInfoBox.h"

@interface MSInfoBox ()

@property (nonatomic, retain) UILabel *originLabel;
@property (nonatomic, retain) UILabel *originInfo;
@property (nonatomic, retain) UILabel *destinationLabel;
@property (nonatomic, retain) UILabel *destinationInfo;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *modeLabel;

@end

@implementation MSInfoBox

@synthesize originLabel, originInfo, destinationLabel, destinationInfo, timeLabel, dateLabel, modeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#warning Remake all the labels into large custom buttons to be clicked and edited.
        CGRect originLabelFrame = CGRectMake(5, 0, 60, 20);
        originLabel = [[UILabel alloc]initWithFrame:originLabelFrame];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
