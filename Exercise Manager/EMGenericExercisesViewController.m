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
    //UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
    
    // Retrieve the value and check if the row should be checked.
    bIsChecked = [exercisesDoneTillNow boolForKey:[NSString stringWithFormat:@"%@_%@", todaysDate, tempExercise.pSExerciseName]];
    
    if( bIsChecked == TRUE){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //DBLog(@"tempExercise at %d n:%@ wt:%i b:%i", __LINE__, tempExercise.pSExerciseName, tempExercise.IWeight, tempExercise.IWeightMeterRequired);
    
    // check if weight is required
    if(tempExercise.IWeightMeterRequired){
        UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
        UIStepper *stepper = (UIStepper *)[cell viewWithTag:2];
        UILabel *weight = (UILabel *)[cell viewWithTag:3];
        UILabel *weightUnits = (UILabel *)[cell viewWithTag:4];
        stepper.hidden = FALSE;
        weight.hidden = FALSE;
        weightUnits.hidden = FALSE;
        weight.text = [NSString stringWithFormat:@"%i",tempExercise.IWeight];
        //cell.frame.size.height = 50;
        stepper.value = tempExercise.IWeight;
        [cellLabel setText:tempExercise.pSExerciseName];
        DBLog(@"%d %@", __LINE__, tempExercise.pSExerciseName);
    }else {
        UILabel *cellNativeText = (UILabel *)[cell viewWithTag:0];
        UIStepper *stepper = (UIStepper *)[cell viewWithTag:2];
        UILabel *weight = (UILabel *)[cell viewWithTag:3];
        UILabel *weightUnits = (UILabel *)[cell viewWithTag:4];
        stepper.hidden = TRUE;
        weight.hidden = TRUE;
        weightUnits.hidden = TRUE;
        [cellNativeText setText:tempExercise.pSExerciseName];
        DBLog(@"%d %@", __LINE__, tempExercise.pSExerciseName);
    }
    //[cellLabel setText:tempExercise.pSExerciseName];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBLog(@" %s ", __PRETTY_FUNCTION__);

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *cellLabel = NULL;
    
    // check the pMAExercise
    EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];

    if (tempExercise.IWeightMeterRequired) {
        cellLabel = (UILabel *)[cell viewWithTag:1];
    }else {
        cellLabel = (UILabel *)[cell viewWithTag:0];
    }
    NSString *cellLabelText = cellLabel.text;
    
    BOOL bIsChecked =  FALSE;
    bIsChecked = [exercisesDoneTillNow boolForKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
    
    DBLog(@"Key : %@ ", [NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]);
    
    if (bIsChecked == FALSE) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [exercisesDoneTillNow setBool:TRUE forKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [exercisesDoneTillNow setBool:FALSE forKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
    }
    bIsChecked = [exercisesDoneTillNow boolForKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

- (IBAction)stepperChanged:(UIStepper *)sender {

    DBLog(@"IBAction %s STARTS ", __PRETTY_FUNCTION__);

    UILabel *cellLabel = NULL;
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    // assuming your view controller is a subclass of UITableViewController, for example.
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UILabel *weight = (UILabel *)[cell viewWithTag:3];
    weight.text = [NSString stringWithFormat:@"%.f",sender.value];
    
    UILabel *exercise = (UILabel *)[cell viewWithTag:1];
    
    cellLabel = (UILabel *)[cell viewWithTag:1];
    
    NSString *cellLabelText = cellLabel.text;

    
    if ( sender.value > 0) {
        [exercisesDoneTillNow setBool:TRUE forKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [exercisesDoneTillNow setBool:FALSE forKey:[NSString stringWithFormat:@"%@_%@", todaysDate, cellLabelText]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    // Enter the value in database
    [EMSQLManager updateTableWithName:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem] andExercise:exercise.text andWeight:[weight.text intValue]];
    //[NSString stringWithUTF8String:(char *)
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
