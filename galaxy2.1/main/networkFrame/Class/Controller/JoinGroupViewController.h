//
//  JoinGroupViewController.h
//  MyDemo
//
//  Created by tomzhu on 15/6/15.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinGroupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (void)initConfig:(NSString*)title placeholder:(NSString *)placeholder;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UITextField* searchTextView;
@property (nonatomic, weak) IBOutlet UIButton* searchBtn;

- (IBAction)search:(id)sender;

@end
