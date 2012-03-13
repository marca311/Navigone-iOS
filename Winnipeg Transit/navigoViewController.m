//
//  navigoViewController.m
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "navigoViewController.h"
#import "TBXML.h"
#import "XMLParser.h"

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
    TBXML *theFile = [XMLParser loadXmlDocumentFromFile:@"10064.xml"];
    TBXMLElement *theElement = [XMLParser getRootElement:theFile];
    TBXMLElement *extractedElement = [XMLParser extractElementFromParent:@"cross-street" :theElement];
    extractedElement = [XMLParser extractElementFromParent:@"key" :extractedElement];
    NSString *nomz = [XMLParser extractAttributeFromElement:extractedElement];
    NSLog(nomz);
    [super viewDidLoad];
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
