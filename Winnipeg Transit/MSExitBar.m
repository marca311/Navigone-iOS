//
//  MSExitBar.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-29.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSExitBar.h"

@implementation MSExitBar

@synthesize theResponder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(MSExitBar *)initToView:(UIView *)parentView withParentResponder:(id)responder
{
    self = [[MSExitBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, parentView.frame.size.width, 44.0f)];
	self.tintColor = [UIColor darkGrayColor];
	theResponder = responder;
	NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(killSender:)];
	[items addObject:doneButton];
	self.items = items;	
	
	return self;
}

-(IBAction)killSender:(id)sender
{
    [theResponder resignFirstResponder];
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
