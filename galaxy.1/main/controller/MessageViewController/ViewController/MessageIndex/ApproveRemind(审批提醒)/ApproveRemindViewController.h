//
//  ApproveRemindViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@interface ApproveRemindViewController : FlowBaseViewController

@property (weak, nonatomic) IBOutlet UIView *view_tableview;


@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *flowCode;
@property(nonatomic,strong)NSString *taskId;
@property(nonatomic,strong)NSString *procId;
@property(nonatomic,strong)NSString *userId;

//1待审批 100待支付
@property(nonatomic,strong)NSString *ApproveEditStatus;

@property(nonatomic,strong)NSString *str_Title;

@end
