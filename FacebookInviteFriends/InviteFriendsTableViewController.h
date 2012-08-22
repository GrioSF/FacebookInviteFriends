//
//  InviteFriendsTableViewController.h
//  FacebookInviteFriends
//
//  Created by Purnama Santo on 7/22/12.
//  Copyright (c) 2012 grio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface InviteFriendsTableViewController : UITableViewController <FBRequestDelegate> {
    int _pageNo;
    NSMutableArray *_friends;
    Facebook *_facebook;
}

- (id)initWithFacebook:(Facebook*)fb;


@property (nonatomic, retain) Facebook *facebook;


@end
