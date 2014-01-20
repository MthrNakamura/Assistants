//
//  TaskCell.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/22.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "TaskCell.h"
#import "AppDelegate.h"
#import "TopViewController.h"
#import "AsyncURLConnection.h"


@implementation TaskCell


+ (id)loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    return [[nib instantiateWithOwner:nil options:nil]objectAtIndex:0];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)completeTask:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    __block BOOL result = YES;
    
    
    NSURLRequest *request = [self createDeleteRequest:[[delegate.tasks objectAtIndex:indexPath.row]objectForKey:TASK_ID]];
    AsyncURLConnection *conn = [[AsyncURLConnection alloc] initWithRequest:request timeoutSec:TIMEOUT_INTERVAL completeBlock:^(id conn, NSData *data) {
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![[response objectForKey:@"errorCode"]isEqualToString:NO_ERROR]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"タスク削除" message:@"タスクの削除に失敗しました。再度お試しください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
        }
        
        [delegate.tasks removeObjectAtIndex:indexPath.row];
        
    } progressBlock:nil errorBlock:^(id conn, NSError *error) {
        
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

// **************************************
//          タスク削除リスエストを送信
// **************************************
- (NSURLRequest *)createDeleteRequest:(NSString *)taskId
{
    // リクエストURLを設定
    NSURL *url = [[NSURL alloc]initWithString:DELETE_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    
    // メソッドを設定
    [request setHTTPMethod:@"POST"];
    
    // パラメータを設定
    NSString *body = [NSString stringWithFormat:@"taskId=%@", taskId];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (IBAction)didCheckedCheckbox:(id)sender {
    
    
    // チェックマークを入れる
    [self.checkBox setImage:[UIImage imageNamed:@"checkbox_filled.png"] forState:UIControlStateNormal];

    // このセルの属するテーブルビューを取得
    id tableView = [sender superview];
    while ([tableView isKindOfClass:[UITableView class]] == NO) {
        tableView = [tableView superview];
    }

    // indexPathを取得
    NSIndexPath *indexPath = [((UITableView *)tableView) indexPathForCell:self];
    
    if ([self completeTask:tableView indexPath:indexPath]) {
        sleep(1.5);
        [tableView reloadData];
    }
    
}
@end