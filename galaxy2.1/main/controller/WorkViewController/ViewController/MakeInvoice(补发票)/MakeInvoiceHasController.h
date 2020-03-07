//
//  MakeInvoiceHasController.h
//  galaxy
//
//  Created by hfk on 2018/6/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MakeInvoiceFormData.h"

@interface MakeInvoiceHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>

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
 *  原因视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  付款单视图
 */
@property(nonatomic,strong)UIView *View_Pay;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Acount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
/**
 汇率
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
/**
 本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
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

//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;


@end
