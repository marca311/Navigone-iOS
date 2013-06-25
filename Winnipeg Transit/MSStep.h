//
//  MSStep.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-22.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSStep : NSObject <NSCoding> {
    NSString *text;
    NSString *type;
    NSString *time;
}

-(NSString *)getHumanReadable;
-(NSString *)getTime;
-(NSString *)getType;

@end
