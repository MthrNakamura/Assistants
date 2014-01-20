//
//  UserConfigViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2014/01/06.
//  Copyright (c) 2014年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_SECTIONS_IN_USERCONFIG 3

#define SECTION_USERNAME_IN_USERCONFIG 0
#define SECTION_SKILL_IN_USERCONFIG 1
#define SECTION_CONTACT_IN_USERCONFIG 2

#define NUM_CELL_IN_USERNAME_IN_USERCONFIG 1
#define NUM_CELL_IN_SKILL_IN_USERCONFIG 3
#define NUM_CELL_IN_CONTACT_IN_USERCONFIG 2

@interface UserConfigViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    BOOL isEditing;
    UITextField *currentEditing;

}


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSave;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UITextField *skill1;
@property (strong, nonatomic) IBOutlet UITextField *skill2;
@property (strong, nonatomic) IBOutlet UITextField *skill3;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *mailAddr;


- (IBAction)finishEditingSkill1:(id)sender;
- (IBAction)finishEditingSkill2:(id)sender;
- (IBAction)finishEditingSkill3:(id)sender;
- (IBAction)finishEditingPhone:(id)sender;
- (IBAction)finishEditingMail:(id)sender;

- (IBAction)pushBtnSave:(id)sender;

@end
