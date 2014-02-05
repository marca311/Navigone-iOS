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
#import "MSSearchHistoryView.h"
#import "MSUtilities.h"
#import "XMLParser.h"

@interface MSTopBar () <MSSearchHistoryDelegate> {
    float originalHeight;
    float previousHeight;
    MSSearchHistoryView *searchHistory;
}

@property (nonatomic, retain) MSSuggestions *suggestions;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *submitButton;

@property (nonatomic) int stage; //Current stage that top bar is at (1=Origin, 2=Destination, 3=Date,Mode)
@property (nonatomic, retain) MSLocation *origin;
@property (nonatomic, retain) NSString *originText;
@property (nonatomic, retain) MSLocation *destination;
@property (nonatomic, retain) NSString *destinationText;
@property (nonatomic, retain) NSDate *date;

@property (nonatomic, retain) MSSuggestionBox *suggestionBox;
@property (nonatomic, retain) MSSearchHistoryView *searchHistory;

@end

@implementation MSTopBar

@synthesize textField, timeField, dateField, modeField;
@synthesize delegate, suggestions, label, submitButton;
@synthesize stage, origin, originText, destination, destinationText, date;
@synthesize suggestionBox, searchHistory;

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
        CGRect timeFieldFrame = CGRectMake(5, 25, 100, 30);
        timeField = [[UITextField alloc]initWithFrame:timeFieldFrame];
        [timeField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [timeField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [timeField setHidden:true];
        [self addSubview:timeField];
        
        //Set up the date field frame and settings
        CGRect dateFieldFrame = CGRectMake(115, 25, 110, 30);
        dateField = [[UITextField alloc]initWithFrame:dateFieldFrame];
        [dateField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [dateField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [dateField setHidden:true];
        [self addSubview:dateField];
        
        //Set up the mode field frame and settings
        CGRect modeFieldFrame = CGRectMake(5, 65, 150, 30);
        modeField = [[UITextField alloc]initWithFrame:modeFieldFrame];
        [modeField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [modeField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [modeField setHidden:true];
        [self addSubview:modeField];
        
        //Set up the submit button frame and settings
        CGRect submitButtonFrame = CGRectMake(233, 25, 52, 30);
        submitButton = [[UIButton alloc]initWithFrame:submitButtonFrame];
        [submitButton setTitle:@"Next" forState:UIControlStateNormal];
        [submitButton.titleLabel setTextColor:[MSUtilities defaultSystemTintColor]];
        [self addSubview:submitButton];
        
        stage = 1;
        
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
    [suggestionBox.tableView removeFromSuperview];
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

-(void)hideElements {
    [label setHidden:YES];
    [textField setHidden:YES];
    [submitButton setHidden:YES];
    [suggestionBox.tableView setHidden:YES];
}

-(void)unHideElements {
    [label setHidden:NO];
    [textField setHidden:NO];
    [submitButton setHidden:NO];
    [suggestionBox.tableView setHidden:NO];
}

-(void)tableItemClicked:(MSLocation *)resultLocation {
    if (resultLocation == NULL) {
        //Cover existing view elements with search history view
        previousHeight = self.frame.size.height;
        CGRect newFrame = self.frame;
        newFrame.size.height = originalHeight + 200;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self hideElements];
        self.frame = newFrame;
        [UIView commitAnimations];
        CGRect searchHistoryFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        searchHistory = [[MSSearchHistoryView alloc]initWithFrame:searchHistoryFrame];
        searchHistory.delegate = self;
        [self addSubview:searchHistory];
    } else {
        if (stage == 1) {
            origin = resultLocation;
        } else if (stage == 2) {
            destination = resultLocation;
        } else {
            return;
        }
        [self submitData];
    }
}

-(void)userDidPressBackButton {
    [searchHistory removeFromSuperview];
    //Set frame back to previous size
    CGRect originalSize = self.frame;
    originalSize.size.height = previousHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = originalSize;
    [UIView commitAnimations];
    [self unHideElements];
}

-(void)userDidSelectLocation:(MSLocation *)location {
    [searchHistory removeFromSuperview];
    [self restoreFrameToOriginalSize];
    [self unHideElements];
    if (stage == 1) {
        origin = location;
        [self goToDestinationStage];
    } else if (stage == 2) {
        destination = location;
        [self goToDateStage];
    }
    [self submitData];
}

-(void)submitData {
    if (stage == 1) {
        [delegate originSetWithLocation:origin];
        [self goToDestinationStage];
    } else if (stage == 2) {
        [delegate destinationSetWithLocation:destination];
        [self goToDateStage];
    } else if (stage == 3) {
        //Submit time and date and mode then do all empty field checks on viewcontroller side, go back to missing field if applicable
    }
}

-(void)saveQueryText {
    if (stage == 1) {
        originText = textField.text;
    } else if (stage == 2) {
        destinationText = textField.text;
    }
    textField.text = @"";
    [suggestionBox generateSuggestions:@""];
}

-(void)restoreFrameToOriginalSize {
    //If the text field is no longer the first responder
    if (![textField isFirstResponder]) {
        //Shrink view to original height
        CGRect originalSize = self.frame;
        originalSize.size.height = originalHeight;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.frame = originalSize;
        [UIView commitAnimations];
    } else {
        CGRect originalSize = self.frame;
        originalSize.size.height = originalHeight;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.frame = originalSize;
        [UIView commitAnimations];
    }
}

-(void)moveSubmitButton:(int)nextStage {
    //If the next stage is the time/date stage
    if (nextStage == 3) {
        //Move the submit button down
        CGRect submitButtonFrame = submitButton.frame;
        submitButtonFrame.origin.y = 65;
        //Animate
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        submitButton.frame = submitButtonFrame;
        [UIView commitAnimations];
    } else { //Otherwise
        //Move the submit back to where it was
        CGRect submitButtonFrame = submitButton.frame;
        submitButtonFrame.origin.y = 25;
        //Animate
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        submitButton.frame = submitButtonFrame;
        [UIView commitAnimations];
    }
}

-(void)goToOriginStage {
    [label setText:@"Origin"];
    [self moveSubmitButton:1];
    [self restoreFrameToOriginalSize];
    [textField setHidden:false];
    [timeField setHidden:true];
    [dateField setHidden:true];
    [modeField setHidden:true];
    [self saveQueryText];
    stage = 1;
}
-(void)goToDestinationStage {
    [label setText:@"Destination"];
    [self moveSubmitButton:2];
    [self restoreFrameToOriginalSize];
    [textField setHidden:false];
    [timeField setHidden:true];
    [dateField setHidden:true];
    [modeField setHidden:true];
    [self saveQueryText];
    stage = 2;
}
-(void)goToDateStage {
    CGRect timeDateFrame = self.frame;
    [self moveSubmitButton:3];
    
    timeDateFrame.size.height = originalHeight + 40;
    [textField resignFirstResponder];
    [label setText:@"Time and Date"];
    //Animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = timeDateFrame;
    [UIView commitAnimations];
    [textField setHidden:true];
    [timeField setHidden:false];
    [dateField setHidden:false];
    [modeField setHidden:false];
    [self saveQueryText];
    stage = 3;
}

@end