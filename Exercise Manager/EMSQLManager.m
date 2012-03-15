//
//  EMSQLManager.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMSQLManager.h"

@implementation EMSQLManager

+(void)  createDatabase {
     
    // Just need the database path
    NSString *pSDatabasePath = [EMSQLManager getDatabasePath]  ;
    
    if ([EMSQLManager checkIfDatabaseIsPresent: pSDatabasePath]) {
        return;
    } else {
        [EMSQLManager writeDatabaseForFirstTime];
    }
}

+(NSMutableArray *) readAllExercisesFromTable:(NSString *)tableName
{
    
    sqlite3 *database;
    
    NSMutableArray *pMAExercise = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat: @"SELECT * FROM '%@' ",tableName];
        NSLog(@"Query String: %@", pSQueryString);
        
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            NSLog(@"sqlite3_prepare_v2 ");
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *pSExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                
                EMExercises *exercise = [[EMExercises alloc] initWithName:pSExerciseName];
                [pMAExercise   addObject: exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return pMAExercise;
}

+ (NSString *)getDatabaseName
{
    // This should be a constant somewhere
    NSString *pSDatabaseName = @"ExerciseManager.sqlite";
    return pSDatabaseName;
}

+ (NSString *)getDatabasePath
{
    NSString *pSDatabaseName = [EMSQLManager getDatabaseName];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    
    NSString *pSDatabasePath = [documentsDir stringByAppendingPathComponent:pSDatabaseName];
    return pSDatabasePath;
}

+ (BOOL) checkIfDatabaseIsPresent: (NSString *)pSDatabasePath
{    
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    return [fileManager fileExistsAtPath:pSDatabasePath];
}

+ (void)writeDatabaseForFirstTime
{
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[EMSQLManager getDatabaseName]];
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    [fileManager copyItemAtPath:databasePathFromApp toPath:[EMSQLManager getDatabasePath] error:nil];
}


// CREATING TABLE
+ (void ) createTableWithName:(NSString *)tableName andInsertExercise: (NSString *)exerciseName
{
    sqlite3 *database;
    sqlite3_stmt *createStmt;
    
    // Opening the data base
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK){
        
        NSString *pSQueryString = [NSString stringWithFormat:
                                   @"CREATE TABLE '%@' (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, exercise_name TEXT)", tableName];
        NSLog(@"Query String: %@", pSQueryString);
        
        if(sqlite3_exec(database,[ pSQueryString UTF8String],NULL, NULL, NULL) == SQLITE_OK)
        {
                NSLog(@"Table create successful");
        }
        
        
        // Adding the exercise name
        pSQueryString = [NSString stringWithFormat: @"INSERT INTO '%@' (exercise_name) VALUES( '%@' )", tableName, exerciseName];
        NSLog(@"Query String: %@", pSQueryString);
        
        if(sqlite3_exec(database, [pSQueryString UTF8String], NULL, NULL, NULL) == SQLITE_OK){
            NSLog(@"Insert successful");
        }
    }
    
    sqlite3_close(database);
}

+ (NSMutableArray *)exercisesDoneOn: (NSString *) todaysDate
{
    sqlite3 *database;
    
    NSMutableArray *pMAExercise = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat: @"SELECT exercise_name FROM '%@' ",todaysDate];
        NSLog(@"Query String: %@", pSQueryString);
        
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            NSLog(@"sqlite3_prepare_v2 ");
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *pSExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                
                EMExercises *exercise = [[EMExercises alloc] initWithName:pSExerciseName];
                [pMAExercise   addObject: exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return pMAExercise;
}
@end



