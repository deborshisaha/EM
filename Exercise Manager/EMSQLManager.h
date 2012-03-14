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
+ (void)writeDatabaseForFirstTime;
+ (BOOL) checkIfDatabaseIsPresent: (NSString *)pSDatabasePath;
+ (NSString *)getDatabasePath;
+ (NSString *)getDatabaseName;
+ (void) createTableWithName:(NSString *)tableName andInsertExercise:(NSString *)exercise;

@end


