//
//  BusiTvlOrderModel.h
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusiTvlOrderModel : NSObject

@property (nonatomic, strong) NSString *actual_price;       //实付金额（总金额-券抵扣金额）
@property (nonatomic, strong) NSString *baoxiao_status;     //报销状态
@property (nonatomic, strong) NSString *call_phone;         //叫车人手机号
@property (nonatomic, strong) NSString *city_name;          //城市名称
@property (nonatomic, strong) NSString *departure_time;     //出发时间
@property (nonatomic, strong) NSString *end_name;           //目的地地址

@property (nonatomic, strong) NSString *expenseCat;
@property (nonatomic, strong) NSString *expenseCatCode;
@property (nonatomic, strong) NSString *expenseCode;
@property (nonatomic, strong) NSString *expenseIcon;
@property (nonatomic, strong) NSString *expenseType;


@property (nonatomic, strong) NSString *finish_time;
@property (nonatomic, strong) NSString *imported;
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *normal_distance;    //总里程
@property (nonatomic, strong) NSString *order_id;           //订单ID
@property (nonatomic, strong) NSString *passenger_phone;    //乘车人手机号
@property (nonatomic, strong) NSString *pay_time;           //支付时间
@property (nonatomic, strong) NSString *pay_type;           //支付方式（0-企业 1-个人 2-混合）
@property (nonatomic, strong) NSString *personal_real_pay;  //个人实际支付
@property (nonatomic, strong) NSString *company_real_pay;   //企业实际支付

@property (nonatomic, strong) NSString *reimbursementTypId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *require_level;
@property (nonatomic, strong) NSString *start_name;         //出发地地址
@property (nonatomic, strong) NSString *status;             //订单状态（2-已支付 3-已退款 4-已取消 7-部分退款）
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, strong) NSString *use_car_type;       //用车方式
@property (nonatomic, strong) NSString *use_car_config_id;



+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+(RouteModel *)DidiChangeRouteModle:(BusiTvlOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
