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
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.origin isFirstResponder]) {
        [naviView.destination becomeFirstResponder];
    }
    
    //Moves destination label, because the origin label never has to move
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 55;
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 37;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 84;
    //Start animation blocks
    //Destination Label and Origin Separator animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.destinationLabel.frame = destinationLabelRect;
    naviView.originSeparator.frame = originSep;
    naviView.submitButton.frame = submitButtonRect;
    [UIView commitAnimations];
    //Prepares destintination and origin fields to be shown and hidden.
    naviView.origin.alpha = 1;
    naviView.destination.alpha = 0;
    naviView.destination.hidden = NO;
    //Hides origin field and shows destination field using a fade in.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.destination.alpha = 1;
    naviView.origin.alpha = 0;
    [UIView commitAnimations];
    naviView.origin.hidden = YES;
}
+(void)stageOneToStageThree:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.origin isFirstResponder]) {
        [naviView.timeField becomeFirstResponder];
    }

    
    //Move all components up to proper positions
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 55;
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 37;
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 84;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 102;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 170;
    //Start animation blocks
    //Component moving animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.destinationLabel.frame = destinationLabelRect;
    naviView.originSeparator.frame = originSep;
    naviView.timeDateLabel.frame = timeDateLabel;
    naviView.destinationSeparator.frame = destinationSep;
    naviView.submitButton.frame = submitButtonRect;
    [UIView commitAnimations];
    //Presetting fading properties
    naviView.origin.alpha = 1;
    naviView.timeField.alpha = 0;
    naviView.dateField.alpha = 0;
    naviView.mode.alpha = 0;
    naviView.timeField.hidden = NO;
    naviView.dateField.hidden = NO;
    naviView.mode.hidden = NO;
    //Field alpha fading block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.timeField.alpha = 1;
    naviView.dateField.alpha = 1;
    naviView.mode.alpha = 1;
    naviView.origin.alpha = 0;
    [UIView commitAnimations];
    naviView.origin.hidden = YES;

}
+(void)stageTwoToStageThree:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.destination isFirstResponder]) {
        [naviView.timeField becomeFirstResponder];
    }
    
    //Move all components up to proper positions
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 84;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 102;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 170;
    //Start animation blocks
    //Component moving animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.timeDateLabel.frame = timeDateLabel;
    naviView.destinationSeparator.frame = destinationSep;
    naviView.submitButton.frame = submitButtonRect;
    [UIView commitAnimations];
    //Presetting fading properties
    naviView.destination.alpha = 1;
    naviView.timeField.alpha = 0;
    naviView.dateField.alpha = 0;
    naviView.mode.alpha = 0;
    naviView.timeField.hidden = NO;
    naviView.dateField.hidden = NO;
    naviView.mode.hidden = NO;
    //Field alpha fading block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.destination.alpha = 0;
    naviView.timeField.alpha = 1;
    naviView.dateField.alpha = 1;
    naviView.mode.alpha = 1;
    [UIView commitAnimations];
    naviView.destination.hidden = YES;
}
+(void)stageThreeToStageTwo:(navigoViewController *)naviView
{
    //Dismiss pickers and if a responder is already in action, switch responders
    if ([naviView.timeField isFirstResponder] || [naviView.dateField isFirstResponder] || [naviView.mode isFirstResponder]) {
        [naviView.destination becomeFirstResponder];
    }
    
    //Move all components up to proper positions
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 123;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 141;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 84;
    //Start animation blocks
    //Component moving animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.timeDateLabel.frame = timeDateLabel;
    naviView.destinationSeparator.frame = destinationSep;
    naviView.submitButton.frame = submitButtonRect;
    [UIView commitAnimations];
    //Presetting fading properties
    naviView.timeField.alpha = 1;
    naviView.dateField.alpha = 1;
    naviView.mode.alpha = 1;
    naviView.destination.alpha = 0;
    naviView.destination.hidden = NO;
    //Field alpha fading block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.destination.alpha = 1;
    naviView.timeField.alpha = 0;
    naviView.dateField.alpha = 0;
    naviView.mode.alpha = 0;
    [UIView commitAnimations];
    naviView.timeField.hidden = YES;
    naviView.dateField.hidden = YES;
    naviView.mode.hidden = YES;

}
+(void)stageThreeToStageOne:(navigoViewController *)naviView
{
    //Dismiss pickers and if a responder is already in action, switch responders
    if ([naviView.timeField isFirstResponder] || [naviView.dateField isFirstResponder] || [naviView.mode isFirstResponder]) {
        [naviView.origin becomeFirstResponder];
    }
    
    //Move all components up to proper positions
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 76;
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 94;
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 123;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 141;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 37;
    //Start animation blocks
    //Component moving animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.originSeparator.frame = originSep;
    naviView.timeDateLabel.frame = timeDateLabel;
    naviView.destinationLabel.frame = destinationLabelRect;
    naviView.destinationSeparator.frame = destinationSep;
    naviView.submitButton.frame = submitButtonRect;
    [UIView commitAnimations];
    //Presetting fading properties
    naviView.timeField.alpha = 1;
    naviView.dateField.alpha = 1;
    naviView.mode.alpha = 1;
    naviView.origin.alpha = 0;
    naviView.origin.hidden = NO;
    //Field alpha fading block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.origin.alpha = 1;
    naviView.timeField.alpha = 0;
    naviView.dateField.alpha = 0;
    naviView.mode.alpha = 0;
    [UIView commitAnimations];
    naviView.timeField.hidden = YES;
    naviView.dateField.hidden = YES;
    naviView.mode.hidden = YES;
}
+(void)stageTwoToStageOne:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.destination isFirstResponder]) {
        [naviView.origin becomeFirstResponder];
    }    
    
    //Move all components up to proper positions
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 76;
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 94;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 37;
    //Start animation blocks
    //Component moving animation block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    naviView.originSeparator.frame = originSep;
    naviView.destinationLabel.frame = destinationLabelRect;
    naviView.submitButton.frame = submitButtonRect;
    [UIView commitAnimations];
    //Presetting fading properties
    naviView.origin.alpha = 0;
    naviView.origin.hidden = NO;
    //Field alpha fading block
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    naviView.destination.alpha = 0;
    naviView.origin.alpha = 1;
    [UIView commitAnimations];
    naviView.destination.hidden = YES;

}

@end
