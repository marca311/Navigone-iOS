//
//  AnimationInstructionSheet.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-08-28.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import "AnimationInstructionSheet.h"
#import "navigoViewController.h"
#import "MSUtilities.h"

@implementation AnimationInstructionSheet

//Relative Methods
+(void)toNextStage:(navigoViewController *)naviView {
    [naviView fieldChecker];
    int buttonLocation = [naviView.submitButton checkCurrentLocation];
    switch (buttonLocation) {
        case 1:
            [self stageOneToStageTwo:naviView];
            break;
        case 2:
            [self stageTwoToStageThree:naviView];
            break;
    }
}
+(void)toPreviousStage:(navigoViewController *)naviView {
    [naviView fieldChecker];
    int buttonLocation = [naviView.submitButton checkCurrentLocation];
    switch (buttonLocation) {
        case 3:
            [self stageThreeToStageTwo:naviView];
            break;
        case 2:
            [self stageTwoToStageOne:naviView];
    }
}

//Main Animation Methods
//These are to cut down on the amount of other methods I would otherwise have to write.
//These are linked to the view controller so I don't have to introduce so many objects into one method.
+(void)toStageOne:(navigoViewController *)naviView;
{
    [naviView fieldChecker];
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
    [naviView fieldChecker];
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
    [naviView fieldChecker];
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

//Secondary Animation Methods
+(void)stageOneToStageTwo:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.origin isFirstResponder]) {
        [naviView.destination becomeFirstResponder];
    }
    
    [naviView updateFields];
     
    //Moves destination label, because the origin label never has to move
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 67;
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 49;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 96;
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
}//stageOneToStageTwo

+(void)stageOneToStageThree:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.origin isFirstResponder]) {
        [naviView.timeField becomeFirstResponder];
    }
    
    [naviView updateFields];
    
    //Move all components up to proper positions
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 67;
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 49;
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 96;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 114;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 182;
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
}//stageOneToStageThree

+(void)stageTwoToStageThree:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.destination isFirstResponder]) {
        [naviView.timeField becomeFirstResponder];
    }
    
    [naviView updateFields];
    
    //Move all components up to proper positions
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 96;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 114;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 182;
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
}//stageTwoToStageThree

+(void)stageThreeToStageTwo:(navigoViewController *)naviView
{
    //Dismiss pickers and if a responder is already in action, switch responders
    if ([naviView.timeField isFirstResponder] || [naviView.dateField isFirstResponder] || [naviView.mode isFirstResponder]) {
        [naviView.destination becomeFirstResponder];
    }
    
    [naviView updateFields];
    
    //Move all components up to proper positions
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 135;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 153;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 96;
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
}//stageThreeToStageTwo

+(void)stageThreeToStageOne:(navigoViewController *)naviView
{
    //Dismiss pickers and if a responder is already in action, switch responders
    if ([naviView.timeField isFirstResponder] || [naviView.dateField isFirstResponder] || [naviView.mode isFirstResponder]) {
        [naviView.origin becomeFirstResponder];
    }
    
    [naviView updateFields];
    
    //Move all components up to proper positions
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 88;
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 106;
    CGRect destinationSep = naviView.destinationSeparator.frame;
    destinationSep.origin.y = 135;
    CGRect timeDateLabel = naviView.timeDateLabel.frame;
    timeDateLabel.origin.y = 153;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 49;
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
}//stageThreeToStageOne

+(void)stageTwoToStageOne:(navigoViewController *)naviView
{
    //Dismiss keyboard and if a responder is already in action, switch responders
    if ([naviView.destination isFirstResponder]) {
        [naviView.origin becomeFirstResponder];
    }
    
    [naviView updateFields];
    
    //Move all components up to proper positions
    CGRect originSep = naviView.originSeparator.frame;
    originSep.origin.y = 88;
    CGRect destinationLabelRect = naviView.destinationLabel.frame;
    destinationLabelRect.origin.y = 106;
    CGRect submitButtonRect = naviView.submitButton.frame;
    submitButtonRect.origin.y = 49;
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
}//stageTwoToStageOne

@end
