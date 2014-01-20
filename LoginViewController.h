//
//  LoginViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2014/01/01.
//  Copyright (c) 2014年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"

#define LOGIN_STATUS_KEY @"loginStatus"
#define MAIL_KEY @"mail"
#define PASS_KEY @"pass"
#define HAS_LOGGED_IN_KEY @"loggedIn"

@interface LoginViewController : UIViewController <FBLoginViewDelegate> {
    AppDelegate *delegate;
}

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

- (BOOL)login:(NSString *)name userId:(NSString *)userId detail:(NSString *)detail;
@end
