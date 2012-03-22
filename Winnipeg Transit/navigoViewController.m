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

@implementation navigoViewController

@synthesize origin;
@synthesize destination;
@synthesize timeField;
@synthesize dateField;
@synthesize mode;
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
@synthesize searchArray;
@synthesize modeArray;

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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closePicker:)];
	[items addObject:doneButton];
	pickerBar.items = items;	
	
	return pickerBar;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //timeField = [navigoViewLibrary timePickerInputFormat:self.view];
  
    timePicker.datePickerMode = 2;
    
    [timePicker setDate:[NSDate date]];
    
    timePicker = [[UIDatePicker alloc]init];
    datePicker = [[UIDatePicker alloc]init];
    searchArray = [[NSMutableArray alloc]init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    timeField.inputView = timePicker;
    dateField.inputView = datePicker;
    
    timeField.inputAccessoryView = [self accessoryView];
    dateField.inputAccessoryView = [self accessoryView];
    
    modePicker = [[UIPickerView alloc]init];
    [modePicker.delegate = self;
    modeArray = [navigoViewLibrary getModeArray];

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
    } else if ([navigoInterpreter getAddressKeyFromSearchedItem:origin.text] == nil) {
        UIAlertView *missingStuff = [navigoViewLibrary dataMissing];
        [missingStuff show];
    } else if ([navigoInterpreter getAddressKeyFromSearchedItem:destination.text] == nil) {
        UIAlertView *missingStuff = [navigoViewLibrary dataMissing];
        [missingStuff show];
    } else {
        NSString *originText = [navigoInterpreter getLocationNameFromSearchedItem:origin.text];
    NSLog(originText);
    originLabel.text = originText;
    [searchArray addObject:originText];
    NSString *destinationText = [navigoInterpreter getLocationNameFromSearchedItem:destination.text];
    NSLog(destinationText);
    destinationLabel.text = destinationText;
    [searchArray addObject:destinationText];
        
    }
}

-(IBAction)closePicker:(id)sender
{
    [timeField resignFirstResponder];
    [dateField resignFirstResponder];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return [modeArray count]; }

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = [modeArray objectAtIndex:row];
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

@end
