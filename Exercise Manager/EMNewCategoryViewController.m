//
//  EMNewCategoryViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMNewCategoryViewController.h"

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
    NSLog(@"textfield : text%@", textField.text);
    [EMSQLManager createTableWithName:@"ExerciseCategories" andInsertExercise:textField.text ];
    [textField resignFirstResponder]; 
    [self dismissModalViewControllerAnimated: YES];
    
    return YES;
}
@end
