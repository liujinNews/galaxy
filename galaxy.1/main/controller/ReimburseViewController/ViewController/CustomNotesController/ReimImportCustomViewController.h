//
//  ReimImportCustomViewController.h
//  galaxy
//
//  Created by hfk on 2018/10/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReimImportCustomViewController : RootViewController

@property (nonatomic, strong) NSDictionary *dict_parameter;

@property (nonatomic,copy) void(^importCustomBackBlock)(NSArray *array);

@end

NS_ASSUME_NONNULL_END
