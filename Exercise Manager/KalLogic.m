/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

@interface KalLogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, retain) NSDate *fromDate;
@property (nonatomic, retain) NSDate *toDate;
@property (nonatomic, retain) NSArray *daysInSelectedMonth;
@property (nonatomic, retain) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, retain) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation KalLogic

@synthesize baseDate, fromDate, toDate, daysInSelectedMonth, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if ((self = [super init])) {
    monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"LLLL yyyy"];
    [self moveToMonthForDate:date];
  }
  return self;
}

- (id)init
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return [self initForDate:[NSDate date]];
}

- (void)moveToMonthForDate:(NSDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
  [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
}

- (void)advanceToFollowingMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
}

- (NSString *)selectedMonthNameAndYear;
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return [self.baseDate cc_weekday] - 1;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  c.day = [self.baseDate cc_numberOfDaysInMonth];
  NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
  return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  NSMutableArray *days = [NSMutableArray array];
  
  NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
  int n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
  int numPartialDays = [self numberOfDaysInPreviousPartialWeek];
  NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
  for (int i = n - (numPartialDays - 1); i < n + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  NSMutableArray *days = [NSMutableArray array];
  
  NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  for (int i = 1; i < numDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  NSMutableArray *days = [NSMutableArray array];
  
  NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
  NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
  
  for (int i = 1; i < numPartialDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (void)recalculateVisibleDays
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
  self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
  self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
  KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
  KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
  self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
  self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
}


@end
