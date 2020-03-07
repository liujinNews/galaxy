//
//  InvoiceRegisterHasController.h
//  galaxy
//
//  Created by hfk on 2018/11/21.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "InvoiceRegisterFormData.h"
#import "MainReleSubInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceRegisterHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)InvoiceRegisterFormData *FormDatas;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView * dockView;
/**
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  合同视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  入库单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_StoreApp;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
/**
 *  发票名称视图
 */
@property(nonatomic,strong)UIView *View_InvoiceName;
/**
 *  发票日期视图
 */
@property(nonatomic,strong)UIView *View_InvoiceDate;
/**
 *  发票代码视图
 */
@property(nonatomic,strong)UIView *View_InvoiceCode;
/**
 *  发票号码视图
 */
@property(nonatomic,strong)UIView *View_InvoiceNo;
/**
 *  发票抬头视图
 */
@property(nonatomic,strong)UIView *View_InvoiceTitle;
/**
 *  发票金额视图
 */
@property(nonatomic,strong)UIView *View_InvoiceAmount;
/**
 *  发票类型视图
 */
@property(nonatomic,strong)UIView *View_InvoiceType;
/**
 *  税率视图
 */
@property(nonatomic,strong)UIView *View_TaxRate;
/**
 *  税额视图
 */
@property(nonatomic,strong)UIView *View_Tax;
/**
 *  不含税金额视图
 */
@property(nonatomic,strong)UIView *View_ExclTax;
/**
 *  寄出时间视图
 */
@property(nonatomic,strong)UIView *View_SendDate;
/**
 *  快递单号视图
 */
@property(nonatomic,strong)UIView *View_TrackingNo;
/**
 *  收到时间视图
 */
@property(nonatomic,strong)UIView *View_ReceivedDate;
/**
 *  查验结果视图
 */
@property(nonatomic,strong)UIView *View_CheckResult;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 已登记发票信息
 */
@property(nonatomic,strong)MainReleSubInfoView *View_InvoiceRegAppInfo;
/**
 *  采购审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;

//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, strong) UIView *view_line4;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;
@property (nonatomic, assign) NSInteger int_line4;


@end

NS_ASSUME_NONNULL_END
