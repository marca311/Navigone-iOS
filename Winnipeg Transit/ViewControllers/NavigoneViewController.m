//
//  NavigoneViewController.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "NavigoneViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

#import "MSTopBar.h"
#import "MSInfoBox.h"
#import "MSQuery.h"
#import "MSUtilities.h"

@interface NavigoneViewController () <TopBarDelegate> {
    MSTopBar *topBar;
}

@property (nonatomic) BOOL isOffline;

@property (nonatomic) int statusBarAdjustment;
@property (nonatomic, retain) GMSMapView *mainMap;
@property (nonatomic, retain) MSTopBar *topBar;
@property (nonatomic, retain) MSInfoBox *infoBox;

@property (nonatomic, retain) MSQuery *query;

@end

@implementation NavigoneViewController

@synthesize isOffline;
@synthesize statusBarAdjustment, mainMap, topBar, infoBox;
@synthesize query;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check if the client has internet and if it doesn't, show an error message and go into a pre-determined offline mode
    if (![MSUtilities hasInternet]) {
        isOffline = TRUE;
    }
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    if ([MSUtilities firmwareIsSevenOrHigher]) {
        statusBarAdjustment = 20;
    } else {
        statusBarAdjustment = 0;
    }
	
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.8994 longitude:-97.1392 zoom:11];
    mainMap = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    [self.view addSubview:mainMap];
    
    CGRect topBarRect = CGRectMake(15, 5 + statusBarAdjustment, 290, 60);
    topBar = [[MSTopBar alloc]initWithFrame:topBarRect];
    [self.view addSubview:topBar];
    
    float infoBoxY = (height / 3) * 2;
    float infoBoxHeight = (height - infoBoxY) - 5; //The 5 adds padding from the bottom of the screen
    CGRect infoBoxRect = CGRectMake(5, infoBoxY, (width/2)-10, infoBoxHeight);
    infoBox = [[MSInfoBox alloc]initWithFrame:infoBoxRect];
    [self.view addSubview:infoBox];
}

#pragma mark - Top Bar Delegate Methods
-(void)originSetWithLocation:(MSLocation *)location {
    [query setOrigin:location];
}
-(void)destinationSetWithLocation:(MSLocation *)location {
    [query setDestination:location];
}
-(void)dateSetWithDate:(NSDate *)dateAndTime {
    [query setDate:dateAndTime];
}
#pragma mark -

@end
