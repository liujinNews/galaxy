//
//  RepayMentRecordDetailController.h
//  galaxy
//
//  Created by hfk on 2019/1/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RepayMentRecordDetailController : RootViewController

/**
 还款方式 1全部还款 2单条还款
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDictionary *recordDict;


@end

NS_ASSUME_NONNULL_END
