/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"

@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize kTileSize ;
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIFont *font = nil;
    CGFloat fontSize = 20.f;

    if (!iPhone) {
        DBLog(@"iPad");
        kTileSize.width =  46.f * 2.4;
        kTileSize.height = 44.f * 2.13;
        fontSize = fontSize * 2.4;
    }else {
        kTileSize.width =  46.f;
        kTileSize.height = 44.f ;
    }
    
  font = [UIFont fontWithName:@"Street Humouresque" size:fontSize];
  UIColor *shadowColor = nil;
  UIColor *textColor = nil;
  UIImage *markerImage = nil;
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
  CGContextTranslateCTM(ctx, 0, kTileSize.height);
  CGContextScaleCTM(ctx, 1, -1);
  
     
  if ([self isToday] && self.selected) {
       if (iPhone) {
           [[[UIImage imageNamed:@"TodaysTileSelected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
       }else {
           [[[UIImage imageNamed:@"TodaysTileSelected@2x.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
       }
      textColor = [UIColor blackColor];
      shadowColor = nil;
    markerImage = [UIImage imageNamed:@"kal_marker_today.png"];
  } else if ([self isToday] && !self.selected) {
    [[[UIImage imageNamed:@"TodaysTile.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
    textColor = [UIColor blackColor];
    shadowColor = [UIColor clearColor];
    markerImage = [UIImage imageNamed:@"kal_marker_today.png"];
  } else if (self.selected) {
      // Some day selected
      if (iPhone) {
          [[[UIImage imageNamed:@"TileSelected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
          textColor = [UIColor blackColor];
      }else {
          [[[UIImage imageNamed:@"TileSelected@2x.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
          textColor = [UIColor blackColor];
      }

      shadowColor = nil;
      markerImage = [UIImage imageNamed:@"kal_marker_selected.png"];
  } else if (self.belongsToAdjacentMonth) {
      // Dates of next month
      //textColor = [UIColor blackColor];
      textColor = [UIColor grayColor];
      shadowColor = nil;
      markerImage = [UIImage imageNamed:@"kal_marker_dim.png"];
  } else {
      textColor = [UIColor blackColor];
      shadowColor = nil;
      markerImage = [UIImage imageNamed:@"kal_marker.png"];
  }
  
  if (flags.marked)
    [markerImage drawInRect:CGRectMake(21.f, 5.f, 4.f, 5.f)];
  
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
  textX = roundf(0.5f * (kTileSize.width - textSize.width));
  textY = 6.f + roundf(0.5f * (kTileSize.height - textSize.height));
  if (shadowColor) {
    [shadowColor setFill];
    CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
    textY += 1.f;
  }
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
  
  if (self.highlighted) {
    [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
    CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
  }
}

- (void)resetState
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  // realign to the grid
    CGSize kTileSize ;
    if (!iPhone) {
        DBLog(@"iPad");
        kTileSize.width =  46.f * 2.4;
        kTileSize.height = 44.f * 2.13;
    }else {
        kTileSize.width =  46.f;
        kTileSize.height = 44.f ;
    }
    

  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  //[date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if (date == aDate)
    return;

  //[date release];
  date = aDate;

  [self setNeedsDisplay];
}

- (BOOL)isSelected { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return flags.selected; 
}

- (void)setSelected:(BOOL)selected
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return flags.highlighted; 
}

- (void)setHighlighted:(BOOL)highlighted
{
    DBLog(@"%s",__PRETTY_FUNCTION__);
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { 
    DBLog(@"%s",__PRETTY_FUNCTION__);
    return flags.marked; 
}

- (void)setMarked:(BOOL)marked
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return flags.type; 
}

- (void)setType:(KalTileType)tileType
{
    //DBLog(@"%s",__PRETTY_FUNCTION__);
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return flags.type == KalTileTypeToday; 
}

- (BOOL)belongsToAdjacentMonth { 
    //DBLog(@"%s",__PRETTY_FUNCTION__);
    return flags.type == KalTileTypeAdjacent; 
}
/*
- (void)dealloc
{
  [date release];
  [super dealloc];
}
*/
@end
