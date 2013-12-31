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
    
    if (![self getPublicTaskList]) {
        // リストの取得に失敗
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"リスト取得エラー" message:@"公開タスク一覧の取得に失敗しました。ネットワーク環境の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        // タスク一覧を表示する
        userDatas = [[NSMutableArray alloc]init];
        [self createTableFromList];
    }
}

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
    //[cell.userImage setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tempData objectForKey:@"imageUrl"]]]]];
    // ユーザーのプロフィール画像を設定
    [cell.userImage setImage:[UIImage imageNamed:[tempData objectForKey:@"imageUrl"]]];
    [cell.userImage sizeThatFits:CGSizeMake(100, 100)];
    // ユーザー名を設定
    cell.userName.text = [tempData objectForKey:@"name"];
    // タスクタイトルを設定
    cell.taskTitle.text = [[publicTasks objectAtIndex:indexPath.row] objectForKey:KEY_TITLE];
    
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
- (void)createTableFromList
{
    for (int i = 0; i < [publicTasks count]; i++) {
        NSDictionary *task = [publicTasks objectAtIndex:i];
        [self.tableView beginUpdates];
        
        // ユーザ情報を取得
        tempData = [self getUserDataFromUserId:[task objectForKey:KEY_USER_ID]];
        [userDatas insertObject:tempData atIndex:i];
        
        [self.tableView endUpdates];
    }
}

// **************************************
//          ユーザーの情報を取得
// **************************************
- (NSDictionary *)getUserDataFromUserId:(NSString *)userId
{
    NSString *userJSONString = @"{\"name\":\"John\", \"imageUrl\":\"icon_default_user.png\", \"skill\":[\"javascript\", \"css\", \"HTML\"], \"detail\":\"hello every one\", \"tasks\":[\"1\", \"3\", \"5\"]}";
    NSData *data = [userJSONString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}


// **************************************
//     公開タスクのリストをサーバーから取得
// **************************************
- (BOOL)getPublicTaskList
{
    // *** サーバーからリストを取得 ***
    NSString *publicList = @"[{\"userid\":\"1\", \"taskId\":\"1\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"2\", \"taskId\":\"2\", \"title\":\"task2\", \"limit\": \"2014年1月13日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"3\", \"taskId\":\"3\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"4\", \"taskId\":\"4\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"5\", \"taskId\":\"5\", \"title\":\"task1\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]}]";
    

    // *** リストからタスクオブジェクトを生成 ***
    NSData *taskData = [publicList dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    publicTasks = [NSJSONSerialization JSONObjectWithData:taskData options:NSJSONReadingAllowFragments error:&error];
    
    return YES;
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
        openTaskView.taskData = [publicTasks objectAtIndex:indexPath.row];
        openTaskView.userData = [userDatas objectAtIndex:indexPath.row];
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
