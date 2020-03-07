//
//  NewAddCostViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/23.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "AddDetailsModel.h"
#import "RouteModel.h"
#import "RouteDidiModel.h"

@interface NewAddCostViewController : VoiceBaseController

//操作类型(1:新增,2:修改,3:查看 4:复制)
@property (nonatomic, assign) NSInteger Action;

//报销类型(1:差旅费,2:日常费,3:专项费)
@property (nonatomic, assign) NSInteger Type;


//消费记录id
@property (nonatomic, assign) NSInteger Id;

/**
 消费记录是否选择
 */
@property (nonatomic, strong) NSString *check;

//是否取消显示费用类别
@property (nonatomic, assign) NSInteger Enabled_Expense;

//是否取消显示在记一笔
@property (nonatomic, assign) NSInteger Enabled_addAgain;

@property (nonatomic, strong) NSString *str_show_title;

@property (nonatomic, strong) NSString *str_expenseCode;//费用类别编码
@property (nonatomic, strong) NSString *str_expenseIcon;//费用类别图片编码
@property (nonatomic, strong) NSString *str_ExpenseCat;//费用大类

//@property (nonatomic, strong) NSString *expenseCode;
@property (nonatomic, strong) NSString *expenseType;
//@property (nonatomic, strong) NSString *expenseIcon;


@property(nonatomic,strong)NSString *dateSource;//数据来源9华住,10携程,12百望发票，13自驾车，14滴滴 16微信 29 差旅一号

@property (nonatomic, strong) AddDetailsModel *model_addDetail;

@property (nonatomic, strong) NSDictionary *dic_route;//来自自驾车
@property (nonatomic, strong) RouteModel *model_route;
@property (nonatomic, strong) RouteDidiModel *model_didi;
@property (nonatomic, strong) NSString *str_payType;




//选择日期
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)chooseTravelDateView *DateChooseView;
/**
 *  日期选择结果
 */
@property(nonatomic,strong)NSString *selectDataString;
//1开始2结束
@property(nonatomic,assign)NSInteger selectDataType;

/**
 补贴类型(一天餐补(默认) 半天餐补0)
 */
@property (nonatomic,strong)NSMutableArray *arr_AllowType;

@property (nonatomic,strong)NSString *str_lastAmount;


/**
 修改申请人参数(OwnerUserId 当前登录用户，UserId所选用户)
 */
@property (nonatomic,strong)NSDictionary *dict_parameter;

@end
