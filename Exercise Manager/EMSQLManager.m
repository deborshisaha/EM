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
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    NSString *pSDatabasePath = [EMSQLManager getDatabasePath]  ;

    DBLog(@"Database path %@", pSDatabasePath);
    
    if ([EMSQLManager isTablePresentWithName:@"ExerciseCategories"]){
        DBLog(@"The app is NOT running for the first time");
        return;
    }else{
        DBLog(@"The app is running for the first time");
        [EMSQLManager insertInitialData];
        NSMutableArray *SQLQueriesToCreateTables = [[NSMutableArray alloc] 
                                      initWithObjects:@"CREATE TABLE 'ChestExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)", 
                                                      @"CREATE TABLE 'AbsExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)",
                                                      @"CREATE TABLE 'ShouldersExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)",
                                                      @"CREATE TABLE 'LegsExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)",
                                                      @"CREATE TABLE 'BackExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)",
                                                      @"CREATE TABLE 'BicepsExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)",
                                                      @"CREATE TABLE 'TricepsExercisesTable' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)",
                                      nil];
        if([EMSQLManager runSQLQuesriesAsItIs:SQLQueriesToCreateTables]){
            DBLog(@"All categories entered successfully");
        }
        NSMutableArray *SQLQueriesInsertExercises = [[NSMutableArray alloc] 
                                     initWithObjects:@"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 504, 'Bench Press Bar', 1, 0 )", 
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 505, 'Bench Press Dumbell', 1, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 506, 'Butterfly Chest Flies', 1, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 507, 'Cable Cross Over', 0, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 508, 'Chest Flies', 1, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 509, 'Chest Press Ball', 1, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 510, 'Push Up', 0, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 511, 'Chest Dip', 0, 0 )",
                                                     @"INSERT INTO 'ChestExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 512, 'Chest Dip Assisted', 0, 0 )",
                                                     
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 513, 'Ab Crunch', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 514, 'Ball Crunch', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 515, 'Ball Pass', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 516, 'Leg Raise', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 517, 'Reverse Crunch', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 518, 'Twist', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 519, 'Twist Crunch', 0, 0 )",
                                                     @"INSERT INTO 'AbsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 520, 'Side Crunch', 0, 0 )",
                                                     
                                                     @"INSERT INTO 'ShouldersExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 521, 'Arnold Press', 1, 0 )",
                                                     @"INSERT INTO 'ShouldersExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 522, 'Military Press', 1, 0 )",
                                                     @"INSERT INTO 'ShouldersExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 523, 'Shoulder Press', 1, 0 )",
                                                     @"INSERT INTO 'ShouldersExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 524, 'Shrug', 1, 0 )",
                                                     @"INSERT INTO 'ShouldersExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 525, 'Front Raise', 1, 0 )",
                                                     @"INSERT INTO 'ShouldersExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 526, 'Lateral Raise', 1, 0 )",
                                                     
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 527, 'Calf Raise', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 528, 'Free Squats', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 529, 'Leg Curl', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 530, 'Leg Extensions', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 531, 'Leg Press', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 532, 'Lunges', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 533, 'Squats Bar', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 534, 'Squats Dumbell', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 535, 'Wall Knee Bend Squats', 1, 0 )",
                                                     @"INSERT INTO 'LegsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 536, 'Wide Leg Squats', 1, 0 )",
                                                     
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 537, 'Bent Over Row', 1, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 538, 'Lateral Pull Down', 1, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 539, 'One Arm row', 1, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 540, 'Seated Cable Rows', 1, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 541, 'Seated Rows', 1, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 542, 'Upright Row', 1, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 543, 'Hyper Back Extension', 0, 0 )",
                                                     @"INSERT INTO 'BackExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 544, 'Wide Arm Chin-Up', 1, 0 )",
                                                     
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 545, 'Preacher Curl', 1, 0 )",
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 546, 'Cable Curl', 1, 0 )",
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 547, 'Concentration Curls', 1, 0 )",
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 548, 'Curls', 1, 0 )",
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 549, 'Hammer Curl', 1, 0 )",
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 550, 'Preacher Curl', 1, 0 )",
                                                     @"INSERT INTO 'BicepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 551, 'Reverse Curl', 1, 0 )",
                                                     
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 552, 'Ball Dip', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 553, 'Bench Dip', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 554, 'Kickback', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 555, 'Lying Triceps Extension', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 556, 'Overhead Triceps Extension', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 557, 'One Arm Triceps Extension', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 558, 'Triceps Press', 1, 0 )",
                                                     @"INSERT INTO 'TricepsExercisesTable' (id, exercise, weight_meter_required, weight) VALUES( 559, 'Triceps Pushdown', 1, 0 )",
                                                    nil];
        
        if([EMSQLManager runSQLQuesriesAsItIs:SQLQueriesInsertExercises]){
            DBLog(@"All exercises entered successfully");
        }else {
            DBLog(@"Error : Could not enter exercise successfully");
        }
    }

    if ([EMSQLManager checkIfDatabaseIsPresent: pSDatabasePath]) {
        DBLog(@"Database is present");
    } else {
        DBLog(@"Database is Absent");
        [EMSQLManager writeDatabaseForFirstTime];
    }
}

