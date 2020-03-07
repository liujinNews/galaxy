//
//  ReimShareMainView.h
//  galaxy
//
//  Created by hfk on 2017/9/20.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReimShareCell.h"
#import "ReimShareModel.h"
#import "MyProcurementModel.h"

@interface ReimShareMainView : UIView<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
/**
 *  分摊明细视图
 */
@property(nonatomic,strong)UIView *ShareDetailView;
/**
 *  明细箭头按钮
 */
@property(nonatomic,strong)UIImageView *ShareDetailClickImg;

@property(nonatomic,strong)UIView *TableViewLine;
/**
 *  消费记录tableView
 */
@property(nonatomic,strong)UITableView *ShareTableView;
@property(nonatomic,strong)UIView *ShareHeadView;

/**
 *  子表cell
 */
@property (nonatomic,strong)ReimShareCell *ShareCell;
/**
 *  总金额视图
 */
@property(nonatomic,strong)UIView *TotolAmountView;
@property(nonatomic,strong)UITextField *txf_Amount;

/**
 *  采购增加明细按钮视图
 */
@property(nonatomic,strong)UIView *AddDetailsView;
/**
 *  判断分摊是否打开
 */
@property(nonatomic,assign)BOOL  isOpenShare;

/**
 费用分摊视图
 
 @param formShowData 表单显示控制
 @param formData 表单显示数据
 @param editType 编辑类型1:新增2:查看3:审批修改
 @param comePlace 来源 1:差旅2日常3专项4付款
 */
-(void)updateReimShareMainViewWith:(NSMutableArray *)formShowData WithData:(NSMutableArray *)formData WithEditType:(NSInteger)editType WithComePlace:(NSInteger)comePlace;

@property(nonatomic,strong)NSMutableArray *formShowData;
@property(nonatomic,strong)NSMutableArray *formData;
@property(nonatomic,assign)NSInteger editType;
@property(nonatomic,assign)NSInteger comePlace;
@property(nonatomic,assign)NSInteger MainHeight;

@property(nonatomic,assign)NSInteger tableHeight;
@property(nonatomic,copy)NSString *totalAmount;

//type1新增2修改 comeplace1差旅2日常3专项4付款
@property (copy, nonatomic) void(^ReimDoneClickedBlock)(NSInteger type, NSInteger comeplace, ReimShareModel *model);

-(void)updateMainView;
@end

