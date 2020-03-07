//
//  AnnouncementFormController.h
//  galaxy
//
//  Created by hfk on 2018/2/11.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "AnnouncementData.h"
#import "AnnouncementListModel.h"
@interface AnnouncementFormController : VoiceBaseController
/**
 修改数据
 */
@property (nonatomic,strong)AnnouncementListModel *EditFormData;
/**
 表单上数据
 */
@property (nonatomic,strong)AnnouncementData *FormDatas;
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
标题
 */
@property(nonatomic,strong)UIView *View_Subject;
@property(nonatomic,strong)UITextField *txf_Subject;
/**
发送范围
 */
@property(nonatomic,strong)UIView *View_SendRange;
@property(nonatomic,strong)UITextField *txf_SendRange;
/**
 发送人
 */
@property(nonatomic,strong)UIView *View_Sender;
@property(nonatomic,strong)UITextField *txf_Sender;
/**
发送内容
 */
@property(nonatomic,strong)UIView *View_Content;
@property(nonatomic,strong)UITextView *txv_Content;
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

@property(nonatomic,assign)NSInteger int_EditType;

@end
