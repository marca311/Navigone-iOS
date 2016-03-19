//
//  MSTopBar.m
//  Winnipeg Transit
//
//  The top bar is the bar that shows up on program start.
//  It is the section where the user enters the origin, destination, and time for the query.
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

@interface MSTopBar () <MSSearchHistoryDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    float                   originalHeight;
    float                   previousHeight;
    MSSearchHistoryView     *searchHistory;
}

@property (nonatomic, retain) UIViewController  *parentViewController;

@property (nonatomic, retain) MSSuggestions         *suggestions;
@property (nonatomic, retain) UILabel               *label;
@property (nonatomic, retain) UIButton              *submitButton;

@property (nonatomic) int                           stage; //Current stage that top bar is at (1=Origin, 2=Destination, 3=Date,Mode)
@property (nonatomic, retain) MSLocation            *origin;
@property (nonatomic, retain) NSString              *originText;
@property (nonatomic, retain) MSLocation            *destination;
@property (nonatomic, retain) NSString              *destinationText;
@property (nonatomic, retain) NSDate                *date;
@property (nonatomic, retain) UIDatePicker          *timePicker;
@property (nonatomic, retain) UIDatePicker          *datePicker;
@property (nonatomic, retain) NSArray               *modeArray;
@property (nonatomic, retain) NSString              *modeString;
@property (nonatomic, retain) UIPickerView          *modePicker;

@property (nonatomic, retain) MSSuggestionBox       *suggestionBox;
@property (nonatomic, retain) MSSearchHistoryView   *searchHistory;

@end

@implementation MSTopBar

@synthesize parentViewController;
@synthesize textField, timeField, dateField, modeField;
@synthesize delegate, suggestions, label, submitButton;
@synthesize stage, origin, originText, destination, destinationText, date, timePicker, datePicker, modeArray, modeString, modePicker;
@synthesize suggestionBox, searchHistory;

#pragma mark - Init method

