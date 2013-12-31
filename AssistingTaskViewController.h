//
//  AssistingTaskViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_SECTIONS_IN_ASSISTING_TASK 1

@interface AssistingTaskViewController : UITableViewController <UIAlertViewDelegate> {
    NSDictionary *tempData;
    BOOL showingAlert;
    NSIndexPath *deletingPath;
}

@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *tasks;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;

- (BOOL)getAssistingTaskList;
- (void)createTableFromList;
- (NSDictionary *)getUserDataFromUserId:(NSString *)userId;

- (IBAction)startEditing:(id)sender;

@end
