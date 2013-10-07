//
//  MSSuggestionBox.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-24.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "MSSuggestionBox.h"
#import <QuartzCore/QuartzCore.h>
#import "SuggestionBoxCell.h"
#import "MSUtilities.h"
#import "apiKeys.h"
#import "MSLocation.h"
#import "MSSegment.h"

@implementation MSSuggestionBox

-(id)initWithFrameFromField:(UITextField *)textField {
    CGRect theFrame;
    theFrame.origin.x = textField.frame.origin.x;
    theFrame.origin.y = (textField.frame.origin.y + textField.frame.size.height);
    
    theFrame.size.width = textField.frame.size.width;
    theFrame.size.height = 100;
        
    self.tableView = [self.tableView init];
    self.tableView.frame = theFrame;
    
    //Border
    CALayer *layer = self.tableView.layer;
    layer.borderWidth = 2;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;
    
    self.tableView.dataSource = self;
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
}//sendQuery
-(NSArray *)getQuerySuggestions:(NSString *)query {
    //Makes the suggestion array for the suggestions table
    if (![MSUtilities isQueryBlank:query])
    {
        NSMutableArray *result = [[NSMutableArray alloc]init];
        NSData *queryXML = [self getXMLFileForSearchedItem:query];
        if ([MSUtilities queryIsError:queryXML] == YES) {
            NSArray *result = [[NSArray alloc]initWithObjects: nil];
            return result;
        }
        TBXML *theFile = [XMLParser loadXmlDocumentFromData:queryXML];
        //Get root element
        TBXMLElement *theElement = [XMLParser getRootElement:theFile];
        TBXMLElement *theElementChild = [XMLParser extractUnknownChildElement:theElement];
        do {
            MSLocation *theLocation = [MSSegment setLocationTypesFromElement:theElementChild];
            [result addObject:theLocation];
        } while ((theElementChild = theElementChild->nextSibling));
        return result;
    } else {
        NSArray *result = [[NSArray alloc]initWithObjects: nil];
        return result;
    }
}
-(NSData *)getXMLFileForSearchedItem:(NSString *)query {
    //Gets the NSData file containing the suggestions based on the query argument
    NSData *resultXMLFile = [[NSData alloc]init];
    int tries = 0;
    do {
        if ([MSUtilities isQueryBlank:query] == YES) return nil;
        else {
            query = [self replaceInvalidCharacters:query];
            tries = tries + 1;
            query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            NSString *queryURL = [NSString stringWithFormat: @"http://api.winnipegtransit.com/locations:%@?api-key=%@", query, transitAPIKey];
            NSURL *checkURL = [[NSURL alloc]initWithString:queryURL];
            resultXMLFile = [NSData dataWithContentsOfURL:checkURL];
        }
    } while (resultXMLFile == nil);
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Tries: %i",tries);
#endif
    
    return resultXMLFile;
    
}
-(NSString *)replaceInvalidCharacters:(NSString *)theString {
    //Omits characters that would screw up the query from the query string before it gets sent to the server
    NSCharacterSet *theSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@- "];
    theSet = [theSet invertedSet];
    theString = [[theString componentsSeparatedByCharactersInSet:theSet ]componentsJoinedByString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"*" withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    return theString;
}


-(void)changeSizeFromEntries:(NSArray *)array
{
    int sizeOfCell = 40;
    int numberOfEntries = [array count];
    CGRect theFrame = self.tableView.frame;
    theFrame.size.height = (numberOfEntries * sizeOfCell) + sizeOfCell;
    self.tableView.frame = theFrame;
    [self.tableView reloadData];
}

-(void)dismissSuggestionBox {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return ([suggestions getNumberOfEntries]+1); }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSArray *contentForThisRow = [[self currentArray] objectAtIndex:[indexPath row]];
    NSString *uniqueIdentifier = @"CellIdentifier";
    SuggestionBoxCell *cell = nil;
    cell = (SuggestionBoxCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SuggestionBoxCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (SuggestionBoxCell *)currentObject;
                break;
            }
        }

    }
    if (indexPath.row == [suggestions getNumberOfEntries]) {
        cell.textBox.text = @"Search History";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        MSLocation *location = [suggestions getLocationAtIndex:indexPath.row];
        cell.textBox.text = [location getHumanReadable];
    }
    
    return cell;
}

-(MSSuggestions *)getSuggestions {
    return suggestions;
}

@end
