//
//  UserInfoViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "UserInfoViewController.h"
#import "PersonalPublicTaskViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // *** 表示するユーザー情報を設定 ***
    // ユーザープロフィール画像
    [self.userImage setImage:[UIImage imageNamed:[self.userInfo objectForKey:@"imageUrl"]]];
    // ユーザー名
    [self.userName setText:[self.userInfo objectForKey:@"name"]];
    // スキル
    NSArray *skills = [self.userInfo objectForKey:@"skill"];
    for (int i = 0; i < [skills count]; i++) {
        
        switch (i) {
            case 0:
                
                [self.skill1 setText:[skills objectAtIndex:i]];
                
                break;
            
            case 1:
                
                [self.skill2 setText:[skills objectAtIndex:i]];
                
                break;
                
            case 2:
                
                [self.skill3 setText:[skills objectAtIndex:i]];
                
                break;
                
            default:
                break;
        }
        
    }
    
    // ユーザー説明文
    [self.detailField setText:[self.userInfo objectForKey:@"detail"]];
    
    
    // *** その他の公開タスク一覧 ***
    // 公開タスクリストを取得
    [self getPublicTaskList];
    numOtherTasks = [publicTasks count];
    // タスクリストの内容を表示
    for (int i = 0; i < numOtherTasks; i++) {
        // 3つ目以降は別ビューで表示する
        if (i >= 3)
            break;
        
        switch (i) {
            case 0:
                
                [self.otherTask1 setText:[[publicTasks objectAtIndex:i]objectForKey:@"title"]];
                
                break;
                
            case 1:
                
                [self.otherTask2 setText:[[publicTasks objectAtIndex:i]objectForKey:@"title"]];
                
                break;
                
            case 2:
                
                [self.otherTask3 setText:[[publicTasks objectAtIndex:i]objectForKey:@"title"]];
                
                break;
                
            default:
                break;
        }
        
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// *************************************
//              セクション数
// *************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTION_USERINFO;
}

// *************************************
//          セクション毎のセル数
// *************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case SECTION_USERINFO:
            
            return NUM_CELLS_IN_USERINFO;
            
        case SECTION_SKILL:
            
            return NUM_CELLS_IN_SKILL;
            
        case SECTION_DETAIL:
            
            return NUM_CELLS_IN_DETAIL;
            
        case SECTION_OTASK:
            
            return ([publicTasks count] >= 3)? NUM_CELLS_IN_TASK:[publicTasks count];
            
        default:
            return 0;
    }
    
}

// *************************************
//          セル選択時イベント
// *************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// *************************************
//        画面遷移時イベント
// *************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // このユーザーの公開タスク一覧に遷移
    if ([[segue identifier] isEqualToString:@"PersonalPublicTaskSegue"]) {
        
        PersonalPublicTaskViewController *pptView = (PersonalPublicTaskViewController *)[segue destinationViewController];
        pptView.tasks = publicTasks;
        pptView.userInfo = self.userInfo;
    }
    
    
}

// *************************************
//          公開タスク一覧を取得
// *************************************
- (void)getPublicTaskList
{
    // *** ユーザーIDを元にリストを取得 ***
    // サーバーにリクエストを送信
    NSString *publicList = @"[{\"userid\":\"1\", \"taskId\":\"1\", \"title\":\"犬の散歩\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"1\", \"taskId\":\"2\", \"title\":\"そうじ\", \"limit\": \"2014年1月13日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"1\", \"taskId\":\"3\", \"title\":\"書類整理\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"1\", \"taskId\":\"4\", \"title\":\"ヨガ\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]},{\"userid\":\"1\", \"taskId\":\"5\", \"title\":\"スイミング\", \"limit\": \"2014年1月11日\", \"memo\":\"hey\", \"public\":\"YES\", \"assistants\":[]}]";
    
    // *** リストからタスクオブジェクトを生成 ***
    NSData *taskData = [publicList dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    publicTasks = [NSJSONSerialization JSONObjectWithData:taskData options:NSJSONReadingAllowFragments error:&error];
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

// *************************************
//          前のビューに戻る
// *************************************
- (IBAction)gobackToPrevView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
