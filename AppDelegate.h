//
//  AppDelegate.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/21.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

#define TIMEOUT_INTERVAL 20

//#define _PRODUCTION 1

// *** ユーザー情報のプロパティキー ***
#define USER_PROP_ID @"userId"
#define USER_PROP_NAME @"name"
#define USER_PROP_MEMO @"memo"
#define USER_PROP_PHOTO @"image"
#define USER_PROP_EMAIL @"mail"
#define USER_PROP_SKILL1 @"skill1"
#define USER_PROP_SKILL2 @"skill2"
#define USER_PROP_SKILL3 @"skill3"
#define USER_PROP_ASSIST @"assist"
#define USER_PROP_PHONE @"phone"
#define USER_PROP_MAIL @"mail"

// *** mytasklist API のタスクキー ***
#define MYTASK_LIST_TASK @"task"

// *** サーバーからのリクエストパラメータのエラーコードキー ***
#define ERROR_CODE @"errorCode"

// *** サーバーからのエラーコード ***
#define NO_ERROR @"0000"        // 正常

#define _PRODUCTION

#ifdef _PRODUCTION

#define LOGIN_API @"http://202.144.229.58/assistants/login.php"
#define ADDTASK_API @"http://202.144.229.58/assistants/addtask.php"
#define UPDATE_API @"http://202.144.229.58/assistants/update.php"
#define DELETE_API @"http://202.144.229.58/assistants/delete.php"
#define MYLIST_API @"http://202.144.229.58/assistants/mytasklist.php"
#define PLIST_API  @"http://202.144.229.58/assistants/publictasklist.php"
#define UINFO_API  @"http://202.144.229.58/assistants/userinfo.php"
#define PPLIST_API @"http://202.144.229.58/assistants/personalpublictasklist.php"
#define ASSIST_API @"http://202.144.229.58/assistants/assist.php"
#define UNASSIST_API @"http://202.144.229.58/assistants/unassist.php"
#define TASKINFO_API @"http://202.144.229.58/assistants/taskinfo.php"
#define UPDATE_USERINFO_API @"http://202.144.229.58/assistants/updateuserinfo.php"
#define ASSISTANTS_API @"http://202.144.229.58/assistants/assistants.php"

#else

#define LOGIN_API @"http://MMacbookPro.local/~motohiro/assistants/login.php"
#define ADDTASK_API @"http://MMacbookPro.local/~motohiro/assistants/addtask.php"
#define UPDATE_API @"http://MMacbookPro.local/~motohiro/assistants/update.php"
#define DELETE_API @"http://MMacbookPro.local/~motohiro/assistants/delete.php"
#define MYLIST_API @"http://MMacbookPro.local/~motohiro/assistants/mytasklist.php"
#define PLIST_API  @"http://MMacbookPro.local/~motohiro/assistants/publictasklist.php"
#define UINFO_API  @"http://MMacbookPro.local/~motohiro/assistants/userinfo.php"
#define PPLIST_API @"http://MMacbookPro.local/~motohiro/assistants/personalpublictasklist.php"
#define ASSIST_API @"http://MMacbookPro.local/~motohiro/assistants/assist.php"
#define UNASSIST_API @"http://MMacbookPro.local/~motohiro/assistants/unassist.php"
#define TASKINFO_API @"http://MMacbookPro.local/~motohiro/assistants/taskinfo.php"
#define UPDATE_USERINFO_API @"http://MMacbookPro.local/~motohiro/assistants/updateuserinfo.php"
#define ASSISTANTS_API @"http://MMacbookPro.local/~motohiro/assistants/assistants.php"


#endif

#define VERSION @"1.0.1"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// ユーザー情報
@property (strong, nonatomic) NSMutableDictionary *user;
// ユーザーの保有タスク数
@property NSInteger numTasks;
// ユーザーの保有タスク一覧
@property (strong, nonatomic) NSMutableArray *tasks;

// アシスト中のタスク一覧
@property (strong, nonatomic) NSMutableArray *assistingTask;
// アシスト中のユーザー(ユーザーIDが入る)
@property (strong, nonatomic) NSMutableArray *assistingUser;
// 新たにタスクをアシストしたか？ (YESなら assistingTaskにアクセスする)
@property BOOL hasAssisted;



@end
