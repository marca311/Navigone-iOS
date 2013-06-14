//
//  PlanTableViewCell.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-15.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariationTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *startTime;
@property (nonatomic, retain) IBOutlet UILabel *endTime;
@property (nonatomic, retain) IBOutlet UILabel *buses;

@end
