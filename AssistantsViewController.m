//
//  AssistantsViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "AssistantsViewController.h"
#import "TopViewController.h"
#import "AssistantsCell.h"
#import "AppDelegate.h"
#import "UserInfoViewController.h"

#import "AsyncURLConnection.h"

#import "MBProgressHUD.h"

@interface AssistantsViewController ()

@end

@implementation AssistantsViewController

@synthesize task;

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
    
    // テーブルビューの背景を設定
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.jpg"]];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // タイトルを表示
    self.navigationItem.title = [self.task objectForKey:TASK_TITLE];
    
    // アシスタント一覧のリストを取得
    NSString *taskId = [self.task objectForKey:TASK_ID];
    [self sendAssistantsListRequest:taskId];
}


// *****************************************
//          アシスタント一覧のリクエストを送信
// *****************************************
- (BOOL)sendAssistantsListRequest:(NSString *)taskId
{
    
    __block BOOL result = YES;
    
    // *** ダイアログを表示 ***
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    [progress setLabelText:@"ロード中"];
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSURLRequest *request = [self createAssistantsListRequest:taskId];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        
        // *** ダイアログを隠す ***
        [progress show:NO];
        [progress removeFromSuperview];
        
        
        // *** レスポンスをチェック ***
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"アシスタント一覧" message:@"アシストの一覧の取得に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
            return ;
        }
        
        // ユーザー情報を取得
        assistantsArray = [response objectForKey:@"users"];
        NSLog(@"%@", assistantsArray);
        
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

// *****************************************
//          アシスタント一覧のリクエストを送信
// *****************************************
- (NSURLRequest *)createAssistantsListRequest:(NSString *)taskId
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:ASSISTANTS_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    NSString *body = [NSString stringWithFormat:@"taskId=%@", taskId];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


// *****************************************
//       アシスタント一覧を表示
// *****************************************
- (void)showAssistants
{
    int numAssistants = [assistantsArray count];
    for (int i = 0; i < numAssistants; i++) {
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
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


// **********************************
//          セクション数
// **********************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// **********************************
//          セクション毎の行数
// **********************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [assistantsArray count];
}

// **********************************
//          セルを返す
// **********************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssistantsCell *cell = [tableView dequeueReusableCellWithIdentifier:ASSISTANTS_CELL_ID forIndexPath:indexPath];

    NSMutableDictionary *userData = [assistantsArray objectAtIndex:indexPath.row];
    
    cell.userName.text = (NSString *)[userData objectForKey:USER_PROP_NAME];
    [cell.userImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[userData objectForKey:USER_PROP_PHOTO]]]]];
    
    
    return cell;
}

// **********************************
//          セル選択時イベント
// **********************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoViewController *uinfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoView"];
    uinfoView.userInfo = [assistantsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:uinfoView animated:YES];
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// ***************************
//          セルの高さ
// ***************************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSISTANTS_CELL_HEIGHT;
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

- (IBAction)gobackToPrevView:(id)sender {
    // TopViewに戻る
    [self.navigationController popViewControllerAnimated:YES];
}
@end
