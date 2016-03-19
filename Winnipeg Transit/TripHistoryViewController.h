//
//  TripHistoryViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-21.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripHistoryCell.h"

@interface TripHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *theTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;


@end
