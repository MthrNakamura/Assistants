//
//  ConfigViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/31.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "ConfigViewController.h"
#import "LoginViewController.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

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
    
    
    self.navigationController.delegate = self;
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


// ***************************************
//              セクション数を返す
// ***************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS_OF_CONFIGVIEW;
}


// ***************************************
//          セクションごとのセルの数
// ***************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case SECTION_ACCOUNT:
            
            return NUM_CELLS_IN_ACCOUNT;
        
        case SECTION_VERSION:
            
            return NUM_CELLS_IN_VERSION;
            
        default:
            return 0;
    }
}

// ***************************************
//              セル選択時イベント
// ***************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    switch (indexPath.section) {
//        case SECTION_ACCOUNT:
//            
//            // *** ログアウトを実行 ***
//            if (indexPath.row == ROW_OF_LOGOUT) {
//                // ログアウト処理
//                [self gotoLoginView];
//            }
//            
//            break;
//            
//        default:
//            break;
//    }
    
}


// ***************************************
//              ログインビューに戻る
// ***************************************
- (void)gotoLoginView
{
    [self setLogedInStatus:NO];
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self presentViewController:loginView animated:YES completion:nil];
}

// ***************************************
//              ログイン状態を保存
// ***************************************
- (void)setLogedInStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:LOGIN_STATUS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"hello");
}
@end