+ (void) insertInitialData{
    
    unsigned int rand=0;

    NSArray *categories  = [[NSArray alloc] initWithObjects:@"Abs", @"Shoulders", @"Chest", @"Back",@"Biceps", @"Triceps", @"Legs", nil];

    for (int i=0; i < [categories count]; i++) {
        DBLog(@"Present");
        rand= (unsigned int)arc4random();
        DBLog(@"%s %d rand:%d", __PRETTY_FUNCTION__, __LINE__, rand);
        [EMSQLManager createTableWithName:@"ExerciseCategories" andInsertExercise:[categories objectAtIndex:i] andWeightMeterRequired: 0 andExId:rand];
    }
}

+ (BOOL) runSQLQuesriesAsItIs: (NSMutableArray *) SQLQueries{
    sqlite3 *database;
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        //sqlite3_stmt *compiledStatement;
        char *errorMsg = NULL;
        for (int i=0; i < [SQLQueries count]; i++) {
            if(sqlite3_exec(database, [[SQLQueries objectAtIndex:i] UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
                DBLog(@"sqlite3_exec went thru");
            }else {
                sqlite3_close(database);
                DBLog(@"executeQuery Error:  %s at %d", errorMsg, i);
                return FALSE;
            }
        }
    }
    sqlite3_close(database);
    return TRUE;

}

+ (NSString *)getDatabaseName
{
    // This should be a constant somewhere
    NSString *pSDatabaseName = @"EM.sqlite";
    return pSDatabaseName;
}

+ (NSString *)getDatabasePath
{
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    NSString *pSDatabaseName = [EMSQLManager getDatabaseName];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    
    NSString *pSDatabasePath = [documentsDir stringByAppendingPathComponent:pSDatabaseName];
    return pSDatabasePath;
}

+(BOOL) deleteEntry:(NSString *)tableName withExerciseId:(NSInteger) exId{
    
    sqlite3 *database;
    
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
            DBLog(@"executeQuery Error:  %s", errorMsg);
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
                
                EMExercises *exercise = [[EMExercises alloc] initWithName:pSExerciseName andId:Iid andWeightIsRequired: weightIsRequired andWeight: weight ];
                [pMAExercise   addObject: exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return pMAExercise;
}

+(NSMutableArray *) readFromLogTable:(NSString *)tableName
{
    sqlite3 *database;
    
    NSMutableArray *pMAExercise = [[NSMutableArray alloc] init];;    
    //  Should check if the table exists or not
    int count=0;
    count = [EMSQLManager isTablePresentWithName:tableName];
    if (count == 0){
        pMAExercise = [[NSMutableArray alloc] init];
        // No exercise performed on this day. Create a dummy informing the user- no exercise was performed
        NSString *pSExerciseName = @"";
        NSInteger Iid = 0;
        NSInteger weight = 0;
        EMExercisesBasic *exercise = [[EMExercises alloc] initWithName:pSExerciseName andId:Iid andWeight: weight ];
        [pMAExercise   addObject: exercise];
        return pMAExercise;
    }


    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat: @"SELECT DISTINCT(exercise), exId FROM '%@' ",tableName];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *pSExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                NSInteger Iid = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)]intValue ];
                NSInteger weight = 0;//[[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] intValue];
                
                DBLog(@"string : %@ id : %i wt.:%i", pSExerciseName, Iid, weight );
                
                EMExercisesBasic *exercise = [[EMExercises alloc] initWithName:pSExerciseName andId:Iid andWeight: weight ];
                [pMAExercise   addObject: exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return pMAExercise;
}

+ (BOOL) checkIfDatabaseIsPresent: (NSString *)pSDatabasePath
{    
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    BOOL success;
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    success = [fileManager fileExistsAtPath:pSDatabasePath];
    return success;
}

