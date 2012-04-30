//
//  EMMoreDetailsViewController.h
//  TracWet
//
//  Created by Deborshi Saha on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EMMoreDetailsViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    NSString *titleString;
    NSString *topic;
    
    IBOutlet UILabel *topicLabel;
    IBOutlet UILabel *msgLabel;
    IBOutlet UIButton *sendFeedback;
}

@property(nonatomic, retain) NSString *titleString;
@property(nonatomic, retain) NSString *topic;

@property(nonatomic, retain)  IBOutlet UILabel* topicLabel;
@property(nonatomic, retain)  IBOutlet UILabel* msgLabel;
@property(nonatomic, retain)  IBOutlet UIButton* sendFeedback;

@end
