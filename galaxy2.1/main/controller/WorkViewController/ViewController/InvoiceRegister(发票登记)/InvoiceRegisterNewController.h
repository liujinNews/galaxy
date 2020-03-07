//
//  InvoiceRegisterNewController.h
//  galaxy
//
//  Created by hfk on 2018/11/21.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "InvoiceRegisterData.h"
#import "InvoiceRegisterFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceRegisterNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>

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
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  合同视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  入库单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_StoreApp;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;
/**
 *  发票名称视图
 */
@property(nonatomic,strong)UIView *View_InvoiceName;
@property(nonatomic,strong)UITextField *txf_InvoiceName;
/**
 *  发票日期视图
 */
@property(nonatomic,strong)UIView *View_InvoiceDate;
@property(nonatomic,strong)UITextField *txf_InvoiceDate;
/**
 *  发票代码视图
 */
@property(nonatomic,strong)UIView *View_InvoiceCode;
@property(nonatomic,strong)UITextField *txf_InvoiceCode;
/**
 *  发票号码视图
 */
@property(nonatomic,strong)UIView *View_InvoiceNo;
@property(nonatomic,strong)UITextField *txf_InvoiceNo;
/**
 *  发票抬头视图
 */
@property(nonatomic,strong)UIView *View_InvoiceTitle;
@property(nonatomic,strong)UITextField *txf_InvoiceTitle;
/**
 *  发票金额视图
 */
@property(nonatomic,strong)UIView *View_InvoiceAmount;
@property(nonatomic,strong)UITextField *txf_InvoiceAmount;
/**
 *  发票类型视图
 */
@property(nonatomic,strong)UIView *View_InvoiceType;
@property(nonatomic,strong)UITextField *txf_InvoiceType;
/**
 *  税率视图
 */
@property(nonatomic,strong)UIView *View_TaxRate;
@property(nonatomic,strong)UITextField *txf_TaxRate;
/**
 *  税额视图
 */
@property(nonatomic,strong)UIView *View_Tax;
@property(nonatomic,strong)UITextField *txf_Tax;
/**
 *  不含税金额视图
 */
@property(nonatomic,strong)UIView *View_ExclTax;
@property(nonatomic,strong)UITextField *txf_ExclTax;
/**
 *  寄出时间视图
 */
@property(nonatomic,strong)UIView *View_SendDate;
@property(nonatomic,strong)UITextField *txf_SendDate;
/**
 *  快递单号视图
 */
@property(nonatomic,strong)UIView *View_TrackingNo;
@property(nonatomic,strong)UITextField *txf_TrackingNo;
/**
 *  收到时间视图
 */
@property(nonatomic,strong)UIView *View_ReceivedDate;
@property(nonatomic,strong)UITextField *txf_ReceivedDate;
/**
 *  查验结果视图
 */
@property(nonatomic,strong)UIView *View_CheckResult;
@property(nonatomic,strong)UITextField *txf_CheckResult;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;
/**
 *  审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
@property(nonatomic,strong)UITextField *txf_CcToPeople;

@end

NS_ASSUME_NONNULL_END
