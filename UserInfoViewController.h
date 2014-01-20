//
//  UserInfoViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_SECTION_USERINFO 4

#define SECTION_USERINFO 0
#define SECTION_SKILL    1
#define SECTION_DETAIL   2
#define SECTION_OTASK    3

#define NUM_CELLS_IN_USERINFO 1
#define NUM_CELLS_IN_SKILL    3
#define NUM_CELLS_IN_DETAIL   1
#define NUM_CELLS_IN_TASK     4


@interface UserInfoViewController : UITableViewController {
    NSMutableArray *publicTasks;
}

@property (strong, nonatomic) NSDictionary *userInfo;

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UITextField *skill1;
@property (strong, nonatomic) IBOutlet UITextField *skill2;
@property (strong, nonatomic) IBOutlet UITextField *skill3;
@property (strong, nonatomic) IBOutlet UITextView *detailField;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;



@property (strong, nonatomic) IBOutlet UILabel *otherTask1;
@property (strong, nonatomic) IBOutlet UILabel *otherTask2;
@property (strong, nonatomic) IBOutlet UILabel *otherTask3;


- (void)getPublicTaskList;
//- (void)transOtherTaskDetailView;

- (IBAction)gobackToPrevView:(id)sender;
- (IBAction)call:(id)sender;
- (IBAction)chat:(id)sender;
@end
