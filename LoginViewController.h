//
//  LoginViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/31.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

- (void)gotoTopView:(NSString *)userId name:(NSString *)name;

@end
