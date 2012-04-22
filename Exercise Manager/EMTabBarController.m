//
//  EMTabBarController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMTabBarController.h"

@interface EMTabBarController ()

@end

@implementation EMTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarBG.png"];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"selectedItemImage.png"];
}

- (void)viewDidUnload
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DBLog(@" %s STARTS ", __PRETTY_FUNCTION__);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
