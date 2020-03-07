//
//  ConferenceBookHasController.h
//  galaxy
//
//  Created by hfk on 2017/12/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "ConferenceFormData.h"
#import "ConferenceDeatil.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"

@interface ConferenceBookHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)ConferenceFormData *FormDatas;
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
 *  会议名称视图
 */
@property(nonatomic,strong)UIView *View_Name;
/**
 *  会议类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  会议室名称视图
 */
@property(nonatomic,strong)UIView *View_RoomName;
/**
 *  开始时间视图
 */
@property(nonatomic,strong)UIView *View_FromDate;
/**
 *  结束时间视图
 */
@property(nonatomic,strong)UIView *View_ToDate;
/**
 *  参会人
 */
@property (nonatomic, strong) UIView *View_Staff;
/**
 *  参会人数
 */
@property (nonatomic, strong) UIView *View_MeetingNum;
/**
 *  需要设备
 */
@property (nonatomic, strong) UIView *View_Equipment;
/**
 *  公开方式
 */
@property (nonatomic, strong) UIView *View_OpenMethod;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
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
