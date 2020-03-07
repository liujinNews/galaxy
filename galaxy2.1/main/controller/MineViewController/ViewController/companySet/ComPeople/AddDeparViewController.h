//
//  AddDeparViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface AddDeparViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITableView *tab_table;

@property (weak, nonatomic) IBOutlet UIButton *btn_addClick;

@property (weak, nonatomic) IBOutlet UIButton *btn_deleteBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lc_btn_delete;





@property (nonatomic, copy) NSString *NowDeparName;

@property (nonatomic, copy) NSString *NowDeparId;

@property (nonatomic, copy) NSString *DeparTitle;

@property (nonatomic, copy) NSString *DeparId;

@property (nonatomic, copy) NSString *DeparCode;

@property (nonatomic, copy) NSString *DeparLevel;

@property (nonatomic, assign) NSInteger isBranch;

@property (nonatomic, copy) NSString *type;

@end
