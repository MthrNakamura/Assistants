//
//  UserInfoViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "UserInfoViewController.h"
#import "PersonalPublicTaskViewController.h"
#import "TopViewController.h"
#import "AsyncURLConnection.h"
#import "AppDelegate.h"
#import "PersonalPublicTaskDetailViewController.h"

#import "MBProgressHUD.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

@synthesize userInfo;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // タブバーデリゲートの設定
    //self.tabBarController.delegate = self;
    
    // テーブルビューの背景を設定
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.jpg"]];
    
    // *** 表示するユーザー情報を設定 ***
    
    // ユーザープロフィール画像
    [self.userImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.userInfo objectForKey:USER_PROP_PHOTO]]]]];
    
    // ユーザー名
    [self.userName setText:[self.userInfo objectForKey:USER_PROP_NAME]];
    
    // スキル
    [self.skill1 setText:([[self.userInfo objectForKey:USER_PROP_SKILL1] isEqualToString:@"none"])?@"なし":[self.userInfo objectForKey:USER_PROP_SKILL1]];
    [self.skill2 setText:([[self.userInfo objectForKey:USER_PROP_SKILL2] isEqualToString:@"none"])?@"なし":[self.userInfo objectForKey:USER_PROP_SKILL2]];
    [self.skill3 setText:([[self.userInfo objectForKey:USER_PROP_SKILL3] isEqualToString:@"none"])?@"なし":[self.userInfo objectForKey:USER_PROP_SKILL3]];
    
    // ユーザー説明文
    [self.detailField setText:[self.userInfo objectForKey:USER_PROP_MEMO]];
    
    
    // *** その他の公開タスク一覧 ***
    // 公開タスクリストを取得
    [self getPublicTaskList];
    NSUInteger numOtherTasks = [publicTasks count];
    // タスクリストの内容を表示
    for (int i = 0; i < numOtherTasks; i++) {
        // 3つ目以降は別ビューで表示する
        if (i >= 3)
            break;
        
        switch (i) {
            case 0:
                
                [self.otherTask1 setText:[[publicTasks objectAtIndex:i]objectForKey:TASK_TITLE]];
                
                break;
                
            case 1:
                
                [self.otherTask2 setText:[[publicTasks objectAtIndex:i]objectForKey:TASK_TITLE]];
                
                break;
                
            case 2:
                
                [self.otherTask3 setText:[[publicTasks objectAtIndex:i]objectForKey:TASK_TITLE]];
                
                break;
                
            default:
                break;
        }
        
        
        
    }
    
    // 電話
//    if (![self.userInfo objectForKey:@"phone"]) {
//        [self.btnCall setEnabled:NO];
//    }
//    
//    // メール
//    if (![self.userInfo objectForKey:@"mail"]) {
//        [self.btnChat setEnabled:NO];
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

#pragma mark - Table view data source

// *************************************
//              セクション数
// *************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTION_USERINFO;
}

// *************************************
//          セクション毎のセル数
// *************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case SECTION_USERINFO:
            
            return NUM_CELLS_IN_USERINFO;
            
        case SECTION_SKILL:
            
            return NUM_CELLS_IN_SKILL;
            
        case SECTION_DETAIL:
            
            return NUM_CELLS_IN_DETAIL;
            
        case SECTION_OTASK:
            
            return ([publicTasks count] >= 3)? NUM_CELLS_IN_TASK:[publicTasks count];
            
        default:
            return 0;
    }
    
}

// *************************************
//          セル選択時イベント
// *************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_OTASK && indexPath.row != 3) {
        // 他のタスク詳細ビューを表示する
        PersonalPublicTaskDetailViewController *pptdView = [self.storyboard instantiateViewControllerWithIdentifier:@"PPTDView"];
        pptdView.taskData = [publicTasks objectAtIndex:indexPath.row];
        pptdView.userData = self.userInfo;
        [self.navigationController pushViewController:pptdView animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// *************************************
//        画面遷移時イベント
// *************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // このユーザーの公開タスク一覧に遷移
    if ([[segue identifier] isEqualToString:@"PersonalPublicTaskSegue"]) {
        
        PersonalPublicTaskViewController *pptView = (PersonalPublicTaskViewController *)[segue destinationViewController];
        pptView.tasks = publicTasks;
        pptView.userInfo = self.userInfo;
    }
}

// *************************************
//          公開タスク一覧を取得
// *************************************
- (void)getPublicTaskList
{
    // *** ユーザーIDを元にリストを取得 ***
    // サーバーにリクエストを送信
    if ([self sendPublicTaskListRequest]) {
        
       
        
    }
    
    
}


// **************************************
//     公開タスクリスト取得リスエストを送信
// **************************************
- (BOOL)sendPublicTaskListRequest
{
    __block BOOL result = YES;
    
    // *** ダイアログを表示 ***
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    [progress setLabelText:@"アシスト中..."];
    [self.view addSubview:progress];
    [progress show:YES];
    
    
    NSURLRequest *request = [self createPublicTaskListRequest];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // *** ダイアログを隠す ***
        [progress show:NO];
        [progress removeFromSuperview];
        
        // *** レスポンスをチェック ***
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"response: %@", response);
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"ユーザー情報の取得に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
            return ;
        }
        
        publicTasks = [response objectForKey:@"tasks"];
        
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
        // *** ダイアログを隠す ***
        [progress show:NO];
        [progress removeFromSuperview];
        
        
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
    
    return result;
}

// **************************************
//     公開タスクリスト取得リスエストを作成
// **************************************
- (NSURLRequest *)createPublicTaskListRequest
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:PPLIST_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"userId=%@", [self.userInfo objectForKey:USER_PROP_ID]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

// *************************************
//          前のビューに戻る
// *************************************
- (IBAction)gobackToPrevView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// *************************************
//              電話をかける
// *************************************
- (IBAction)call:(id)sender {
    NSLog(@"%@", [self.userInfo objectForKey:@"phone"]);
    if ([[self.userInfo objectForKey:@"phone"] isEqualToString:@"none"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"電話" message:@"電話番号が登録されていません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return ;
    }
    NSString *phoneNum = [self.userInfo objectForKey:@"phone"];
    if (!phoneNum)
        return ;
    NSURL *phone = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]];
    [[UIApplication sharedApplication]openURL:phone];
    
}


// *************************************
//              メールを開く
// *************************************
- (IBAction)chat:(id)sender {
    
    if ([[self.userInfo objectForKey:@"mail"] isEqualToString:@"none"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"メール" message:@"メールアドレスが登録されていません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return ;
    }
    
    NSString *mailAddr = [self.userInfo objectForKey:@"mail"];
    if (!mailAddr)
        return ;
    NSURL *mail = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", mailAddr]];
    [[UIApplication sharedApplication]openURL:mail];
}
@end
