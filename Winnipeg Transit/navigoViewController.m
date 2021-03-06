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
#import "MSUtilities.h"
#import "navigoViewLibrary.h"
#import "navigoResultViewController.h"
#import "DejalActivityView.h"
#import "MSSeparator.h"
#import "SubmitButton.h"
#import "AnimationInstructionSheet.h"
#import "QueryHistoryViewController.h"

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
@synthesize originResults, destinationResults;
@synthesize searchHistory;
@synthesize query;

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

- (UIToolbar *) accessoryView:(NSString *)field
{
	pickerBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
	pickerBar.tintColor = [UIColor darkGrayColor];
	
	NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(backgroundTap)];
    UIBarButtonItem *nowButton = [[UIBarButtonItem alloc]initWithTitle:@"Now" style:UIBarButtonItemStyleDone target:self action:@selector(resetTimePicker)];
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc]initWithTitle:@"Today" style:UIBarButtonItemStyleDone target:self action:@selector(resetDatePicker)];
	[items addObject:doneButton];
    if ([field isEqualToString:@"time"]) [items addObject:nowButton];
    if ([field isEqualToString:@"date"]) [items addObject:todayButton];
	pickerBar.items = items;	
	
	return pickerBar;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    query = [[MSQuery alloc]init];
    
    //Determine whether iOS version is 7 or higher and set up accordingly
    if ([MSUtilities firmwareIsSevenOrHigher]) {
        [self setAppForIosSeven];
    }
  
    //setting accessory views
    timeField.inputAccessoryView = [self accessoryView:@"time"];
    dateField.inputAccessoryView = [self accessoryView:@"date"];
    mode.inputAccessoryView = [self accessoryView:@"mode"];
    
    
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
    [modePicker selectRow:1 inComponent:0 animated:NO];
    
    //Small script to load current time into time and date pickers
    NSString *display = [navigoViewLibrary timeFromNSDate:timePicker.date];
    timeField.text = display;
    display = [navigoViewLibrary dateFromNSDate:datePicker.date];
    dateField.text = display;
    mode.text = @"Depart After";
    
    //Moves around time and date fields if the device is an iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGRect theFrame = dateField.frame;
        theFrame.origin.x = 200;
        theFrame.size.width = 20;
        dateField.frame = theFrame;
    }
    
    submitButton = [[SubmitButton alloc]init];
    
    //Check whether the search history has been updated to the new protocol
    [MSUtilities convertSearchHistory];
    
    NSLog(@"Navigone main UI Loaded");
    
    [super viewDidLoad];
    
}

-(void)setAppForIosSeven {
    [originSeparator setAlpha:0.25];
    [destinationSeparator setAlpha:0.25];
    [timeSeparator setAlpha:0.25];
}

-(IBAction)datePickerValueChanged {
    NSString *display = [navigoViewLibrary timeFromNSDate:timePicker.date];
    timeField.text = display;
    display = [navigoViewLibrary dateFromNSDate:datePicker.date];
    dateField.text = display;
}

#pragma mark - Submit button
-(IBAction)submitButtonClick
{
    [self fieldChecker];
    //Gets the current button location as a integer
    int buttonLocation = [submitButton checkCurrentLocation];
    //If the submit button has "Next" as the text, go to the next field available or change to 
    if ([submitButton.titleLabel.text isEqualToString:@"Next"]) {
        //
        if (buttonLocation == 1) {
            [query setOrigin:[origin getFirstAvailableLocation]];
            [AnimationInstructionSheet toNextStage:self];
        } else if (buttonLocation == 2) {
            [query setDestination:[destination getFirstAvailableLocation]];
            [AnimationInstructionSheet toNextStage:self];
        } else if (buttonLocation == 3) {
            NSString *message = [[NSString alloc]initWithFormat:@"You appear to have missed a field or two, go check whether you have all of the fields filled"];
            UIAlertView *emptyFieldAlert = [[UIAlertView alloc]initWithTitle:@"Uh oh" message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [emptyFieldAlert show];
        } else {
            [AnimationInstructionSheet toNextStage:self];
        }
    } else {
        DejalBezelActivityView *activityView = [[DejalBezelActivityView alloc]initForView:self.view withLabel:@"Loading..." width:5];
        [activityView animateShow];
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self resignFirstResponder];
            if ([query getOriginString] == NULL) [query setOrigin:[origin getLocation]];
            if ([query getDestinationString] == NULL) [query setDestination:[destination getLocation]];
            [query setDate:[self combineTimeAndDatePickers]];
            [query setMode:[mode text]];
            //[query setEasyAccess:[easyAccessSwitch isOn]]; This method will have significance once the switch is visible in view
            [query setWalkSpeed:[[NSUserDefaults standardUserDefaults]objectForKey:@"walk_speed"]];
            [query setMaxWalkTime:[[NSUserDefaults standardUserDefaults]objectForKey:@"max_walk_time"]];
            [query setMinTransferWaitTime:[[NSUserDefaults standardUserDefaults]objectForKey:@"min_transfer_wait_time"]];
            [query setMaxTransferWaitTime:[[NSUserDefaults standardUserDefaults]objectForKey:@"max_transfer_time"]];
            [query setMaxTransfers:[[NSUserDefaults standardUserDefaults]objectForKey:@"max_transfers"]];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                MSRoute *route = [query getRoute];
                if (route == NULL) {
                    UIAlertView *failQuery = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There is no available route for the query you just entered. Please try a different query" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [activityView animateRemove];
                    [failQuery show];
                } else {
                    navigoResultViewController *resultView = [[navigoResultViewController alloc]initWithMSRoute:route];
                    [activityView animateRemove];
                    [MSUtilities presentViewController:resultView withParent:self];
                }

            });
        });
    }
}
//Small helper method for submit button. Check whether all fields are filled in, and changes button to "submit" when applicable
-(void)fieldChecker
{
    if ([self fieldsFilled]) [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    else [submitButton setTitle:@"Next" forState:UIControlStateNormal];
}
//Method to combine date and time pickers together
-(NSDate *)combineTimeAndDatePickers {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:self.datePicker.date];
    NSDateComponents *timeComponents = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:self.timePicker.date];
    
    NSDateComponents *newComponents = [[NSDateComponents alloc]init];
    [newComponents setDay:[dateComponents day]];
    [newComponents setMonth:[dateComponents month]];
    [newComponents setYear:[dateComponents year]];
    [newComponents setHour:[timeComponents hour]];
    [newComponents setMinute:[timeComponents minute]];
    
    NSDate *result = [calendar dateFromComponents:newComponents];
    return result;
}


