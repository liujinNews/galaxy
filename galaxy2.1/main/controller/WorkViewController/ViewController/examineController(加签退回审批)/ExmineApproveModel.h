//
//  ExmineApproveModel.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExmineApproveModel : NSObject

@property (nonatomic, strong) UIView *view_view;
@property (nonatomic, strong) UITextField *txf_txfView;
@property (nonatomic, strong) UIImageView *img_imgView;
@property (nonatomic, strong) NSString *str_HandlerUserId;
@property (nonatomic, strong) NSString *str_HandlerUserName;
@property (nonatomic, strong) NSString *str_HandlerUserNamePhoto;
@property (nonatomic, assign) int str_HandlerUserNamegender;


@end
