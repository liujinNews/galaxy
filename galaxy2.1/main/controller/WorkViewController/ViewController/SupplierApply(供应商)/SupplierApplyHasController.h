//
//  SupplierApplyHasController.h
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "SupplierFormData.h"
#import "SupplierDetail.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"

@interface SupplierApplyHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)SupplierFormData *FormDatas;
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
 *  供应商名称视图
 */
@property(nonatomic,strong)UIView *View_SupplierName;
/**
 *  供应商编号视图
 */
@property(nonatomic,strong)UIView *View_SupplierCode;
/**
 *  供应商分类视图
 */
@property(nonatomic,strong)UIView *View_SupplierCat;
/**
 *  VMS Code视图
 */
@property(nonatomic,strong)UIView *View_VMSCode;
/**
 *  联系人明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  开户银行视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
/**
 *  开户行网点视图
 */
@property(nonatomic,strong)UIView *View_BankOutlets;
/**
 *  开户行视图
 */
@property(nonatomic,strong)UIView *View_BankName;
/**
 *  开户行城市视图
 */
@property(nonatomic,strong)UIView *View_BankCity;
/**
 *  联系人视图
 */
@property(nonatomic,strong)UIView *View_Contacts;
/**
 *  电话视图
 */
@property(nonatomic,strong)UIView *View_Tel;
/**
 *  地址视图
 */
@property(nonatomic,strong)UIView *View_Addr;
/**
 *  邮编视图
 */
@property(nonatomic,strong)UIView *View_ZipCode;
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
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;


@end
