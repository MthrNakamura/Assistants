//
//  AppDelegate.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/21.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDatabase.h"

#import <FacebookSDK/FacebookSDK.h>


#define kFacebookAPIKey @"761593323870189"
#define kFacebookSecretKey @"3fb615def99939ee56947f1359df2de6"

@implementation AppDelegate

@synthesize tasks;
@synthesize db;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // *** FB OOathの設定 ***/
    [FBLoginView class];
    
    // Whenever a person opens the app, check for a cached session
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                      }];
    
    
    // *** SQLite DBの設定 ***
    // DBファイルのパス
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    // DBファイルがあるか確認
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[dir stringByAppendingPathComponent:@"assistants.db"]])
    {
        // なければ新規作成
        db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"assistants.db"]];
        
        // テーブルを作成
        NSString *sql = @"CREATE TABLE task (task_title TEXT NOT NULL,task_memo TEXT NULL,task_limit VARCHAR(45) NULL,PRIMARY KEY task_title, assistants TEXT NULL);";
        [db open];
        [db executeUpdate:sql];
        [db close];
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

@end
