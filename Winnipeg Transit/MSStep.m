//
//  MSStep.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-06-22.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "MSStep.h"

@implementation MSStep

-(NSString *)getHumanReadable {
    return text;
}
-(NSString *)getTime {
    if (time != NULL) return time;
    else return @"";
}
-(NSString *)getType {
    return type;
}

@end
