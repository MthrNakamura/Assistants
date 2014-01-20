//
//  UserConfigViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2014/01/06.
//  Copyright (c) 2014年 com.self.planningdev. All rights reserved.
//

#import "UserConfigViewController.h"

#import "AppDelegate.h"
#import "AsyncURLConnection.h"

#import "MBProgressHUD.h"


AppDelegate *delegate;

BOOL showingAlert;
BOOL willGoBackToLoginView;

@interface UserConfigViewController ()

@end

@implementation UserConfigViewController

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
    
    delegate = [UIApplication sharedApplication].delegate;
    
    self.skill1.delegate = self;
    self.skill2.delegate = self;
    self.skill3.delegate = self;
    self.phoneNumber.delegate = self;
    self.mailAddr.delegate = self;
    
    isEditing = NO;
    
    // データを表示
    // ユーザー名
    [self.userName setText:[delegate.user objectForKey:USER_PROP_NAME]];
    // スキル
    [self.skill1 setText:([[delegate.user objectForKey:USER_PROP_SKILL1] isEqualToString:@"none"])?@"なし":[delegate.user objectForKey:USER_PROP_SKILL1]];
    [self.skill2 setText:([[delegate.user objectForKey:USER_PROP_SKILL2] isEqualToString:@"none"])?@"なし":[delegate.user objectForKey:USER_PROP_SKILL2]];
    [self.skill3 setText:([[delegate.user objectForKey:USER_PROP_SKILL3] isEqualToString:@"none"])?@"なし":[delegate.user objectForKey:USER_PROP_SKILL3]];
    // 連絡先
    if ([delegate.user objectForKey:USER_PROP_PHONE] != [NSNull null]) {
        [self.phoneNumber setText:([[delegate.user objectForKey:USER_PROP_PHONE] isEqualToString:@"none"])? @"":[delegate.user objectForKey:USER_PROP_PHONE]];
    }
    if ([delegate.user objectForKey:USER_PROP_MAIL] != [NSNull null]) {
        [self.mailAddr setText:([[delegate.user objectForKey:USER_PROP_MAIL] isEqualToString:@"none"])? @"":[delegate.user objectForKey:USER_PROP_MAIL]];
    }
    
    showingAlert = NO;
    willGoBackToLoginView = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS_IN_USERCONFIG;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_USERNAME_IN_USERCONFIG:
            
            return NUM_CELL_IN_USERNAME_IN_USERCONFIG;
            
        case SECTION_SKILL_IN_USERCONFIG:
            
            return NUM_CELL_IN_SKILL_IN_USERCONFIG;
        
        case SECTION_CONTACT_IN_USERCONFIG:
            
            return NUM_CELL_IN_CONTACT_IN_USERCONFIG;
            
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// *************************************
//          テキスト入力を開始した
// *************************************
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.btnSave setTitle:@"完了"];
    currentEditing = textField;
    isEditing = YES;
}


// *************************************
//          テキスト入力を開始した
// *************************************
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.btnSave setTitle:@"保存"];
    currentEditing = nil;
    isEditing = NO;
}


// ************************************
//         変更内容を送信
// ************************************
- (BOOL)sendChange
{
    __block BOOL result = YES;
    
    // *** ダイアログを表示 ***
    MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:self.view];
    [progress setLabelText:@"ロード中"];
    [self.view addSubview:progress];
    [progress show:YES];
    
    
    NSURLRequest *request = [self createChangeRequest];
    
    AsyncURLConnection *conn = [[AsyncURLConnection alloc]initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        // *** ダイアログを隠す ***
        [progress show:NO];
        [progress removeFromSuperview];
        
        
        // *** レスポンスをチェック ***
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"ユーザー情報の更新に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
            return ;
        }
        
        // *** ローカルの情報も更新 ***
        // スキル
        [delegate.user setValue:[self.skill1 text] forKey:USER_PROP_SKILL1];
        [delegate.user setValue:[self.skill2 text] forKey:USER_PROP_SKILL2];
        [delegate.user setValue:[self.skill3 text] forKey:USER_PROP_SKILL3];
        
        // 連絡先
        [delegate.user setValue:[self.phoneNumber text] forKey:USER_PROP_PHONE];
        [delegate.user setValue:[self.mailAddr text] forKey:USER_PROP_MAIL];
        
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


