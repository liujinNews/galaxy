//
//  selectExamineViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@protocol selectExamineViewControllerDelegate <NSObject>

-(void)selectExamineViewController_Delegate:(NSDictionary *)dic type:(NSString *)type style:(NSString *)style;

@end

@interface selectExamineViewController : FlowBaseViewController

@property (nonatomic, strong) NSString *select_id;//选择ID
@property (nonatomic, strong) NSString *type;//0 退回 1 加签
@property (nonatomic, strong) NSString *style;// 0 意见 1 申请人
@property (nonatomic, weak) id<selectExamineViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *TaskId;
@property (nonatomic, strong) NSString *ProcId;

@end