-(id)initWithFrame:(CGRect)frame andParentViewController:(UIViewController *)aParentViewController {
    self = [super init];
    self.view.frame = frame;
    if (self) {
        //Set up the parent view controller variable
        parentViewController = aParentViewController;
        
        originalHeight = self.view.frame.size.height;
        
        //Set up the label frame and settings
        CGRect labelFrame = CGRectMake(5, 0, 280, 20);
        label = [[UILabel alloc]initWithFrame:labelFrame];
        [label setFont:[UIFont systemFontOfSize:14]]; //Set to the system font size 14
        [label setText:@"Origin"];
        [self.view addSubview:label];
        
        //Set up the text field frame and settings
        CGRect textFieldFrame = CGRectMake(5, 25, 220, 30);
        textField = [[UITextField alloc]initWithFrame:textFieldFrame];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [textField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        [self.view addSubview:textField];
        
        //Set up the time field frame and settings
        CGRect timeFieldFrame = CGRectMake(5, 25, 100, 30);
        timeField = [[UITextField alloc]initWithFrame:timeFieldFrame];
        [timeField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [timeField setInputView:[self createTimePicker]];
        [timeField setInputAccessoryView:[self createAccessoryView:@"time"]];
        [timeField setHidden:true];
        [self.view addSubview:timeField];
        
        //Set up the date field frame and settings
        CGRect dateFieldFrame = CGRectMake(110, 25, 175, 30);
        dateField = [[UITextField alloc]initWithFrame:dateFieldFrame];
        [dateField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [dateField setInputView:[self createDatePicker]];
        [dateField setInputAccessoryView:[self createAccessoryView:@"date"]];
        [dateField setHidden:true];
        [self.view addSubview:dateField];
        
        //Set the time and date fields to the current time and date
        [self resetDatePickers];
        
        //Set up the mode field frame and settings
        CGRect modeFieldFrame = CGRectMake(5, 65, 150, 30);
        modeField = [[UITextField alloc]initWithFrame:modeFieldFrame];
        [modeField setClearButtonMode:UITextFieldViewModeWhileEditing]; //Show the clear button when editing
        [modeField setBorderStyle:UITextBorderStyleRoundedRect]; //Set the text field border to rounded rectanguar (default for IB)
        [modeField setText:@"Depart After"];
        [modeField setInputView:[self createModePicker]];
        [modeField setInputAccessoryView:[self createAccessoryView:@"mode"]];
        [modeField setHidden:true];
        [self.view addSubview:modeField];
        
        //Set up the submit button frame and settings
        CGRect submitButtonFrame = CGRectMake(235, 25, 55, 30);
        submitButton = [[UIButton alloc]initWithFrame:submitButtonFrame];
        [submitButton setTitle:@"Next" forState:UIControlStateNormal];
        [submitButton setTitleColor:[MSUtilities defaultSystemTintColor] forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:submitButton];
        
        stage = 1;
        
        //Create the frame for the text input section
        //Frame gets modified based on how many suggestions there are for the entered destination
        
        //Creates frame with rounded corners around the view
        CALayer *layer = self.view.layer;
        layer.backgroundColor = [[UIColor whiteColor]CGColor];
        layer.borderWidth = 2;
        layer.borderColor = [[UIColor whiteColor] CGColor];
        layer.cornerRadius = 10;
        layer.opacity = 0.9;
        layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - Text Field delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //[delegate topBoxHasFirstResponder];
    [self showSuggestionBox];
}

-(void)textFieldDidChange {
    [suggestionBox generateSuggestions:textField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    /*CGRect mainFrame = self.frame;
    mainFrame.size.height = originalHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = mainFrame;
    [UIView commitAnimations];
    [suggestionBox.tableView removeFromSuperview]; */
    [self restoreFrameToOriginalSize];
    [self resignSuggestionBox];
}

#pragma mark - Suggestion box delegate method

-(void)suggestionBoxFrameWillChange:(CGRect)frame {
    CGRect mainFrame = self.view.frame;
    //Add the height of the suggestion box to the original height of the view to get the new height
    mainFrame.size.height = frame.size.height + originalHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = mainFrame;
    [UIView commitAnimations];
}

#pragma mark - Element hide and unhide methods

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

#pragma mark - Time, date, and mode picker creator methods

-(UIDatePicker *)createTimePicker {
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker setDate:[NSDate date]];
    timePicker = [[UIDatePicker alloc]init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    timeField.inputView = timePicker;
    return timePicker;
}

-(UIDatePicker *)createDatePicker {
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    dateField.inputView = datePicker;
    return datePicker;
}

-(UIPickerView *)createModePicker {
    modePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    modePicker.showsSelectionIndicator = YES;
    modeArray = [[NSArray alloc]initWithObjects:@"Depart Before", @"Depart After", @"Arrive Before", @"Arrive After", nil];
    modePicker.delegate = self;
    modePicker.dataSource = self;
    [modePicker selectRow:1 inComponent:0 animated:NO];
    return modePicker;
}

#pragma mark - Create accessory view for pickers

-(UIToolbar *)createAccessoryView:(NSString *)field {
	UIToolbar *pickerBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, parentViewController.view.frame.size.width, 44.0f)];
	pickerBar.tintColor = [UIColor darkGrayColor];
	
	NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPickers)];
	[items addObject:doneButton];
    if ([field isEqualToString:@"time"]) {
        UIBarButtonItem *nowButton = [[UIBarButtonItem alloc]initWithTitle:@"Now" style:UIBarButtonItemStylePlain target:self action:@selector(resetTimePicker)];
        [items addObject:nowButton];
    }
    if ([field isEqualToString:@"date"]) {
        UIBarButtonItem *todayButton = [[UIBarButtonItem alloc]initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(resetDatePicker)];
        [items addObject:todayButton];
    }
	pickerBar.items = items;
	
	return pickerBar;
}

#pragma mark

-(void)tableItemClicked:(MSLocation *)resultLocation {
    if (resultLocation == NULL) {
        //Cover existing view elements with search history view
        previousHeight = self.view.frame.size.height;
        CGRect newFrame = self.view.frame;
        newFrame.size.height = originalHeight + 200;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self hideElements];
        self.view.frame = newFrame;
        [UIView commitAnimations];
        CGRect searchHistoryFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        searchHistory = [[MSSearchHistoryView alloc]initWithFrame:searchHistoryFrame];
        searchHistory.delegate = self;
        [self.view addSubview:searchHistory];
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
    CGRect originalSize = self.view.frame;
    originalSize.size.height = previousHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = originalSize;
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

-(void)dismissPickers {
    [timeField resignFirstResponder];
    [dateField resignFirstResponder];
    [modeField resignFirstResponder];
}

-(void)resetDatePickers {
    [self resetTimePicker];
    [self resetDatePicker];
    [delegate dateSetWithDate:[NSDate date]];
}
-(void)resetTimePicker {
    [timePicker setDate:[NSDate date]];
    NSString *display = [MSUtilities getTimeFormatForHuman:[NSDate date]];
    timeField.text = display;
}
-(void)resetDatePicker {
    [datePicker setDate:[NSDate date]];
    NSString *display = [MSUtilities getDateFormatForHuman:[NSDate date]];
    dateField.text = display;
}

-(void)submitData {
    if (stage == 1) {
        if (origin != NULL) {
            [delegate originSetWithLocation:origin];
            [self goToDestinationStage];
        }
    } else if (stage == 2) {
        if (destination != NULL) {
            [delegate destinationSetWithLocation:destination];
            [self goToDateStage];
        }
    } else if (stage == 3) {
        [delegate dateSetWithDate:date];
        [delegate submitQueryButtonPressed];
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
        CGRect originalSize = self.view.frame;
        originalSize.size.height = originalHeight;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.view.frame = originalSize;
        [UIView commitAnimations];
    } else {
        CGRect originalSize = self.view.frame;
        originalSize.size.height = originalHeight;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.view.frame = originalSize;
        [UIView commitAnimations];
    }
}

#pragma mark - Suggestion box visibility methods

-(void)showSuggestionBox {
    CGRect suggestionBoxFrame = CGRectMake(0, 60, 290, 100 );
    suggestionBox = [[MSSuggestionBox alloc]initWithFrame:suggestionBoxFrame andDelegate:self];
    [self.view addSubview:suggestionBox.view];
}

-(void)resignSuggestionBox {
    [suggestionBox.tableView removeFromSuperview];
    suggestionBox = NULL;
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
    if (!textField.isFirstResponder) {
        [self restoreFrameToOriginalSize];
    }
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
    if (!textField.isFirstResponder) {
        [self restoreFrameToOriginalSize];
    }
    [textField setHidden:false];
    [timeField setHidden:true];
    [dateField setHidden:true];
    [modeField setHidden:true];
    [self saveQueryText];
    stage = 2;
}
-(void)goToDateStage {
    CGRect timeDateFrame = self.view.frame;
    [self moveSubmitButton:3];
    
    timeDateFrame.size.height = originalHeight + 40;
    [textField resignFirstResponder];
    [label setText:@"Time and Date"];
    //Animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = timeDateFrame;
    [UIView commitAnimations];
    [textField setHidden:true];
    [timeField setHidden:false];
    [dateField setHidden:false];
    [modeField setHidden:false];
    [self saveQueryText];
    stage = 3;
}

#pragma mark - Picker specific methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return [modeArray count]; }

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = [modeArray objectAtIndex:row];
    return result;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    modeString = [[NSString alloc]init];
    modeString = [modeArray objectAtIndex:row];
    modeField.text = modeString;
}

-(void)datePickerValueChanged {
    NSString *display = [MSUtilities getTimeFormatForHuman:timePicker.date];
    timeField.text = display;
    display = [MSUtilities getDateFormatForHuman:datePicker.date];
    dateField.text = display;
}

#pragma mark -

@end