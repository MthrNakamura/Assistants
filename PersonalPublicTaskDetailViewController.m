//
//  PersonalPublicTaskDetailViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "PersonalPublicTaskDetailViewController.h"
#import "PublicTasksViewController.h"
#import "TopViewController.h"

#import "AsyncURLConnection.h"
#import "MBProgressHUD.h"

@interface PersonalPublicTaskDetailViewController ()

@end

@implementation PersonalPublicTaskDetailViewController

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

    
    // デリゲートを取得
    delegate = [UIApplication sharedApplication].delegate;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // タブバーデリゲートの設定
    //self.tabBarController.delegate = self;
    
    // アラートを表示していない状態に設定
    showingAlert = NO;
    
    // データを表示
    [self setShowingTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// **************************************
//          ビューが切り替わった時
// **************************************
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    NSLog(@"switched");
//}

#pragma mark - Table view data source


// ****************************************
//          セクション数を返す
// ****************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS_IN_PPTDVIEW;
}


// ****************************************
//              セクションごとの行数
// ****************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case SECTION_USER_PPTD:
            
            return NUM_CELLS_IN_USER;
            
        case SECTION_TASK_PPTD:
            
            return NUM_CELLS_IN_TASK_PPTD;
            
        default:
            
            return 0;
            
    }
}

// ****************************************
//          セルの選択時イベント
// ****************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// ****************************************
//          表示する情報を設定
// ****************************************
- (void)setShowingTask
{
    // *** ユーザー情報を設定 ***
    // 画像
    [self.userImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.userData objectForKey:USER_PROP_PHOTO]]]]];
    // 名前
    [self.userName setText:[self.userData objectForKey:USER_PROP_NAME]];
    
    // *** タスク情報を設定 ***
    // タイトル
    [self.taskTitle setText:[self.taskData objectForKey:TASK_TITLE]];
    // 期限
    [self.taskLimit setText:([[self.taskData objectForKey:TASK_LIMIT] isEqualToString:@"none"])? @"期限指定なし":[self.taskData objectForKey:TASK_LIMIT]];
    // メモ
    [self.taskMemo setText:[self.taskData objectForKey:TASK_MEMO]];
    
}

// ****************************************
//          アラートをタップしたイベント
// ****************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!showingAlert)
        return ;
    
    if (buttonIndex == 1) {
        
        showingAlert = NO;
        
        // はい
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"このタスクをアシストしました" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
        
        // サーバーにアシストした情報を伝える
        if ([self sendAssistRequest:[self.taskData objectForKey:TASK_ID] userId:[self.userData objectForKey:@"userId"]]) {
            
            // ローカルデータにも反映
            NSString *assist = [self.userData objectForKey:@"assist"];
            assist = [assist stringByAppendingString:[NSString stringWithFormat:@"%@:", [self.taskData objectForKey:TASK_ID]]];
            [self.userData setValue:assist forKey:@"assist"];
            delegate.user = [NSMutableDictionary dictionaryWithDictionary:self.userData];
            
            // アシストしたタスクを一時保存
            [delegate.assistingTask addObject:self.taskData];
            [delegate.assistingUser addObject:self.userData];
            delegate.hasAssisted = YES;
            
        }
    }
}


// **************************************
//          アシストリクエストを送信
// **************************************
- (BOOL)sendAssistRequest:(NSString *)taskId userId:(NSString *)userId
{
    __block BOOL result = YES;
    
    // *** ダイアログを表示 ***
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    [progress setLabelText:@"アシスト中..."];
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSURLRequest *request = [self createAssistRequest:taskId userId:userId];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // *** ダイアログを隠す ***
        [progress show:NO];
        [progress removeFromSuperview];
        
        // *** レスポンスをチェック ***
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"assist: %@", response);
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"アシストに失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
            return ;
        }
        
        // *** ローカルのユーザーアシスト情報を更新 ***
        NSString *assist = [delegate.user objectForKey:USER_PROP_ASSIST];
        assist = [assist stringByAppendingString:[NSString stringWithFormat:@"%@:", taskId]];
        [delegate.user setValue:assist forKey:USER_PROP_ASSIST];
        
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
    
    return YES;
}

// **************************************
//          アシストリクエストを作成
// **************************************
- (NSURLRequest *)createAssistRequest:(NSString *)taskId userId:(NSString *)userId
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:ASSIST_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"taskId=%@&userId=%@", [self.taskData objectForKey:TASK_ID], [self.userData objectForKey:USER_PROP_ID]];
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


// ****************************************
//              一つ前のビューに戻る
// ****************************************
- (IBAction)gobackToPrevView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// ****************************************
//          タスクをアシストする
// ****************************************
- (IBAction)addAssistingTask:(id)sender {
    
    // すでにアシストしていないか検査
    NSString *taskId = [self.taskData objectForKey:TASK_ID];
    NSString *assist = [delegate.user objectForKey:@"assist"];
    
    NSRange range = [assist rangeOfString:taskId];
    if (range.location != NSNotFound) {
        showingAlert = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"すでにアシストしています" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        showingAlert = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"このタスクをアシストしますか" delegate:self cancelButtonTitle:@"やめる" otherButtonTitles:@"はい", nil];
        [alert show];
    }
    
}
@end
