//
//  MSSuggestionBox.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSSuggestionBox.h"
#import <QuartzCore/QuartzCore.h>
#import "MSSuggestionBoxCell.h"
#import "MSSearchHistoryView.h"
#import "MSUtilities.h"
#import "apiKeys.h"
#import "MSLocation.h"
#import "MSSegment.h"

@interface MSSuggestionBox ()

@property (nonatomic, retain) MSSuggestions *suggestions;

@end

@implementation MSSuggestionBox

@synthesize suggestions, delegate;

-(id)initWithFrame:(CGRect)frame andDelegate:(id<SuggestionBoxDelegate>)delegateObject; {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.delegate = delegateObject;
        [delegate suggestionBoxFrameWillChange:frame];
        self.tableView.frame = frame;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)generateSuggestions:(NSString *)query {
    //Gets query suggestions on a separate thread
    //Make this have some kind of time stamp so that previous queries don't override newer ones when showing results on a slow connection.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MSSuggestions *newSuggestions = [[MSSuggestions alloc]initWithQuery:query];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            //Check if the recently searched suggestions is 
            if ([newSuggestions isYounger:suggestions]) {
                suggestions = newSuggestions;
            }
            [self.tableView reloadData];
        });
    });
}

-(void)setTextField:(UITextField *)textFieldInput {
    self.textField = textFieldInput;
}

//The +1 is to take into account the text entry cell and the search history cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return ([suggestions getNumberOfEntries]+1); }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSArray *contentForThisRow = [[self currentArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    MSSuggestionBoxCell *cell = nil;
    cell = (MSSuggestionBoxCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil) {
        cell = [[MSSuggestionBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uniqueIdentifier];
    }
    
    if (indexPath.row == [suggestions getNumberOfEntries]) {
        cell.textView.text = @"Search History";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        MSLocation *location = [suggestions getLocationAtIndex:indexPath.row];
        cell.textView.text = [location getHumanReadable];
    }
    return cell;
}

#pragma mark - Search History method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([tableView numberOfRowsInSection:0]-1)) {
        //Returns null if search history button is clicked
        [delegate tableItemClicked:NULL];
    } else {
        MSLocation *answer;
        answer = [suggestions getLocationAtIndex:indexPath.row];
        [delegate tableItemClicked:answer];
    }
}

@end
