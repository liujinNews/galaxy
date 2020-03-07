//
//  CtripDetailListController.h
//  galaxy
//
//  Created by hfk on 2017/3/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "XFSegementView.h"
@interface CtripDetailListController : FlowBaseViewController<GPClientDelegate,TouchLabelDelegate>
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,assign)NSInteger segIndex;//分段器当前选择
@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据
@property (nonatomic, strong) XFSegementView *segementView;

@end
