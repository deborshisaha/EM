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
}

@property (nonatomic, retain) NSString *pSExerciseName;
@property (nonatomic, readwrite) NSInteger IExerciseId;

-(id) initWithName:(NSString *)name;

@end

