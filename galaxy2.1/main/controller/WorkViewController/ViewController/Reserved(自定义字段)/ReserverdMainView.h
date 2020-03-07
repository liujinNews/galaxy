//
//  ReserverdMainView.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/5.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserverdMainModel.h"
#import "ReimShareModel.h"
typedef void(^ReserverdMainBlock)(NSInteger height);

@interface ReserverdMainView : UIView

@property (nonatomic, strong) ReserverdMainBlock Re_block;
@property (nonatomic, strong) ReserverdMainModel *Re_model;
@property (nonatomic, assign) NSInteger int_Height;

@property (nonatomic, strong) UIView *view_1;
@property (nonatomic, strong) UIView *view_2;
@property (nonatomic, strong) UIView *view_3;
@property (nonatomic, strong) UIView *view_4;
@property (nonatomic, strong) UIView *view_5;
@property (nonatomic, strong) UIView *view_6;
@property (nonatomic, strong) UIView *view_7;
@property (nonatomic, strong) UIView *view_8;
@property (nonatomic, strong) UIView *view_9;
@property (nonatomic, strong) UIView *view_10;

@property (nonatomic, strong) UITextField *txf_1;
@property (nonatomic, strong) UITextField *txf_2;
@property (nonatomic, strong) UITextField *txf_3;
@property (nonatomic, strong) UITextField *txf_4;
@property (nonatomic, strong) UITextField *txf_5;
@property (nonatomic, strong) UITextField *txf_6;
@property (nonatomic, strong) UITextField *txf_7;
@property (nonatomic, strong) UITextField *txf_8;
@property (nonatomic, strong) UITextField *txf_9;
@property (nonatomic, strong) UITextField *txf_10;

-(ReserverdMainView *)initArr:(NSMutableArray *)arr isRequiredmsdic:(NSDictionary *)isRequiredmsdic reservedDic:(NSDictionary *)reservedDic UnShowmsArray:(NSMutableArray *)UnShowmsArray view:(UIView *)view model:(ReserverdMainModel *)models block:(ReserverdMainBlock)block;

-(ReserverdMainView *)initReimShareArr:(NSMutableArray *)arr isRequiredmsdic:(NSMutableDictionary *)isRequiredmsdic reservedDic:(NSMutableDictionary *)reservedDic UnShowmsArray:(NSMutableArray *)UnShowmsArray view:(UIView *)view model:(ReserverdMainModel *)models DataModel:(ReimShareModel *)dataModel block:(ReserverdMainBlock)block ;

@end
