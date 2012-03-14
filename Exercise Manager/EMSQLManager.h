//
//  EMSQLManager.h
//  Exercise Manager
//
//  Created by Deborshi Saha on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMSQLManager : NSObject

@end


// List of exercises
@interface AbsExercise : NSObject{
    NSString *abs_exercise;
    NSInteger abs_id;
}

@property (nonatomic, retain) NSString *abs_exercise;
@property (nonatomic, readwrite) NSInteger abs_id;

-(id) initWithName:(NSString *)name;

@end