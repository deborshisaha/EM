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
    IBOutlet UISwitch *weightMeter;
    IBOutlet UITextField *exerciseText;
    NSString *category;
    IBOutlet UILabel *label1, *label2;
}

@property(nonatomic, retain) IBOutlet UITextField* exerciseText;
@property(nonatomic, retain) NSString *category;
@property(nonatomic, retain) IBOutlet UILabel* label1;
@property(nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) UISwitch *weightMeter;

@end
