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

+(BOOL) deleteEntry:(NSString *)tableName withExerciseId:(NSInteger) exId{
    
    sqlite3 *database;
    
    //NSMutableArray *pMAExercise = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        //sqlite3_stmt *compiledStatement;
        char *errorMsg = NULL;
        NSString *pSQueryString = [NSString stringWithFormat: @"DELETE FROM '%@' WHERE id='%i' ",tableName, exId];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        
        if(sqlite3_exec(database, [pSQueryString UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
            DBLog(@"sqlite3_exec went thru");
        }else {
            sqlite3_close(database);
            DBLog(@"executeQuery Error:  %@", errorMsg);
            return FALSE;
        }
    }
    sqlite3_close(database);
    return TRUE;
}

+(NSMutableArray *) readAllExercisesFromTable:(NSString *)tableName
{
    sqlite3 *database;
    
    NSMutableArray *pMAExercise = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat: @"SELECT * FROM '%@' ",tableName];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
       
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *pSExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
                NSInteger Iid = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)]intValue ];
                    NSInteger weightIsRequired = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] intValue];
                    NSInteger weight = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)] intValue];
                
                //DBLog(@"string : %@ id : %i weightIsRequired %i wt.:%i", pSExerciseName, Iid, weightIsRequired, weight );
                
                EMExercises *exercise = [[EMExercises alloc] initWithName:pSExerciseName andId:Iid andWeightIsRequired: weightIsRequired andWeight: weight ];
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

// Probably we have to have a Singleton class
+ (void)setDatabaseName: (NSString *) databaseName
{
    // This should be a constant somewhere
    //NSString *pSDatabaseName = databaseName;
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


// TABLE

+ (int) isTablePresentWithName: (NSString *) tableName
{
    sqlite3 *database;
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK){
        
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat:
                                   @"SELECT COUNT(*) FROM 'sqlite_master' WHERE type='table' AND name='%@'", tableName];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                int count = sqlite3_column_int(compiledStatement, 0);
                sqlite3_finalize(compiledStatement);
                sqlite3_close(database);
                return count;
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return -1;
}

+ (void ) createTableWithName:(NSString *)tableName andInsertExercise: (NSString *)exerciseName andWeightMeterRequired:(BOOL)weightMeterRequired
{
    sqlite3 *database;
    //sqlite3_stmt *createStmt;
    
    // First check if the table is present??
    int count=0;
    count = [EMSQLManager isTablePresentWithName:tableName];
    
    // Opening the data base
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK){
        
        NSString *pSQueryString;
        if (count == 0) {
            //create the table
            pSQueryString = [NSString stringWithFormat:
                                       @"CREATE TABLE '%@' (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)", tableName];
            DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
            
            int error_code = sqlite3_exec(database,[ pSQueryString UTF8String],NULL, NULL, NULL);
            if(error_code == SQLITE_OK)
            {
                DBLog(@"Table create successful");
            }else {
                DBLog(@" *** ERROR CODE: %d ***", error_code);
                
            }
        }
        
        if (exerciseName == nil) {
            return;
        }
        
        // Adding the exercise name
        if(weightMeterRequired){
            pSQueryString = [NSString stringWithFormat: @"INSERT INTO '%@' (exercise, weight_meter_required, weight) VALUES( '%@', 1, 0 )", tableName, exerciseName];
        }else{
             pSQueryString = [NSString stringWithFormat: @"INSERT INTO '%@' (exercise, weight_meter_required, weight) VALUES( '%@', 0, 0 )", tableName, exerciseName];           
        }
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        
        if(sqlite3_exec(database, [pSQueryString UTF8String], NULL, NULL, NULL) == SQLITE_OK){
            DBLog( @"Function : %s, Line : %d  Insert Successful", __PRETTY_FUNCTION__, __LINE__);
        }
    }
    
    sqlite3_close(database);
}

+ (void ) updateTableWithName:(NSString *)tableName andExercise: (NSString *)exerciseName andWeight:(NSInteger)weight{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    sqlite3 *database;
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK){
        NSString *pSQueryString;
        pSQueryString = [NSString stringWithFormat: @"UPDATE '%@' SET weight='%i' WHERE exercise='%@'", tableName, weight,exerciseName];
        DBLog(@"pSQueryString : %@", pSQueryString);
        if (sqlite3_exec(database, [pSQueryString UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            DBLog(@"Update successful");
        }
    }
    sqlite3_close(database);
}

/*
+ (NSMutableArray *)exercisesDoneOn: (NSString *) todaysDate
{
    sqlite3 *database;
    
    NSMutableArray *pMAExercise = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat: @"SELECT exercise FROM '%@' ",todaysDate];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *pSExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                
                //EMExercises *exercise = [[EMExercises alloc] initWithName:pSExerciseName ];
                //[pMAExercise   addObject: exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return pMAExercise;
}
 */

@end



