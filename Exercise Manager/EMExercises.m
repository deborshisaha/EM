//
//  EMExercises.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMExercises.h"

@implementation EMExercises
@synthesize pSExerciseName, IExerciseId;


-(id) initWithName:(NSString *)name{
    self.pSExerciseName = name;
    return self;
}

@end