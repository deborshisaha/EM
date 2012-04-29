//
//  EMMoreDetailsViewController.h
//  TracWet
//
//  Created by Deborshi Saha on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMMoreDetailsViewController : UIViewController{
    NSString *titleString;
    NSString *topic;
    
    IBOutlet UILabel* topicLabel;
}

@property(nonatomic, retain) NSString *titleString;
@property(nonatomic, retain) NSString *topic;

@property(nonatomic, retain)  IBOutlet UILabel* topicLabel;

@end
