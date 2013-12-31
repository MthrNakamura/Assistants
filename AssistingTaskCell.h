//
//  AssistingTaskCell.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/30.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ASSISTING_CELL_ID @"assisting_cell"
#define ASSISTING_CELL_HEIGHT 150

@interface AssistingTaskCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;



@end
