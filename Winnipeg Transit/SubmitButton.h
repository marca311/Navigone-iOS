//
//  SubmitButton.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-07-22.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitButton : UIButton {
    int firstLocation;
    int secondLocation;
    int thirdLocation;
}

-(int)checkCurrentLocation;

-(void)nextButtonLocation;

@end
