//
//  PublicTasksViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "PublicTasksViewController.h"
#import "PublicTaskCell.h"
#import "OpenTaskDetailViewController.h"
#import "TopViewController.h"
#import "AppDelegate.h"
#import "AsyncURLConnection.h"

#import "MBProgressHUD.h"

@interface PublicTasksViewController ()

@end

@implementation PublicTasksViewController

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
    
    
    // 下に引っ張って更新するためのコントロール
    refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(updatePublicTask) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    // テーブルビューの背景を設定
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.jpg"]];
    
    if (![self getPublicTaskList]) {
        // リストの取得に失敗
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"リスト取得エラー" message:@"公開タスク一覧の取得に失敗しました。ネットワーク環境の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//
//// **************************************
////          ビューが切り替わった時
//// **************************************
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if (viewController == self)
//        [self updatePublicTask];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


// **************************************
//          セクション数を返す
// **************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// **************************************
//          セクション毎の行数
// **************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (publicTasks) {
        return [publicTasks count];
    }
    return 0;
}


// **************************************
//              セルを返す
// **************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PublicTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:PUBLIC_TASK_CELL_ID forIndexPath:indexPath];
    
    // セルに表示するデータセット
    NSDictionary *infoSet = [publicTasks objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [infoSet objectForKey:@"user"];
    NSDictionary *taskInfo = [infoSet objectForKey:@"task"];
    
    // 画像をセット
    [cell.userImage setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo objectForKey:USER_PROP_PHOTO]]]]];
    // ユーザーのプロフィール画像を設定
    //NSLog(@"data: %@", tempData);
    //NSLog(@"url: %@", [tempData objectForKey:@"imageUrl"]);
    //[cell.userImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tempData objectForKey:@"imageUrl"]]]]];
    [cell.userImage sizeThatFits:CGSizeMake(100, 100)];
    // ユーザー名を設定
    cell.userName.text = [userInfo objectForKey:USER_PROP_NAME];
    // タスクタイトルを設定
    cell.taskTitle.text = [taskInfo objectForKey:TASK_TITLE];
    
    return cell;
}


// **************************************
//           セルの高さを返す
// **************************************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PUBLIC_CELL_HEIGHT;
}


// **************************************
//      テーブルに表示するタスク一覧を形成
// **************************************
//- (void)createTableFromList
//{
//    for (int i = 0; i < [publicTasks count]; i++) {
//        NSMutableDictionary *task = [NSMutableDictionary dictionaryWithDictionary:[publicTasks objectAtIndex:i]];
//        [self.tableView beginUpdates];
//        
//        // ユーザ情報を取得
//        //NSLog(@"%@", task);
//        tempData = [NSMutableDictionary dictionaryWithDictionary:[self getUserDataFromUserId:[task objectForKey:KEY_USER_ID]]];
//        [userDatas insertObject:tempData atIndex:i];
//        
//        [self.tableView endUpdates];
//    }
//}

// **************************************
//          ユーザーの情報を取得
// **************************************
//- (NSDictionary *)getUserDataFromUserId:(NSString *)userId
//{
//    // *** サーバーにユーザー情報をリクエスト ***
//    NSString *userJSONString = [self sendUserInfoRequest:userId];
//    NSData *data = [userJSONString dataUsingEncoding:NSUTF8StringEncoding];
//    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//}


// **************************************
//          一覧を更新
// **************************************
- (void)updatePublicTask
{
    [refresh beginRefreshing];
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    [progress setLabelText:@"更新中..."];
    [self.view addSubview:progress];
    [progress show:YES];
    
    // *** 最新の公開タスクリストを取得 ***
    if (![self getPublicTaskList]) {
        // リストの取得に失敗
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"リスト取得エラー" message:@"公開タスク一覧の取得に失敗しました。ネットワーク環境の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    // *** テーブルを更新 ***
    [self.tableView reloadData];
    
    [progress show:NO];
    [progress removeFromSuperview];
    [refresh endRefreshing];
}


- (IBAction)updatePublickTaskList:(id)sender {
    
    [self updatePublicTask];
    
    
}

// **************************************
//       ユーザー情報取得リスエストを送信
// **************************************
//- (NSString *)sendUserInfoRequest:(NSString *)userId
//{
//    __block NSString *userInfoStr = @"[]";
//    
//    NSURLRequest *request = [self createUserInfoRequest:userId];
//    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
//        
//        userInfoStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", userInfoStr);
//        NSMutableDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        [userProfiles setObject:userInfo forKey:userId];
//        
//        
//    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"ユーザー情報の取得に失敗しました。再度お確かめください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
//    
//    
//    [conn performRequest];
//    [conn join];
//    
//    return userInfoStr;
//}


// **************************************
//       ユーザー情報取得リスエストを作成
// **************************************
//- (NSURLRequest *)createUserInfoRequest:(NSString *)userId
//{
//    
//    // リクエストURLを設定
//    NSURL *url = [[NSURL alloc]initWithString:UINFO_API];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    
//    // メソッドを設定
//    [request setHTTPMethod:@"POST"];
//    
//    // パラメータを設定
//    NSString *body = [NSString stringWithFormat:@"userId=%@", userId];
//    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return request;
//    
//}


// **************************************
//     公開タスクのリストをサーバーから取得
// **************************************
- (BOOL)getPublicTaskList
{
    // *** サーバーからリストを取得 ***
    if (![self sendPublicTaskListRequest]) {
        return NO;
    }
    
    return YES;
}


// **************************************
//     公開タスクリスト取得リスエストを送信
// **************************************
- (BOOL)sendPublicTaskListRequest
{
    // ダイアログを表示
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"取得中...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    
    __block BOOL result = YES;
    
    NSURLRequest *request = [self createPublicTaskListRequest];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // ダイアログを隠す
        [progress show:NO];
        [progress removeFromSuperview];
        
        NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        // タスクリストを取得
        publicTasks = [NSMutableArray arrayWithArray:[response objectForKey:@"tasks"]];
        
        // エラーチェック
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            result = NO;
        }
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
        // ダイアログを隠す
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
    NSURL *url = [[NSURL alloc]initWithString:PLIST_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"GET"];
    
    
    return request;
}


// **************************************
//          アラートタップ時イベント
// **************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // アラートを閉じた後は何もしない
        ;
    }
}

// **************************************
//          画面遷移時イベント
// **************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 公開タスク詳細ビュー
    if ([[segue identifier] isEqualToString:@"OpenDetailSegue"]) {
        // 選択したタスクのインデックスを取得
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // 詳細を表示するタスクの情報を渡す
        OpenTaskDetailViewController *openTaskView = (OpenTaskDetailViewController *)[segue destinationViewController];
        NSLog(@"%@", [publicTasks objectAtIndex:indexPath.row]);
        
        openTaskView.taskData = [NSMutableDictionary dictionaryWithDictionary:[[publicTasks objectAtIndex:indexPath.row] objectForKey:@"task"]];
        openTaskView.userData = [NSMutableDictionary dictionaryWithDictionary:[[publicTasks objectAtIndex:indexPath.row] objectForKey:@"user"]];
    }
}


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

@end
