//
//  TripHistoryCell.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-03-05.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripHistoryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *origin;
@property (nonatomic, retain) IBOutlet UILabel *destination;
@property (nonatomic, retain) IBOutlet UILabel *mode;
@property (nonatomic, retain) IBOutlet UILabel *time;

@end
