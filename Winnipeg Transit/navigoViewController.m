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
#import "navigoResultViewController.h"
#import "DejalActivityView.h"
#import "MSSeparator.h"
#import "SubmitButton.h"
#import "AnimationInstructionSheet.h"

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
@synthesize originLabel, destinationLabel, timeDateLabel;
@synthesize timePicker;
@synthesize datePicker;
@synthesize modePicker;
@synthesize pickerBar;
@synthesize modeArray;
@synthesize modeString;
@synthesize originSeparator, destinationSeparator, timeSeparator, otherSeparator;
@synthesize submitButton;
@synthesize suggestionBox;
@synthesize originResults, destinationResults, currentField;

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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(backgroundTap)];
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
    [timePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    timeField.inputView = timePicker;
    
    //setting up the date picker
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    dateField.inputView = datePicker;
    
    //setting up the mode picker
    modePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    modePicker.showsSelectionIndicator = YES;
    modeArray = [navigoViewLibrary getModeArray];
    modePicker.delegate = self;
    modePicker.dataSource = self;
    mode.inputView = modePicker;
    
    NSLog(@"Main UI Loaded");
    
    //Small script to load current time into time and date pickers
    NSString *display = [navigoViewLibrary timeFromNSDate:timePicker.date];
    timeField.text = display;
    display = [navigoViewLibrary dateFromNSDate:datePicker.date];
    dateField.text = display;
    mode.text = @"Depart After";
    
    queriedDictionary = [[NSMutableDictionary alloc]init];
    
    [super viewDidLoad];
    
}

-(IBAction)datePickerValueChanged {
    NSString *display = [navigoViewLibrary timeFromNSDate:timePicker.date];
    timeField.text = display;
    display = [navigoViewLibrary dateFromNSDate:datePicker.date];
    dateField.text = display;
}

-(IBAction)submitButtonClick
{
    int buttonLocation = [submitButton checkCurrentLocation];
    if (buttonLocation == 1 && [submitButton.titleLabel.text isEqualToString:@"Next"]) [AnimationInstructionSheet toStageTwo:self];
    else if (buttonLocation == 2 && [submitButton.titleLabel.text isEqualToString:@"Next"])
    {
        [AnimationInstructionSheet toStageThree:self];
        [submitButton setTitle:@"Submit" forState:nil];
    }
    else {
        NSMutableArray *searchArray = [[NSMutableArray alloc]init];
        [searchArray addObject:[[queriedDictionary objectForKey:@"origin"] objectAtIndex:1]];
        [searchArray addObject:[[queriedDictionary objectForKey:@"destination"] objectAtIndex:1]];
        [searchArray addObject:[navigoInterpreter timeFormatForServer:timePicker.date]];
        [searchArray addObject:[navigoInterpreter dateFormatForServer:datePicker.date]];
        [searchArray addObject:[navigoInterpreter serverModeString:mode.text]];
        [searchArray addObject:[navigoInterpreter stringForBool:easyAccessSwitch.on]];
        [searchArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"walk_speed"]];
        [searchArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"max_walk_time"]];
        [searchArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"min_transfer_wait_time"]];
        [searchArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"max_transfer_time"]];
        [searchArray addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"max_transfers"]];
        NSData *resultXMLFile = [navigoInterpreter getXMLFileFromResults:searchArray];
        [navigoInterpreter getRouteData:resultXMLFile];
        [self performSegueWithIdentifier:@"toResults" sender:self];
    }
}

-(IBAction)backgroundTap
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

-(IBAction)clearFields
{
    origin.text = @"";
    destination.text = @"";
    NSString *display = [navigoViewLibrary timeFromNSDate:timePicker.date];
    timeField.text = display;
    display = [navigoViewLibrary dateFromNSDate:datePicker.date];
    dateField.text = display;
    mode.text = @"Depart After";
    [originLabel setTitle:@"Origin" forState:nil];
    [destinationLabel setTitle:@"Destination" forState:nil];
    [AnimationInstructionSheet toStageOne:self];
}

-(IBAction)testButton
{
    currentFile = @"Route1";
    [self performSegueWithIdentifier:@"toResults" sender:self];
}

//Actions for origin, destination and time/date labels/buttons
-(IBAction)originLabelClick
{
    [AnimationInstructionSheet toStageOne:self];
}
-(IBAction)destinationLabelClick
{
    [AnimationInstructionSheet toStageTwo:self];
}
-(IBAction)timeDateLabelClick
{
    [AnimationInstructionSheet toStageThree:self];
}

#pragma mark - Actions for origin and destination suggestion boxes

-(IBAction)originBoxEdit
{
    currentField = @"origin";
    suggestionBox = [[MSSuggestionBox alloc] initWithFrameFromField:origin];
    suggestionBox.tableView.delegate = self;
    [self.view addSubview:suggestionBox.tableView];
}
-(IBAction)originBoxChanged
{
    [suggestionBox getSuggestions:origin.text];
}
-(IBAction)originBoxFinished
{
    [suggestionBox.tableView removeFromSuperview];
    suggestionBox = nil;
}
-(IBAction)destinationBoxEdit
{
    currentField = @"destination";
    suggestionBox = [[MSSuggestionBox alloc] initWithFrameFromField:destination];
    suggestionBox.tableView.delegate = self;
    [self.view addSubview:suggestionBox.tableView];
}
-(IBAction)destinationBoxChanged
{
    [suggestionBox getSuggestions:destination.text];
}
-(IBAction)destinationBoxFinished
{
    [suggestionBox.tableView removeFromSuperview];
    suggestionBox = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *answerArray = [[NSArray alloc]init];
    answerArray = [suggestionBox.tableArray objectAtIndex:indexPath.row];
    NSString *answer = [[NSString alloc]init];
    answer = [answerArray objectAtIndex:0];
    [suggestionBox.tableView removeFromSuperview];
    suggestionBox = nil;
    if ([currentField isEqualToString:@"origin"]) {
        [queriedDictionary setObject:answerArray forKey:@"origin"];
        self.origin.text = answer;
    } else if ([currentField isEqualToString:@"destination"]) {
        [queriedDictionary setObject:answerArray forKey:@"destination"];
        self.destination.text = answer;
    }
}

#pragma mark -

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
