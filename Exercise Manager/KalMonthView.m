/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.clipsToBounds = YES;
      
      CGSize kTileSize ;
      if (!iPhone) {
          DBLog(@"iPad");
          kTileSize.width =  46.f * 2.4;
          kTileSize.height = 44.f * 2.13;
      }else {
          kTileSize.width =  46.f;
          kTileSize.height = 44.f ;
      }
    for (int i=0; i<6; i++) {
      for (int j=0; j<7; j++) {
        CGRect r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
        [self addSubview:[[KalTileView alloc] initWithFrame:r] ];
      }
    }
  }
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++) {
    for (KalDate *d in dates[i]) {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
  
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    CGSize kTileSize ;
    if (!iPhone) {
        DBLog(@"iPad");
        kTileSize.width =  46.f * 2.4;
        kTileSize.height = 44.f * 2.13;
    }else {
        kTileSize.width =  46.f;
        kTileSize.height = 44.f ;
    }
  CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (iPhone) {
          CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"kal_tile.png"] CGImage]);
    }else {
          CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"kal_tile@2x.png"] CGImage]);
    }

}

- (KalTileView *)firstTileOfMonth
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  KalTileView *tile = nil;
    int i=0;
    if (self.subviews) {
        DBLog(@"Subviews are present #: %d", [self.subviews count]);
    }
  for (KalTileView *t in self.subviews) {
      DBLog(@"%d %d %d %d", i, t.date.day, t.date.month, t.date.year);
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
      i++;
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
    CGSize kTileSize ;
    if (!iPhone) {
        DBLog(@"iPad");
        kTileSize.width =  46.f * 2.4;
        kTileSize.height = 44.f * 2.13;
    }else {
        kTileSize.width =  46.f;
        kTileSize.height = 44.f ;
    }
  self.height = 1.f + kTileSize.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  for (KalTileView *tile in self.subviews)
    tile.marked = [dates containsObject:tile.date];
}

@end
