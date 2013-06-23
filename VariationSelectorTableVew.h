//
//  PlanSelectorTableVew.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VariationTableViewCell.h"
#import "MSRoute.h"

@interface VariationSelectorTableVew : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    MSRoute *routeData;
    NSArray *variationsArray;
}

@property (nonatomic) CGRect tableRect;
@property (nonatomic, retain) NSArray *resultsArray;

- (id)initWithFrameFromButton:(UIButton *)button;

- (void)showAndAnimate:(UIView *)theView Route:(MSRoute *)route;

- (void)closeAndAnimate;

@end
