//
//  SavedRouteViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-01-28.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedRouteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *theTableView;
}

@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) NSArray *savedRoutes;
@property (nonatomic, retain) NSArray *previousRoutes;
@property (nonatomic) BOOL fileExists;

-(id)initSavedRouteViewController;

+(void)addRoute:(NSString *)theURL :(NSArray *)theRoute;

@end
