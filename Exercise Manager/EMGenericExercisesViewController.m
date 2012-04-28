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
    DBLog(@"%s", __PRETTY_FUNCTION__);
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

    // Get exercises done today
    todaysDate=[self getDate];

    //  Allocate memory to done
    pMAExercise = [[NSMutableArray alloc] init];
    pMAExercisesDoneTillNow = [[NSMutableArray alloc] init];
    done = [[NSMutableDictionary alloc] init];

    //Customizing the navigation bar
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];


    DBLog(@"# of exercise %d", [pMAExercisesDoneTillNow count]);
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
    
    //Mark exercises which are done
    DBLog(@"All set");
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
    //UIStepper *stepper=NULL;
    UILabel *weight = NULL;
    UILabel *exerciseLabel = NULL;
    UILabel *exerciseLabelNative = NULL;
    UILabel *unitLabel = NULL;
    
    static NSString *CellIdentifier = @"Cell";
    // Create or reuse a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    weight = (UILabel *)[cell viewWithTag:3];
    unitLabel = (UILabel *)[cell viewWithTag:4];
    
    // Configure the cell...
    EMExercises *tempExercise = [pMAExercise objectAtIndex:indexPath.row];
        
    // check if weight is required
    if(tempExercise.IWeightMeterRequired){
        exerciseLabel = (UILabel *)[cell viewWithTag:1];
        weight.hidden = FALSE;
        unitLabel.hidden = FALSE;
        [exerciseLabel setText:tempExercise.pSExerciseName];
        [weight setText:[NSString stringWithFormat:@"%i",tempExercise.IWeight]];
        [weight setFont:[UIFont fontWithName:@"Street Humouresque" size:18.0]];
        [exerciseLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:24.0]];
        [unitLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:18.0]];
    }else {
        exerciseLabelNative = (UILabel *)[cell viewWithTag:0];
        //stepper.hidden = TRUE;
        weight.hidden = TRUE;
        unitLabel.hidden = TRUE;
        [exerciseLabelNative setText:tempExercise.pSExerciseName];
        [exerciseLabelNative setFont:[UIFont fontWithName:@"Street Humouresque" size:24.0]];
    }
    // Retrieve the value and check if the row should be checked.
    bIsChecked = [[done valueForKey:[NSString stringWithFormat:@"%i", tempExercise.IExerciseId]] boolValue];
    
    if(  bIsChecked  == YES){
        //  Set the check for the row
        UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exerciseDone.png"]];
        cell.backgroundView = img1;
        weight.textColor = [UIColor whiteColor];
        exerciseLabel.textColor = [UIColor whiteColor];
        unitLabel.textColor = [UIColor whiteColor];
        DBLog(@"Done today");
    }else {
        DBLog(@"Not done today");
        cell.backgroundView = nil;
        weight.textColor = [UIColor blackColor];
        exerciseLabel.textColor = [UIColor blackColor];
        unitLabel.textColor = [UIColor blackColor];
    }
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
    return 60.0;
}

- (IBAction)weightIncreased:(id)sender{
    // get required elements of the cell
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UILabel *weight = (UILabel *)[cell viewWithTag:3];
    UILabel *unitLabel = (UILabel *)[cell viewWithTag:4];
    UILabel *exercise = (UILabel *)[cell viewWithTag:1];
    EMExercises *tempExercise =[pMAExercise objectAtIndex:indexPath.row];
    UIButton *decreaseButton = (UIButton *)[cell viewWithTag:10];
    UIButton *increaseButton = (UIButton *)[cell viewWithTag:11];
    
    // Increase the value by 5 only if it has not reached the maximum limit
    if (tempExercise.IWeight < 1000) {
        tempExercise.IWeight += 5;
        //  Enable the decrease button
        decreaseButton.hidden = FALSE;
        [EMSQLManager updateTableWithName:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem] andExercise:exercise.text andWeight:tempExercise.IWeight];
        if([EMSQLManager logWithTablename:[self getDate] andExerciseName:tempExercise.pSExerciseName andExId:tempExercise.IExerciseId andWeight: tempExercise.IWeight]){
            //  Set the check for the row
            DBLog(@"Changing Color");
            UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exerciseDone.png"]];
            cell.backgroundView = img1;
            weight.textColor = [UIColor whiteColor];
            exercise.textColor = [UIColor whiteColor];
            unitLabel.textColor = [UIColor whiteColor];
        }
    }
    if(tempExercise.IWeight == 1000){
        //  Deactivate the button
        increaseButton.hidden = TRUE;
    }
    // Update the label
    [weight setText: [NSString stringWithFormat:@"%.i", tempExercise.IWeight]];
}

- (IBAction)weightDecreased:(id)sender{
    // get required elements of the cell
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UILabel *unitLabel = (UILabel *)[cell viewWithTag:4];
    UILabel *weight = (UILabel *)[cell viewWithTag:3];
    UILabel *exercise = (UILabel *)[cell viewWithTag:1];
    EMExercises *tempExercise =[pMAExercise objectAtIndex:indexPath.row];
    UIButton *increaseButton = (UIButton *)[cell viewWithTag:11];
    
    // decrease the value by 5 only if it is greater that zero
    if (tempExercise.IWeight > 0) {
        tempExercise.IWeight -= 5;
        //  Enable the increase button
        increaseButton.hidden = FALSE;
        // Update the DB with new value
        [EMSQLManager updateTableWithName:[NSString stringWithFormat:@"%@ExercisesTable", selectedItem] andExercise:exercise.text andWeight:tempExercise.IWeight];
        if([EMSQLManager logWithTablename:[self getDate] andExerciseName:tempExercise.pSExerciseName andExId:tempExercise.IExerciseId andWeight: tempExercise.IWeight]){
            //  Set the check for the row
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            DBLog(@"Changing Color");
            UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exerciseDone.png"]];
            cell.backgroundView = img1;
            weight.textColor = [UIColor whiteColor];
            exercise.textColor = [UIColor whiteColor];
            unitLabel.textColor = [UIColor whiteColor];
        }
    }
    // Update the label
    [weight setText: [NSString stringWithFormat:@"%.i", tempExercise.IWeight]];
    
    if(tempExercise.IWeight == 0){
        // Update the label
        [weight setText: [NSString stringWithFormat:@"0"]];
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
