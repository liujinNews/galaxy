//
//  ByCarOrderController.h
//  galaxy
//
//  Created by APPLE on 2019/12/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByCarOrderController : FlowBaseViewController<GPClientDelegate>
@property (nonatomic, assign) NSInteger totalPage;//系统分页数
@property (nonatomic, strong) NSDictionary *resultDict;//下载成功字典
@property (nonatomic, assign) BOOL requestType;
@end

NS_ASSUME_NONNULL_END
