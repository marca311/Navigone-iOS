//
//  navigoViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-03-02.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "navigoViewController.h"
#import "TBXML.h"
#import "XMLParser.h"
#import "navigoInterpreter.h"
#import "MSUtilities.h"
#import "navigoViewLibrary.h"
#import "navigoResultView.h"

@implementation navigoViewController

@synthesize origin;
@synthesize destination;
@synthesize timeField;
@synthesize dateField;
@synthesize mode;
@synthesize easyAccessSwitch;
@synthesize easyAccess;
@synthesize walkSpeed;
@synthesize maxWalkTime;
@synthesize minTransferWait;
@synthesize maxTransferWait;
@synthesize maxTransfers;
@synthesize originLabel;
@synthesize destinationLabel;
@synthesize timePicker;
@synthesize datePicker;
@synthesize modePicker;
@synthesize pickerBar;
@synthesize modeArray;
@synthesize modeString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (UIToolbar *) accessoryView
{
	pickerBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
	pickerBar.tintColor = [UIColor darkGrayColor];
	
	NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(backgroundTap:)];
	[items addObject:doneButton];
	pickerBar.items = items;	
	
	return pickerBar;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //timeField = [navigoViewLibrary timePickerInputFormat:self.view];
  
    //setting accessory views
    origin.inputAccessoryView = [self accessoryView];
    destination.inputAccessoryView = [self accessoryView];
    timeField.inputAccessoryView = [self accessoryView];
    dateField.inputAccessoryView = [self accessoryView];
    mode.inputAccessoryView = [self accessoryView];
    walkSpeed.inputAccessoryView = [self accessoryView];
    minTransferWait.inputAccessoryView = [self accessoryView];
    maxTransferWait.inputAccessoryView = [self accessoryView];
    maxWalkTime.inputAccessoryView = [self accessoryView];
    maxTransfers.inputAccessoryView = [self accessoryView];
    
    
    //setting up the time picker
    timePicker.datePickerMode = 2;
    [timePicker setDate:[NSDate date]];
    timePicker = [[UIDatePicker alloc]init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    timeField.inputView = timePicker;
    
    //setting up the date picker
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    dateField.inputView = datePicker;
    
    //setting up the mode picker
    modePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    modePicker.delegate = self;
    modePicker.dataSource = self;
    modePicker.showsSelectionIndicator = YES;
    modeArray = [navigoViewLibrary getModeArray];
    mode.inputView = modePicker;
    
    [super viewDidLoad];
}

-(IBAction)datePickerValueChanged:(id)sender {
    NSString *display = [navigoViewLibrary timeFromNSDate:timePicker.date];
    timeField.text = display;
    NSLog(display);
    display = [navigoViewLibrary dateFromNSDate:datePicker.date];
    dateField.text = display;
    NSLog(display);
}

-(IBAction)submitButton:(id)sender
{
    if ([origin.text isEqualToString:@""] || [destination.text isEqualToString:@""]) {
        UIAlertView *missingStuff = [navigoViewLibrary dataMissing];
        [missingStuff show];
    } /*else if ([navigoInterpreter getAddressKeyFromSearchedItem:origin.text] == nil) {
        UIAlertView *missingStuff = [navigoViewLibrary dataMissing];
        [missingStuff show];
    } else if ([navigoInterpreter getAddressKeyFromSearchedItem:destination.text] == nil) {
        UIAlertView *missingStuff = [navigoViewLibrary dataMissing];
        [missingStuff show];
    } */else {
        NSString *originText = [navigoInterpreter getLocationNameFromSearchedItem:origin.text];
        originLabel.text = originText;
        NSMutableArray *searchArray = [[NSMutableArray alloc]init];
        [searchArray addObject:[navigoInterpreter getAddressKeyFromSearchedItem:origin.text]];
        NSString *destinationText = [navigoInterpreter getLocationNameFromSearchedItem:destination.text];
        destinationLabel.text = destinationText;
        [searchArray addObject:[navigoInterpreter getAddressKeyFromSearchedItem:destination.text]];
        [searchArray addObject:[navigoInterpreter timeFormatForServer:timePicker.date]];
        [searchArray addObject:[navigoInterpreter dateFormatForServer:datePicker.date]];
        [searchArray addObject:[navigoInterpreter serverModeString:mode.text]];
        [searchArray addObject:[navigoInterpreter stringForBool:easyAccessSwitch.on]];
        [searchArray addObject:walkSpeed.text];
        [searchArray addObject:maxWalkTime.text];
        [searchArray addObject:minTransferWait.text];
        [searchArray addObject:maxTransferWait.text];
        [searchArray addObject:maxTransfers.text];
        NSData *resultXMLFile = [navigoInterpreter getXMLFileFromResults:searchArray];
        navigoResultView *resultView = [[navigoResultView alloc]init];
        [self.view addSubview:resultView];
    }
}

-(IBAction)backgroundTap:(id)sender
{
    [origin resignFirstResponder];
    [destination resignFirstResponder];
    [timeField resignFirstResponder];
    [dateField resignFirstResponder];
    [mode resignFirstResponder];
    [walkSpeed resignFirstResponder];
    [maxWalkTime resignFirstResponder];
    [minTransferWait resignFirstResponder];
    [maxTransferWait resignFirstResponder];
    [maxTransfers resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Picker Delegate protocols

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return [modeArray count]; }

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = [modeArray objectAtIndex:row];
    return result;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    modeString = [[NSString alloc]init];
    modeString = [modeArray objectAtIndex:row];
    mode.text = modeString;
}

#pragma mark -

@end
