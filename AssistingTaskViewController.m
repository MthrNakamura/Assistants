//
//  AssistingTaskViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "AssistingTaskViewController.h"
#import "AssistingTaskCell.h"
#import "PublicTasksViewController.h"
#import "OpenTaskDetailViewController.h"

#import "TopViewController.h"
#import "AsyncURLConnection.h"

#import "MBProgressHUD.h"


@interface AssistingTaskViewController ()

@end

@implementation AssistingTaskViewController

@synthesize tasks;



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
    [refresh addTarget:self action:@selector(updateTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];

    
    delegate = [UIApplication sharedApplication].delegate;
    
    // テーブルの編集モード
    showingAlert = NO;
    
    // テーブルのデリゲートを設定
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // テーブルビューの背景を設定
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.jpg"]];
    
    // ユーザ情報格納配列
    self.tasks = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
//    [progress setLabelText:@"読み込み中"];
//    [self.view addSubview:progress];
//    [progress show:YES];
    
    // アシスト中のタスクリストを取得
    if (![self getAssistingTaskList]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"リスト取得" message:@"アシスト中タスクのリストの取得に失敗しました。接続状況の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }

//    [progress show:NO];
//    [progress removeFromSuperview];
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
////    
//}


// *************************************
//          タスクリストを更新
// *************************************
- (void)updateTasks
{
    [refresh beginRefreshing];
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"更新中...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    // アシスト中のタスクリストを取得
    if (![self getAssistingTaskList]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"リスト取得" message:@"アシスト中タスクのリストの取得に失敗しました。接続状況の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.tableView reloadData];
    
    [progress show:NO];
    [progress removeFromSuperview];
    
    [refresh endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


// *************************************
//          セクション数を返す
// *************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS_IN_ASSISTING_TASK;
}

// *************************************
//          セクションごとの行数
// *************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tasks count];
}


// *************************************
//               セルを返す
// *************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssistingTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ASSISTING_CELL_ID forIndexPath:indexPath];
    
    // ユーザー情報
    NSDictionary *userInfo = [[self.tasks objectAtIndex:indexPath.row] objectForKey:@"user"];
    NSLog(@"%@", userInfo);
    NSLog(@"count: %d", [self.tasks count]);
    // タスク情報
    NSDictionary *taskInfo = [[self.tasks objectAtIndex:indexPath.row] objectForKey:@"task"];
    
    // ユーザーのプロフィール画像を設定
    [cell.userImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo objectForKey:USER_PROP_PHOTO]]]]];
    [cell.userImage sizeThatFits:CGSizeMake(100, 100)];
    // ユーザー名を設定
    cell.userName.text = [userInfo objectForKey:USER_PROP_NAME];
    // タスクタイトルを設定
    cell.taskTitle.text = [taskInfo objectForKey:TASK_TITLE];
    
    return cell;
}


// *************************************
//              セルの高さを返す
// *************************************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSISTING_CELL_HEIGHT;
}


// *************************************
//          セル選択時イベント
// *************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.tasks count] && [self.tasks objectAtIndex:indexPath.row]) {
        // 詳細を表示するタスクの情報を渡す
        OpenTaskDetailViewController *openTaskView = [self.storyboard instantiateViewControllerWithIdentifier:@"OpenTaskDetailView"];
        openTaskView.taskData = [[self.tasks objectAtIndex:indexPath.row] objectForKey:@"task"];
        openTaskView.userData = [[self.tasks objectAtIndex:indexPath.row] objectForKey:@"user"];
        [self.navigationController pushViewController:openTaskView animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク詳細" message:@"このタスクは既に完了したか、削除されています。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
        [self.tableView reloadData];
    }
    
}

// **************************************
//          セル削除時イベント
// **************************************
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // *** セル削除 ***
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        showingAlert = YES;
        deletingPath = indexPath;

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト中止" message:@"このタスクのアシストを中止しますか" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }
}

