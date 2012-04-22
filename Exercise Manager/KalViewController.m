/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "EMSqliteDatasource.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};

    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface KalViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end

@implementation KalViewController

@synthesize dataSource, delegate, initialDate, selectedDate;

- (id)initWithSelectedDate:(NSDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if ((self = [super init])) {
    logic = [[KalLogic alloc] initForDate:date];
    self.initialDate = date;
    self.selectedDate = date;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    dataSource = [[EMSqliteDatasource alloc] initWithTodaysDate:[NSDate date]];
    //tableView.dataSource = dataSource;
    return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    return (KalView*)self.view; 
}
/*
- (void)setDataSource:(id<KalDataSource>)aDataSource
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if (dataSource != aDataSource) {
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}
*/
- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if (delegate != aDelegate) {
    delegate = aDelegate;
    tableView.delegate = delegate;
  }
}

- (void)clearTable
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    [dataSource removeAllItems];
    [tableView reloadData];
}

- (void)reloadData
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)significantTimeChangeOccurred
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [[self calendarView] jumpToSelectedMonth];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol
/*
- (void):(KalDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  self.selectedDate = [date NSDate];
  NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to];
  [tableView reloadData];
  [tableView flashScrollIndicators];
}
 */

- (void)showPreviousMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
  [self reloadData];
}

- (void)showFollowingMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  //NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
  //NSMutableArray *dates = [markedDates mutableCopy] ;
  //for (int i=0; i<[dates count]; i++)
    //[dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
  
  //[[self calendarView] markTilesForDates:dates];
  //[self didSelectDate:self.calendarView.selectedDate];
}


// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToMonthForDate:date];
  
#if PROFILER
  uint64_t start, end;
  struct timespec tp;
  start = mach_absolute_time();
#endif
  
  [[self calendarView] jumpToSelectedMonth];
  
#if PROFILER
  end = mach_absolute_time();
  mach_absolute_difference(end, start, &tp);
  printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
  
  [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
  [self reloadData];
}

- (NSDate *)selectedDate
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  return [self.calendarView.selectedDate NSDate];
}


// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didSelectDate:(KalDate *)date
{
    DBLog(@"%s", __PRETTY_FUNCTION__);
    //DBLog(@"Date selected: %d %d %d", date.day, date.month, date.year);
    self.selectedDate = [date NSDate];
    [tableView reloadData];
    [tableView flashScrollIndicators];
}

- (void)userSelectedDate:(KalDate *)date
{
    DBLog(@"%s", __PRETTY_FUNCTION__);
    //DBLog(@"Date selected: %d %d %d", date.day, date.month, date.year);
    self.selectedDate = [date NSDate];
    DBLog(@" DAY user selected %d", date.day);
    [dataSource loadExerciseOfDate:[date NSDate]];
    //[self reloadData];
    [tableView reloadData];
    [tableView flashScrollIndicators];
}


- (void)didReceiveMemoryWarning
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  self.initialDate = self.selectedDate; // must be done before calling super
  [super didReceiveMemoryWarning];
}

- (void)loadView
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  //if (!self.title)
  //  self.title = @"Calendar";
  KalView *kalView = [[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic] ;
  
    // Set the data source
    //[dataSource loadExerciseOfDate:<#(NSDate *)#>]
    self.view = kalView;
  tableView = kalView.tableView;
    tableView.dataSource = dataSource;
  tableView.delegate = delegate;
  //[tableView retain];
  [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
  [self reloadData];
}

- (void)viewDidload{
    DBLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [super viewDidUnload];
  //[tableView release];
  tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [super viewWillAppear:animated];
    [dataSource loadExerciseOfDate:[NSDate date]];
  [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}

#pragma mark -



/*
- (void)dealloc
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
  [initialDate release];
  [selectedDate release];
  [logic release];
  [tableView release];
  [super dealloc];
}
*/
@end
