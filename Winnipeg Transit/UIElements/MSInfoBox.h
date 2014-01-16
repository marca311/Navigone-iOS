//
//  MSInfoBlock.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/20/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"

@protocol MSInfoBlockDelegate <NSObject>

-(void)originButtonPressed;
-(void)destinationButtonPressed;
-(void)dateButtonPressed;

@end

@interface MSInfoBox : UIView {
    __weak id <MSInfoBlockDelegate> delegate;
}

@property (nonatomic, weak) id <MSInfoBlockDelegate> delegate;

-(void)setOriginLocation:(MSLocation *)location;
-(void)setDestinationLocation:(MSLocation *)location;
-(void)setMode:(NSString *)mode;
-(void)setDate:(NSDate *)date;

@end
