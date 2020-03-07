//
//  NewCalendarController.h
//  galaxy
//
//  Created by hfk on 2018/1/16.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "NewCalendarData.h"
@interface NewCalendarController : VoiceBaseController
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

/**
 表单上数据
 */
@property (nonatomic,strong)NewCalendarData *FormDatas;
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
 主题
 */
@property(nonatomic,strong)UIView *View_Subject;
@property(nonatomic,strong)UITextField *txf_Subject;
/**
 地点
 */
@property(nonatomic,strong)UIView *View_Address;
@property(nonatomic,strong)UITextField *txf_Address;
/**
 开始时间
 */
@property(nonatomic,strong)UIView *View_StartTime;
@property(nonatomic,strong)UITextField *txf_StartTime;
/**
 结束时间
 */
@property(nonatomic,strong)UIView *View_EndTime;
@property(nonatomic,strong)UITextField *txf_EndTime;
/**
 知会人员
 */
@property(nonatomic,strong)UIView *View_Notify;
@property(nonatomic,strong)UITextField *txf_Notify;
/**
私密
 */
@property(nonatomic,strong)UIView *View_Private;
@property(nonatomic,strong)UISwitch *Swh_Private;

/**
 *  项目
 */
@property (nonatomic, strong) UIView *View_Project;
@property (nonatomic, strong) UITextField *txf_Project;
/**
 *  客户名称
 */
@property (nonatomic, strong) UIView *View_Client;
@property (nonatomic, strong) UITextField *txf_Client;
/**
 *  供应商
 */
@property (nonatomic, strong) UIView *View_Supplier;
@property (nonatomic, strong) UITextField *txf_Supplier;
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
 *  附件中图片数组
 */
@property(nonatomic,strong)NSMutableArray *arr_imagesArray;
/**
 *  附件总文件数组
 */
@property(nonatomic,strong)NSMutableArray *arr_totalFileArray;

/**
 展开按钮
 */
@property(nonatomic,strong)UIView *View_LookDetail;
@property(nonatomic,assign)BOOL bool_openDetail;

@end
