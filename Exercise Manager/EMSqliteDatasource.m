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
    return [[[self class] alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        //items = [[NSMutableArray alloc] init];
        exercises = [[NSMutableArray alloc] init];
    }
    return self;
}

- (EMExercisesBasic *)exerciseAtIndexPath:(NSIndexPath *)indexPath
{
    return [exercises objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    EMExercisesBasic *exercise = [self exerciseAtIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"flags/%@.gif", holiday.country]];
    cell.textLabel.text = exercise.pSExerciseName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [exercises count];
}

// Load exercise of that date
/*- (void)loadExercises:(NSDate *)ofDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    DBLog(@"Fetching exercises done on date %@ ...", ofDate);
	[delegate loadedDataSource:self];
}
*/
#pragma mark KalDataSource protocol conformance

- (void)presentingDate:(NSDate *)date delegate:(id<KalDataSourceCallbacks>)delegate
{
    [exercises removeAllObjects];
    //[self loadExercises:date  delegate:delegate];
}

- (void)loadItemsOfDate:(NSDate *)ofDate
{
    // Construct the table name from the date
    NSString *tableName = [self getLogTableName:ofDate];
    DBLog(@"Read from log table %@", tableName);
    
    exercises = [EMSQLManager readFromLogTable:tableName];
}

- (void)removeAllItems
{
    [exercises removeAllObjects];
}

- (NSString *)getLogTableName:forDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM_dd_yyyy"];
    NSString *stringDate = [formatter stringFromDate:date];
    
    return stringDate;
}

@end
