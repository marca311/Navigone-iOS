//
//  MSTopBar.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "apiKeys.h"
#import "MSTopBar.h"
#import "MSSegment.h"
#import "MSSuggestions.h"
#import "MSTextFieldCell.h"
#import "MSUtilities.h"
#import "XMLParser.h"

@interface MSTopBar ()

@property (nonatomic)     id <TopBarDelegate> topBarDelegate;

@property (nonatomic, retain) MSSuggestions *suggestions;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *submitButton;

@property (nonatomic, retain) MSSuggestionBox *suggestionBox;

@end

@implementation MSTopBar

@synthesize topBarDelegate, suggestions, label, textField, submitButton, suggestionBox;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //Set up the label frame and settings
        CGRect labelFrame = CGRectMake(5, 0, 280, 20);
        label = [[UILabel alloc]initWithFrame:labelFrame];
        [label setFont:[UIFont fontWithName:@"System" size:14]]; //Set to the system font size 14
        [label setText:@"Origin"];
        [self addSubview:label];
        
        //Set up the text field frame and settings
        CGRect textFieldFrame = CGRectMake(5, 25, 220, 30);
        textField = [[UITextField alloc]initWithFrame:textFieldFrame];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [textField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        textField.delegate = self;
        [self addSubview:textField];
        
        //Set up the submit button frame and settings
        CGRect submitButtonFrame = CGRectMake(233, 25, 52, 30);
        submitButton = [[UIButton alloc]initWithFrame:submitButtonFrame];
        [submitButton setTitle:@"Next" forState:UIControlStateNormal];
        [submitButton.titleLabel setTextColor:[MSUtilities defaultSystemTintColor]];
        [self addSubview:submitButton];
        
        //Create the frame for the text input section
        //Frame gets modified based on how many suggestions there are for the entered destination
        
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //suggestionBox = [[MSSuggestionBox alloc]init]
}

@end