//
//  TaskDetailViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/27.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#define DATEPICKER_HEIGHT 180  // DatePickerを開いた時のセルの高さ
#define DEFAULT_CELL_HEIGHT 44 // セルのデフォルトの高さ
#define MEMO_CELL_HEIGHT 150   // メモセルの高さ


// --- セクション番号 ---
#define SECTION_DATE   0
#define SECTION_PUBLIC 1
#define SECTION_MEMO   2

// --- セクション数 ---
#define NUM_SECTIONS 3

// --- セクションごとの行数 ---
#define NUM_ROWS_IN_DATE_SECTION   2
#define NUM_ROWS_IN_PUBLIC_SECTION 1
#define NUM_ROWS_IN_MEMO_SECTION   1

@interface TaskDetailViewController : UITableViewController <UIAlertViewDelegate, UITextViewDelegate> {
    AppDelegate *delegate;
    BOOL isOpenedDatePicker;
}

@property (strong, nonatomic) NSMutableDictionary *taskData;
@property unsigned int taskIndex;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDoneEditting;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextView *memoField;
@property (strong, nonatomic) IBOutlet UILabel *publicLabel;
@property (strong, nonatomic) IBOutlet UIButton *assistantsBtn;


- (IBAction)doneEditing:(id)sender;
- (IBAction)didSelectedLimitDate:(id)sender;
- (IBAction)gobackToTopView:(id)sender;


@end
