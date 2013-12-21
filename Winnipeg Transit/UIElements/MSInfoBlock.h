//
//  MSInfoBlock.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSInfoBlock : UIView {
    UILabel *originLabel;
    UILabel *originInfo;
    UILabel *destinationLabel;
    UILabel *destinationInfo;
    UITextField *timeField;
    UITextField *dateField;
    UITextField *modeField;
}

@end
