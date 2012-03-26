//
//  EMExercises.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMExercises : NSObject
{
    NSString *pSExerciseName;
    NSInteger IExerciseId;
    NSInteger IWeightMeterRequired;
    NSInteger IWeight;
}

@property (nonatomic, retain) NSString *pSExerciseName;
@property (nonatomic, readwrite) NSInteger IExerciseId;
@property (nonatomic, readwrite) NSInteger IWeightMeterRequired;
@property (nonatomic, readwrite) NSInteger IWeight;

-(id) initWithName:(NSString *)name andId:(NSInteger)id andWeightIsRequired: (NSInteger)weightIsRequired andWeight: (NSInteger)weight;

@end

