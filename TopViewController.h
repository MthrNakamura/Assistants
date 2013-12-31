//
//  TopViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/21.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


// --- タスクオブジェクトのキー ---
#define TASK_TITLE      @"task_title"
#define TASK_LIMIT      @"task_limit"
#define TASK_MEMO       @"task_memo"
#define TASK_PUBLIC     @"task_public"
#define NUM_ASSISTANTS  @"num_assistants"

@interface TopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    AppDelegate *delegate;
    BOOL isEditing;
}

@property (strong, nonatomic) NSMutableDictionary *taskData;
@property (strong, nonatomic) IBOutlet UITextField *taskInputField;
@property (strong, nonatomic) IBOutlet UITableView *taskTable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;




- (IBAction)startEditing:(id)sender;
- (IBAction)finishEditting:(id)sender;
- (IBAction)editAndDone:(id)sender;

- (void)addNewAssistants;
- (void)appendNewTask:(NSString *)taskTitle;
@end
