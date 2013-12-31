//
//  TaskCell.m
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/22.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import "TaskCell.h"


@implementation TaskCell

BOOL isChecked = NO;

+ (id)loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    return [[nib instantiateWithOwner:nil options:nil]objectAtIndex:0];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



// *************************************
//          チェックボックスをタップした
// *************************************
- (IBAction)didCheckedBOx:(id)sender {
    
    // *** チェックボックスにチェックを入れる ***
    if (isChecked) {
        [self.checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else {
        [self.checkBox setImage:[UIImage imageNamed:@"checkbox_filled.png"] forState:UIControlStateNormal];
    }
    isChecked = !isChecked;
    
    // *** タスクの状態をサーバーに送信 ***
    
    
}
@end