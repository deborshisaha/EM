//
//  EMNewExerciseViewController.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSQLManager.h"

@interface EMNewExerciseViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *exerciseText;
    NSString *category;
}

@property(nonatomic, retain) IBOutlet UITextField* exerciseText;
@property(nonatomic, retain) NSString *category;

@end
