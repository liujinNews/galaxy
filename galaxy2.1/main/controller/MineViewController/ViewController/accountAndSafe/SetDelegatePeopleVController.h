//
//  SetDelegatePeopleVController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/3/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"


@interface SetDelegatePeopleVController : RootViewController

@property (weak, nonatomic) IBOutlet UITableView *tab_tableview;

@property (weak, nonatomic) IBOutlet UISearchBar *sea_Search;


@property (nonatomic, strong) NSMutableArray *arrClickPeople;//选中的用户

@property (nonatomic, strong) NSMutableArray *arr_System;//选中的用户

@property (nonatomic,copy) void(^chooseDelegateBlock)(NSArray *array);

@end
