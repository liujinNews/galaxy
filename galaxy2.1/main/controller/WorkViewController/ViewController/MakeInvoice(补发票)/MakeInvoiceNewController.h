//
//  MakeInvoiceNewController.h
//  galaxy
//
//  Created by hfk on 2018/6/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "STOnePickView.h"
#import "STOnePickModel.h"
#import "MakeInvoiceData.h"
#import "MakeInvoiceFormData.h"

@interface MakeInvoiceNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MakeInvoiceFormData *FormDatas;
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
 *  原因视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  原因txv
 */
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  付款单视图
 */
@property(nonatomic,strong)UIView *View_Pay;
/**
 *  付款单txf
 */
@property(nonatomic,strong)UITextField *txf_Pay;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Acount;
/**
 *  金额输入框
 */
@property (nonatomic,strong)GkTextField * txf_Acount;
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
 *  发票类型视图
 */
@property(nonatomic,strong)UIView *View_InvoiceType;
/**
 *  发票类型txf
 */
@property(nonatomic,strong)UITextField *txf_InvoiceType;
/**
 *  税率视图
 */
@property(nonatomic,strong)UIView *View_TaxRate;
/**
 *  税率txf
 */
@property(nonatomic,strong)UITextField *txf_TaxRate;
/**
 *  税额视图
 */
@property(nonatomic,strong)UIView *View_Tax;
/**
 *  税额txf
 */
@property(nonatomic,strong)UITextField *txf_Tax;
/**
 *  不含税金额视图
 */
@property(nonatomic,strong)UIView *View_ExclTax;
/**
 *  不含税金额txf
 */
@property(nonatomic,strong)UITextField *txf_ExclTax;
/**
 *  发票视图
 */
@property(nonatomic,strong)UIView *View_File;
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

@end
