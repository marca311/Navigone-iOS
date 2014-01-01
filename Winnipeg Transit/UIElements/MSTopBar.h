//
//  MSTopBar.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"
#import "MSSuggestionBox.h"

@protocol TopBarDelegate <NSObject>

-(void)setOrigin:(MSLocation *)location;
-(void)setDestination:(MSLocation *)location;
-(void)setDateAndTime:(NSDate *)dateAndTime;

@end

@interface MSTopBar : UIView <SuggestionBoxDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *textField;
}

@end
