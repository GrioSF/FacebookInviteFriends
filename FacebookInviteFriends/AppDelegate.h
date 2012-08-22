//
//  AppDelegate.h
//  FacebookInviteFriends
//
//  Created by Santo Purnama on 7/30/12.
//  Copyright (c) 2012 Santo Purnama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate> {
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) Facebook *facebook;
@end
