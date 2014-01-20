//
//  ConfigViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/31.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>


#define NUM_SECTIONS_OF_CONFIGVIEW 2

#define SECTION_ACCOUNT 0
#define SECTION_VERSION 1

#define NUM_CELLS_IN_ACCOUNT 1
#define NUM_CELLS_IN_VERSION 1

#define ROW_OF_LOGOUT 1

@interface ConfigViewController : UITableViewController <UINavigationControllerDelegate>

- (void)gotoLoginView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end
