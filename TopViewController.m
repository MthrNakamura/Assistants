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
    delegate = [UIApplication sharedApplication].delegate;
    
    
    // タスク一覧のテーブルtaskTableの設定
    self.taskTable.delegate = self;
    self.taskTable.dataSource = self;
    self.taskTable.backgroundColor = [UIColor clearColor];
    
    // タスクリストの取得
    [self getTasks];
    
    // 新規タスク入力中のフラグ
    isEditing = NO;
    
    
    //[[[self navigationController] navigationBar] setBackgroundColor:[UIColor colorWithRed:0.40 green:0.78 blue:0.98 alpha:1.0]];
}

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
    return delegate.numTasks;
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

        // テーブルからデータを削除
        [delegate.tasks removeObjectAtIndex:indexPath.row];
        delegate.numTasks--;
        [self.taskTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 編集モードを終了
        [self.taskTable setEditing:NO animated:YES];
        [self.btnEdit setTitle:@"編集"];
    }
}


// **************************************
//          サーバーからタスクを受信
// **************************************
- (BOOL)getTasks
{
    // サーバーと非同期通信によってタスクリストを取得
    delegate.numTasks = 0;
    delegate.tasks = [[NSMutableArray alloc]init];
    
    return YES;
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
    
    
    // *** DBに登録 ***
    /*
    NSString *query = [NSString stringWithFormat:@"INSERT INTO task VALUES(%@)", taskTitle];
    [delegate.db open];
    [delegate.db executeUpdate:query];
    [delegate.db close];
    */

    // *** 新規タスクをテーブルに追加 ***
    [self.taskTable beginUpdates];
    
    // タスクに関するデータを設定
    NSMutableDictionary *task = [NSMutableDictionary dictionaryWithObjectsAndKeys:taskTitle, TASK_TITLE, @"期限指定なし", TASK_LIMIT, @"", TASK_MEMO, [NSNumber numberWithBool:YES], TASK_PUBLIC, [NSNumber numberWithInt:0], NUM_ASSISTANTS, nil];
    [delegate.tasks addObject:task];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    delegate.numTasks++;
    [self.taskTable insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.taskTable endUpdates];
    [self.taskTable reloadData];
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
    // 選択したタスクのタイトルを取得。次の画面に渡すために使用
    self.taskData = [delegate.tasks objectAtIndex:indexPath.row];
    
    
    // *** 詳細画面に情報を渡す ***
    taskDetailView.taskData = self.taskData;//[NSDictionary dictionaryWithDictionary:passingTaskData];
    taskDetailView.taskIndex = indexPath.row;
}

@end
