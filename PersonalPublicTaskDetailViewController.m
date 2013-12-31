//
//  PersonalPublicTaskDetailViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "PersonalPublicTaskDetailViewController.h"
#import "PublicTasksViewController.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
            
            return NUM_CELLS_IN_TASK;
            
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
    UIImage *image =  [UIImage imageNamed:[self.userData objectForKey:@"imageUrl"]];
    [self.userImage setImage:image];
    // 名前
    [self.userName setText:[self.userData objectForKey:@"name"]];
    
    // *** タスク情報を設定 ***
    // タイトル
    [self.taskTitle setText:[self.taskData objectForKey:KEY_TITLE]];
    // 期限
    [self.taskLimit setText:[self.taskData objectForKey:KEY_LIMIT]];
    // メモ
    [self.taskMemo setText:[self.taskData objectForKey:KEY_MEMO]];
    
}

// ****************************************
//          アラートをタップしたイベント
// ****************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!showingAlert)
        return ;
    
    if (buttonIndex == 1) {
        // はい
        showingAlert = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"このタスクをアシストしました" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
        [alert show];
    }
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
    
    showingAlert = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスト" message:@"このタスクをアシストしますか" delegate:self cancelButtonTitle:@"やめる" otherButtonTitles:@"はい", nil];
    [alert show];
    
}
@end
