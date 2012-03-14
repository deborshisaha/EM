//
//  EMSQLManager.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMSQLManager.h"

@implementation EMSQLManager

@end

@implementation AbsExercise
@synthesize abs_exercise, abs_id;


-(id) initWithName:(NSString *)name{
    self.abs_exercise = name;
    return self;
}

@end

