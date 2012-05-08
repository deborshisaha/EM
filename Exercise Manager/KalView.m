/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 44.f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    if ((self = [super initWithFrame:frame])) {
        delegate = theDelegate;
        logic = theLogic ;
        
        
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
        UIView *headerView = NULL;
        UIView *contentView = NULL;
        if (!iPhone) {
            DBLog(@"headerview iPad");
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width , kHeaderHeight * 2.13)];
            contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight * 2.13, frame.size.width, frame.size.height - kHeaderHeight * 2.13)];
        }else {
            DBLog(@"headerview iPhone");
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight )];
            contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight , frame.size.width, frame.size.height - kHeaderHeight )];
        }
      
    headerView.backgroundColor = [UIColor clearColor];
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
    
    //UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    [self jumpToSelectedMonth]; 
}

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    CGFloat ChangeMonthButtonWidth = 46.0f;
    CGFloat ChangeMonthButtonHeight = 30.0f;
    CGFloat MonthLabelWidth = 200.0f;
    CGFloat HeaderVerticalAdjust = 3.0f;
    CGFloat fontSizeForDayTags = 10.f;
    CGFloat fontSizeForMonthTags = 22.f;
    
    if (!iPhone) {
        DBLog(@"Month Label adjustments for iPad");
        fontSizeForMonthTags *= 2.13;
        ChangeMonthButtonWidth *= 2.4;
        ChangeMonthButtonHeight *= 2.13;
        MonthLabelWidth *= 2.4;
        HeaderVerticalAdjust *= 2.13;
    } 


    
    // Header background gradient
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbarBG.png"]];
    CGRect imageFrame = headerView.frame;
    imageFrame.origin = CGPointZero;
    backgroundView.frame = imageFrame;
    [headerView addSubview:backgroundView];
  
    
  // Create the previous month button on the left side of the view
  CGRect previousMonthButtonFrame = CGRectMake(self.left,
                                               HeaderVerticalAdjust,
                                               ChangeMonthButtonWidth,
                                               ChangeMonthButtonHeight);
  UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
  [previousMonthButton setImage:[UIImage imageNamed:@"LeftArrow.png"] forState:UIControlStateNormal];
  previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:previousMonthButton];
    CGRect monthLabelFrame;
    
  // Draw the selected month name centered and at the top of the view
    if (!iPhone) {
        DBLog(@"iPad");
         monthLabelFrame = CGRectMake((self.width/2.0f) - (MonthLabelWidth/2.0f),
                                     HeaderVerticalAdjust,
                                     MonthLabelWidth,
                                     kMonthLabelHeight * 2.13);
    }else {
        monthLabelFrame = CGRectMake((self.width/2.0f) - (MonthLabelWidth/2.0f),
                                     HeaderVerticalAdjust,
                                     MonthLabelWidth,
                                     kMonthLabelHeight );
    }

    headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.font = [UIFont fontWithName:@"Street Humouresque" size: fontSizeForMonthTags];
    headerTitleLabel.textAlignment = UITextAlignmentCenter;
    headerTitleLabel.textColor = [UIColor blackColor];
    headerTitleLabel.shadowColor = nil;

    [self setHeaderTitleText:[logic selectedMonthNameAndYear]];
    [headerView addSubview:headerTitleLabel];
  
    // Create the next month button on the right side of the view
    CGRect nextMonthButtonFrame = CGRectMake(self.width - ChangeMonthButtonWidth,
                                           HeaderVerticalAdjust,
                                           ChangeMonthButtonWidth,
                                           ChangeMonthButtonHeight);
  UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
  [nextMonthButton setImage:[UIImage imageNamed:@"RightArrow.png"] forState:UIControlStateNormal];
  nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
  [headerView addSubview:nextMonthButton];
  //[nextMonthButton release];
  
    /*
     * The code below adds weekday tags
     * e.g. Sun Mon Tues Wed Thu Fr Sat
     */
    NSArray *weekdayNames = [[[NSDateFormatter alloc] init]  shortWeekdaySymbols];
    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
    NSUInteger i = firstWeekday - 1;
    CGFloat xOffset = 0.0f;
    CGFloat yOffset = 30.f;
    CGFloat xOffsetIncrements = 46.f;
    
    if (!iPhone) {
        DBLog(@"iPad");
        fontSizeForDayTags *= 2.13;
        xOffset = 24.0f;
        yOffset *= 2.13f;
        xOffsetIncrements *= 2.4;
    }
    for (; xOffset < headerView.width; xOffset += xOffsetIncrements, i = (i+1)%7) {
        CGRect weekdayFrame = CGRectMake(xOffset, yOffset, 46.f, kHeaderHeight - 29.f);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont fontWithName:@"Street Humouresque" size:fontSizeForDayTags];
        weekdayLabel.textAlignment = UITextAlignmentCenter;
        weekdayLabel.textColor = [UIColor blackColor];
        weekdayLabel.shadowColor = nil;
        weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [headerView addSubview:weekdayLabel];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
    DBLog(@"%s",__PRETTY_FUNCTION__);
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
  gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate];
  [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
  [contentView addSubview:gridView];

  // The list of events for the selected day
  tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [contentView addSubview:tableView];
  
  // Drop shadow below tile grid and over the list of events for the selected day
  shadowView = [[UIImageView alloc] initWithFrame:fullWidthAutomaticLayoutFrame];
  shadowView.image = [UIImage imageNamed:@"kal_grid_shadow.png"];
  shadowView.height = shadowView.image.size.height;
  [contentView addSubview:shadowView];
  
  // Trigger the initial KVO update to finish the contentView layout
  [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
    /* Animate tableView filling the remaining space after the
     * gridView expanded or contracted to fit the # of weeks
     * for the month that is being displayed.
     *
     * This observer method will be called when gridView's height
     * changes, which we know to occur inside a Core Animation
     * transaction. Hence, when I set the "frame" property on
     * tableView here, I do not need to wrap it in a
     * [UIView beginAnimations:context:].
     */
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.height - gridBottom;
    tableView.frame = frame;
    shadowView.top = gridBottom;
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    [headerTitleLabel setText:text];
    //[headerTitleLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:60.0]];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    [gridView jumpToSelectedMonth]; 
}

- (void)selectDate:(KalDate *)date { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    [gridView selectDate:date]; 
}

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    [gridView markTilesForDates:dates]; 
}

- (KalDate *)selectedDate { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    //DBLog(@"date", gridview.selectedDate);
    return gridView.selectedDate;
}


@end