// *************************************
//          アラートタップ時イベント
// *************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!showingAlert)
        return ;
    
    showingAlert = NO;
    
    // タスクのアシストを中止
    if (buttonIndex == 1) {
        
        showingAlert = NO;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト中止" message:@"アシストを中止しました" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
        
        // *** サーバーにタスクの削除リクエストを送信 ***
        NSDictionary *infoSet = [self.tasks objectAtIndex:deletingPath.row];
        if (![self sendUnAssistRequest:[[infoSet objectForKey:@"task"] objectForKey:TASK_ID] userId:[[infoSet objectForKey:@"user"] objectForKey:USER_PROP_ID]]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト中止" message:@"アシストの中止に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            
            return ;
        }
        
        
        // ユーザー情報からタスク情報を消す
        NSDictionary *task = [[self.tasks objectAtIndex:deletingPath.row] objectForKey:@"task"];
        NSString *taskId = [task objectForKey:TASK_ID];
        NSString *newAssist = [[delegate.user objectForKey:USER_PROP_ASSIST] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@:", taskId] withString:@""];
        [delegate.user setValue:newAssist forKey:USER_PROP_ASSIST];
        
        // テーブルからデータを削除
        [self.tasks removeObjectAtIndex:deletingPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletingPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    // 編集モードを終了
    [self.tableView setEditing:NO animated:YES];
    [self.btnEdit setTitle:@"編集"];
}

// *************************************
//       アシスト中止リスエストを送信
// *************************************
- (BOOL)sendUnAssistRequest:(NSString *)taskId userId:(NSString *)userId
{
    
    __block BOOL result = YES;

    // ダイアログを表示
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"取得中...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSURLRequest *request = [self createUnAssistRequest:taskId userId:userId];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // ダイアログを隠す
        [progress show:NO];
        [progress removeFromSuperview];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
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
        result = NO;
    }];
    
    
    [conn performRequest];
    [conn join];
    
    return result;
}

// *************************************
//       アシスト中止リスエストを作成
// *************************************
- (NSURLRequest *)createUnAssistRequest:(NSString *)taskId userId:(NSString *)userId
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:UNASSIST_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"taskId=%@&userId=%@", taskId,  userId];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

// *************************************
//       アシスト中タスクのリストを取得
// *************************************
- (BOOL)getAssistingTaskList
{

    if (![self sendAssistingTaskListRequest:[delegate.user objectForKey:USER_PROP_ASSIST]]) {
        return NO;
    }
    // *** 返ってきたタスクリストからローカルのアシスト情報を更新 ***
    NSString *assist = @"";
    NSUInteger numTasks = [self.tasks count];
    for (NSUInteger i = 0; i < numTasks; i++) {
        
        NSDictionary *task = [[self.tasks objectAtIndex:i] objectForKey:@"task"];
        assist = [assist stringByAppendingString:[task objectForKey:TASK_ID]];
        assist = [assist stringByAppendingString:@":"];
        
    }
    [delegate.user setValue:assist forKey:USER_PROP_ASSIST];
    
    
    return YES;
}


//**************************************
//     公開タスクリスト取得リスエストを送信
//**************************************
- (BOOL)sendAssistingTaskListRequest:(NSString *)assist
{
    __block BOOL result = YES;
    
    // *** ダイアログを表示 ***
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    [progress setLabelText:@"ロード中..."];
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSURLRequest *request = [self createAssistingTaskListRequest:assist];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // *** ダイアログを隠す ***
        [progress show:NO];
        [progress removeFromSuperview];
        
        NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        // *** レスポンスをチェック ***
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト中タスク" message:@"タスクの取得に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
            NSLog(@"error: %@", [response objectForKey:@"errorCode"]);
            return ;
        }
        
        // *** タスク情報 & ユーザー情報を取得 ***
        self.tasks = [NSMutableArray arrayWithArray:[response objectForKey:@"tasks"]];
        
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
        result = NO;
        
    }];
    
    
    [conn performRequest];
    [conn join];
    
    return result;
}

// **************************************
//     公開タスクリスト取得リスエストを作成
// **************************************
- (NSURLRequest *)createAssistingTaskListRequest:(NSString *)assist
{

    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:TASKINFO_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    NSString *body = [NSString stringWithFormat:@"assist=%@", assist];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return request;
}

