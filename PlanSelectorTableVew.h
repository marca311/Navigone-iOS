//
//  PlanSelectorTableVew.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanSelectorTableVew : UITableView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *planTableView;
}

@property 

- (void)setFrameFromButton:(UIButton *)button;

- (void)setDataSourceArray:(NSArray *)array;

@end
