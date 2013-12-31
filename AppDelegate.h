//
//  AppDelegate.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/21.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <FacebookSDK/FacebookSDK.h>



#define VERSION @"1.0.1"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



// タスク数
@property NSInteger numTasks;
// タスク一覧
@property (strong, nonatomic) NSMutableArray *tasks;

// DB
@property (strong, nonatomic) FMDatabase *db;

@end
