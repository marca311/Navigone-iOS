//
//  MSSuggestionBox.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSuggestions.h"

@protocol SuggestionBoxDelegate

@optional
-(void)tableItemClicked:(MSLocation *)resultLocation;
-(void)suggestionBoxFrameWillChange:(CGRect)frame;

@end

@interface MSSuggestionBox : UITableViewController <UITableViewDataSource, UITableViewDelegate>

-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrameFromField:(UITextField *)textField;

-(void)generateSuggestions:(NSString *)query;

-(void)dismissSuggestionBox;

@end
