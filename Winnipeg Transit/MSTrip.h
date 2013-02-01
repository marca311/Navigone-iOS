//
//  MSTrip.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 13-01-29.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTrip : NSObject

@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSURL *theURL;
//@property (nonatomic, retain) MSRoute *theRoute; This class has yet to be created

-(id)initWithURL:(NSURL *)queryURL origin:(NSString *)queryOrigin destination:(NSString *)queryDestination date:(NSDate *)queryDate;

-(NSString *)getOrigin;
-(NSString *)getDestination;
-(NSString *)getTime;
-(NSString *)getDate;

@end
