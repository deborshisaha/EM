/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalDate.h"
#import "KalPrivate.h"

static KalDate *today;


@interface KalDate ()
+ (void)cacheTodaysDate;
@end


@implementation KalDate

+ (void)initialize
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheTodaysDate) name:UIApplicationSignificantTimeChangeNotification object:nil];
  [self cacheTodaysDate];
}

+ (void)cacheTodaysDate
{
  //[today release];
    DBLog(@"%s",__PRETTY_FUNCTION__);
  today = [KalDate dateFromNSDate:[NSDate date]];
}

+ (KalDate *)dateForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  return [[KalDate alloc] initForDay:day month:month year:year];
}

+ (KalDate *)dateFromNSDate:(NSDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  NSDateComponents *parts = [date cc_componentsForMonthDayAndYear];
    DBLog(@"%i %i %i ", [parts day], [parts month], [parts year]);
  return [KalDate dateForDay:[parts day] month:[parts month] year:[parts year]];
}

- (id)initForDay:(unsigned int)day month:(unsigned int)month year:(unsigned int)year
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if ((self = [super init])) {
    a.day = day;
    a.month = month;
    a.year = year;
  }
  return self;
}

- (unsigned int)day { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return a.day; 
}
- (unsigned int)month { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return a.month; 
}
- (unsigned int)year { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return a.year; 
}

- (NSDate *)NSDate
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  NSDateComponents *c = [[NSDateComponents alloc] init] ;
  c.day = a.day;
  c.month = a.month;
  c.year = a.year;
  return [[NSCalendar currentCalendar] dateFromComponents:c];
}

- (BOOL)isToday { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return [self isEqual:today]; 
}

- (NSComparisonResult)compare:(KalDate *)otherDate
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  NSInteger selfComposite = a.year*10000 + a.month*100 + a.day;
  NSInteger otherComposite = [otherDate year]*10000 + [otherDate month]*100 + [otherDate day];
  
  if (selfComposite < otherComposite)
    return NSOrderedAscending;
  else if (selfComposite == otherComposite)
    return NSOrderedSame;
  else
    return NSOrderedDescending;
}

#pragma mark -
#pragma mark NSObject interface

- (BOOL)isEqual:(id)anObject
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if (![anObject isKindOfClass:[KalDate class]])
    return NO;
  
  KalDate *d = (KalDate*)anObject;
  return a.day == [d day] && a.month == [d month] && a.year == [d year];
}

- (NSUInteger)hash
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return a.day;
}

- (NSString *)description
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return [NSString stringWithFormat:@"%u/%u/%u", a.month, a.day, a.year];
}

@end
