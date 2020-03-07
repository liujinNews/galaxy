//
//  contactsVController.h
//  galaxy
//
//  Created by 赵碚 on 15/7/30.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "RootViewController.h"

typedef void(^ContactsVCBlock)(NSMutableArray *array);
typedef void(^PerformanceSelectBlock)(NSDictionary *SelectDict);

//@protocol ContactsVCDelegate <NSObject>
//@optional
//- (void)contactsVCClickedLoadBtn:(NSMutableArray *)array type:(NSString *)type;
//@end

@interface contactsVController : RootViewController

@property (nonatomic, strong) NSArray *arrClickPeople;//已经选择的数据
//@property (nonatomic, weak) id<ContactsVCDelegate> delegate;

//menutype :1://常用申请人 2://常用同行人员 3://常用一级审批人 4://常用二级审批人
@property (nonatomic, assign) int menutype;
//itemType 1.出差 2.差旅 3.日常 4.请假 5.采购 6.借款 7.物品领用 8.通用审批 9.付款 10专项11还款单12费用申请单13合同审批14用车申请15用印申请16外出申请17加班申请18会议申请19开票申请20撤销申请单21补打卡申请单 22 绩效考核 23业务招待 24车辆维修 25收款 26供应商申请 27补发票
@property (nonatomic, assign) int itemType;
// status 1 选择审批人  2选择申请人  3出差人员选择   4代理人选择   5添加成员   6负责人 7选择联系人 8选择参会人员  9选择知会人 10选择绩效申请人 11受益人 12抄送人 13 选择参训人员  14证明人 15业务经理 16业务负责人
@property (nonatomic, strong)NSString * status;
//是否剔除已选择人员 1 是 2 否
@property (nonatomic, strong) NSString *isclean;
//是否不包含自己
@property (nonatomic, assign) BOOL isCleanSelf;
//是否单选  1 是 2 否
@property (nonatomic, strong)NSString *Radio;
//是否有全部 1 有 2 没有
@property (nonatomic, assign) int isAll;

@property (nonatomic, strong)NSString *flowCode;

@property (nonatomic, copy) ContactsVCBlock Block;
@property (nonatomic, copy) PerformanceSelectBlock  PerfSelectBlock;

@end

