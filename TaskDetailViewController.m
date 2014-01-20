//
//  TaskDetailViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/27.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TopViewController.h"
#import "AssistantsViewController.h"

#import "AsyncURLConnection.h"

#import "MBProgressHUD.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

@synthesize taskData;
@synthesize taskIndex;

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

    // delegateを取得
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // DatePickerを閉じる
    isOpenedDatePicker = NO;
    
    // タブバーデリゲートの設定
    //self.tabBarController.delegate = self;
    
    // タイトルを設定
    self.navigationItem.title = [self.taskData objectForKey:TASK_TITLE];
    
    // 期限を設定
    self.dateLabel.text = ([[taskData objectForKey:TASK_LIMIT] isEqualToString:@"none"])? @"期限指定なし":(NSString *)[taskData objectForKey:TASK_LIMIT];
    
    // メモを設定
    self.memoField.text = [taskData objectForKey:TASK_MEMO];
    self.memoField.delegate = self;
    // メモの編集完了ボタンを無効化
    self.btnDoneEditting.title = @"";
    [self.btnDoneEditting setEnabled:NO];
    editingMemo = NO;
    
    
    // 公開設定
    if ([[taskData objectForKey:TASK_PUBLIC] boolValue]) {
        self.publicLabel.text = @"公開";
        [self.assistantsBtn setEnabled:YES];
        [self.assistantsBtn setHidden:NO];
    }
    else {
        self.publicLabel.text = @"非公開";
        [self.assistantsBtn setEnabled:NO];
        [self.assistantsBtn setHidden:YES];
    }
    
    showingAlert = NO;
    
    // 編集されたかどうか
    isEdited = NO;
    // 右上の保存ボタンを無効化
//    self.saveBtn.title = @"";
//    [self.saveBtn setEnabled:NO];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS;
}



// ************************************
//          セルを選択した
// ************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"公開設定" message:@"タスクを非公開に設定しますか" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    
    switch (indexPath.section) {
        case SECTION_DATE: // 期日セクション
            
            [self.tableView beginUpdates];
            isOpenedDatePicker = !isOpenedDatePicker;
            [self.tableView endUpdates];
            
            break;
            
        case SECTION_PUBLIC: // 公開セクション
            
            if (![[self.taskData objectForKey:TASK_PUBLIC]boolValue]) {
                [alert setMessage:@"タスクを公開に設定しますか"];
            }
            showingAlert = YES;
            [alert show];
            
            break;
            
        case SECTION_MEMO: // メモセクション
            
            break;
            
        default:
            
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// ************************************
//         セクションごとの行数を返す
// ************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_DATE: // 期日セクション
            
            return NUM_ROWS_IN_DATE_SECTION;
            
        case SECTION_PUBLIC: // 公開セクション
            
            return NUM_ROWS_IN_PUBLIC_SECTION;
            
        case SECTION_MEMO: // メモセクション
            
            return NUM_ROWS_IN_MEMO_SECTION;
            
        default:
            
            return 0;
    }
}


// ************************************
//          セルの高さを返す
// ************************************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case SECTION_DATE:     // 期限セクション
            
            if (indexPath.row == 0) {
                return DEFAULT_CELL_HEIGHT;
            }
            return (isOpenedDatePicker)? DATEPICKER_HEIGHT:0;
            
            
        case SECTION_PUBLIC:     // 公開設定セクション
            
            return DEFAULT_CELL_HEIGHT;
            
        case SECTION_MEMO:     // メモセクション
            
            return MEMO_CELL_HEIGHT;
            
        default:
            return 0;
    }
}

// ************************************
//          アラートをクリックした
// ************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (!showingAlert)
        return ;
    
    // はい
    if (buttonIndex == 1) {
        if ([[self.taskData objectForKey:TASK_PUBLIC] boolValue]) {
            // 公開の状態で「はい」→ 非公開
            // *** 表示を切り替え ***
            [self.taskData setValue:[NSNumber numberWithBool:NO] forKey:TASK_PUBLIC];
            self.publicLabel.text = @"非公開";
            [self.assistantsBtn setHidden:YES];
            [self.assistantsBtn setEnabled:NO];
            
            // 保存ボタンを表示
            isEdited = YES;
            [self.btnDoneEditting setTitle:@"保存"];
            [self.btnDoneEditting setEnabled:YES];
        }
        else {
            // 非公開の状態で「はい」→ 公開
            // *** 表示を切り替え ***
            [self.taskData setValue:[NSNumber numberWithBool:YES] forKey:TASK_PUBLIC];
            self.publicLabel.text = @"公開";
            [self.assistantsBtn setHidden:NO];
            [self.assistantsBtn setEnabled:YES];
            
            // 保存ボタンを表示
            isEdited = YES;
            [self.btnDoneEditting setTitle:@"保存"];
            [self.btnDoneEditting setEnabled:YES];
        }
    }
}


