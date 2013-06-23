//
//  PlanDisplayTableViewController.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-09-27.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTableViewCell.h"
#import "navigoViewLibrary.h"
#import "MSVariation.h"

@interface VariationDisplayTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    MSVariation *variationData;
    NSArray *stepArray;
}

@property (nonatomic, retain) NSArray *currentArray;
@property (nonatomic, retain) UIImage *locationImage;
@property (nonatomic, retain) UIImage *stopImage;
@property (nonatomic, retain) UIImage *monumentImage;
@property (nonatomic, retain) UIImage *rideImage;
@property (nonatomic, retain) UIImage *walkImage;
@property (nonatomic, retain) UIImage *transferImage;

-(id)initWithCorrectFrame:(MSVariation *)theVariation;

-(void)showTable:(UIView *)theView;

-(void)changeTableVariation:(MSVariation *)theVariation;

@end
