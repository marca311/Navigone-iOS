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
#import "MSSearchHistoryView.h"

@protocol TopBarDelegate <NSObject>

-(void)originSetWithLocation:(MSLocation *)location;
-(void)destinationSetWithLocation:(MSLocation *)location;
-(void)dateSetWithDate:(NSDate *)dateAndTime;

@end

@interface MSTopBar : UIView <SuggestionBoxDelegate, UITextFieldDelegate, MSSearchHistoryDelegate> {
    __weak id <TopBarDelegate> delegate;
    
    UITextField *textField;
    
}

@property (nonatomic, weak) id <TopBarDelegate> delegate;

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextField *timeField;
@property (nonatomic, retain) UITextField *dateField;
@property (nonatomic, retain) UITextField *modeField;

-(id)initWithFrame:(CGRect)frame andParentViewController:(UIViewController *)aParentViewController;

-(void)goToOriginStage;
-(void)goToDestinationStage;
-(void)goToDateStage;

@end
