//
//  MSResultsView.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2/21/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSRoute.h"

@protocol ResultsViewDelegate <NSObject>

//Nothing here yet

@end

@interface MSResultsView : UIView

-(id)initWithFrame:(CGRect)frame andRoute:(MSRoute *)aRoute;

@end
