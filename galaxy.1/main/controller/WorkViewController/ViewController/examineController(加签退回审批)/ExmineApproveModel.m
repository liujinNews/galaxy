//
//  ExmineApproveModel.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ExmineApproveModel.h"

@implementation ExmineApproveModel

-(instancetype)init{
    self=[super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.view_view = [[UIView alloc]init];
    self.img_imgView = [[UIImageView alloc]init];
    self.txf_txfView = [[UITextField alloc]init];
    self.str_HandlerUserId = @"";
    self.str_HandlerUserName = @"";
    self.str_HandlerUserNamePhoto = @"";
    self.str_HandlerUserNamegender = 0;
}

@end
