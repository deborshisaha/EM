//
//  EMSQLManager.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "EMExercises.h"

@interface EMSQLManager : NSObject{
    
}

+ (void) createDatabase;
+(NSMutableArray *) readAllExercisesFromTable:(NSString *)tableName;
+(NSMutableArray *) readFromLogTable:(NSString *)tableName;

+ (void)writeDatabaseForFirstTime;
+ (BOOL) checkIfDatabaseIsPresent: (NSString *)pSDatabasePath;
+ (NSString *)getDatabasePath;
+ (NSString *)getDatabaseName;
+ (BOOL) deleteEntry:(NSString *)tableName withExerciseId:(NSInteger) exId ;
+ (void) createTableWithName:(NSString *)tableName andInsertExercise:(NSString *)exercise andWeightMeterRequired:(BOOL)weightMeterRequired andExId:(int)exId;
//+ (NSMutableArray *)exercisesDoneOn: (NSString *) todaysDate;
+ (void ) updateTableWithName:(NSString *)tableName andExercise: (NSString *)exerciseName andWeight:(NSInteger)weight;

//  Log table name
+ (void) createLogTableWithName:(NSString *)logTableName;
+ (BOOL)logWithTablename:(NSString *)logTableName andExerciseName:(NSString *)exercise andExId:(NSInteger)exId andWeight:(int)weight;
+ (BOOL)clearLogTable:(NSString *)logTableName withExerciseId: (NSInteger)exId;

@end


