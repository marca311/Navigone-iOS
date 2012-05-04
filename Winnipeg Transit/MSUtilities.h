//
//  MSUtilities.h
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-19.
//  Copyright (c) 2012 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUtilities : NSObject

+(void)saveMutableDictionaryToFile:(NSMutableDictionary *)savedDictionary:(NSString *)fileName;

+(void)saveDictionaryToFile:(NSDictionary *)savedDictionary:(NSString *)fileName;

+(void)saveMutableArrayToFile:(NSMutableArray *)savedArray:(NSString *)fileName;

+(void)saveArrayToFile:(NSArray *)savedArray:(NSString *)fileName;

+(NSString *)getFirmwareVersion;

+(BOOL)firmwareIsHigherThanFour;

@end
