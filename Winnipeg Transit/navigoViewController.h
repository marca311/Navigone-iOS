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
#import "navigoResultViewController.h"
#import "DejalActivityView.h"

@interface navigoViewController : UniversalViewController <UITextFieldDelegate> {
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
@property (nonatomic, retain) IBOutlet UISwitch *easyAccessSwitch;
@property (nonatomic)         BOOL easyAccess;
@property (nonatomic, retain) IBOutlet UITextField *walkSpeed;
@property (nonatomic, retain) IBOutlet UITextField *maxWalkTime;
@property (nonatomic, retain) IBOutlet UITextField *minTransferWait;
@property (nonatomic, retain) IBOutlet UITextField *maxTransferWait;
@property (nonatomic, retain) IBOutlet UITextField *maxTransfers;
@property (nonatomic, retain) IBOutlet UILabel *originLabel;
@property (nonatomic, retain) IBOutlet UILabel *destinationLabel;
@property (nonatomic, retain) UIDatePicker *timePicker;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *modePicker;
@property (nonatomic, retain) UIToolbar *pickerBar;
@property (nonatomic, retain) NSArray *modeArray;
@property (nonatomic, retain) NSString *modeString;
@property (nonatomic, retain) IBOutlet UIImageView *separator;

-(IBAction)submitButton:(id)sender;

-(NSMutableDictionary *)getRoutePlans:(NSData *)resultXMLFile;

-(IBAction)openDatePicker:(id)sender;

-(IBAction)datePickerValueChanged:(id)sender;

-(IBAction)backgroundTap:(id)sender;

-(IBAction)testButton;

@end
