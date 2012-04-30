//
//  EMAbsViewController.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EMExercises.h"
#include "EMSQLManager.h"
#include "EMNewExerciseViewController.h"

@interface EMGenericExercisesViewController : UITableViewController{
    
    // Array to store Abs exercise objects
    NSMutableArray *pMAExercise;
    NSString *todaysDate;
    
    NSString *selectedItem;
    NSString *logTablename;
    NSMutableArray *pMAExercisesDoneTillNow;
    NSMutableDictionary *done;
}

@property(nonatomic, retain) NSMutableArray *pMAExercise;
@property(nonatomic, retain) NSString *todaysDate;

@property (nonatomic, retain) NSString *selectedItem;
@property (nonatomic, retain) NSString *logTablename;

@property(nonatomic, retain) NSMutableArray *pMAExercisesDoneTillNow;

@property(nonatomic, retain) NSMutableDictionary *done;

- (IBAction)weightIncreased:(id)sender;
- (IBAction)weightDecreased:(id)sender;
@end
