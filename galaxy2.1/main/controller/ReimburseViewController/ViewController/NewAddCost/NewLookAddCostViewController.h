//
//  NewLookAddCostViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/4/5.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@interface NewLookAddCostViewController : VoiceBaseController

//消费记录id
@property (nonatomic, assign) NSInteger Id;

//是否取消显示费用类别
@property (nonatomic, assign) NSInteger Enabled_Expense;

//操作类型(1:新增,2:修改,3:查看)
@property (nonatomic, assign) NSInteger Action;

//报销类型(1:差旅费,2:日常费,3:专项费)
@property (nonatomic, assign) NSInteger Type;

@property (nonatomic, strong) NSString *TaskId;

@property (nonatomic, strong) NSString *GridOrder;

@property(nonatomic,strong)NSString *dateSource;//数据来源9华住,10携程,12百望发票

@property (nonatomic, strong) HasSubmitDetailModel *model_has;

@property (nonatomic, strong) NSDictionary *dic_route;//来自自驾车
@property (nonatomic, strong) RouteModel *model_route;
@property (nonatomic, strong) RouteDidiModel *model_didi;

/**
 修改申请人参数(OwnerUserId 当前登录用户，UserId所选用户)
 */
@property (nonatomic,strong)NSDictionary *dict_parameter;

@end
