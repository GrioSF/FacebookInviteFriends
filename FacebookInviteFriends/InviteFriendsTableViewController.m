//
//  InviteFriendsTableViewController.m
//  FacebookInviteFriends
//
//  Created by Purnama Santo on 7/22/12.
//  Copyright (c) 2012 grio. All rights reserved.
//

#import "InviteFriendsTableViewController.h"
#import "AppDelegate.h"

static NSString* kGraphBaseURL = @"https://graph.facebook.com/";

#define FRIENDS_PER_LOAD    30


@interface InviteFriendsTableViewController ()
@end


@implementation InviteFriendsTableViewController

@synthesize facebook = _facebook;


- (id)initWithFacebook:(Facebook*)fb
{
    self = [super init];
    if (self) {
        self.facebook = fb;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Invite Friends", nil);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated {
    if (![self.facebook isSessionValid]) {
        // TODO: uialertview here???
        // for now, assume this is never going to happen
        return;
    }
    
    [self requestFriendList];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)requestFriendList {
    NSString *url = [NSString stringWithFormat:@"me/friends?limit=%d&offset=%d", FRIENDS_PER_LOAD, _pageNo*FRIENDS_PER_LOAD];
    [self.facebook requestWithGraphPath:url andDelegate:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friends ? [_friends count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FacebookFriendsListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (_friends) {
        NSDictionary *friend = [_friends objectAtIndex:indexPath.row];
        cell.textLabel.text = [friend objectForKey:@"name"];
        cell.accessoryView = nil;
    }
    else {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        cell.accessoryView = activityView;
        cell.textLabel.text = @"Loading...";
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *friend = [_friends objectAtIndex:indexPath.row];
    NSString *to = [friend objectForKey:@"id"];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Check this app out...",  @"message",
                                   to, @"to",
                                   nil];
    [self.facebook dialog:@"apprequests" andParams:params andDelegate:nil];
}


#pragma mark - FBRequestDelegate implementation


/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}


/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    // here, you can show an alert and send cancellation notice to delegate
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                                        message:NSLocalizedString(@"There was a problem retrieving list of your friends.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
}


/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"---> %@", result);
        result = [(NSDictionary*)result objectForKey:@"data"];
        
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray*)result;

            if (!_friends) {
                _friends = [NSMutableArray array];
            }
            for (NSDictionary *newFriend in data) {
                int ndx = 0;
                for (NSDictionary *friend in _friends) {
                    NSString *name = [friend objectForKey:@"name"];
                    NSString *newName = [newFriend objectForKey:@"name"];
                    if ([name compare:newName]==NSOrderedDescending)
                        break;
                    ndx++;
                }
                [_friends insertObject:newFriend atIndex:ndx];
            }

            if ([data count]==FRIENDS_PER_LOAD) {
                _pageNo++;
                [self requestFriendList];
            }
            else {
                // reload the view...
                [self.tableView reloadData];
            }
        }
    }
}


@end
