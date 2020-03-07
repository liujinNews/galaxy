//
//  ReceiptHasController.h
//  galaxy
//
//  Created by hfk on 2018/6/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "ReceiptFormData.h"

@interface ReceiptHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate,UITableViewDelegate,UITableViewDataSource>
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
分割块1
 */
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, assign) NSInteger int_line1;
/**
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
/**
 /本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
/**
 *  收款日期视图
 */
@property(nonatomic,strong)UIView *View_ReceiptDate;
/**
 *  收款方式视图
 */
@property(nonatomic,strong)UIView *View_Method;
/**
 *  类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 分割块2
 */
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, assign) NSInteger int_line2;
/**
 *  合同名称视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  项目名称视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  合同开始日期视图
 */
@property(nonatomic,strong)UIView *View_EffectiveDate;
/**
 *  合同截止日期视图
 */
@property(nonatomic,strong)UIView *View_ExpiryDate;
/**
 *  合同金额视图
 */
@property(nonatomic,strong)UIView *View_ContractAmount;
/**
 *  已回款视图
 */
@property(nonatomic,strong)UIView *View_ReturnedAmount;
/**
 *  未回款视图
 */
@property(nonatomic,strong)UIView *View_UnReturnedAmount;
/**
 *  回款明细
 */
@property(nonatomic,strong)UITableView *View_ReceBillTable;
/**
 分割块1
 */
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, assign) NSInteger int_line3;
/**
 *  开票申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_Application;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
/**
 *  银行名称视图
 */
@property(nonatomic,strong)UIView *View_Bank;
/**
 *  银行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
/**
 分割块3
 */
@property (nonatomic, strong) UIView *view_line4;
@property (nonatomic, assign) NSInteger int_line4;
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
 *  采购审批人视图
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


@end
