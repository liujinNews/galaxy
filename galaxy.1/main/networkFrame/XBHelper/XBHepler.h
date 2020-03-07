//
//  XBHepler.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyProcurementModel.h"
//#import "UITextField+XBHelper.h"
//#import "UILabel+XBHelper.h"

typedef void(^XBHepler_Look_Block)(NSInteger height);

@interface XBHepler : NSObject
//创建视图 高度50
+(UIView *)creation_textField:(UITextField *)txf model:(MyProcurementModel *)model  isUser:(BOOL)isbool;
//创建视图 自定义Y轴属性
+(UIView *)creation_textField:(UITextField *)txf model:(MyProcurementModel *)model  isUser:(BOOL)isbool Y:(NSInteger)Y;

+(UIView *)creation_Lable:(UILabel *)lab model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block;

//IsAmount 1 金额 2 汇率
+(UIView *)creation_Lable:(UILabel *)lab model:(MyProcurementModel *)model Y:(NSInteger)Y IsAmount:(NSInteger)IsAmount  block:(XBHepler_Look_Block)block;

+(UIView *)creation_Txf:(UITextField *)txf model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block;

+(UIView *)creation_Txf_Right:(UITextField *)txf model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block;

+(UIView *)creation_State_Lab:(NSString *)state;

@end
