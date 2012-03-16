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

@implementation navigoViewController

@synthesize origin;
@synthesize destination;
@synthesize timeDate;
@synthesize mode;
@synthesize walkSpeed;
@synthesize maxWalkTime;
@synthesize minTransferWait;
@synthesize maxTransferWait;
@synthesize maxTransfers;
@synthesize originLabel;
@synthesize timePicker;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    timePicker.datePickerMode = 2;
    
    [timePicker setDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"
    
    [super viewDidLoad];
}


-(IBAction)submitButton:(id)sender
{
    NSString *nomz = [navigoInterpreter getAddressKeyFromSearchedItem:origin.text ];
    NSLog(nomz);
    originLabel.text = nomz;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { 
    // Make a new view, or do what you want here
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,200,0,0)];
    [self.view addSubview:timePicker];
    
    return NO;
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
