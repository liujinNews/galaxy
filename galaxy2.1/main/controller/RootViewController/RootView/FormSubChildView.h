//
//  FormSubChildView.h
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormSubChildView : UIView

@property (nonatomic, strong) NSMutableArray *showSetArray;
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, copy) void(^budgetTotalAmountBlock)(NSString *amount);

-(instancetype)initWithType:(NSInteger)type withStatus:(NSInteger)status;

-(void)refresh;

@end
