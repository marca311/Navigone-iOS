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
#import "MSPullTabView.h"
#import "MSResultsView.h"
#import "MSQuery.h"
#import "MSUtilities.h"

@interface NavigoneViewController () <TopBarDelegate, InfoBoxDelegate, PullTabDelegate> {
    MSTopBar *topBar;
    MSInfoBox *infoBox;
    MSPullTabView *pullTabView;
}

@property (nonatomic) BOOL isOffline;

@property (nonatomic) int statusBarAdjustment;
@property (nonatomic, retain) GMSMapView *mainMap;
@property (nonatomic, retain) GMSCameraPosition *camera;
@property (nonatomic, retain) MSTopBar *topBar;
@property (nonatomic, retain) MSInfoBox *infoBox;
@property (nonatomic, retain) MSPullTabView *pullTabView;
@property (nonatomic, retain) MSResultsView * resultsView;

@property (nonatomic, retain) MSQuery *query;

@end

@implementation NavigoneViewController

@synthesize isOffline;
@synthesize statusBarAdjustment, mainMap, camera, topBar, infoBox, pullTabView, resultsView;
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
    [self.view addSubview:topBar.view];
    
    float infoBoxY = height - 184;
    float infoBoxHeight = 184; //The 5 adds padding from the bottom of the screen
    CGRect infoBoxRect = CGRectMake(5, infoBoxY, 150, infoBoxHeight);
    infoBox = [[MSInfoBox alloc]initWithFrame:infoBoxRect];
    infoBox.delegate = self;
    //[self.view addSubview:infoBox];
    
    pullTabView = [[MSPullTabView alloc]initWithFrame:CGRectMake((width/2)-33, height-30, 67, 30) andParentView:self.view];
    [pullTabView setImage:[UIImage imageNamed:@"pull_tab.png"]];
    [pullTabView setUserInteractionEnabled:YES];
    [pullTabView setDelegate:self];
    [self.view addSubview:pullTabView];
    
    resultsView = [[MSResultsView alloc]initWithFrame:CGRectMake((width/2)-33, height, 67, 200) andRoute:NULL];
    [self.view addSubview:resultsView.view];
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

#pragma mark - Pull Tab Delegate Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint touchPoint = [touch locationInView:pullTabView];
    [pullTabView setTouchOriginHeight:touchPoint.y];
    NSLog(@"%@", NSStringFromCGPoint(touchPoint));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    // Pulltab frame gets changed and applied through this var.
    CGRect newRect = pullTabView.frame;
    // The difference between the origin of the tab and the touch point.
    CGFloat originDifference = currentPoint.y - newRect.origin.y;
    // The difference between the size of the tab and the touch point.
    CGFloat heightDifference = newRect.size.height - pullTabView.touchOriginHeight;
    // If the pulltab goes below the screen, stop it.
    if ((currentPoint.y + heightDifference) > self.view.frame.size.height) {
        NSLog(@"The box stops here");
        newRect.origin.y = self.view.frame.size.height - newRect.size.height;
    } else if ((currentPoint.y + heightDifference) < self.view.frame.size.height / 2) {
        CGFloat halfway = self.view.frame.size.height / 2;
        newRect.origin.y = (currentPoint.y - pullTabView.touchOriginHeight) + (heightDifference / 2);
    } else {
        newRect.origin.y = currentPoint.y - pullTabView.touchOriginHeight;
    }
    pullTabView.frame = newRect;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat bottomY = pullTabView.frame.origin.y + pullTabView.frame.size.height;
    CGFloat halfway = self.view.frame.size.height / 2;
    CGFloat threshold = (self.view.frame.size.height / 4) * 3; // 3/4 down the screen
    CGFloat bottom = self.view.frame.size.height;
    CGRect newRect = pullTabView.frame;
    if (bottomY < threshold) {
        newRect.origin.y = halfway - newRect.size.height;
    } else {
        newRect.origin.y = bottom - newRect.size.height;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    pullTabView.frame = newRect;
    [UIView commitAnimations];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // On cancel, just spring back to a neutral location (top or bottom)
    [self touchesEnded:touches withEvent:event];
}

@end
