//
//  MSSuggestionBox.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSuggestionBox : UITableViewController <UITableViewDataSource> {
    
}

@property (nonatomic, retain) NSArray *tableArray;

-(id)initWithFrameFromField:(UITextField *)textField;

-(void)getSuggestions:(NSString *)query;

@end
