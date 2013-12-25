//
//  MSTopBar.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSTopBar.h"
#import "MSSuggestionBox.h"

@implementation MSTopBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //float height = self.frame.size.height;
        float width = self.frame.size.width;
        
        CGRect labelFrame = CGRectMake(5, 3, width / 2, 20);
        label = [[UILabel alloc]initWithFrame:labelFrame];
        label.font = [label.font fontWithSize:11];
        label.text = @"Origin";
        [self addSubview:label];
        
        CGRect textFieldFrame = CGRectMake(5, 20, ((width / 4) * 3), 25);
        textField = [[UITextField alloc]initWithFrame:textFieldFrame];
        textField.delegate = self;
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:textField];
        
        submitButton = [[UIButton alloc]initWithFrame:CGRectMake(((width/4)*3)+6, 20, (width/4)-12, 25)];
        [submitButton setTitle:@"Next" forState:UIControlStateNormal];
        //submitButton addTarget:NULL action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>] This needs to do something
        [self addSubview:submitButton];
        
        //Sets a black border (with rounded corners) around the view
        CALayer *layer = self.layer;
        layer.backgroundColor = [[UIColor whiteColor] CGColor];
        layer.borderWidth = 2;
        layer.borderColor = [[UIColor blackColor] CGColor];
        layer.cornerRadius = 10;
        layer.masksToBounds = YES;
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    MSSuggestionBox *suggestionBox = [[MSSuggestionBox alloc]initWithFrameFromField:textField];
    [self addSubview:suggestionBox.view];
    [suggestionBox generateSuggestions:textField.text];
}



@end
