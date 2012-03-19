//
//  MSUtilities.h
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUtilities : NSObject

+(NSString *)getFirmwareVersion;

+(BOOL)firmwareIsHigherThanFour;

@end
