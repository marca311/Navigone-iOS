//
//  AnimationInstructionSheet.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-08-28.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "AnimationInstructionSheet.h"
#import "navigoViewController.h"

@implementation AnimationInstructionSheet

//Main Animation Arguments
//These are to cut down on the amount of other methods I would otherwise have to write.
//These are linked to the view controller so I don't have to introduce so many objects into one method.
+(void)toStageOne:(navigoViewController *)naviView;
{
    int buttonLocation = [naviView.submitButton checkCurrentLocation];
    switch (buttonLocation) {
        case 2:
            [self stageTwoToStageOne:naviView];
            break;
        case 3:
            [self stageThreeToStageOne:naviView];
            break;
        default:
            break;
    }
}
+(void)toStageTwo:(navigoViewController *)naviView
{
    int buttonLocation = [naviView.submitButton checkCurrentLocation];
    switch (buttonLocation) {
        case 1:
            [self stageOneToStageTwo:naviView];
            break;
        case 3:
            [self stageThreeToStageTwo:naviView];
            break;
        default:
            break;
    }
}
+(void)toStageThree:(navigoViewController *)naviView
{
    int buttonLocation = [naviView.submitButton checkCurrentLocation];
    switch (buttonLocation) {
        case 1:
            [self stageOneToStageThree:naviView];
            break;
        case 2:
            [self stageTwoToStageThree:naviView];
            break;
        default:
            break;
    }
}

//Secondary Animation Arguments
+(void)stageOneToStageTwo:(navigoViewController *)naviView
{
    //Moves destination label, because the origin label never has to move
    CGRect destinationRect = naviView.destinationLabel.frame;
    destinationRect.origin.y = 55;
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 37;
    //Start animation blocks
    //Destination Label and Origin Separator animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.destinationLabel.frame = destinationRect;
    naviView.originSeparator.frame = originSep;
    [UIView commitAnimations];
    naviView.origin.alpha = 1;
    naviView.destination.alpha = 0;
    naviView.destination.hidden = NO;
    //Origin Separator animation block with 0.1 time delay
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.destination.alpha = 1;
    naviView.origin.alpha = 0;
    [UIView commitAnimations];
    naviView.origin.hidden = YES;
}
+(void)stageOneToStageThree:(navigoViewController *)naviView
{
    
}
+(void)stageTwoToStageThree:(navigoViewController *)naviView
{
    
}
+(void)stageThreeToStageTwo:(navigoViewController *)naviView
{
    
}
+(void)stageThreeToStageOne:(navigoViewController *)naviView
{
    
}
+(void)stageTwoToStageOne:(navigoViewController *)naviView
{
    
}

@end
