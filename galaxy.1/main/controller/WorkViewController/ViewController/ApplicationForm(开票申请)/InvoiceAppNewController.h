//
//  InvoiceAppNewController.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "InvoiceAppData.h"
#import "InvoiceAppFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceAppNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 表单上数据
 */
@property (nonatomic,strong)InvoiceAppFormData *FormDatas;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView *scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView *dockView;
/**
 *提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 * 开票事由
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextField *txf_Reason;
/**
 * 开票内容
 */
@property(nonatomic,strong)UIView *View_InvContent;
@property(nonatomic,strong)UITextField *txf_InvContent;
/**
 * 开票金额
 */
@property(nonatomic,strong)UIView *View_InvAmount;
@property(nonatomic,strong)GkTextField *txf_InvAmount;
/**
 * 发票类型
 */
@property(nonatomic,strong)UIView *View_InvType;
@property(nonatomic,strong)UITextField *txf_InvType;
/**
 * 税率
 */
@property(nonatomic,strong)UIView *View_TaxRate;
@property(nonatomic,strong)UITextField *txf_TaxRate;
/**
 * 开票周期
 */
@property(nonatomic,strong)UIView *View_InvDuring;
@property(nonatomic,strong)UITextField *txf_InvDuring;
/**
 * 期望开票日期
 */
@property(nonatomic,strong)UIView *View_InvExpectedDate;
@property(nonatomic,strong)UITextField *txf_InvExpectedDate;
/**
 * 预计付款日期
 */
@property(nonatomic,strong)UIView *View_PlanPaymentDate;
@property(nonatomic,strong)UITextField *txf_PlanPaymentDate;
/**
 *合同名称视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 * 合同签订日期
 */
@property(nonatomic,strong)UIView *View_ContractDate;
@property(nonatomic,strong)UITextField *txf_ContractDate;
/**
 * 合同开始日期
 */
@property(nonatomic,strong)UIView *View_EffectiveDate;
@property(nonatomic,strong)UITextField *txf_EffectiveDate;
/**
 * 合同截止日期
 */
@property(nonatomic,strong)UIView *View_ExpiryDate;
@property(nonatomic,strong)UITextField *txf_ExpiryDate;
/**
 * 合同金额
 */
@property(nonatomic,strong)UIView *View_ContractAmount;
@property(nonatomic,strong)UITextField *txf_ContractAmount;
/**
 * 已开票金额
 */
@property(nonatomic,strong)UIView *View_InvoicedAmount;
@property(nonatomic,strong)UITextField *txf_InvoicedAmount;
/**
 * 未开票金额
 */
@property(nonatomic,strong)UIView *View_UnbilledAmount;
@property(nonatomic,strong)UITextField *txf_UnbilledAmount;
/**
 * 收款单
 */
@property(nonatomic,strong)MulChooseShowView *View_ReceiveBill;
/**
 *  开票历史
 */
@property(nonatomic,strong)UITableView *View_InvoiceHistoryTable;
/**
 * 客户
 */
@property(nonatomic,strong)UIView *View_Client;
@property(nonatomic,strong)UITextField *txf_Client;
/**
 * 税号
 */
@property(nonatomic,strong)UIView *View_TaxNumber;
@property(nonatomic,strong)UITextField *txf_TaxNumber;
/**
 * 开户银行
 */
@property(nonatomic,strong)UIView *View_BankName;
@property(nonatomic,strong)UITextField *txf_BankName;
/**
 * 银行账号
 */
@property(nonatomic,strong)UIView *View_BankAccount;
@property(nonatomic,strong)UITextField *txf_BankAccount;
/**
 * 地址
 */
@property(nonatomic,strong)UIView *View_Address;
@property(nonatomic,strong)UITextField *txf_Address;
/**
 * 电话
 */
@property(nonatomic,strong)UIView *View_Tel;
@property(nonatomic,strong)UITextField *txf_Tel;
/**
 * 收件人姓名
 */
@property(nonatomic,strong)UIView *View_ReceiverName;
@property(nonatomic,strong)UITextField *txf_ReceiverName;
/**
 * 电话号码
 */
@property(nonatomic,strong)UIView *View_ReceiverTel;
@property(nonatomic,strong)UITextField *txf_ReceiverTel;
/**
 * 地址
 */
@property(nonatomic,strong)UIView *View_ReceiverAddress;
@property(nonatomic,strong)UITextField *txf_ReceiverAddress;
/**
 * 邮编
 */
@property(nonatomic,strong)UIView *View_ReceiverPostCode;
@property(nonatomic,strong)UITextField *txf_ReceiverPostCode;
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
