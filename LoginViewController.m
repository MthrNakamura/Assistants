//
//  LoginViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/31.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TopViewController.h"

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

    FBLoginView *loginView = [[FBLoginView alloc]init];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame, self.view.frame.size.width/2 - loginView.frame.size.width/2, self.view.frame.size.height/2 - loginView.frame.size.height/2);
    [self.view addSubview:loginView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"id: %@", user.id);
    NSLog(@"name: %@", user.name);
    
    [self gotoTopView:user.id name:user.name];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ログインエラー" message:@"ログインに失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"logged out");
}

- (void)gotoTopView:(NSString *)userId name:(NSString *)name
{
    TopViewController *topView = [self.storyboard instantiateViewControllerWithIdentifier:@"EntryView"];
    [self presentViewController:topView animated:YES completion:nil];
}

@end
