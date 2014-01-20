//
//  AssistantsViewController.h
//  Assistants
//
//  Created by MotohiroNAKAMURA on 2013/12/29.
//  Copyright (c) 2013年 com.self.planningdev. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AssistantsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *assistantsArray;
    NSDictionary *tempData;
}


@property (strong, nonatomic) NSMutableDictionary *task;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEdit;


- (IBAction)gobackToPrevView:(id)sender;


@end
