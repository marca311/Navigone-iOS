//
//  MSTopCell.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/28/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTextFieldCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@end
