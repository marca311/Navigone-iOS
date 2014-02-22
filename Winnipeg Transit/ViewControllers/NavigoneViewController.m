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

@interface NavigoneViewController () <TopBarDelegate, MSInfoBlockDelegate> {
    MSTopBar *topBar;
    MSInfoBox *infoBox;
}

@property (nonatomic) BOOL isOffline;

@property (nonatomic) int statusBarAdjustment;
@property (nonatomic, retain) GMSMapView *mainMap;
@property (nonatomic, retain) GMSCameraPosition *camera;
@property (nonatomic, retain) MSTopBar *topBar;
@property (nonatomic, retain) MSInfoBox *infoBox;

@property (nonatomic, retain) MSQuery *query;

@end

@implementation NavigoneViewController

@synthesize isOffline;
@synthesize statusBarAdjustment, mainMap, camera, topBar, infoBox;
@synthesize query;

-(id)init {
    self = [super init];
    if (self) {
        //Something goes in here, I'm not sure yet.
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
	
    camera = [GMSCameraPosition cameraWithLatitude:49.8994 longitude:-97.1392 zoom:11];
    mainMap = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    [self.view addSubview:mainMap];
    
    
    CGRect topBarRect = CGRectMake((width/2)-145, 5 + statusBarAdjustment, 290, 60);
    topBar = [[MSTopBar alloc]initWithFrame:topBarRect andParentViewController:self];
    topBar.delegate = self;
    [self.view addSubview:topBar];
    
    float infoBoxY = height - 184;
    float infoBoxHeight = 184; //The 5 adds padding from the bottom of the screen
    CGRect infoBoxRect = CGRectMake(5, infoBoxY, 150, infoBoxHeight);
    infoBox = [[MSInfoBox alloc]initWithFrame:infoBoxRect];
    infoBox.delegate = self;
    [self.view addSubview:infoBox];
}

#pragma mark - Top Bar Delegate Methods
-(void)originSetWithLocation:(MSLocation *)location {
    [query setOrigin:location];
    [infoBox setOriginLocation:location];
    GMSMarker *originMarker = [[GMSMarker alloc]init];
    [originMarker setPosition:[location getMapCoordinates]];
    [originMarker setIcon:[UIImage imageNamed:@"origin_flag.png"]];
    camera = [GMSCameraPosition cameraWithTarget:[location getMapCoordinates] zoom:11];
    [mainMap animateToCameraPosition:camera];
    [originMarker setMap:mainMap];
}
-(void)destinationSetWithLocation:(MSLocation *)location {
    [query setDestination:location];
    [infoBox setDestinationLocation:location];
    GMSMarker *destinationMarker = [[GMSMarker alloc]init];
    [destinationMarker setPosition:[location getMapCoordinates]];
    [destinationMarker setIcon:[UIImage imageNamed:@"destination_flag.png"]];
    camera = [GMSCameraPosition cameraWithTarget:[location getMapCoordinates] zoom:11];
    [mainMap animateToCameraPosition:camera];
    [destinationMarker setMap:mainMap];
}
-(void)dateSetWithDate:(NSDate *)dateAndTime {
    [query setDate:dateAndTime];
}
-(void)submitQueryButtonPressed {
    [query getRoute];
}

#pragma mark - Info Box Delegate Methods
-(void)originButtonPressed {
    [topBar goToOriginStage];
}
-(void)destinationButtonPressed {
    [topBar goToDestinationStage];
}
-(void)dateButtonPressed {
    [topBar goToDateStage];
}

@end
