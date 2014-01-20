//
//  AssistingTaskViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define NUM_SECTIONS_IN_ASSISTING_TASK 1

@interface AssistingTaskViewController : UITableViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *tempData;
    BOOL showingAlert;
    AppDelegate *delegate;
    NSIndexPath *deletingPath;
    UIRefreshControl *refresh;
    NSUInteger numRows;
}

@property (strong, nonatomic) NSMutableArray *tasks;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

- (BOOL)getAssistingTaskList;
//- (void)createTableFromList;
- (NSDictionary *)getUserDataFromUserId:(NSString *)userId;

- (IBAction)startEditing:(id)sender;
- (IBAction)realodTasks:(id)sender;

@end
