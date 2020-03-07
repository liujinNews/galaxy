//
//  DepartmentSelectViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/2/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

typedef void(^DepartmentSelectBlock)(NSMutableArray *arr);

@interface DepartmentSelectViewController : VoiceBaseController

//1.选择部门 2。选择部门和员工
@property (nonatomic, assign) NSInteger Type;

//1.单选 2.多选
@property (nonatomic, assign) NSInteger SelectAll;

//选择后数据
@property (nonatomic, strong) NSMutableArray *arr_SelectData;

@property (nonatomic, strong) DepartmentSelectBlock block;

@end

