//
//  MSTopBar.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopBarDelegate <NSObject>

//Something

@end

@interface MSTopBar : UIView {
    UILabel *label;
    UITextField *textField;
    UIButton *submitButton;
}



@end
