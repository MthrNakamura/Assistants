//
//  TaskCell.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/22.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_ID @"TaskCell"

@interface TaskCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIButton *checkBox;
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;



- (IBAction)didCheckedBOx:(id)sender;

@end
