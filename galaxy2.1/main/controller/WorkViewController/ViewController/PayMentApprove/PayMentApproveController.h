//
//  PayMentApproveController.h
//  galaxy
//
//  Created by hfk on 2016/11/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "MyApplyModel.h"
#import "ApproveCell.h"
#import "XFSegementView.h"
#import "FilterBaseViewController.h"
@interface PayMentApproveController : FlowBaseViewController<GPClientDelegate,TouchLabelDelegate>
@property (nonatomic, copy) NSString * approvalStatus;//角色登陆区分
@property (nonatomic, strong) UIButton *rightSearchBtn;
@property (nonatomic, strong) UIButton *rightEditBtn;
@property (nonatomic, strong) UIButton *rightFiltBtn;
@property (nonatomic, strong) UIButton *rightCancleBtn;
@property (nonatomic, strong) UIView *dockView;//底部按钮
@property (nonatomic, assign) NSInteger totalPage;//系统分页数
@property (nonatomic, assign) NSDictionary *resultDict;//下载成功字典
@property (nonatomic, strong) ApproveCell *cell;
@property (nonatomic, assign) NSInteger segIndex;//分段器当前选择
@property (nonatomic, strong) NSMutableArray *chooseArray;//记录批量点击
@property (nonatomic, strong) NSMutableArray *agreeArray;
@property (nonatomic, copy) NSString *toApprovalNum;
@property (nonatomic, copy) NSString *toPayNum;
@property (nonatomic, copy) NSString *requestType;//区分viewwillapper是否请求数据
@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign) BOOL  isEditing;
-(id)initWithType:(NSString *)type;
@end
