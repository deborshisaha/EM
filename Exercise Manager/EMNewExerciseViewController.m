//
//  EMNewCategoryViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMNewExerciseViewController.h"
#import <stdlib.h>

@interface EMNewExerciseViewController ()

@end

@implementation EMNewExerciseViewController
@synthesize  exerciseText, category, weightMeter, label1, label2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    //Customizing the navigation bar
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    [label1 setFont:[UIFont fontWithName:@"Street Humouresque" size:20.0 ]];
    [label2 setFont:[UIFont fontWithName:@"Street Humouresque" size:20.0 ]];
    [exerciseText setFont:[UIFont fontWithName:@"Street Humouresque" size:20.0 ]];
}

- (void)viewDidUnload
{DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    DBLog(@"textfield : text%@", textField.text);
    if ([textField.text length] != 0) {
        // Generate the random id
        unsigned int ExId=0;
        ExId = arc4random()%1000;
        // Enter the field in the database, else exit the view
        DBLog(@"Text has been entered ");
        DBLog(@"ID generated %u", ExId);
        if (weightMeter.on) {
            DBLog(@"weightMeter is on");
            [EMSQLManager createTableWithName:[ NSString stringWithFormat:@"%@ExercisesTable", category] andInsertExercise:textField.text andWeightMeterRequired:YES andExId:ExId];
        }else {
            DBLog(@"weightMeter is off");
            [EMSQLManager createTableWithName:[ NSString stringWithFormat:@"%@ExercisesTable", category] andInsertExercise:textField.text andWeightMeterRequired:NO andExId:ExId];
        }
        //  Create log DB for this category
        // [EMSQLManager createLogTableWithName:[NSString stringWithFormat:@"%@LogTable", category]];
    }
    [textField resignFirstResponder]; 
    [self.navigationController popViewControllerAnimated: YES];
    
    return YES;
}

- (IBAction) weightMeterIsRequired: (id) sender {  
    if (weightMeter.on) {
        DBLog(@"hi"); 
    } else {
        DBLog(@"bi");
    }
} 


@end
