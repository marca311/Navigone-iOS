//
//  MSTextField.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-02-21.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"

@interface MSTextField : UITextField {
    MSLocation *location;
}

-(void)setLocation:(MSLocation *)input;

-(MSLocation *)getLocation;

@end
