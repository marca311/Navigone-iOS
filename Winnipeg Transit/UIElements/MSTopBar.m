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
#import "MSUtilities.h"
#import "XMLParser.h"

@interface MSTopBar () {
    float originalHeight;
}

@property (nonatomic, retain) MSSuggestions *suggestions;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *submitButton;

@property (nonatomic) int stage; //Current stage that top bar is at (1=Origin, 2=Destination, 3=Date,Mode)
@property (nonatomic, retain) MSLocation *origin;
@property (nonatomic, retain) MSLocation *destination;
@property (nonatomic, retain) NSDate *date;

@property (nonatomic, retain) MSSuggestionBox *suggestionBox;

@end

@implementation MSTopBar

@synthesize textField, timeField, dateField, modeField;
@synthesize delegate, suggestions, label, submitButton;
@synthesize stage, origin, destination, date;
@synthesize suggestionBox;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        originalHeight = self.frame.size.height;
        
        //Set up the label frame and settings
        CGRect labelFrame = CGRectMake(5, 0, 280, 20);
        label = [[UILabel alloc]initWithFrame:labelFrame];
        [label setFont:[UIFont systemFontOfSize:14]]; //Set to the system font size 14
        [label setText:@"Origin"];
        [self addSubview:label];
        
        //Set up the text field frame and settings
        CGRect textFieldFrame = CGRectMake(5, 25, 220, 30);
        textField = [[UITextField alloc]initWithFrame:textFieldFrame];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [textField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        [self addSubview:textField];
        
        //Set up the time field frame and settings
        CGRect timeFieldFrame = CGRectMake(5, 25, 220, 30);
        timeField = [[UITextField alloc]initWithFrame:timeFieldFrame];
        [timeField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [timeField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        timeField.delegate = self;
        
        //Set up the date field frame and settings
        CGRect dateFieldFrame = CGRectMake(5, 25, 220, 30);
        dateField = [[UITextField alloc]initWithFrame:dateFieldFrame];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [textField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        textField.delegate = self;
        
        //Set up the mode field frame and settings
        CGRect modeFieldFrame = CGRectMake(5, 25, 220, 30);
        modeField = [[UITextField alloc]initWithFrame:modeFieldFrame];
        [modeField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [modeField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        modeField.delegate = self;
        
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
    CGRect suggestionBoxFrame = CGRectMake(0, 60, 290, 100 );
    suggestionBox = [[MSSuggestionBox alloc]initWithFrame:suggestionBoxFrame andDelegate:self];
    [self addSubview:suggestionBox.view];
}

-(void)textFieldDidChange {
    [suggestionBox generateSuggestions:textField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect mainFrame = self.frame;
    mainFrame.size.height = originalHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = mainFrame;
    [UIView commitAnimations];
    [suggestionBox dismissModalViewControllerAnimated:NO];
}

-(void)suggestionBoxFrameWillChange:(CGRect)frame {
    CGRect mainFrame = self.frame;
    //Add the height of the suggestion box to the original height of the view to get the new height
    mainFrame.size.height = frame.size.height + originalHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = mainFrame;
    [UIView commitAnimations];
}

-(void)tableItemClicked:(MSLocation *)resultLocation {
    if (stage == 1) {
        origin = resultLocation;
    } else if (stage == 2) {
        destination = resultLocation;
        [self textFieldDidEndEditing:NULL];
    } else {
        return;
    }
    [self submitData];
}

-(void)submitData {
    if (stage == 1) {
        [delegate originSetWithLocation:origin];
        
    } else if (stage == 2) {
        [delegate destinationSetWithLocation:destination];
    } else if (stage == 3) {
        //Submit time and date and mode then do all empty field checks on viewcontroller side, go back to missing field if applicable
    }
}

-(void)goToOriginStage {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [label setText:@"Origin"];
    [UIView commitAnimations];
}
-(void)goToDestinationStage {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [label setText:@"Destination"];
    [UIView commitAnimations];
}
-(void)goToDateStage {
    CGRect timeDateFrame = self.frame;
    timeDateFrame.size.height = originalHeight + 40;
    //Animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [label setText:@"Time and Date"];
    self.frame = timeDateFrame;
    [UIView commitAnimations];
}

@end