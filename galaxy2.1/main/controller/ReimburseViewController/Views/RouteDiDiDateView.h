//
//  RouteDiDiDateView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RouteBlock)(void);

@interface RouteDiDiDateView : UIView <chooseTravelDateViewDelegate>

-(RouteDiDiDateView *)initView:(UITextField *)txf_state endTxf:(UITextField *)txf_end;

@property (nonatomic, strong) UITextField *txf_state;
@property (nonatomic, strong) UITextField *txf_end;

@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;
@property (nonatomic, strong) chooseTravelDateView *cho_datelView;//选择弹出框

@property (nonatomic , copy) RouteBlock block;

@end
