//
//  EMAbsViewController.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#include "EMExercises.h"

@interface EMGenericExercisesViewController : UITableViewController{
    
    NSString *pSDatabaseName;
    NSString *pSDatabasePath;
    
    // Array to store Abs exercise objects
    NSMutableArray *pMAExercise;
}

@property(nonatomic, retain) NSMutableArray *pMAExercise;
@property(nonatomic, retain) NSString *pSDatabaseName;
@property(nonatomic, retain) NSString *pSDatabasePath;

- (void) createDatabaseIfNotPresent;
@end
