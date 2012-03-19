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

@interface navigoViewController : UniversalViewController <UITextFieldDelegate> {
    UITextField *origin;
    UITextField *timeDate;
    UIToolbar *pickerBar;
    IBOutlet UIToolbar *keyboardToolbar;
    UISegmentedControl *nextPreviousControl;
}

@property (nonatomic, retain) IBOutlet UITextField *origin;
@property (nonatomic, retain) UITextField *destination;
@property (nonatomic, retain) IBOutlet UITextField *timeDate;
@property (nonatomic, retain) UITextField *mode;
@property (nonatomic, retain) UITextField *walkSpeed;
@property (nonatomic, retain) UITextField *maxWalkTime;
@property (nonatomic, retain) UITextField *minTransferWait;
@property (nonatomic, retain) UITextField *maxTransferWait;
@property (nonatomic, retain) UITextField *maxTransfers;
@property (nonatomic, retain) IBOutlet UILabel *originLabel;
@property (nonatomic, retain) UIDatePicker *timePicker;
@property (nonatomic, retain) UIToolbar *pickerBar;

-(IBAction)submitButton:(id)sender;

-(IBAction)openDatePicker:(id)sender;

-(IBAction)closePicker:(id)sender;

@property (nonatomic, retain) UISegmentedControl *nextPreviousControl;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

- (IBAction)nextPrevious:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)editingChanged:(id)sender;

@end