#pragma mark - Method to detect whether all fields are filled
-(BOOL)fieldsFilled {
    BOOL originBOOL = NO;
    BOOL destinationBOOL = NO;
    BOOL timeBOOL = NO;
    BOOL dateBOOL = NO;
    BOOL modeBOOL = NO;
    if ([query getOriginString] != NULL) originBOOL = YES;
    if ([query getDestinationString] != NULL) destinationBOOL = YES;
    if ([self containsSomething:timeField]) timeBOOL = YES;
    if ([self containsSomething:dateField]) dateBOOL = YES;
    if ([self containsSomething:mode]) modeBOOL = YES;
    if (originBOOL && destinationBOOL && timeBOOL && dateBOOL && modeBOOL) return YES;
    else return NO;
}
//Small method to cut down on clutter on above method
-(BOOL)containsSomething:(UITextField *)theTextField {
    if ([theTextField.text isEqualToString:@""]) return NO;
    else return YES;
}

#pragma mark -

-(void)updateFields {
    MSLocation *originLocation = [query getOrigin];
    MSLocation *destinationLocation = [query getDestination];
    if (originLocation != NULL) {
        [originLabel setTitle:[originLocation getHumanReadable] forState:UIControlStateNormal];
    } else {
        [originLabel setTitle:@"Origin" forState:UIControlStateNormal];
    }
    if (destinationLocation != NULL) {
        [destinationLabel setTitle:[destinationLocation getHumanReadable] forState:UIControlStateNormal];
    } else {
        [destinationLabel setTitle:@"Destination" forState:UIControlStateNormal];
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
    //Part of old structure, might need to be replaced
    //[queriedDictionary removeAllObjects];
    [submitButton setTitle:@"Next" forState:UIControlStateNormal];
    [self resetDatePickers];
    mode.text = @"Depart After";
    [query setOrigin:NULL];
    [query setDestination:NULL];
    [self updateFields];
    [AnimationInstructionSheet toStageOne:self];
}

-(IBAction)testButton
{
    //Nothing requires this button right now
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

-(IBAction)queryHistoryButton {
    QueryHistoryViewController *queryHistoryController = [[QueryHistoryViewController alloc]initWithNibName:@"QueryHistoryViewController" bundle:[NSBundle mainBundle]];
    [MSUtilities presentViewController:queryHistoryController withParent:self];
}

-(IBAction)tripHistoryButton
{
    //RouteHistoryViewController *tripHistoryController = [[RouteHistoryViewController alloc]initSavedRouteViewController];
    //[MSUtilities presentViewController:tripHistoryController withParent:self];
}

-(void)resetDatePickers {
    [self resetTimePicker];
    [self resetDatePicker];
    [query setDate:[NSDate date]];
}
-(void)resetTimePicker {
    [timePicker setDate:[NSDate date]];
    NSString *display = [navigoViewLibrary timeFromNSDate:[NSDate date]];
    timeField.text = display;
}
-(void)resetDatePicker {
    [datePicker setDate:[NSDate date]];
    NSString *display = [navigoViewLibrary dateFromNSDate:[NSDate date]];
    dateField.text = display;
}

#pragma mark - Actions for origin and destination suggestion boxes

-(IBAction)originBoxEdit {
    currentField = @"origin";
    //suggestionBox = [[MSSuggestionBox alloc] initWithFrameFromField:origin];
    [self.view addSubview:suggestionBox.tableView];
}
-(IBAction)originBoxChanged {
    [suggestionBox generateSuggestions:origin.text];
}
-(IBAction)originBoxFinished {
    [suggestionBox.tableView removeFromSuperview];
    suggestionBox = nil;
}
-(IBAction)destinationBoxEdit {
    currentField = @"destination";
    //suggestionBox = [[MSSuggestionBox alloc] initWithFrameFromField:destination];
    [self.view addSubview:suggestionBox.tableView];
}
-(IBAction)destinationBoxChanged {
    [suggestionBox generateSuggestions:destination.text];
}
-(IBAction)destinationBoxFinished {
    [suggestionBox.tableView removeFromSuperview];
    suggestionBox = nil;
}

#pragma mark -

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    /*
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else return NO; */
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Delegate for suggestion box

-(void)tableItemClicked:(MSLocation *)resultLocation {
    if ([currentField isEqualToString:@"origin"]) {
        [query setOrigin:resultLocation];
        [originLabel setTitle:[resultLocation getHumanReadable] forState:UIControlStateNormal];
    } else if ([currentField isEqualToString:@"destination"]) {
        [query setDestination:resultLocation];
        [destinationLabel setTitle:[resultLocation getHumanReadable] forState:UIControlStateNormal];
    }
    [self fieldChecker];
    [AnimationInstructionSheet toNextStage:self];
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
