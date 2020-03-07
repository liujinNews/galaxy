//
//  DocumentSearchController.h
//  galaxy
//
//  Created by hfk on 2017/2/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "MyApplyModel.h"
#import "MyApproveViewCell.h"
#import "FilterBaseViewController.h"
@interface DocumentSearchController : FlowBaseViewController<GPClientDelegate>
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *dic_requst;//下载成功字典
@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据
@property(nonatomic,strong)MyApproveViewCell *cell;


@end
