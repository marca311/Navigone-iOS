//
//  navigoInterpreter.h
//  Winnipeg Transit
//
//  Created by Keith Brenneman on 12-03-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface navigoInterpreter : NSObject

-(NSData *)getXMLFileFromResults:(NSString *)origin:(NSString *)destination:(NSString *)date:(NSString *)time:(NSString *)mode:(BOOL)easyAccess:(int)walkSpeed:(int)maxWalkTime:(int)minTransferWait:(int)maxTransferWait:(int)maxTransfers;

//-(NSString *)getTotalWalkTime

@end
