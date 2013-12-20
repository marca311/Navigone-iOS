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

-(void)tableItemClicked:(MSLocation *)resultLocation;

@end

@interface MSSuggestionBox : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    MSSuggestions *suggestions;
    UITextField *textField;
    
    id <SuggestionBoxDelegate> suggestionDelegate;
}

-(id)initWithFrameFromField:(UITextField *)textField;

-(void)generateSuggestions:(NSString *)query;

-(void)dismissSuggestionBox;

@end
