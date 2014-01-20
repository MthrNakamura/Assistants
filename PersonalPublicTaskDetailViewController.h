//
//  PersonalPublicTaskDetailViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#define NUM_SECTIONS_IN_PPTDVIEW 2

#define SECTION_USER_PPTD 0
#define SECTION_TASK_PPTD 1


#define NUM_CELLS_IN_USER 1
#define NUM_CELLS_IN_TASK_PPTD 3

@interface PersonalPublicTaskDetailViewController : UITableViewController <UIAlertViewDelegate> {
    BOOL showingAlert;
    AppDelegate *delegate;
}

@property (strong, nonatomic) NSDictionary *taskData;
@property (strong, nonatomic) NSDictionary *userData;

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) IBOutlet UILabel *taskTitle;
@property (strong, nonatomic) IBOutlet UILabel *taskLimit;
@property (strong, nonatomic) IBOutlet UITextView *taskMemo;

- (IBAction)gobackToPrevView:(id)sender;
- (IBAction)addAssistingTask:(id)sender;


- (void)setShowingTask;

@end
