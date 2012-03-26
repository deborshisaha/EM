//
//  EMAbsViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMGenericExercisesViewController.h"


@implementation EMGenericExercisesViewController
@synthesize pMAExercise, exercisesDoneTillNow, selectedItem, todaysDate;

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
    
    exercisesDoneTillNow= [NSUserDefaults standardUserDefaults];
    
    // Get the database adapter
    [EMSQLManager createDatabase];

    // Read all exercises
    pMAExercise = [EMSQLManager readAllExercisesFromTable:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem]];
    
    // Get exercises done today
    todaysDate=[self getDate];
    
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    self.navigationItem.title = selectedItem;
    
    // Read all exercises
    pMAExercise = [EMSQLManager readAllExercisesFromTable:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem]];
    
    [self.tableView reloadData];
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
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    BOOL bIsChecked=FALSE;
    static NSString *CellIdentifier = @"Cell";
    // Create or reuse a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
      
    // Configure the cell...
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
    
    // Retrieve the value and check if the row should be checked.
    bIsChecked = [exercisesDoneTillNow boolForKey:[NSString stringWithFormat:@"%@_%@", todaysDate, tempExercise.pSExerciseName]];
    DBLog(@" Bool : %d ", bIsChecked);
    
    if( bIsChecked == TRUE){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [cellLabel setText:tempExercise.pSExerciseName];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    NSString *cellLabelText = cellLabel.text;
    
    BOOL bIsChecked =  FALSE;
    bIsChecked = [exercisesDoneTillNow boolForKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
    
    DBLog(@"Key : %@ ", [NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]);
    DBLog(@"before Bool : %d ", bIsChecked);
    
    if (bIsChecked == FALSE) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [exercisesDoneTillNow setBool:TRUE forKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [exercisesDoneTillNow setBool:FALSE forKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
    }
    bIsChecked = [exercisesDoneTillNow boolForKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];    
    DBLog(@"after Bool : %d ", bIsChecked);
}

- (NSString *)getDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM_dd_yyyy"];
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
        
        if([EMSQLManager deleteEntry:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem] withExerciseId: tempExercise.IExerciseId]){
            [pMAExercise removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];      
        }
    }       
    [tableView endUpdates];
}

- (IBAction)stepperChanged:(UIStepper *)sender {

    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    // assuming your view controller is a subclass of UITableViewController, for example.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:2];
    cellLabel.text = [NSString stringWithFormat:@"%.f",sender.value];
    
    DBLog(@"clicked %d", indexPath.row); 
    //self.counter.text = [NSString stringWithFormat:@"%03d",value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"AddedNewCategory"]) {
        
        // Get reference to the destination view controller
        EMNewExerciseViewController *vc = [segue destinationViewController];
        
        // Pass the name and index of our film
        [vc setCategory:[NSString stringWithFormat:@"%@", self.navigationItem.title]];
    }
}
@end
