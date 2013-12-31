//
//  TaskDetailViewController.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/27.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TopViewController.h"
#import "AssistantsViewController.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

@synthesize taskData;
@synthesize taskIndex;

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

    // delegateを取得
    delegate = [UIApplication sharedApplication].delegate;
    
    // DatePickerを閉じる
    isOpenedDatePicker = NO;
    
    // タイトルを設定
    self.navigationItem.title = [taskData objectForKey:TASK_TITLE];
    
    // 期限を設定
    self.dateLabel.text = [taskData objectForKey:TASK_LIMIT];
    
    // メモを設定
    self.memoField.text = [taskData objectForKey:TASK_MEMO];
    self.memoField.delegate = self;
    // メモの編集完了ボタンを無効化
    [self.btnDoneEditting setEnabled:NO];
    
    
    // 公開設定
    if ([[taskData objectForKey:TASK_PUBLIC] boolValue]) {
        self.publicLabel.text = @"公開";
        [self.assistantsBtn setEnabled:YES];
        [self.assistantsBtn setHidden:NO];
    }
    else {
        self.publicLabel.text = @"非公開";
        [self.assistantsBtn setEnabled:NO];
        [self.assistantsBtn setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS;
}



// ************************************
//          セルを選択した
// ************************************
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"公開設定" message:@"タスクを非公開に設定しますか" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    
    switch (indexPath.section) {
        case SECTION_DATE: // 期日セクション
            
            [self.tableView beginUpdates];
            isOpenedDatePicker = !isOpenedDatePicker;
            [self.tableView endUpdates];
            
            break;
            
        case SECTION_PUBLIC: // 公開セクション
            
            if (![[self.taskData objectForKey:TASK_PUBLIC]boolValue]) {
                [alert setMessage:@"タスクを公開に設定しますか"];
            }
            [alert show];
            
            break;
            
        case SECTION_MEMO: // メモセクション
            
            break;
            
        default:
            
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// ************************************
//         セクションごとの行数を返す
// ************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_DATE: // 期日セクション
            
            return NUM_ROWS_IN_DATE_SECTION;
            
        case SECTION_PUBLIC: // 公開セクション
            
            return NUM_ROWS_IN_PUBLIC_SECTION;
            
        case SECTION_MEMO: // メモセクション
            
            return NUM_ROWS_IN_MEMO_SECTION;
            
        default:
            
            return 0;
    }
}


// ************************************
//          セルの高さを返す
// ************************************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case SECTION_DATE:     // 期限セクション
            
            if (indexPath.row == 0) {
                return DEFAULT_CELL_HEIGHT;
            }
            return (isOpenedDatePicker)? DATEPICKER_HEIGHT:0;
            
            
        case SECTION_PUBLIC:     // 公開設定セクション
            
            return DEFAULT_CELL_HEIGHT;
            
        case SECTION_MEMO:     // メモセクション
            
            return MEMO_CELL_HEIGHT;
            
        default:
            return 0;
    }
}

// ************************************
//          アラートをクリックした
// ************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // はい
    if (buttonIndex == 1) {
        if ([[self.taskData objectForKey:TASK_PUBLIC] boolValue]) {
            // 公開の状態で「はい」→ 非公開
            [self.taskData setValue:[NSNumber numberWithBool:NO] forKey:TASK_PUBLIC];
            self.publicLabel.text = @"非公開";
            [self.assistantsBtn setHidden:YES];
            [self.assistantsBtn setEnabled:NO];
        }
        else {
            // 非公開の状態で「はい」→ 公開
            [self.taskData setValue:[NSNumber numberWithBool:YES] forKey:TASK_PUBLIC];
            self.publicLabel.text = @"公開";
            [self.assistantsBtn setHidden:NO];
            [self.assistantsBtn setEnabled:YES];
        }
    }
}


// ************************************
//          メモの編集を開始
// ************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // アシスタント一覧ビューへ遷移
    if ([[segue identifier] isEqualToString:@"AssistantsSegue"]) {
        
        // 一覧を表示するタスクの情報を渡す
        AssistantsViewController *assistantsView = (AssistantsViewController *)[segue destinationViewController];
        assistantsView.task = [delegate.tasks objectAtIndex:self.taskIndex];
        
    }
}




// ************************************
//          メモの編集を開始
// ************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.btnDoneEditting setTitle:@"完了"];
    [self.btnDoneEditting setEnabled:YES];
    return YES;
}


// ************************************
//          メモの編集を終了
// ************************************
- (IBAction)doneEditing:(id)sender {
    // キーボードを閉じる
    [self.memoField resignFirstResponder];
    
    // 完了ボタンを隠す
    [self.btnDoneEditting setTitle:@""];
    [self.btnDoneEditting setEnabled:NO];
}

// ************************************
//          期限をピッカーで選択した
// ************************************
- (IBAction)didSelectedLimitDate:(id)sender {
    
    // 選択した日付を取得
    NSDate *limitDate = [self.datePicker date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy年MM月dd日 HH時mm分"];
    
    // 選択した日付を設定
    self.dateLabel.text = [df stringFromDate:limitDate];
    
}


// ************************************
//          TopViewに戻る
// ************************************
- (IBAction)gobackToTopView:(id)sender
{
    NSMutableDictionary *tasks = [delegate.tasks objectAtIndex:self.taskIndex];
    [tasks setValue:self.dateLabel.text forKey:TASK_LIMIT];
    [tasks setValue:self.memoField.text forKey:TASK_MEMO];
    [tasks setValue:[self.taskData objectForKey:TASK_PUBLIC] forKey:TASK_PUBLIC];
    [delegate.tasks replaceObjectAtIndex:self.taskIndex withObject:tasks];
    
    
    // TopViewに戻る
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
