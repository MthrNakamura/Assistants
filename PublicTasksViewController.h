//
//  PublicTasksViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_USER_ID     @"userId"
#define KEY_TITLE       @"title"
#define KEY_LIMIT       @"limit"
#define KEY_MEMO        @"memo"
#define KEY_PUBLIC      @"public"
#define KEY_ASSISTANTS  @"assistants"

#define PUBLIC_TASK_CELL_ID @"public_task_cell"

#define TASK_TYPE_ALL     0
#define TASK_TYPE_PRIVATE 1

@interface PublicTasksViewController : UITableViewController <UIAlertViewDelegate> {
    NSMutableArray *publicTasks;
    UIRefreshControl *refresh;
}

@property int publicTaskType;
@property (strong, nonatomic) NSString *userId;

- (BOOL)getPublicTaskList;
- (IBAction)updatePublickTaskList:(id)sender;

@end
