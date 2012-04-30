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
@synthesize titleString, topic, topicLabel, sendFeedback, msgLabel;

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
    
    NSString *msgLabelText = NULL;
    
    if ( [topic isEqualToString:@"Undo today's exercise?"]){
        msgLabelText = [[NSString alloc] initWithString:@"Go to 'History'. Locate the exercise you did not perform or want to remove. Swipe the exercise row in any direction. A red button with 'Delete' label will appear. Click on it to remove the exercise."];
    }else if ( [topic isEqualToString:@"Delete a category?"]) {
        msgLabelText = [[NSString alloc] initWithString:@"Swipe the category row in any direction. A red button with 'Delete' label will appear. Click on it to remove the category."];
    }else if ([topic isEqualToString:@"Delete an exercise?"]) {
         msgLabelText = [[NSString alloc] initWithString:@"Swipe the exercise row in any direction. A red button with 'Delete' label will appear. Click on it to remove the exercise."];
    }else if (  [topic isEqualToString:@"To expect?"]) {
         msgLabelText = [[NSString alloc] initWithString:@"1. This app stores all its information in the device itself. No information goes out of this device.\n2. This app only assists you to keep track of weights you have used to perform an exercise.\nThe app also stores history about exercises you have performed."];
    }else if (  [topic isEqualToString:@"Is the gray color on changing weight?"]) {
         msgLabelText = [[NSString alloc] initWithString:@"A row turns gray to indicate that you have performed that exercise on that day"];
    }else if ( [topic isEqualToString:@"Contact Us"]){
        // This sample can run on devices running iPhone OS 2.0 or later  
        // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
        // So, we must verify the existence of the above class and provide a workaround for devices running 
        // earlier versions of the iPhone OS. 
        // We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
        // We launch the Mail application on the device, otherwise.
        msgLabelText = [[NSString alloc] initWithString:@""];
        
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self showEmailModalView];
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }else {
         msgLabelText = [[NSString alloc] initWithString:@"This app has been designed and developed by Deborshi Saha and reserves all rights."];
    }
    [msgLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:15]];
    //[msgLabel sizeToFit];
    msgLabel.text =  msgLabelText;
    //[sendFeedback.titleLabel setFont:[UIFont fontWithName:@"Street Humouresque" size:18]];
    
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


-(void) showEmailModalView {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
	[picker setSubject:@"Feedback!"];
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"deborshi.saha@gmail.com"]; 
    
    [picker setToRecipients:toRecipients];
    
	[self presentModalViewController:picker animated:YES];    
}

-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Feedback!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	NSString *successOrFailMessage = [[NSString alloc] init];
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
            DBLog(@"Result: canceled");
			successOrFailMessage = @"Email canceled";
			break;
		case MFMailComposeResultSaved:
            DBLog(@"Result: saved");
			successOrFailMessage = @"Email saved";
			break;
		case MFMailComposeResultSent:
            DBLog(@"Result: sent");
			successOrFailMessage = @"Email sent";
			break;
		case MFMailComposeResultFailed:
            DBLog(@"Result: failed");
			successOrFailMessage = @"Email failed";
			break;
		default:
            DBLog(@"Result: not sent");
			successOrFailMessage = @"Email not sent";
			break;
	}
 
    DBLog(@"%@",successOrFailMessage);
    
	[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated: YES];
}

@end
