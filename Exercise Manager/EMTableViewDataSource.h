//
//  EMTableViewDataSource.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EMTableViewDataSource <NSObject, UITableViewDataSource>

- (void)loadExerciseOfDate:(NSDate *)ofDate;

@end

@protocol EMTableViewDataSourceCallback <NSObject>
- (void)loadedDataSource:(id<EMTableViewDataSource>)dataSource;
@end