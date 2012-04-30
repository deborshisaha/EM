//
//  EMCustomNavigationController.m
//  Exercise Manager
//
//  Created by Deborshi Saha on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMCustomNavigationController.h"

@interface EMCustomNavigationController ()

@end

@implementation EMCustomNavigationBar: UINavigationBar 

- (void) drawRect:(CGRect)rect{
DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
UIImage *image = [UIImage imageNamed:@"tabbarBG.png"];
[image drawInRect:frame];
}

@end

@implementation EMCustomNavigationController

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
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DBLog(@"%s STARTS", __PRETTY_FUNCTION__);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end