//
//  LoginViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2014/01/01.
//  Copyright (c) 2014年 com.self.planningdev. All rights reserved.
//

#import "LoginViewController.h"
#import "UserConfigViewController.h"
#import "AppDelegate.h"



#import "AsyncURLConnection.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    // タブバーデリゲートの設定
    //self.tabBarController.delegate = self;
    
    delegate = [UIApplication sharedApplication].delegate;
    
    if ([self getLoginStatus]) {
        [self.navigationItem setTitle:@"ログイン済み"];
    }
    else {
        [self.navigationItem setTitle:@"ログインしていません"];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.loginView.delegate = self;
    // ログイン中であればスキップ
//    if ([self getLoginStatus]) {
//        [self transitionToConfigView];
//    }
}

// **************************************
//          ビューが切り替わった時
// **************************************
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    NSLog(@"switched");
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// **********************************
//          ログイン処理をする
// **********************************
- (BOOL)login:(NSString *)name userId:(NSString *)userId detail:(NSString *)detail;
{
    NSURLRequest *request = [self createLoginRequest:name userId:userId detail:detail];
    
    AsyncURLConnection *conn = [[AsyncURLConnection alloc] initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // ユーザー情報を取得
        delegate.user = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
        
        // エラー情報を確認
        if (![[delegate.user objectForKey:ERROR_CODE] isEqualToString:NO_ERROR]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ログイン" message:@"ログインに失敗しました。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
        // タイムアウトが発生
        if ( error.code==NSURLErrorTimedOut ) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ログイン" message:@"タイムアウトが発生しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
        }
        // 通信エラー
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ログイン" message:@"通信エラーが発生しました。通信環境の良い場所で再度お試しください。。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
    
    [conn performRequest];
    [conn join];
    
    return YES;
}


// **********************************
//          ログインリクエストを作成
// **********************************
- (NSURLRequest *)createLoginRequest:(NSString *)name userId:(NSString *)userId detail:(NSString *)detail
{
    
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:LOGIN_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", userId];
    NSString *body = [NSString stringWithFormat:@"name=%@&userId=%@&image=%@&memo=%@", name, userId, imageUrl, detail];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

// **********************************
//          ログイン状態を取得
// **********************************
- (BOOL)getLoginStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_STATUS_KEY];
}


// **********************************
//          ログイン状態を保存
// **********************************
- (void)saveLoginStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:LOGIN_STATUS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



// *******************************************
//              FBログインエラー時
// *******************************************
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    FBErrorCategory errorCategory = [FBErrorUtility errorCategoryForError:error];
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if (errorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (errorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}



// *******************************************
//              FBログイン成功時
// *******************************************
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // if you become logged in, no longer flag to skip log in
    
    if (![self getLoginStatus]) {
        [self saveLoginStatus:YES];
        //[self transitionToConfigView];
        [self.navigationItem setTitle:@"ログイン済み"];
    }
    
}


// *******************************************
//              FB情報取得イベント
// *******************************************
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    // ログインする
    [self login:user.name userId:user.id detail:[user objectForKey:@"bio"]];
}

// *******************************************
//              FBログアウト時
// *******************************************
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self saveLoginStatus:NO];
    [self.navigationItem setTitle:@"ログインしていません"];
}


// ********************************************
//          画面遷移時イベント: ConfigSegue
// ********************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"ConfigSegue"]) {
        ;
    }
}


@end
