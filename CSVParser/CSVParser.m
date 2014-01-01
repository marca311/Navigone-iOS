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
        
        NSMutableArray *allColumns = [[NSMutableArray alloc]initWithCapacity:self.columnNames.count];
        for (int i = 0; i < self.columnNames.count; i++) {
            NSMutableArray *currentColumn = [[NSMutableArray alloc]initWithCapacity:self.rows.count];
            for (int c = 0; c < self.rows.count; i++) {
                NSArray *rowContents = [[rows objectAtIndex:3]componentsSeparatedByString:@","]; //change the 3
                [currentColumn addObject:[rowContents objectAtIndex:i]];
            }
        }
    }
    return self;
}

-(NSArray *)contentsForRow:(int)row {
    NSString *rowString = [rows objectAtIndex:row];
    return [rowString componentsSeparatedByString:@","];
}

@end