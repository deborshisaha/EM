//
//  EMNewCategoryViewController.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSQLManager.h"

@interface EMNewCategoryViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *categoryText;
}

@property(nonatomic, retain) IBOutlet UITextField* categoryText;

@end
