//
//  EMMoreDetailsViewController.m
//  TracWet
//
//  Created by Deborshi Saha on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMMoreDetailsViewController.h"

@interface EMMoreDetailsViewController ()

@end


@implementation EMMoreDetailsViewController
@synthesize titleString, topic, topicLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = titleString;
    [topicLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:17]];
    topicLabel.text = topic;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
