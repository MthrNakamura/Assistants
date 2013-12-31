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

@interface AssistingTaskViewController ()

@end

@implementation AssistingTaskViewController

@synthesize users;
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
    
    // テーブルの編集モード
    showingAlert = NO;
    
    // テーブルのデリゲートを設定
    self.tableView.delegate = self;
    
    // ユーザ情報格納配列
    self.users = [[NSMutableArray alloc]init];
    
    // アシスト中のタスクリストを取得
    if (![self getAssistingTaskList]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"リスト取得" message:@"アシスト中タスクのリストの取得に失敗しました。接続状況の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self createTableFromList];
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
    // Return the number of rows in the section.
    return [self.tasks count];
}


// *************************************
//               セルを返す
// *************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssistingTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ASSISTING_CELL_ID forIndexPath:indexPath];
    
    // ユーザーのプロフィール画像を設定
    [cell.userImage setImage:[UIImage imageNamed:[tempData objectForKey:@"imageUrl"]]];
    [cell.userImage sizeThatFits:CGSizeMake(100, 100)];
    // ユーザー名を設定
    cell.userName.text = [tempData objectForKey:@"name"];
    // タスクタイトルを設定
    cell.taskTitle.text = [[self.tasks objectAtIndex:indexPath.row] objectForKey:KEY_TITLE];
    
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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト中止" message:@"アシストを中止しました" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
        
        // サーバーにタスクの削除リクエストを送信
        
        
        // テーブルからデータを削除
        [self.users removeObjectAtIndex:deletingPath.row];
        [self.tasks removeObjectAtIndex:deletingPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletingPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    // 編集モードを終了
    [self.tableView setEditing:NO animated:YES];
    [self.btnEdit setTitle:@"編集"];
}

// *************************************
//       アシスト中タスクのリストを取得
// *************************************
- (BOOL)getAssistingTaskList
{
    // サーバーからアシスト中のタスクのリストを取得
    NSString *publicList = @"[{\"userid\":\"1\", \"taskId\":\"1\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"2\", \"taskId\":\"2\", \"title\":\"task2\", \"limit\": \"2014年1月13日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"3\", \"taskId\":\"3\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"4\", \"taskId\":\"4\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"5\", \"taskId\":\"5\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]}]";
    
    // *** リストからタスクオブジェクトを生成 ***
    NSData *taskData = [publicList dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableArray *t = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:taskData options:NSJSONReadingAllowFragments error:&error];
    self.tasks = [[NSMutableArray alloc]initWithArray:t];
    
    return YES;
}

// **************************************
//      テーブルに表示するタスク一覧を形成
// **************************************
- (void)createTableFromList
{
    NSInteger numTasks = [self.tasks count];
    for (int i = 0; i < numTasks; i++) {
        NSDictionary *task = [self.tasks objectAtIndex:i];
        [self.tableView beginUpdates];
        
        // ユーザ情報を取得
        tempData = [self getUserDataFromUserId:[task objectForKey:KEY_USER_ID]];
        [self.users insertObject:tempData atIndex:i];
        
        [self.tableView endUpdates];
    }
}


// **************************************
//      ユーザーIDを基にユーザ情報を取得
// **************************************
- (NSDictionary *)getUserDataFromUserId:(NSString *)userId
{
    
    // サーバーからユーザ情報を取得
    NSString *userJSONString = @"{\"name\":\"John\", \"imageUrl\":\"icon_default_user.png\", \"skill\":[\"javascript\", \"css\", \"HTML\"], \"detail\":\"hello every one\", \"tasks\":[\"1\", \"3\", \"5\"]}";
    NSData *data = [userJSONString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}


// **************************************
//          画面遷移時イベント
// **************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 公開タスク詳細ビュー
    if ([[segue identifier] isEqualToString:@"OpenDetailSegue2"]) {
        // 選択したタスクのインデックスを取得
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // 詳細を表示するタスクの情報を渡す
        OpenTaskDetailViewController *openTaskView = (OpenTaskDetailViewController *)[segue destinationViewController];
        openTaskView.taskData = [self.tasks objectAtIndex:indexPath.row];
        openTaskView.userData = [self.users objectAtIndex:indexPath.row];
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
@end
