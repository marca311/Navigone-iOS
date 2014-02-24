//
//  MSPullTabView.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2/24/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import "MSPullTabView.h"
#import "NavigoneViewController.h"

@interface MSPullTabView ()

@property (nonatomic, retain) UIView *parentView;

@end

@implementation MSPullTabView

@synthesize delegate;
@synthesize touchOriginHeight;
@synthesize parentView;

- (id)initWithFrame:(CGRect)frame andParentView:(UIView *)aParentView
{
    self = [super initWithFrame:frame];
    if (self) {
        parentView = aParentView;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate touchesMoved:touches withEvent:event];
}

@end
