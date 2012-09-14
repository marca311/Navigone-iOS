//
//  PlanSelectorTableVew.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanTableViewCell.h"
#import "navigoInterpreter.h"

@interface PlanSelectorTableVew : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) CGRect tableRect;
@property (nonatomic, retain) NSArray *primaryResults;
@property (nonatomic, retain) NSArray *resultsArray;

- (id)initWithFrameFromButton:(UIButton *)button;

- (void)showAndAnimate:(UIView *)theView :(NSDictionary *)dictionary;

- (void)setDataSourceArray:(NSDictionary *)dictionary;

- (CGRect)getFrameSizeFromArray:(NSDictionary *)dictionary;

@end
