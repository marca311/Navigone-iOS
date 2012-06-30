//
//  MSExitBar.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-06-29.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSExitBar : UIToolbar

-(MSExitBar *)initToView:(UIView *)parentView withParentResponder:(id)responder;

-(IBAction)killSender:(id)sender;

@property (nonatomic, retain) id theResponder;

@end
