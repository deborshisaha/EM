//
//  EMSecondViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMSecondViewController.h"

@interface EMSecondViewController ()

@end

@implementation EMSecondViewController
@synthesize pMAExercise;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);

    // Read all exercises
    pMAExercise = [EMSQLManager readAllExercisesFromTable:@"ExerciseCategories"];
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
    return [pMAExercise count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    static NSString *CellIdentifier = @"Cell";
 
    // Create or reuse a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
    
    [cellLabel setText:tempExercise.pSExerciseName];
    return cell;
}

- (void) viewDidAppear: (BOOL) animated{
    
    [super viewDidAppear:animated];
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    pMAExercise = [EMSQLManager readAllExercisesFromTable:@"ExerciseCategories"];
    [self.tableView reloadData];
}

// Do some customisation of our new view when a table item has been selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"ShowExercisesOf"]) {
        
        // Get reference to the destination view controller
        EMGenericExercisesViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        // Pass the name and index of our film
        [vc setSelectedItem:[NSString stringWithFormat:@"%@", [[pMAExercise objectAtIndex:selectedIndex]  pSExerciseName]]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
        
        if([EMSQLManager deleteEntry:@"ExerciseCategories" withExerciseId: tempExercise.IExerciseId]){
            [pMAExercise removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];      
        }
    }       
    [tableView endUpdates];
}

@end
