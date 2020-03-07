//
//  NewAddressViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"

@protocol NewAddressVCDelegate <NSObject>
@optional
- (void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start;
@end

@interface NewAddressViewController : VoiceBaseController

@property (nonatomic, assign) NSInteger Type;//是否多选。1.单选2.多选
@property (nonatomic, strong) NSArray *arr_Click_Citys;//已经选择的数据
@property (nonatomic, strong) NSString * status;//状态值 只会返回回去，
@property (nonatomic, strong) NSString *isGocity;//是否是出发城市，0,选择城市 1出发城市，2到达城市 3差旅 4日常 5专项
@property (nonatomic, assign) BOOL notOften;//去除常用城市
@property (nonatomic, assign) int isAll;//是否有全部
@property (nonatomic, assign) BOOL isXiecheng;
@property (nonatomic, assign) BOOL OnlyInternal;
@property (nonatomic, weak) id<NewAddressVCDelegate> delegate;
@property (nonatomic,copy) void(^selectAddressBlock)(NSArray *array, NSString *start);

@end
