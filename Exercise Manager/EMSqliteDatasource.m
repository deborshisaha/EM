//
//  EMSqliteDatasource.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMSqliteDatasource.h"
#import "EMSQLManager.h"

@implementation EMSqliteDatasource

+ (EMSqliteDatasource *)dataSource
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    return [[[self class] alloc] init];
}

- (id)initWithTodaysDate:(NSDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    if ((self = [super init])) {
        tableForDate = date;
        exercises = [[NSMutableArray alloc] init];
        [self loadExerciseOfDate:tableForDate];
        DBLog(@"exercise count: %d", [exercises count]);
    }
    return self;
}

- (EMExercisesBasic *)exerciseAtIndexPath:(NSIndexPath *)indexPath
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    return [exercises objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    //NSString *cellValue = [exercises objectAtIndex:indexPath.row];
    EMExercisesBasic *exercise = [self exerciseAtIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"flags/%@.gif", holiday.country]];
    cell.textLabel.text = exercise.pSExerciseName;
    [cell.textLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:24.0]];
    //cell.textLabel.text = cellValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    [tableView beginUpdates];    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        EMExercises *tempExercise = [exercises objectAtIndex:indexPath.row];
        
        if([EMSQLManager clearLogTable:[self getLogTableName:tableForDate] withExerciseId: tempExercise.IExerciseId]){
            [exercises removeObjectAtIndex:indexPath.row];
            DBLog(@"number of exercises in %i", [exercises count]);
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];      
        }
    }       
    [tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    return [exercises count];
}

- (void) loadExerciseOfDate:(NSDate *)date{
    DBLog(@"%s %d", __PRETTY_FUNCTION__, __LINE__);
    // Construct the table name from the date)
    NSString *tableName = [self getLogTableName:date];
    DBLog(@"Read from log table %@", tableName);
    exercises = [EMSQLManager readFromLogTable:tableName];
    DBLog(@"number of exercises in %@ : %i", tableName, [exercises count]);
}

- (void)removeAllItems
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    [exercises removeAllObjects];
}

- (NSString *)getLogTableName:forDate{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    //NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM_dd_yyyy"];
    NSString *stringDate = [formatter stringFromDate:forDate];
    DBLog(@"string date: %@", stringDate);
    
    return stringDate;
}

@end
