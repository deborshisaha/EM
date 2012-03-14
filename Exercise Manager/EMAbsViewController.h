//
//  EMAbsViewController.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#include "EMSQLManager.h"

@interface EMAbsViewController : UITableViewController{
    
    NSString *nS_databaseName;
    NSString *nS_databasePath;
    
    // Array to store Abs exercise objects
    NSMutableArray *nMA_AbsExercise;
}

@property(nonatomic, retain) NSMutableArray *nMA_AbsExercise;
@property(nonatomic, retain) NSString *nS_databaseName;
@property(nonatomic, retain) NSString *nS_databasePath;

- (void) createDatabaseIfNotPresent;
@end
