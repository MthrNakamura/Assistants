//
//  OpenTaskDetailViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SECTION_USER 0
#define SECTION_TASK 1

#define NUM_SECTIONS 2

#define NUM_CELL_USER_SECTION 1
#define NUM_CELL_TASK_SECTION 3

@interface OpenTaskDetailViewController : UITableViewController <UIAlertViewDelegate> {
    BOOL showingAssistAlert;
}

@property (strong, nonatomic) NSDictionary *taskData;
@property (strong, nonatomic) NSDictionary *userData;

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;
@property (strong, nonatomic) IBOutlet UILabel *taskLimit;
@property (strong, nonatomic) IBOutlet UITextView *taskMemo;

- (void)setShowingTask;

- (IBAction)startAssistingTask:(id)sender;
- (IBAction)gobackToPublicTasksView:(id)sender;


@end
