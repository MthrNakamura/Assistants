//
//  PersonalPublicTaskViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_SECTIONS_IN_PPTVIEW 1

#define SECTION_OTHER_TASKS 3

@interface PersonalPublicTaskViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSDictionary *userInfo;
- (IBAction)gobackToPrevView:(id)sender;

@end
