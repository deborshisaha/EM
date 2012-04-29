//
//  EMMoreViewController.m
//  TracWet
//
//  Created by Deborshi Saha on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMMoreViewController.h"

@interface EMMoreViewController ()

@end

@implementation EMMoreViewController
@synthesize moreItems;

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
    //Initialize the array.
    moreItems = [[NSMutableArray alloc] init];
    
    NSArray *howTos = [NSArray arrayWithObjects:@"Undo today's exercise?", @"Delete a category?", @"Delete an exercise?", nil];
    NSDictionary *howTosInDict = [NSDictionary dictionaryWithObject:howTos forKey:@"More"];
    
    NSArray *whats = [NSArray arrayWithObjects:@"To expect?", @"Is the gray color on changing weight?", nil];
    NSDictionary *whatsInDict = [NSDictionary dictionaryWithObject:whats forKey:@"More"];
    
    NSArray *misc = [NSArray arrayWithObjects:@"Contact us", @"About", nil];
    NSDictionary *miscInDict = [NSDictionary dictionaryWithObject:misc forKey:@"More"];
    
    [moreItems addObject:howTosInDict];
    [moreItems addObject:whatsInDict];
    [moreItems addObject:miscInDict];

    UIFont *font = [UIFont fontWithName:@"Street Humouresque" size:25];
    UIColor *color = [UIColor blackColor];
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:font, UITextAttributeFont, color, UITextAttributeTextColor, nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = attr;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [moreItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSDictionary *dictionary = [moreItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"More"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:0];
    
    //First get the dictionary object
    NSDictionary *dictionary = [moreItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"More"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cellLabel.text = cellValue;
    [cellLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:18.0]];
    return cell;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DBLog(@"%s", __PRETTY_FUNCTION__);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3 , 300, 20)];
    headerLabel.backgroundColor= [UIColor clearColor];
    [headerLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:18]];
    [headerView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            [headerView setBackgroundColor:[UIColor greenColor]];
            headerLabel.text = @"How to(s)";
            break;
            
        case 1:
            [headerView setBackgroundColor:[UIColor greenColor]];
            headerLabel.text = @"What";
            break;
            
        case 2:
            [headerView setBackgroundColor:[UIColor greenColor]];
            headerLabel.text = @"Misc";
            break;
            
        default:
            break;
    }
    return headerView;
}

// Do some customisation of our new view when a table item has been selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"More"]) {
         
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        EMMoreDetailsViewController *vc = [segue destinationViewController];
        NSDictionary *dictionary = [moreItems objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"More"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        NSString *titleString = [[NSString alloc] init];
        
        switch (indexPath.section) {
            case 0:
                titleString = @"How to(s)";
                break;
                
            case 1:
                titleString = @"What";
                break;
                
            case 2:
                titleString = @"Misc";
                break;
                
            default:
                break;
        }
        [vc setTitleString:titleString];
        [vc setTopic:cellValue];
        DBLog(@"%i %@", indexPath.section, cellValue);
    }
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

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}
*/
@end