// ************************************
//       変更リクエストを作成
// ************************************
- (NSURLRequest *)createChangeRequest
{
    
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:UPDATE_USERINFO_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *s1 = ([[self.skill1 text] isEqualToString:@"なし"])? @"none":[self.skill1 text];
    NSString *s2 = ([[self.skill2 text] isEqualToString:@"なし"])? @"none":[self.skill2 text];
    NSString *s3 = ([[self.skill3 text] isEqualToString:@"なし"])? @"none":[self.skill3 text];
    NSString *phone = ([[self.phoneNumber text]isEqualToString:@""])? @"none":[self.phoneNumber text];
    NSString *mail = ([[self.mailAddr text] isEqualToString:@""])? @"none":[self.mailAddr text];
    
    NSString *body = [NSString stringWithFormat:@"userId=%@&skill1=%@&skill2=%@&skill3=%@&phone=%@&mail=%@", [delegate.user objectForKey:USER_PROP_ID], s1, s2, s3, phone, mail];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
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

// *******************************
//          編集したかどうか
// *******************************
- (BOOL)isEdited
{
    BOOL result = NO;
    
    // *** スキル ***
    if (![self.skill1.text isEqualToString:[delegate.user objectForKey:USER_PROP_SKILL1]]) {
        result = YES;
    }
    if (![self.skill2.text isEqualToString:[delegate.user objectForKey:USER_PROP_SKILL2]]) {
        result = YES;
    }
    if (![self.skill3.text isEqualToString:[delegate.user objectForKey:USER_PROP_SKILL3]]) {
        result = YES;
    }
    
    // *** 連絡先 ***
    if (![self.phoneNumber.text isEqualToString:[delegate.user objectForKey:USER_PROP_PHONE]]) {
        result = YES;
    }
    
    if (![self.mailAddr.text isEqualToString:[delegate.user objectForKey:USER_PROP_MAIL]]) {
        result = YES;
    }
    
    return result;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (!showingAlert) {
        if (willGoBackToLoginView) {
            // 前のビューに戻る
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        return ;
    }
    
    showingAlert = NO;
    switch (buttonIndex) {
        case 0:
            // キャンセル => 何もしない
            break;
        
        case 1:

            // はい => 保存して戻る
            // 保存ボタンを押した
            // *** 変更内容をサーバーに送信する ***
            if ([self sendChange]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"変更を保存しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                willGoBackToLoginView = YES;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"変更の保存に失敗しました。通信環境の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                willGoBackToLoginView = NO;
            }
            break;
            
            
        
        case 2:
            
            // いいえ => 保存せずに戻る
            // 前のビューに戻る
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}


- (IBAction)gobackToLoginView:(id)sender {
    
    if ([self isEdited]) {
        showingAlert = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ユーザー情報" message:@"情報は変更されています。保存しますか。" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles: @"保存する", @"保存しない", nil];
        [alertView show];
    }
    else {
        // 前のビューに戻る
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


- (IBAction)finishEditingSkill1:(id)sender {
    [self.skill1 resignFirstResponder];
}

- (IBAction)finishEditingSkill2:(id)sender {
    [self.skill2 resignFirstResponder];
}

- (IBAction)finishEditingSkill3:(id)sender {
    [self.skill3 resignFirstResponder];
}

- (IBAction)finishEditingPhone:(id)sender {
    [self.phoneNumber resignFirstResponder];
}

- (IBAction)finishEditingMail:(id)sender {
    [self.mailAddr resignFirstResponder];
}

// *************************************
//          保存&完了ボタンを押した
// *************************************
- (IBAction)pushBtnSave:(id)sender {
    if (isEditing) {
        
        // 完了ボタンを押した
        [currentEditing resignFirstResponder];
        
    }
    else {
        // 保存ボタンを押した
        // *** 変更内容をサーバーに送信する ***
        if ([self sendChange]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"変更を保存しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ユーザー情報" message:@"変更の保存に失敗しました。通信環境の良い場所で再度お試しください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
@end