// **************************************
//      テーブルに表示するタスク一覧を形成
// **************************************
//- (void)createTableFromList
//{
//    // プログレスバーを表示
//    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
//    progress.labelText = @"読み込み中";
//    [self.view addSubview:progress];
//    [progress show:YES];
//    
//    
//    
//    NSUInteger numAssistingTasks = [self.tasks count];
//    //delegate.numAssistingTasks = numAssistingTasks;
//    for (NSUInteger i = 0; i < numAssistingTasks; i++) {
//        NSDictionary *task = [self.tasks objectAtIndex:i];
//        
//        [self.tableView beginUpdates];
//        
//        
//        // ユーザ情報を取得
//        tempData = [NSMutableDictionary dictionaryWithDictionary:[self getUserDataFromUserId:[task objectForKey:KEY_USER_ID]]];
//        [self.users insertObject:tempData atIndex:i];
//        
//        
//        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//        
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationTop];
//        
//        [self.tableView endUpdates];
//        [self.tableView reloadData];
//        //numRows = i+1;
//        
//        
//    }
//    
//    
//        // プログレスバーを閉じる
//    [progress show:NO];
//    [progress removeFromSuperview];
//    progress = nil;
//
//}

// **************************************
//      テーブルに表示するタスク一覧を更新
// **************************************
//- (void)updateTableFromList
//{
//    NSUInteger numAssistingTasks = [self.tasks count];
//    //delegate.numAssistingTasks = numAssistingTasks;
//    for (NSUInteger i = 0; i < numAssistingTasks; i++) {
//        NSDictionary *task = [self.tasks objectAtIndex:i];
//        
//        [self.tableView beginUpdates];
//        
//        
//        // ユーザ情報を取得
//        tempData = [NSMutableDictionary dictionaryWithDictionary:[self getUserDataFromUserId:[task objectForKey:KEY_USER_ID]]];
//        [self.users insertObject:tempData atIndex:i];
//        
//        
//        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationTop];
//        
//        [self.tableView endUpdates];
//        [self.tableView reloadData];
//        //numRows = i+1;
//    }
//    //delegate.numAssistingTasks = 0;
//}

// **************************************
//      ユーザーIDを基にユーザ情報を取得
// **************************************
- (NSDictionary *)getUserDataFromUserId:(NSString *)userId
{
    // サーバーからユーザ情報を取得
    NSString *userJSONString = [self sendUserInfoRequest:userId];
    NSData *data = [userJSONString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}


// **************************************
//       ユーザー情報取得リスエストを送信
// **************************************
- (NSString *)sendUserInfoRequest:(NSString *)userId
{
    __block NSString *userInfoStr = @"[]";
    
    NSURLRequest *request = [self createUserInfoRequest:userId];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        userInfoStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"ユーザー情報の取得に失敗しました。再度お確かめください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
    [conn performRequest];
    [conn join];
    
    return userInfoStr;
}


// **************************************
//       ユーザー情報取得リスエストを作成
// **************************************
- (NSURLRequest *)createUserInfoRequest:(NSString *)userId
{
    
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:UINFO_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"userId=%@", userId];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

// **************************************
//          画面遷移時イベント
// **************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 選択したタスクのインデックスを取得
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    NSLog(@"%@", self.tasks);
    if (indexPath.row < [self.tasks count] && [self.tasks objectAtIndex:indexPath.row]) {
        // 詳細を表示するタスクの情報を渡す
        OpenTaskDetailViewController *openTaskView = [[OpenTaskDetailViewController alloc]init];
        openTaskView.taskData = [[self.tasks objectAtIndex:indexPath.row] objectForKey:@"task"];
        openTaskView.userData = [[self.tasks objectAtIndex:indexPath.row] objectForKey:@"user"];
        [self.navigationController pushViewController:openTaskView animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク詳細" message:@"このタスクは既に完了したか、削除されています。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
        
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


// **************************************
//              編集モードに移行
// **************************************
- (IBAction)startEditing:(id)sender {
    
    // 編集モードに移行
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        // 編集ボタンを完了ボタンに変更
        [self.btnEdit setTitle:@"完了"];
    }
    else {
        // 完了ボタンを編集ボタンに変更
        [self.btnEdit setTitle:@"編集"];
    }
    
}

- (IBAction)realodTasks:(id)sender {
    [self updateTasks];
}
@end
