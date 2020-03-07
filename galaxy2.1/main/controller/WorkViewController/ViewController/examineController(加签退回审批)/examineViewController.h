//
//  examineViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface examineViewController : VoiceBaseController

@property (nonatomic, strong) NSString *FlowCode;//流程代码
@property (nonatomic, strong) NSString *TaskId;//任务id
@property (nonatomic, strong) NSString *ProcId;//审批过程id
@property (nonatomic, strong) NSString *Type;// 0 退回 1 加签  2 同意 3转交 4抄送
@property (nonatomic, strong) NSString *FeeAppNumber;//费用申请单编号
@property (nonatomic, strong) NSString *ContractNumber;//合同单号
@property (nonatomic, strong) NSString *AdvanceNumber;//借款单号

@property (nonatomic, strong) NSDictionary *dic_APPROVAL;

@property (nonatomic, strong) NSMutableDictionary *dic_AgreeAmount;

@property (nonatomic, strong) NSString  *str_CommonField;

@end
