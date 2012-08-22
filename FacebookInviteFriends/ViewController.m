//
//  ViewController.m
//  FacebookInviteFriends
//
//  Created by Santo Purnama on 7/30/12.
//  Copyright (c) 2012 Santo Purnama. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "InviteFriendsTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)inviteFriends:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    InviteFriendsTableViewController *invite = [[InviteFriendsTableViewController alloc] initWithFacebook:appDelegate.facebook];
    [self presentModalViewController:invite animated:YES];
//    [invite ]
}
@end
