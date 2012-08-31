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

//Main Animation Arguments
+(void)toStageOne:(navigoViewController *)naviView;
+(void)toStageTwo:(navigoViewController *)naviView;
+(void)toStageThree:(navigoViewController *)naviView;

//Secondary Animation Arguments
+(void)stageOneToStageTwo:(navigoViewController *)naviView;
+(void)stageOneToStageThree:(navigoViewController *)naviView;
+(void)stageTwoToStageThree:(navigoViewController *)naviView;
+(void)stageThreeToStageTwo:(navigoViewController *)naviView;
+(void)stageThreeToStageOne:(navigoViewController *)naviView;
+(void)stageTwoToStageOne:(navigoViewController *)naviView;

@end
