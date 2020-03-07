//
//  NewAddCostApproveViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/9/4.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

typedef void (^NewAddCostApproveBlock)(HasSubmitDetailModel *model,NSIndexPath *indexPath);

@interface NewAddCostApproveViewController : VoiceBaseController

@property (nonatomic, strong) HasSubmitDetailModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSString *ProcId;
@property (nonatomic, strong) NSString *ClaimType;

@property (nonatomic, strong) NewAddCostApproveBlock Block;
@property (nonatomic, strong) NSDictionary *dic_route;//来自自驾车
@property (nonatomic, strong) RouteModel *model_route;
@property (nonatomic, strong) RouteDidiModel *model_didi;

@property(nonatomic,strong)NSString *dateSource;//数据来源9华住,10携程,12百望发票

/**
 修改申请人参数(OwnerUserId 当前登录用户，UserId所选用户)
 */
@property (nonatomic,strong)NSDictionary *dict_parameter;

@property (nonatomic,assign)NSInteger int_comeEditType;

/**
 财务审核节点是否能够修改费用类别和发票金额开关（0：否/1:是）
 */
@property (nonatomic, assign) BOOL bool_IsAllowModCostCgyOrInvAmt;


@end
