//
//  CSVParser.m
//  Winnipeg Transit
//
//  Created by Marcus Dyck on 12/26/2013.
//  Copyright (c) 2013 marca311. All rights reserved.
//

#import "CSVParser.h"

@interface CSVParser ()

@property (retain, nonatomic) NSArray *columnNames;
@property (retain, nonatomic) NSArray *rows;
@property (retain, nonatomic) NSArray *columns;

@end

@implementation CSVParser

@synthesize columnNames, rows, columns;

-(id)initWithContentsOfFile:(NSString *)pathToFile {
    self = [super init];
    if (self) {
        NSString *fileString = [[NSString alloc]initWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray *allRows = (NSMutableArray *)[fileString componentsSeparatedByString:@"\n"];
        self.columnNames = [[allRows objectAtIndex:0]componentsSeparatedByString:@","];
        [allRows removeObjectAtIndex:0];
        self.rows = allRows;
        
        //Generate array of columns
        NSMutableArray *allColumns = [[NSMutableArray alloc]initWithCapacity:self.columnNames.count];
        for (int i = 0; i < self.columnNames.count; i++) {
            NSMutableArray *currentColumn = [[NSMutableArray alloc]initWithCapacity:self.rows.count];
            for (int j = 0; j < self.rows.count; j++) {
                NSArray *rowContents = [[rows objectAtIndex:j]componentsSeparatedByString:@","];
                [currentColumn addObject:[rowContents objectAtIndex:i]];
            }
            [allColumns addObject:currentColumn];
        }
    }
    return self;
}

-(NSArray *)contentsForRow:(int)row {
    NSString *rowString = [rows objectAtIndex:row];
    return [rowString componentsSeparatedByString:@","];
}
-(NSString *)contentsForRow:(int)row andColumn:(int)column {
    NSString *rowString = [rows objectAtIndex:row];
    NSArray *rowArray = [rowString componentsSeparatedByString:@","];
    return [rowArray objectAtIndex:column];
}

-(NSArray *)contentsForColumn:(int)column {
    
}
-(NSArray *)contentsForColumnFromString:(NSString *)column {
    
}

-(NSArray *)findContentsOfRowContainingString:(NSString *)query {
    
}
-(NSArray *)findContentsOfRowContainingString:(NSString *)query fromColumn:(int)column {
    
}

@end