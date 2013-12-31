//
//  OpenTaskDetailViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "OpenTaskDetailViewController.h"
#import "PublicTasksViewController.h"
#import "UserInfoViewController.h"

@interface OpenTaskDetailViewController ()

@end

@implementation OpenTaskDetailViewController

@synthesize userData;
@synthesize taskData;

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
    
    // アシストアラートを表示しているか
    showingAssistAlert = NO;
    
    // タスク情報を設定する
    [self setShowingTask];
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
    return NUM_SECTIONS;
}


// **************************************
//          セクション毎の行数を返す
// **************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case SECTION_USER:
            
            return NUM_CELL_USER_SECTION;
            
        case SECTION_TASK:
            
            return NUM_CELL_TASK_SECTION;
            
        default:
            return 0;
    }
}

// **************************************
//          セル選択時イベント
// **************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_USER) {
        
        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

// **************************************
//          アラートをタップしたとき
// **************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // アシストアラート以外は無視
    if (!showingAssistAlert)
        return ;
    

    if (buttonIndex == 1) {
        // はい
        showingAssistAlert = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"このタスクをアシストしました" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// **************************************
//          タスク情報を表示する
// **************************************
- (void)setShowingTask
{
    
    NSLog(@"%@", self.userData);
    
    // *** ユーザ情報を表示 ***
    // プロフィール画像
    [self.userImage setImage:[UIImage imageNamed:[self.userData objectForKey:@"imageUrl"]]];
    // ユーザー名
    [self.userName setText:[self.userData objectForKey:@"name"]];

    // *** タスク情報を表示 ***
    // タスクタイトル
    [self.taskTitle setText:[self.taskData objectForKey:KEY_TITLE]];
    // タスク期限
    [self.taskLimit setText:[self.taskData objectForKey:KEY_LIMIT]];
    // タスクメモ
    [self.taskMemo setText:[self.taskData objectForKey:KEY_MEMO]];
    
}

// *************************************
//          画面遷移時イベント
// *************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // ユーザ情報ビューへの遷移
    if ([[segue identifier] isEqualToString:@"UserInfoSegue"]) {
        
        UserInfoViewController *userInfoView = (UserInfoViewController *)[segue destinationViewController];
        userInfoView.userInfo = self.userData;
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
//          タスクのアシストを開始
// **************************************
- (IBAction)startAssistingTask:(id)sender {
    showingAssistAlert = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"このタスクをアシストしますか" delegate:self cancelButtonTitle:@"やめる" otherButtonTitles:@"はい", nil];
    [alert show];
}


// **************************************
//          公開タスク一覧ビューに戻る
// **************************************
- (IBAction)gobackToPublicTasksView:(id)sender {
    // TopViewに戻る
    [self.navigationController popViewControllerAnimated:YES];
}
@end
