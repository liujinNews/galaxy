//
//  ConferenceBookController.h
//  galaxy
//
//  Created by hfk on 2017/12/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "ConferenceData.h"
#import "ConferenceFormData.h"
#import "ConferenceDeatil.h"
#import "MeetingRoomController.h"

@interface ConferenceBookController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
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
 *  会议名称视图
 */
@property(nonatomic,strong)UIView *View_Name;
@property(nonatomic,strong)UITextField *txf_Name;

/**
 *  会议类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
@property(nonatomic,strong)UITextField *txf_Type;

/**
 *  会议室名称视图
 */
@property(nonatomic,strong)UIView *View_RoomName;
@property(nonatomic,strong)UITextField *txf_RoomName;

/**
 *  开始时间视图
 */
@property(nonatomic,strong)UIView *View_FromDate;
@property(nonatomic,strong)UITextField *txf_FromDate;

/**
 *  结束时间视图
 */
@property(nonatomic,strong)UIView *View_ToDate;
@property(nonatomic,strong)UITextField *txf_ToDate;

/**
 *  参会人
 */
@property (nonatomic, strong) UIView *View_Staff;
@property (nonatomic, strong) UITextField *txf_Staff;

/**
 *  参会人数
 */
@property (nonatomic, strong) UIView *View_MeetingNum;
@property (nonatomic, strong) UITextField *txf_MeetingNum;

/**
 *  需要设备
 */
@property (nonatomic, strong) UIView *View_Equipment;
@property (nonatomic, strong) UITextField *txf_Equipment;

/**
 *  公开方式
 */
@property (nonatomic, strong) UIView *View_OpenMethod;
@property (nonatomic, strong) UITextField *txf_OpenMethod;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  会议议程视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  会议议程tableView的头视图
 */
@property(nonatomic,strong)UIView *View_Head;
/**
 *  会议议程增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除会议议程警告框
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
 *  抄送人txf
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;


@end
