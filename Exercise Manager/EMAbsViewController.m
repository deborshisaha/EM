//
//  EMAbsViewController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMAbsViewController.h"

@interface EMAbsViewController ()

@end

@implementation EMAbsViewController
@synthesize nMA_AbsExercise, nS_databaseName, nS_databasePath;

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
    NSLog(@"Function : %s", __PRETTY_FUNCTION__);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    nS_databaseName = @"ExerciseManager.sqlite";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    nS_databasePath = [documentsDir stringByAppendingPathComponent:nS_databaseName];
    
    // check and create database function
    [self createDatabaseIfNotPresent];
    
    // Read all abs exercises
    [self readAbsExercisesFromDatabase];
    
    
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
    NSLog(@"Function : %s", __PRETTY_FUNCTION__);

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Function : %s", __PRETTY_FUNCTION__);
    // Return the number of rows in the section.
    return nMA_AbsExercise.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    AbsExercise *ae = (AbsExercise *)[nMA_AbsExercise objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell setText:ae.abs_exercise];
    /*
    if(cell){
        NSLog(@"Cell exists");
    }else {
        NSLog(@"Returns NULL");
        return NULL;
    }*/
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void) createDatabaseIfNotPresent{
    NSLog(@"Function : %s", __PRETTY_FUNCTION__);
    BOOL isDatabasePresent;
    
    NSFileManager *fileManager = [NSFileManager  defaultManager];
    
    isDatabasePresent = [fileManager fileExistsAtPath:nS_databasePath];
    
    if (isDatabasePresent) {
        return;
    }
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nS_databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:nS_databasePath error:nil];
}

-(void) readAbsExercisesFromDatabase{

    sqlite3 *database;
    
    nMA_AbsExercise = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([nS_databasePath UTF8String], &database)== SQLITE_OK){

        const char *sqlStatement = "select abs_exercise from AbsExercisesTable";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            NSLog(@"sqlite3_prepare_v2 ");
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                NSString *absExerciseName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                
                AbsExercise *abs_exercise = [[AbsExercise alloc] initWithName:absExerciseName];
                [nMA_AbsExercise   addObject: abs_exercise];
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
}
@end
