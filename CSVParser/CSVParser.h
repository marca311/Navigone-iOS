//
//  CSVParser.h
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/26/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVParser : NSObject

-(id)initWithContentsOfFile:(NSString *)pathToFile;

-(NSArray *)contentsForRow:(int)row;

-(NSArray *)contentsForColumn:(int)column;
-(NSArray *)contentsForColumnFromString:(NSString *)column;

-(NSArray *)findContentsOfRowContainingString:(NSString *)query;
-(NSArray *)findContentsOfRowContainingString:(NSString *)query fromColumn:(int)column;

@end
