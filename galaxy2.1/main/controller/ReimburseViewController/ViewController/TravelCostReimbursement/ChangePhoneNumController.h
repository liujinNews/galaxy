//
//  ChangePhoneNumController.h
//  galaxy
//
//  Created by hfk on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"


@interface ChangePhoneNumController : RootViewController

/**
 类型 1:电话 2:银行账号
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *str_content;


@property (nonatomic, copy) void(^numDataChangeBlock)(NSString *numData, NSInteger type);



@end
