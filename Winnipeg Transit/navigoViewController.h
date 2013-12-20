//
//  navigoViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-02.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "XMLParser.h"
#import "UniversalViewController.h"
#import "MSUtilities.h"
#import "navigoViewLibrary.h"
#import "navigoResultViewController.h"
#import "DejalActivityView.h"
#import "MSSeparator.h"
#import "SubmitButton.h"
#import "MSSuggestionBox.h"
#import "SearchHistoryViewController.h"
#import "MSQuery.h"
#import "MSTextField.h"

@interface navigoViewController : UniversalViewController <UIPickerViewDelegate, UIPickerViewDataSource, SuggestionBoxDelegate> {
    UIDatePicker *timePicker;
    UIDatePicker *datePicker;
    UIPickerView *modePicker;
    MSSuggestionBox *suggestionBox;
    
    MSTextField *origin;
    MSTextField *destination;
    NSString *currentField; //Tells the suggestion box delegate which field is currently selected so it can send the text to the correct one
}

@property (nonatomic, retain) IBOutlet MSTextField *origin;
@property (nonatomic, retain) IBOutlet MSTextField *destination;
@property (nonatomic, retain) IBOutlet UITextField *timeField;
@property (nonatomic, retain) IBOutlet UITextField *dateField;
@property (nonatomic, retain) IBOutlet UITextField *mode;
@property (nonatomic, retain) IBOutlet UISwitch *easyAccessSwitch;
@property (nonatomic)         BOOL easyAccess;
@property (nonatomic, retain) IBOutlet UITextField *walkSpeed;
@property (nonatomic, retain) IBOutlet UITextField *maxWalkTime;
@property (nonatomic, retain) IBOutlet UITextField *minTransferWait;
@property (nonatomic, retain) IBOutlet UITextField *maxTransferWait;
@property (nonatomic, retain) IBOutlet UITextField *maxTransfers;
@property (nonatomic, retain) IBOutlet UIButton *originLabel;
@property (nonatomic, retain) IBOutlet UIButton *destinationLabel;
@property (nonatomic, retain) IBOutlet UIButton *timeDateLabel;
@property (nonatomic, retain) UIDatePicker *timePicker;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *modePicker;
@property (nonatomic, retain) UIToolbar *pickerBar;
@property (nonatomic, retain) NSArray *modeArray;
@property (nonatomic, retain) NSString *modeString;
@property (nonatomic, retain) IBOutlet MSSeparator *originSeparator;
@property (nonatomic, retain) IBOutlet MSSeparator *destinationSeparator;
@property (nonatomic, retain) IBOutlet MSSeparator *timeSeparator;
@property (nonatomic, retain) IBOutlet MSSeparator *otherSeparator;
@property (nonatomic, retain) IBOutlet SubmitButton *submitButton;
@property (nonatomic, retain) SearchHistoryViewController *searchHistory;
//These store the query results (location name and key) for the entered origin and destination
@property (nonatomic, retain) NSArray *originResults;
@property (nonatomic, retain) NSArray *destinationResults;


@property (nonatomic, retain) MSQuery *query;

//Activiated when the submit button is clicked (duh)
-(IBAction)submitButtonClick;
//Small helper method for submit button. Check whether all fields are filled in, and changes button to "submit" when applicable
-(void)fieldChecker;

-(IBAction)datePickerValueChanged;

-(IBAction)backgroundTap;

-(IBAction)clearFields;

-(IBAction)testButton;

-(IBAction)queryHistoryButton;

-(IBAction)tripHistoryButton;

-(void)resetDatePickers;

//Actions for origin, destination and time/date labels/buttons
-(IBAction)originLabelClick;
-(IBAction)destinationLabelClick;
-(IBAction)timeDateLabelClick;

//Method to detect whether all fields are filled
-(BOOL)fieldsFilled;
//Method to update all field values
-(void)updateFields;

//Actions for origin and destination suggestion boxes
-(IBAction)originBoxEdit;
-(IBAction)originBoxChanged;
-(IBAction)originBoxFinished;
-(IBAction)destinationBoxEdit;
-(IBAction)destinationBoxChanged;
-(IBAction)destinationBoxFinished;

@end
