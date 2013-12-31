//
//  PublicTaskCell.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PUBLIC_CELL_HEIGHT 150

@interface PublicTaskCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;

@end
