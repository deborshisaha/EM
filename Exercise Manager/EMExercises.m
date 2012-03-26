//
//  EMExercises.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMExercises.h"

@implementation EMExercises
@synthesize pSExerciseName, IExerciseId, IWeight,IWeightMeterRequired;


-(id) initWithName:(NSString *)name andId:(NSInteger)id andWeightIsRequired: (NSInteger)weightIsRequired andWeight: (NSInteger)weight{
    self.pSExerciseName = name;
    self.IExerciseId = id;
    self.IWeightMeterRequired = weightIsRequired;
    self.IWeight = weight;
    return self;
}

@end