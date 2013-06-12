//
//  MSSuggestionBox.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSuggestions.h"

@interface MSSuggestionBox : UITableViewController <UITableViewDataSource> {
    MSSuggestions *suggestions;
}

-(id)initWithFrameFromField:(UITextField *)textField;

-(void)generateSuggestions:(NSString *)query;

-(void)dismissSuggestionBox;

-(MSSuggestions *)getSuggestions;

@end
