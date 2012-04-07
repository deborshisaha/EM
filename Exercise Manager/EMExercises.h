//
//  EMExercises.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMExercisesBasic : NSObject
{
    NSString *pSExerciseName;
    NSInteger IExerciseId;
    NSInteger IWeight;
}

@property (nonatomic, retain) NSString *pSExerciseName;
@property (nonatomic, readwrite) NSInteger IExerciseId;
@property (nonatomic, readwrite) NSInteger IWeight;

-(id) initWithName:(NSString *)name andId:(NSInteger)id andWeight: (NSInteger)weight;

@end


@interface EMExercises : EMExercisesBasic
{
    NSInteger IWeightMeterRequired;
}

@property (nonatomic, readwrite) NSInteger IWeightMeterRequired;

-(id) initWithName:(NSString *)name andId:(NSInteger)id andWeightIsRequired: (NSInteger)weightIsRequired andWeight: (NSInteger)weight;

@end

