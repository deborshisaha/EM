//
//  EMNewCategoryViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMNewCategoryViewController.h"
#include <stdlib.h>

@interface EMNewCategoryViewController ()

@end

@implementation EMNewCategoryViewController
@synthesize  categoryText;

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
    unsigned int rand=0;
    if ([textField.text length] != 0) {
        rand= (unsigned int)arc4random();
        DBLog(@"%s %d rand:%d", __PRETTY_FUNCTION__, __LINE__, rand);
        [EMSQLManager createTableWithName:@"ExerciseCategories" andInsertExercise:textField.text andWeightMeterRequired: 0 andExId:rand];
    }
    [textField resignFirstResponder]; 
    [self dismissModalViewControllerAnimated: YES];
    
    return YES;
}
@end
