//
//  MSTableViewCell.h
//  Winnipeg Transit
//
//  Created by Tristan Brenneman on 12-06-08.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UILabel *time;

@end
