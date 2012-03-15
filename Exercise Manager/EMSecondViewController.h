//
//  EMSecondViewController.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMGenericExercisesViewController.h"
#import "EMSQLManager.h"

@interface EMSecondViewController : UITableViewController{
    NSMutableArray *pMAExercise;
}

@property(nonatomic, retain) NSMutableArray *pMAExercise;

@end
