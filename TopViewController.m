//
//  TopViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/21.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "TopViewController.h"
#import "TaskCell.h"
#import "TaskDetailViewController.h"

#import "AsyncURLConnection.h"

#import "MBProgressHUD.h"

@interface TopViewController ()

@end

@implementation TopViewController

@synthesize taskData;

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
    
    // delegateの取得
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // タブバーデリゲートの設定
    //self.tabBarController.delegate = self;
    
    // タスク一覧のテーブルtaskTableの設定
    self.taskTable.delegate = self;
    self.taskTable.dataSource = self;
    self.taskTable.backgroundColor = [UIColor clearColor];
    
    // タスクリストの取得
    if (![self getMyTaskList]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク一覧の取得" message:@"タスク一覧の取得に失敗しました。アプリを終了して再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    // 新規タスク入力中のフラグ
    isEditing = NO;
    
    // セルのチェックマークをチェックしたときのイベント
    
    //[[[self navigationController] navigationBar] setBackgroundColor:[UIColor colorWithRed:0.40 green:0.78 blue:0.98 alpha:1.0]];
}


// **************************************
//          ビューが切り替わった時
// **************************************
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// **************************************
//          現在の行の数(タスク数)を返す
// **************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [delegate.tasks count];
}

// **************************************
//          セクション数
// **************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// **************************************
//          テーブルのセルを返す
// **************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    cell.taskTitle.text = [[delegate.tasks objectAtIndex:indexPath.row] objectForKey:TASK_TITLE];
    
    [cell.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    
    return cell;
}




// **************************************
//          セル選択時イベント
// **************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.taskTable deselectRowAtIndexPath:indexPath animated:YES];
}

// **************************************
//          セル削除時イベント
// **************************************
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // *** セル削除 ***
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // サーバーにタスクの削除リクエストを送信
        if ([self sendDeleteTask:[delegate.tasks objectAtIndex:indexPath.row]]) {
            // テーブルからデータを削除
            [delegate.tasks removeObjectAtIndex:indexPath.row];
            [self.taskTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        // 編集モードを終了
        [self.taskTable setEditing:NO animated:YES];
        [self.btnEdit setTitle:@"編集"];
    }
}

// **************************************
//          セルをアップデート
// **************************************
- (void)updateTaskCells
{
    
    [self.taskTable beginUpdates];
    
    [self.taskTable endUpdates];
}

// **************************************
//          タスク情報を取得
// **************************************
- (BOOL)getTasks
{
    
    
    return YES;
}


// **************************************
//          自身のタスクリストを取得
// **************************************
- (BOOL)getMyTaskList
{
    
    __block BOOL result = YES;
    
    // *** プログレスバーを作成・表示 ***
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"リスト取得中";
    [self.view addSubview:progress];
    [progress show:YES];

    // *** リクエストの作成 ***
    NSURLRequest *request = [self createTaskListRequest:[delegate.user objectForKey:USER_PROP_ID]];
    
    
    // *** リクエストの送信 ***
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // プログレスバーを隠す
        [progress show:NO];
        [progress removeFromSuperview];
        
        // *** 通信成功時 ***
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        // タスクリストを取得
        delegate.tasks = [NSMutableArray arrayWithArray:[response objectForKey:@"task"]];
        
        // エラーチェック
        if (![[response objectForKey:@"errorCode"] isEqualToString:NO_ERROR]) {

            result = NO;
            
        }
        
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
        
        // プログレスバーを隠す
        [progress show:NO];
        [progress removeFromSuperview];
        
        // タイムアウトが発生
        if ( error.code==NSURLErrorTimedOut ) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスクリスト取得" message:@"タイムアウトが発生しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
        }
        // 通信エラー
        else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスクリスト取得" message:@"タイムアウトが発生しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        
        result = NO;
        
    }];
    
    
    [conn performRequest];
    [conn join];
    
    return result;
}


// **************************************
//       タスクリスト取得リクエストを作成
// **************************************
- (NSURLRequest *)createTaskListRequest:(NSString *)userId
{
    
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:MYLIST_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"userId=%@", [delegate.user objectForKey:USER_PROP_ID]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}



// **************************************
//     タスクを公開: 新規アシスタントを追加
// **************************************
- (void)addNewAssistants
{
    // *** サーバーにタスクの公開リクエストを送信 ***
    
    // リクエストの作成
    
    // リクエストの非同期送信
}