+ (void)writeDatabaseForFirstTime
{
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
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

+ (void ) createTableWithName:(NSString *)tableName andInsertExercise: (NSString *)exerciseName andWeightMeterRequired:(BOOL)weightMeterRequired andExId:(int)exId                                                                                                                                                    
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
                                       @"CREATE TABLE '%@' (id INTEGER PRIMARY KEY NOT NULL, exercise TEXT, weight_meter_required INTEGER, weight INTEGER)", tableName];
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
            pSQueryString = [NSString stringWithFormat: @"INSERT INTO '%@' (id, exercise, weight_meter_required, weight) VALUES( %d, '%@', 1, 0 )", tableName, exId, exerciseName];
        }else{
            pSQueryString = [NSString stringWithFormat: @"INSERT INTO '%@' (id, exercise, weight_meter_required, weight) VALUES( %d, '%@', 0, 0 )", tableName, exId, exerciseName]; 
            DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
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


//  Log table
+ (void) createLogTableWithName:(NSString *)logTableName{
    sqlite3 *database;
    //sqlite3_stmt *createStmt;
    
    char *errormsg=NULL;
    // First check if the table is present??
    int count=0;
    count = [EMSQLManager isTablePresentWithName:logTableName];
    
    // Opening the data base
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK){
        
        NSString *pSQueryString;
        if (count == 0) {
            //create the table
            pSQueryString = [NSString stringWithFormat:
                             @"CREATE TABLE '%@' (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, exercise TEXT, exId INTEGER, weight INTEGER)", logTableName];
            DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
            
            int error_code = sqlite3_exec(database,[ pSQueryString UTF8String],NULL, NULL, &errormsg);
            if(error_code == SQLITE_OK)
            {
                DBLog(@"Table create successful");
            }else {
                DBLog(@" *** ERROR MSG: %s ***", errormsg);
            }
        }
    }
    sqlite3_close(database);
}

//  Enter values into log table
+ (BOOL)logWithTablename:(NSString *)logTableName andExerciseName:(NSString *)exercise andExId:(NSInteger)exId andWeight:(int)weight{
    
    DBLog(@"%s %d", __PRETTY_FUNCTION__, __LINE__);
    sqlite3 *database;
    int count=0;
    char *errormsg=NULL;
    
    //  Check if the table is present
    count = [EMSQLManager isTablePresentWithName:logTableName];
    if (!count) {
        DBLog(@"Table not present");
        [self createLogTableWithName:logTableName];
    }
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK){
        NSString *pSQueryString;
        if (exercise == nil) {
            return FALSE;
        }
        
        pSQueryString = [NSString stringWithFormat: @"INSERT INTO '%@' (exId, exercise, weight) VALUES( %i, '%@', %d )", logTableName, exId , exercise, weight];
                         
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
                         
        if(sqlite3_exec(database, [pSQueryString UTF8String], NULL, NULL, &errormsg) == SQLITE_OK){
            DBLog( @"Function : %s, Line : %d  Insert Successful", __PRETTY_FUNCTION__, __LINE__);
            return TRUE;
        }else {
            DBLog(@"Logging unsuccessful because %s", errormsg);
            return FALSE;
        }
    }
    sqlite3_close(database);
    return FALSE;
}

+(BOOL) clearLogTable:(NSString *)logTableName withExerciseId:(NSInteger) exId{
    
    sqlite3 *database;
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        //sqlite3_stmt *compiledStatement;
        char *errorMsg = NULL;
        NSString *pSQueryString = [NSString stringWithFormat: @"DELETE FROM '%@' WHERE exId='%i' ",logTableName, exId];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        
        if(sqlite3_exec(database, [pSQueryString UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK){
            DBLog(@"sqlite3_exec went thru");
        }else {
            sqlite3_close(database);
            DBLog(@"executeQuery Error:  %s", errorMsg);
            return FALSE;
        }
    }
    sqlite3_close(database);
    return TRUE;
}

+(NSMutableArray *) readAllExercisesFromLogTable:(NSString *)tableName
{
    sqlite3 *database;
    
    NSMutableArray *pMAExerciseBasic = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([[EMSQLManager getDatabasePath] UTF8String], &database)== SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        NSString *pSQueryString = [NSString stringWithFormat: @"SELECT * FROM '%@' ",tableName];
        DBLog( @"Function : %s, Line : %d  %@", __PRETTY_FUNCTION__, __LINE__ , pSQueryString);
        
        if(sqlite3_prepare_v2(database, [pSQueryString UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK){
            
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *pSExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
                NSInteger Iid = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)]intValue ];
                NSInteger weight = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] intValue];
                
                DBLog(@"string : %@ id : %i weightIsRequired wt.:%i", pSExerciseName, Iid, weight );
                
                EMExercisesBasic *exercise = [[EMExercisesBasic alloc] initWithName:pSExerciseName andId:Iid andWeight: weight ];
                [pMAExerciseBasic   addObject: exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return pMAExerciseBasic;
}



@end



