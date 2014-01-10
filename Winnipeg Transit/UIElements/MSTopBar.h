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

-(void)originSetWithLocation:(MSLocation *)location;
-(void)destinationSetWithLocation:(MSLocation *)location;
-(void)dateSetWithDate:(NSDate *)dateAndTime;

@end

@interface MSTopBar : UIView <SuggestionBoxDelegate, UITextFieldDelegate> {
    __weak id <TopBarDelegate> delegate;
    
    UITextField *textField;
}

@property (nonatomic, weak) id <TopBarDelegate> delegate;

@property (nonatomic, retain) UITextField *textField;

@end
