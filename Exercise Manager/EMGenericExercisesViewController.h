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

    NSUserDefaults *exercisesDoneTillNow;
}

@property(nonatomic, retain) NSMutableArray *pMAExercise;
@property(nonatomic, retain) NSString *todaysDate;

//@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) NSString *selectedItem;

@property(nonatomic, retain) NSUserDefaults *exercisesDoneTillNow;

@end
