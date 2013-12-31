//
//  AssistantsViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ASSISTANTS_CELL_ID @"AssistantCell"

@interface AssistantsViewController : UITableViewController


@property (strong, nonatomic) NSMutableDictionary *task;

@property (strong, nonatomic) IBOutlet UIImageView *assistantImage;
@property (strong, nonatomic) IBOutlet UILabel *assistantName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;


- (IBAction)gobackToPrevView:(id)sender;


@end
