//
//  InvoiceAppHasController.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "InvoiceAppFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceAppHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
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
@property (nonatomic,strong)UIView *contentView;
/**
 *  下部按钮底层视图
 */
@property (nonatomic, strong) DoneBtnView *dockView;
/**
 *  内容1视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 * 开票事由
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 * 开票内容
 */
@property(nonatomic,strong)UIView *View_InvContent;
/**
 * 开票金额
 */
@property(nonatomic,strong)UIView *View_InvAmount;
/**
 * 发票类型
 */
@property(nonatomic,strong)UIView *View_InvType;
/**
 * 税率
 */
@property(nonatomic,strong)UIView *View_TaxRate;
/**
 * 开票周期
 */
@property(nonatomic,strong)UIView *View_InvDuring;
/**
 * 期望开票日期
 */
@property(nonatomic,strong)UIView *View_InvExpectedDate;
/**
 * 预计付款日期
 */
@property(nonatomic,strong)UIView *View_PlanPaymentDate;
/**
 *合同名称视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 * 合同签订日期
 */
@property(nonatomic,strong)UIView *View_ContractDate;
/**
 * 合同开始日期
 */
@property(nonatomic,strong)UIView *View_EffectiveDate;
/**
 * 合同截止日期
 */
@property(nonatomic,strong)UIView *View_ExpiryDate;
/**
 * 合同金额
 */
@property(nonatomic,strong)UIView *View_ContractAmount;
/**
 * 已开票金额
 */
@property(nonatomic,strong)UIView *View_InvoicedAmount;
/**
 * 未开票金额
 */
@property(nonatomic,strong)UIView *View_UnbilledAmount;
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
/**
 * 税号
 */
@property(nonatomic,strong)UIView *View_TaxNumber;
/**
 * 开户银行
 */
@property(nonatomic,strong)UIView *View_BankName;
/**
 * 银行账号
 */
@property(nonatomic,strong)UIView *View_BankAccount;
/**
 * 地址
 */
@property(nonatomic,strong)UIView *View_Address;
/**
 * 电话
 */
@property(nonatomic,strong)UIView *View_Tel;
/**
 * 收件人姓名
 */
@property(nonatomic,strong)UIView *View_ReceiverName;
/**
 * 电话号码
 */
@property(nonatomic,strong)UIView *View_ReceiverTel;
/**
 * 地址
 */
@property(nonatomic,strong)UIView *View_ReceiverAddress;
/**
 * 邮编
 */
@property(nonatomic,strong)UIView *View_ReceiverPostCode;
/**
 * 是否回款
 */
@property(nonatomic,strong)UIView *View_Payback;
@property(nonatomic,strong)UITextField *txf_Payback;
/**
 * 回款金额
 */
@property(nonatomic,strong)UIView *View_PaybackAccount;
@property(nonatomic,strong)UITextField *txf_PaybackAccount;
/**
 * 发票号码
 */
@property(nonatomic,strong)UIView *View_InvNumber;
@property(nonatomic,strong)UITextField *txf_InvNumber;
/**
 * 发票日期
 */
@property(nonatomic,strong)UIView *View_InvDate;
@property(nonatomic,strong)UITextField *txf_InvDate;
/**
 * 发票
 */
@property(nonatomic,strong)UIView *View_InvFiles;
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
 *  审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
/**
 *  审批人头像
 */
@property(nonatomic,strong)UIImageView *View_ApproveImg;
/**
 *  审批人Label
 */
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
@property (nonatomic, strong) UIView *view_line5;
@property (nonatomic, strong) UIView *view_line6;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;
@property (nonatomic, assign) NSInteger int_line4;
@property (nonatomic, assign) NSInteger int_line5;
@property (nonatomic, assign) NSInteger int_line6;


@end

NS_ASSUME_NONNULL_END
