//
//  AnimationInstructionSheet.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12-08-28.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSeparator.h"
#import "SubmitButton.h"
#import "navigoViewController.h"

@interface AnimationInstructionSheet : NSObject

//Relative Animation Methods
+(void)toNextStage:(navigoViewController *)naviView;
+(void)toPreviousStage:(navigoViewController *)naviView;

//Main Animation Methods
+(void)toStageOne:(navigoViewController *)naviView;
+(void)toStageTwo:(navigoViewController *)naviView;
+(void)toStageThree:(navigoViewController *)naviView;

//Secondary Animation Methods
+(void)stageOneToStageTwo:(navigoViewController *)naviView;
+(void)stageOneToStageThree:(navigoViewController *)naviView;
+(void)stageTwoToStageThree:(navigoViewController *)naviView;
+(void)stageThreeToStageTwo:(navigoViewController *)naviView;
+(void)stageThreeToStageOne:(navigoViewController *)naviView;
+(void)stageTwoToStageOne:(navigoViewController *)naviView;

//Methods for other stuff relating to animation
+(BOOL)changeLabel:(NSString *)fieldText;
+(NSString *)getLabelLocation:(NSString *)field;

@end
