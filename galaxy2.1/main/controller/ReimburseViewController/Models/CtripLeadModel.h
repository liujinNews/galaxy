//
//  CtripLeadModel.h
//  galaxy
//
//  Created by hfk on 2016/10/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CtripLeadModel : NSObject


@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *orderType;//订单类型(酒店:4,机票:2,火车票:3)
@property (nonatomic, copy) NSString *orderDate;//日期信息
@property (nonatomic, copy) NSString *cityName;//城市
@property (nonatomic, copy) NSString *cityCode;//城市代码
@property (nonatomic, copy) NSString *creater;
@property (nonatomic, copy) NSString *orderStatus;//订单状态
@property (nonatomic, copy) NSString *amount;//金额
@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *active;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *journeyNo;
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, copy) NSString *airlineFuelFee;//总金额
@property (nonatomic, copy) NSString *airTicketPrice;//民航发展基金
@property (nonatomic, copy) NSString *developmentFund;//发展基金
@property (nonatomic, copy) NSString *fuelSurcharge;//燃油附加费
@property (nonatomic, copy) NSString *otherTaxes;//其他费用
@property (nonatomic, copy) NSString *taxRate;
@property (nonatomic, copy) NSString *invoiceType;
@property (nonatomic, copy) NSString *invoiceTypeCode;
@property (nonatomic, copy) NSString *invoiceTypeName;
@property (nonatomic, copy) NSString *reimbursementTypId;
@property (nonatomic, copy) NSString *reimbursementTyp;
@property (nonatomic, copy) NSString *expenseCode;
@property (nonatomic, copy) NSString *expenseType;
@property (nonatomic, copy) NSString *expenseIcon;
@property (nonatomic, copy) NSString *expenseCatCode;
@property (nonatomic, copy) NSString *expenseCat;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *isChoosed;

//    "orderDate" : "2019\/05\/18 07:10-2019\/05\/18 09:45",





@end
