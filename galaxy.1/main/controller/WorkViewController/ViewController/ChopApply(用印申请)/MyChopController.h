//
//  MyChopController.h
//  galaxy
//
//  Created by hfk on 2017/12/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "MyChopData.h"
#import "MyChopFormData.h"
#import "MyChopDeatil.h"
@interface MyChopController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
表单上数据
 */
@property (nonatomic,strong)MyChopFormData *FormDatas;
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
 *  用印日期视图
 */
@property(nonatomic,strong)UIView *View_ChopDate;
/**
 *  用印日期输入框
 */
@property(nonatomic,strong)UITextField *txf_ChopDate;
/**
 *  用印文件名称视图
 */
@property(nonatomic,strong)UIView *View_ChopFile_Name;
/**
 *  用印文件名称输入框
 */
@property(nonatomic,strong)UITextField *txf_ChopFile_Name;
/**
 *  用印文件类型视图
 */
@property(nonatomic,strong)UIView *View_ChopFile_Type;
/**
 *  用印文件类型输入框
 */
@property(nonatomic,strong)UITextField *txf_ChopFile_Type;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  公章明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  公章明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_Head;
/**
 *  公章明细增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除明细警告框
 */
@property (nonatomic,strong)UIAlertView *Aler_DeleteDetils;
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
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;



@end
