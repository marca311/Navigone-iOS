//
//  MSSuggestionBox.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSSuggestionBox.h"

@implementation MSSuggestionBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrameFromField:(UITextField *)textField
{
    CGRect theFrame;
    theFrame.origin.x = textField.frame.origin.x;
    theFrame.origin.y = (textField.frame.origin.y + textField.frame.size.height);
    
    theFrame.size.width = textField.frame.size.width;
    theFrame.size.height = 20;
    
    self.frame = theFrame;
    return self;
}

-(void)changeSizeFromEntries:(NSArray *)array
{
    int sizeOfCell = 40;
    int numberOfEntries = [array count];
    CGRect theFrame = self.frame;
    theFrame.size.height = (numberOfEntries * sizeOfCell) + sizeOfCell;
    self.frame = theFrame;
    [self reloadData];
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
