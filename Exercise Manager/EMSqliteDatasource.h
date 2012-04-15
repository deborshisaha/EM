//
//  EMSqliteDatasource.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Kal.h"
#include "EMExercises.h"

@interface EMSqliteDatasource : NSObject <KalDataSource>{
    //NSMutableArray *items;
    NSMutableArray *exercises;
}

+ (EMSqliteDatasource *)dataSource;
- (EMExercisesBasic *)exerciseAtIndexPath:(NSIndexPath *)indexPath;  // exposed for HolidayAppDelegate so that 
@end
