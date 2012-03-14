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

@interface EMGenericExercisesViewController : UITableViewController{
    
    // Array to store Abs exercise objects
    NSMutableArray *pMAExercise;
}

@property(nonatomic, retain) NSMutableArray *pMAExercise;
@end