// **************************************
//          新規タスクの追加
// **************************************
- (void)appendNewTask:(NSString *)taskTitle
{
    // *** 編集モードであれば編集モードを終了 ***
    if (self.taskTable.editing) {
        [self.taskTable setEditing:NO animated:YES];
        [self.btnEdit setTitle:@"編集"];
    }

    // *** 新規タスクをテーブルに追加 ***
    [self.taskTable beginUpdates];
    
    // *** タスクに関するデータを設定 ***
    
    // タスクID
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyMMddHHmmss"];
    NSString *currentDate = [df stringFromDate:[NSDate date]];
    NSString *taskId = [NSString stringWithFormat:@"%@_%@", [delegate.user objectForKey:USER_PROP_ID], currentDate];

    NSMutableDictionary *task = [NSMutableDictionary dictionaryWithObjectsAndKeys:taskTitle, TASK_TITLE, @"none", TASK_LIMIT, @"", TASK_MEMO, [NSNumber numberWithBool:YES], TASK_PUBLIC, taskId, TASK_ID, nil];

    [delegate.tasks addObject:task];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

    [self.taskTable insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationTop];

    [self.taskTable endUpdates];
    [self.taskTable reloadData];

    // *** サーバーに新規タスクを送信 ***
    [self sendNewTask:task];
    
}


// **************************************
//     サーバーにタスク削除リスエストを送信
// **************************************
- (BOOL)sendDeleteTask:(NSMutableDictionary *)task
{
    
    __block BOOL result = YES;
    
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"削除中...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSURLRequest *request = [self createDeleteRequest:task];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc] initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        [progress show:NO];
        [progress removeFromSuperview];
        
        NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク削除" message:@"タスクの削除に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
        }
        NSLog(@"%@", response);
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
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
//          タスク削除リスエストを送信
// **************************************
- (NSURLRequest *)createDeleteRequest:(NSMutableDictionary *)task
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:DELETE_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"taskId=%@", [task objectForKey:TASK_ID]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


// **************************************
//          サーバーに新規タスクを送信
// **************************************
- (BOOL)sendNewTask:(NSMutableDictionary *)task
{
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"追加中...";
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSURLRequest *request = [self createNewTaskRequest:task];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc] initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        [progress show:NO];
        [progress removeFromSuperview];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク追加" message:@"タスクの追加に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@"%@", response);
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
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
//     新規タスク登録のリクエストを作成
// **************************************
- (NSURLRequest *)createNewTaskRequest:(NSMutableDictionary *)task
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:ADDTASK_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"userId=%@&title=%@&taskId=%@", [delegate.user objectForKey:USER_PROP_ID],[task objectForKey:TASK_TITLE], [task objectForKey:TASK_ID]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


// **************************************
//          新規タスクの入力開始
// **************************************
- (IBAction)startEditing:(id)sender {
    // 編集ボタンを完了ボタンに変更
    [self.btnEdit setTitle:@"完了"];
    isEditing = YES;
}


// **************************************
//          新規タスクの入力完了
// **************************************
- (IBAction)finishEditting:(id)sender {
    
    if (isEditing) {
        // *** 編集中に完了を押した ***
        
        // キーボードを閉じる
        [self resignFirstResponder];
        
        // 完了ボタンを編集ボタンに戻す
        [self.btnEdit setTitle:@"編集"];
        
        // 新規タスクの追加
        if (![self.taskInputField.text isEqualToString:@""]) {
            [self appendNewTask:self.taskInputField.text];
            [self.taskInputField setText:@""];
        }
        isEditing = NO;
    }

    
}


// **************************************
//      編集 & 完了ボタン
// **************************************
- (IBAction)editAndDone:(id)sender {
    
    // 完了ボタンを押した
    if (isEditing) {
        // キーボードを閉じる
        [self.taskInputField resignFirstResponder];
        
        // 完了ボタンを編集ボタンに戻す
        [self.btnEdit setTitle:@"編集"];
        
        // 入力欄が空でなければ新規タスクを追加する
        if (![self.taskInputField.text isEqualToString:@""]) {
            // 新規タスクの追加
            [self appendNewTask:self.taskInputField.text];
            [self.taskInputField setText:@""];
        }
    }
    // 編集ボタンを押した
    else {
        // 編集モードに移行
        [self.taskTable setEditing:!self.taskTable.editing animated:YES];
        if (self.taskTable.editing) {
            // 編集ボタンを完了ボタンに変更
            [self.btnEdit setTitle:@"完了"];
        }
        else {
            // 完了ボタンを編集ボタンに変更
            [self.btnEdit setTitle:@"編集"];
        }
    }
}


// **************************************
//          画面遷移時イベント
// **************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    TaskDetailViewController *taskDetailView = (TaskDetailViewController *)[segue destinationViewController];
    
    // 選択したセルのパスを取得
    NSIndexPath *indexPath = [self.taskTable indexPathForSelectedRow];
    
    // 詳細画面に情報を渡す
    taskDetailView.taskData = [NSMutableDictionary dictionaryWithDictionary:[delegate.tasks objectAtIndex:indexPath.row]];
    taskDetailView.taskIndex = indexPath.row;
}



@end
