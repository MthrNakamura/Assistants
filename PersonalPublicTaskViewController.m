//
//  PersonalPublicTaskViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "PersonalPublicTaskViewController.h"
#import "PersonalPublicTaskCell.h"
#import "PublicTasksViewController.h"
#import "PersonalPublicTaskDetailViewController.h"
#import "TopViewController.h"

@interface PersonalPublicTaskViewController ()

@end

@implementation PersonalPublicTaskViewController

@synthesize tasks;
@synthesize userInfo;

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

    // テーブルビューの背景を設定
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.jpg"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // タブバーデリゲートの設定
    //self.tabBarController.delegate = self;
    
    // ナビゲーションバーのタイトルを設定
    [self.navigationItem setTitle:@"公開タスク一覧"];
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

#pragma mark - Table view data source

// *************************************
//          セクション数を返す
// *************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS_IN_PPTVIEW;
}

// *************************************
//         セクションごとの行数を返す
// *************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tasks count];
}


// *************************************
//              セルを返す
// *************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalPublicTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:PPT_CELL_ID forIndexPath:indexPath];
    
    // Configure the cell...
    // タイトルを設定
    cell.taskTitle.text = [[self.tasks objectAtIndex:indexPath.row] objectForKey:TASK_TITLE];
    
    
    return cell;
}

// *************************************
//            セルの高さを返す
// *************************************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PPT_CELL_HEIGHT;
}

// *************************************
//          セルの選択時イベント
// *************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// ****************************************
//              画面遷移時イベント
// ****************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // このユーザーの公開タスクの詳細画面に遷移
    if ([[segue identifier] isEqualToString:@"PPTaskDetailSegue"]) {
        
        // 選択したタスクのインデックスを取得
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // 遷移先のビューにデータを渡す
        PersonalPublicTaskDetailViewController *pptdView = (PersonalPublicTaskDetailViewController *)[segue destinationViewController];
        pptdView.taskData = [self.tasks objectAtIndex:indexPath.row];
        pptdView.userData = self.userInfo;
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


// *************************************
//          一つ前のビューに戻る
// *************************************
- (IBAction)gobackToPrevView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
