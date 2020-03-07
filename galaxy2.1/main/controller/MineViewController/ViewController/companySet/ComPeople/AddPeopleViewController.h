//
//  AddPeopleViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface AddPeopleViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITableView *tab_table;

@property (weak, nonatomic) IBOutlet UIButton *btn_btnClick;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lc_btn_ok;

@property (weak, nonatomic) IBOutlet UIButton *btn_btnDelect;


@property (nonatomic, strong) NSString *DeparTitle;

@property (nonatomic, strong) NSString *DeparId;

@property (nonatomic, strong) NSString *DeparCode;

@end
