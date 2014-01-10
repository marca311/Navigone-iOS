//
//  MSInfoBlock.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"

@interface MSInfoBox : UIView {
    
}

-(void)setOriginLocation:(MSLocation *)location;
-(void)setDestinationLocation:(MSLocation *)location;
-(void)setMode:(NSString *)mode;
-(void)setDate:(NSDate *)date;

@end
