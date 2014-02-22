//
//  MSResultsView.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2/21/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import "MSResultsView.h"

@interface MSResultsView ()

@property (nonatomic, retain) MSRoute *route;

@end

@implementation MSResultsView

@synthesize route;

- (id)initWithFrame:(CGRect)frame andRoute:(MSRoute *)aRoute
{
    self = [super initWithFrame:frame];
    if (self) {
        route = aRoute;
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
