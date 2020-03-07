//
//  ReceiptNewController.h
//  galaxy
//
//  Created by hfk on 2018/6/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "STOnePickView.h"
#import "STOnePickModel.h"
#import "ReceiptData.h"
#import "ReceiptFormData.h"

@interface ReceiptNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 表单上数据
 */
@property (nonatomic,strong)ReceiptFormData *FormDatas;
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
 *  收款事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  收款事由输入框
 */
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
/**
 *  金额输入框
 */
@property (nonatomic,strong)GkTextField * txf_Amount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 *  报销金额大写txf
 */
@property(nonatomic,strong)UITextField *txf_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
/**
 /本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
/**
 *  收款日期视图
 */
@property(nonatomic,strong)UIView *View_ReceiptDate;
/**
 *  日期label
 */
@property (nonatomic,strong)UITextField *txf_ReceiptDate;
/**
 *  收款方式视图
 */
@property(nonatomic,strong)UIView *View_Method;
/**
 *  收款方式label
 */
@property (nonatomic,strong)UITextField *txf_Method;
/**
 *  类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  类型Label
 */
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  合同名称视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  项目名称视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  项目名称Label
 */
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  合同开始日期视图
 */
@property(nonatomic,strong)UIView *View_EffectiveDate;
/**
 *  合同开始日期Label
 */
@property(nonatomic,strong)UITextField *txf_EffectiveDate;
/**
 *  合同截止日期视图
 */
@property(nonatomic,strong)UIView *View_ExpiryDate;
/**
 *  合同截止日期Label
 */
@property(nonatomic,strong)UITextField *txf_ExpiryDate;
/**
 *  合同金额视图
 */
@property(nonatomic,strong)UIView *View_ContractAmount;
/**
 *  合同金额Label
 */
@property(nonatomic,strong)UITextField *txf_ContractAmount;
/**
 *  已回款视图
 */
@property(nonatomic,strong)UIView *View_ReturnedAmount;
/**
 *  已回款Label
 */
@property(nonatomic,strong)UITextField *txf_ReturnedAmount;
/**
 *  未回款视图
 */
@property(nonatomic,strong)UIView *View_UnReturnedAmount;
/**
 *  未回款Label
 */
@property(nonatomic,strong)UITextField *txf_UnReturnedAmount;
/**
 *  回款明细
 */
@property(nonatomic,strong)UITableView *View_ReceBillTable;
/**
 *  开票申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_Application;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
/**
 *  客户Label
 */
@property (nonatomic,strong)UITextField * txf_Client;
/**
 *  银行名称视图
 */
@property(nonatomic,strong)UIView *View_Bank;
/**
 *  银行名称Label
 */
@property (nonatomic,strong)UITextField * txf_Bank;
/**
 *  银行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
/**
 * 银行账户Label
 */
@property (nonatomic,strong)UITextField * txf_BankAccount;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  备注输入框
 */
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
/**
 *  审批人头像
 */
@property(nonatomic,strong)UIImageView *View_ApproveImg;
/**
 *  审批人Label
 */
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;

@end
