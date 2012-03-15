//
//  navigoViewController.h
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "XMLParser.h"
#import "navigoInterpreter.h"
#import "UniversalViewController.h"

@interface navigoViewController : UniversalViewController <UITextFieldDelegate> {
    UITextField *origin;
}

@property (nonatomic, retain) UITextField *origin;
@property (nonatomic, retain) UITextField *destination;
@property (nonatomic, retain) UITextField *timeDate;
@property (nonatomic, retain) UITextField *mode;
@property (nonatomic, retain) UITextField *walkSpeed;
@property (nonatomic, retain) UITextField *maxWalkTime;
@property (nonatomic, retain) UITextField *minTransferWait;
@property (nonatomic, retain) UITextField *maxTransferWait;
@property (nonatomic, retain) UITextField *maxTransfers;

@end
