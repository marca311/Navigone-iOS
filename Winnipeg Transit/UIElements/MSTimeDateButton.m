//
//  MSTimeDateButton.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2014-01-11.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import "MSTimeDateButton.h"

@interface MSTimeDateButton ()

@property (nonatomic, retain) UILabel *modeTitle;
@property (nonatomic, retain) UILabel *dateTitle;
@property (nonatomic, retain) UILabel *timeTitle;

@end

@implementation MSTimeDateButton

@synthesize timeTitle, timeLabel, dateTitle, dateLabel, modeTitle, modeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float height = frame.size.height;
        float width = frame.size.width;
        
        CGRect timeTitleFrame = CGRectMake(3, 0, width, 12);
        timeTitle = [[UILabel alloc]initWithFrame:timeTitleFrame];
        [timeTitle setFont:[UIFont systemFontOfSize:8]];
        [timeTitle setText:@"Time"];
        [self addSubview:timeTitle];
        
        CGRect timeLabelFrame = CGRectMake(0, 0, width, height/3);
        timeLabel = [[UITextView alloc]initWithFrame:timeLabelFrame];
        [timeLabel setFont:[UIFont systemFontOfSize:10]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setEditable:NO];
        [timeLabel setScrollEnabled:NO];
        [self addSubview:timeLabel];
        
        CGRect dateTitleFrame = CGRectMake(3, height/3, width, 12);
        dateTitle = [[UILabel alloc]initWithFrame:dateTitleFrame];
        [dateTitle setFont:[UIFont systemFontOfSize:8]];
        [dateTitle setText:@"Date"];
        [self addSubview:dateTitle];
        
        CGRect dateLabelFrame = CGRectMake(0, height/3, width, height/3);
        dateLabel = [[UITextView alloc]initWithFrame:dateLabelFrame];
        [dateLabel setFont:[UIFont systemFontOfSize:10]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setEditable:NO];
        [dateLabel setScrollEnabled:NO];
        [self addSubview:dateLabel];
        
        CGRect modeTitleFrame = CGRectMake(3, (height/3)*2, width, 12);
        modeTitle = [[UILabel alloc]initWithFrame:modeTitleFrame];
        [modeTitle setFont:[UIFont systemFontOfSize:8]];
        [modeTitle setText:@"Mode"];
        [self addSubview:modeTitle];
        
        CGRect modeLabelFrame = CGRectMake(0, (height/3)*2, width, height/3);
        modeLabel = [[UITextView alloc]initWithFrame:modeLabelFrame];
        [modeLabel setFont:[UIFont systemFontOfSize:10]];
        [modeLabel setBackgroundColor:[UIColor clearColor]];
        [modeLabel setEditable:NO];
        [modeLabel setScrollEnabled:NO];
        [self addSubview:modeLabel];
    }
    return self;
}

@end