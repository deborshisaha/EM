//
//  EMMoreViewController.h
//  TracWet
//
//  Created by Deborshi Saha on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMoreDetailsViewController.h"

@interface EMMoreViewController : UITableViewController{
    NSMutableArray *moreItems;
}

@property(nonatomic, retain) NSMutableArray *moreItems;

@end
