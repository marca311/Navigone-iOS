//
//  MSPullTabView.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 2/24/2014.
//  Copyright (c) 2014 marca311. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullTabDelegate <NSObject>

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface MSPullTabView : UIImageView {
    __weak id <PullTabDelegate> delegate;
}

@property (nonatomic, weak) id <PullTabDelegate> delegate;

@property (nonatomic) float touchOriginHeight;

- (id)initWithFrame:(CGRect)frame andParentView:(UIView *)aParentView;

@end
