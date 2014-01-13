//
//  MSTimeDateButton.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2014-01-11.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTimeDateButton : UIButton

@property (nonatomic, retain) UITextView *timeLabel;
@property (nonatomic, retain) UITextView *dateLabel;
@property (nonatomic, retain) UITextView *modeLabel;

@end