// ************************************
//          画面遷移イベント
// ************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // アシスタント一覧ビューへ遷移
    if ([[segue identifier] isEqualToString:@"AssistantsSegue"]) {
        
        // 一覧を表示するタスクの情報を渡す
        AssistantsViewController *assistantsView = (AssistantsViewController *)[segue destinationViewController];
        assistantsView.task = [delegate.tasks objectAtIndex:self.taskIndex];
        
    }

}




// ************************************
//          メモの編集を開始
// ************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    editingMemo = YES;
    [self.btnDoneEditting setTitle:@"完了"];
    [self.btnDoneEditting setEnabled:YES];
    return YES;
}


// ************************************
//          メモの編集を終了
// ************************************
- (IBAction)doneEditing:(id)sender {
    
    // メモの編集中だったらキーボードを閉じて完了ボタンを変更
    if (editingMemo) {
        // キーボードを閉じる
        [self.memoField resignFirstResponder];
        
        isEdited = YES;
        [self.btnDoneEditting setTitle:@"保存"];
        editingMemo = NO;
        
//        if (isEdited) {
//            [self.btnDoneEditting setTitle:@"保存"];
//        }
//        else {
//            // 完了ボタンを隠す
//            [self.btnDoneEditting setTitle:@""];
//            [self.btnDoneEditting setEnabled:NO];
//            editingMemo = NO;
//        }
    }
    else if (isEdited) {
        // 変更を保存
        NSMutableDictionary *tasks = [[delegate.tasks objectAtIndex:self.taskIndex] mutableCopy];
        [tasks setValue:self.dateLabel.text forKey:TASK_LIMIT];
        [tasks setValue:self.memoField.text forKey:TASK_MEMO];
        [tasks setValue:[self.taskData objectForKey:TASK_PUBLIC] forKey:TASK_PUBLIC];
        [delegate.tasks replaceObjectAtIndex:self.taskIndex withObject:tasks];
        
        if ([self sendChange:tasks]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"変更の保存" message:@"変更を保存しました。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}

// ************************************
//          期限をピッカーで選択した
// ************************************
- (IBAction)didSelectedLimitDate:(id)sender {
    
    // 保存ボタンを有効化
    isEdited = YES;
    self.btnDoneEditting.title = @"保存";
    [self.btnDoneEditting setEnabled:YES];
    
    // 選択した日付を取得
    NSDate *limitDate = [self.datePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd/ HH:mm"];
    
    // 選択した日付を設定
    self.dateLabel.text = [df stringFromDate:limitDate];
    
}


// ************************************
//          TopViewに戻る
// ************************************
- (IBAction)gobackToTopView:(id)sender
{
    // *** タスクの変更内容を保存 ***
    NSLog(@"%@", self.taskData);
    NSMutableDictionary *tasks = [[delegate.tasks objectAtIndex:self.taskIndex] mutableCopy];
    [tasks setValue:self.dateLabel.text forKey:TASK_LIMIT];
    [tasks setValue:self.memoField.text forKey:TASK_MEMO];
    [tasks setValue:[self.taskData objectForKey:TASK_PUBLIC] forKey:TASK_PUBLIC];
    [delegate.tasks replaceObjectAtIndex:self.taskIndex withObject:tasks];
    
    
    // *** サーバーに変更内容を送信 ***
    if ([self sendChange:tasks]) {
        // TopViewに戻る
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


// ************************************
//         変更内容を送信
// ************************************
- (BOOL)sendChange:(NSMutableDictionary *)task
{
    __block BOOL result = YES;
    
    // プログレスバーを表示
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    progress.labelText = @"更新中...";
    [self.view addSubview:progress];
    [progress show:YES];

    
    NSURLRequest *request = [self createChangeRequest:task];
    
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // プログレスバーを隠す
        [progress show:NO];
        [progress removeFromSuperview];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク更新" message:@"タスクの更新に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
        }
        NSLog(@"%@", response);
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
    
        // プログレスバーを隠す
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


// ************************************
//       タスク変更のリクエストを作成
// ************************************
- (NSURLRequest *)createChangeRequest:(NSMutableDictionary *)task
{
    
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:UPDATE_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"time=%@&memo=%@&open=%@&taskId=%@", [task objectForKey:TASK_LIMIT], [task objectForKey:TASK_MEMO], [task objectForKey:TASK_PUBLIC], [task objectForKey:TASK_ID]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

@end
