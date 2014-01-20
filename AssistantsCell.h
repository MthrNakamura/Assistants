//
//  AssistantsCell.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2014/01/06.
//  Copyright (c) 2014年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ASSISTANTS_CELL_ID @"AssistantsCell"
#define ASSISTANTS_CELL_HEIGHT 150


@interface AssistantsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;


@end
