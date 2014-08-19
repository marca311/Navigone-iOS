//
//  MSResultsView.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2/21/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import "MSResultsView.h"

@interface MSResultsView ()

@property (nonatomic, retain) MSRoute *route;
@property (nonatomic, retain) UITableView *table;

@end

@implementation MSResultsView

@synthesize route, table;

- (id)initWithFrame:(CGRect)frame andRoute:(MSRoute *)aRoute
{
    self = [super initWithFrame:frame];
    if (self) {
        route = aRoute;
        
        table = [[UITableView alloc]initWithFrame:frame];
        [table setDelegate:self];
        [table setDataSource:self];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[route getVariationFromIndex:0]getNumberOfSegments];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *uniqueIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    }
    
    return cell;
}

@end
