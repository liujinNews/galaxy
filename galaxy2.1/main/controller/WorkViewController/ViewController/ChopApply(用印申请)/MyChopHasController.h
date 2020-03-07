//
//  MyChopHasController.h
//  galaxy
//
//  Created by hfk on 2017/12/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "MyChopFormData.h"
#import "MyChopDeatil.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
@interface MyChopHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
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
 *  用印日期视图
 */
@property(nonatomic,strong)UIView *View_ChopDate;
/**
 *  用印文件视图
 */
@property(nonatomic,strong)UIView *View_ChopFile;
/**
 *  用印文件类别视图
 */
@property(nonatomic,strong)UIView *View_ChopType;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  采购备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;

/**
 *  采购图片视图
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
