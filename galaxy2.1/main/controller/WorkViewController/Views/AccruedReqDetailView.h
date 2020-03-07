//
//  AccruedReqDetailView.h
//  galaxy
//
//  Created by APPLE on 2020/1/14.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PaymentExpDetailCell.h"
#import "AccruedReqDetailCell.h"
//#import "PaymentExpDetail.h"
#import "AccruedReqDetail.h"
#import "MyProcurementModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccruedReqDetailView : UIView

/**
 费用明细视图
 
 @param data 表单显示数据以及相关数据
 @param editType 编辑类型1:新增2:查看3:审批修改
 @param comePlace 来源
 */
-(void)updatePaymentExpMainViewWithData:(NSMutableArray *)formData WithEditType:(NSInteger)editType;

//type1新增2修改3删除4财务修改 index:点击的index
//@property (nonatomic, copy) void(^PaymentExpBackClickedBlock)(NSInteger type, NSInteger index, PaymentExpDetail *model);
//
//@property (nonatomic, copy) void(^PaymentLeadClickedBlock)(void);
@property (nonatomic, copy) void(^AccruedReqBackClickedBlock)(NSInteger type, NSInteger index, AccruedReqDetail *model);

@property (nonatomic, copy) void(^AccruedLeadClickedBlock)(void);

-(void)updateTableView;

@end

NS_ASSUME_NONNULL_END

