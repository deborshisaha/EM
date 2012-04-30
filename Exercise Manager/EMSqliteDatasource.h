//
//  EMSqliteDatasource.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#include "Kal.h"
#include "EMExercises.h"

@interface EMSqliteDatasource : NSObject <EMTableViewDataSource>{
    //NSMutableArray *items;
    NSMutableArray *exercises;
    NSDate *tableForDate;
}

+ (EMSqliteDatasource *)dataSource;
- (id) initWithTodaysDate:(NSDate *) date;
//- (EMExercisesBasic *)exerciseAtIndexPath:(NSIndexPath *)indexPath;  // exposed for HolidayAppDelegate so that 
//- (void)loadExerciseOfDate:(NSDate *)ofDate;
@end
