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
#import "navigoInterpreter.h"
#import "UniversalViewController.h"
#import "MSUtilities.h"
#import "navigoViewLibrary.h"

@interface navigoViewController : UniversalViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    UITextField *origin;
    UITextField *timeDate;
    UIToolbar *pickerBar;
    IBOutlet UIToolbar *keyboardToolbar;
    UISegmentedControl *nextPreviousControl;
    UIDatePicker *timePicker;
    UIDatePicker *datePicker;
    NSArray *modeArray;
}

@property (nonatomic, retain) IBOutlet UITextField *origin;
@property (nonatomic, retain) IBOutlet UITextField *destination;
@property (nonatomic, retain) IBOutlet UITextField *timeField;
@property (nonatomic, retain) IBOutlet UITextField *dateField;
@property (nonatomic, retain) IBOutlet UITextField *mode;
@property (nonatomic, retain) UITextField *walkSpeed;
@property (nonatomic, retain) UITextField *maxWalkTime;
@property (nonatomic, retain) UITextField *minTransferWait;
@property (nonatomic, retain) UITextField *maxTransferWait;
@property (nonatomic, retain) UITextField *maxTransfers;
@property (nonatomic, retain) IBOutlet UILabel *originLabel;
@property (nonatomic, retain) IBOutlet UILabel *destinationLabel;
@property (nonatomic, retain) UIDatePicker *timePicker;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *modePicker;
@property (nonatomic, retain) UIToolbar *pickerBar;
@property (nonatomic, retain) NSMutableArray *searchArray;
@property (nonatomic, retain) NSArray *modeArray;

-(IBAction)submitButton:(id)sender;

-(IBAction)openDatePicker:(id)sender;

-(IBAction)closePicker:(id)sender;

-(IBAction)datePickerValueChanged:(id)sender;

@end
