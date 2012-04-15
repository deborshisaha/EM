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
@synthesize  exerciseText, category, weightMeter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    
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
    [self dismissModalViewControllerAnimated: YES];
    
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
