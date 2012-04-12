//
//  EMAbsViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMGenericExercisesViewController.h"


@implementation EMGenericExercisesViewController
@synthesize pMAExercise, pMAExercisesDoneTillNow, selectedItem, todaysDate, logTablename, done;

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
    // Get the database adapter
    [EMSQLManager createDatabase];
    // Read all exercises
    pMAExercise = [EMSQLManager readAllExercisesFromTable:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem]];
    // Get exercises done today
    todaysDate=[self getDate];
    //  Read all exercises done on this date
    pMAExercisesDoneTillNow = [EMSQLManager readFromLogTable:todaysDate];
    //  Allocate memory to done
    done = [[NSMutableDictionary alloc] init];
    DBLog(@"# of exercise %d", [pMAExercisesDoneTillNow count]);
    DBLog(@"Line # %d ", __LINE__);
    //  Create a dictionary with exercise Id
    for (EMExercisesBasic *eb in pMAExercisesDoneTillNow) 
    {
        DBLog(@"%i", eb.IExerciseId);
        [done setObject:[NSNumber numberWithBool:YES]
                 forKey:[NSString stringWithFormat:@"%i", eb.IExerciseId]];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    self.navigationItem.title = selectedItem;
    
    // Read all exercises
    pMAExercise = [EMSQLManager readAllExercisesFromTable:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem]];
    pMAExercisesDoneTillNow = [EMSQLManager readFromLogTable:todaysDate];
    DBLog(@"# of exercise %d", [pMAExercisesDoneTillNow count]);
    DBLog(@"Line # %d ", __LINE__);
    //  Create a dictionary with exercise Id
    for (EMExercisesBasic *eb in pMAExercisesDoneTillNow) {
        DBLog(@"%i", eb.IExerciseId);
        [done setObject:[NSNumber numberWithBool:YES]
                forKey:[NSString stringWithFormat:@"%i", eb.IExerciseId]];
         DBLog(@"key: %i Value: %i", eb.IExerciseId, [[done valueForKey:[NSString stringWithFormat:@"%i", eb.IExerciseId]] boolValue]);
    }    
    /*  
     iterate through the mutable array and with the help of exercise id fetch information from the log DB to check
     whether the exercise was performed today?
     */
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
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
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    // Return the number of rows in the section.
    return pMAExercise.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    BOOL bIsChecked=FALSE;
    UIStepper *stepper=NULL;
    UILabel *weightUnits = NULL;
    UILabel *weight = NULL;
    UILabel *cellLabel = NULL;
    UILabel *cellNativeText = NULL;
    
    static NSString *CellIdentifier = @"Cell";
    // Create or reuse a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    stepper = (UIStepper *)[cell viewWithTag:2];
    weight = (UILabel *)[cell viewWithTag:3];
    weightUnits = (UILabel *)[cell viewWithTag:4];
    
    // Configure the cell...
    //UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
    
    // Retrieve the value and check if the row should be checked.
    bIsChecked = [[done valueForKey:[NSString stringWithFormat:@"%i", tempExercise.IExerciseId]] boolValue];
    //bIsChecked = [done valueForKey:]; //, [[NSString stringWithFormat:@"%@", eb.IExerciseId]];
    DBLog(@"key %i value %i",  tempExercise.IExerciseId, bIsChecked);
   
    if(  bIsChecked  == YES){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
        
    // check if weight is required
    if(tempExercise.IWeightMeterRequired){
        cellLabel = (UILabel *)[cell viewWithTag:1];
        stepper.hidden = FALSE;
        weight.hidden = FALSE;
        weightUnits.hidden = FALSE;
        weight.text = [NSString stringWithFormat:@"%i",tempExercise.IWeight];
        stepper.value = tempExercise.IWeight;
        [cellLabel setText:tempExercise.pSExerciseName];
        //DBLog(@"Line # %d %@", __LINE__, tempExercise.pSExerciseName);
    }else {
        cellNativeText = (UILabel *)[cell viewWithTag:0];
        stepper.hidden = TRUE;
        weight.hidden = TRUE;
        weightUnits.hidden = TRUE;
        [cellNativeText setText:tempExercise.pSExerciseName];
        //DBLog(@"Line # %d %@", __LINE__, tempExercise.pSExerciseName);
    }
    //[cellLabel setText:tempExercise.pSExerciseName];
    return cell;
}

- (NSString *)getDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM_dd_yyyy"];
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
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

    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    // assuming your view controller is a subclass of UITableViewController, for example.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    EMExercises *tempExercise =[pMAExercise objectAtIndex:indexPath.row];
    
    UILabel *weight = (UILabel *)[cell viewWithTag:3];
    weight.text = [NSString stringWithFormat:@"%.f",sender.value];
    
    UILabel *exercise = (UILabel *)[cell viewWithTag:1];
    
    DBLog(@"IBAction exercise : ")
    if (sender.value > 0) {
        //  Enter into the log table with date, weight, exercise name and exercise id
        if([EMSQLManager logWithTablename:[self getDate] andExerciseName:tempExercise.pSExerciseName andExId:tempExercise.IExerciseId andWeight: sender.value]){
            //  Set the check for the row
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        // Enter the value in database
        [EMSQLManager updateTableWithName:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem] andExercise:exercise.text andWeight:[weight.text intValue]];
    }else{
        // Check if the control is coming to this block for the first time ater getting zero
        if ([cell accessoryType] == UITableViewCellAccessoryCheckmark ) {
            //  Clear log database after having looked for the exercise id
            [EMSQLManager clearLogTable:[self getDate] withExerciseId:tempExercise.IExerciseId ];
            //  Uncheck the row
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            // Enter the value in database
            [EMSQLManager updateTableWithName:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem] andExercise:exercise.text andWeight:[weight.text intValue]];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"AddedNewCategory"]) {
        
        // Get reference to the destination view controller
        EMNewExerciseViewController *vc = [segue destinationViewController];
        
        // Pass the name and index of our film
        [vc setCategory:[NSString stringWithFormat:@"%@", self.navigationItem.title]];
    }
}
@end
