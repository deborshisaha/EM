//
//  EMAbsViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMGenericExercisesViewController.h"


@implementation EMGenericExercisesViewController
@synthesize pMAExercise, pMAExercisesDoneToday, selectedItem, todaysDate;

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"Function : %s", __PRETTY_FUNCTION__);
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the database adapter
    [EMSQLManager createDatabase];

    // Read all exercises
    pMAExercise = [EMSQLManager readAllExercisesFromTable:@"AbsExercisesTable"];
    
    // Get exercises done today
    todaysDate=[self getDate];
    
    //pMAExercisesDoneToday = [EMSQLManager exercisesDoneOn:todaysDate ];
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated];
    NSLog(@"selected Item %@", selectedItem);
    self.navigationItem.title = selectedItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return pMAExercise.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    EMExercises *exercise = (EMExercises *)[pMAExercise objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell setText:exercise.pSExerciseName];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell accessoryType] == UITableViewCellAccessoryNone) {
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        //Adding a table with date as table name
        [EMSQLManager createTableWithName:todaysDate andInsertExercise: cell.text];
        
        //Lsiting
        pMAExercise = [EMSQLManager readAllExercisesFromTable:todaysDate];
        
        NSLog(@"Count of exercises %d", pMAExercise.count);
        
        // Add to dictionary and create plist
        
    }else {
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        //Remove from the dictionary
    }
}

- (NSString *)getDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM_dd_yyyy"];
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}
@end
