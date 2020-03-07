//
//  BusiTvlOrderDateView.h
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RouteBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BusiTvlOrderDateView : UIView<chooseTravelDateViewDelegate>

-(BusiTvlOrderDateView *)initView:(UITextField *)txf_state endTxf:(UITextField *)txf_end;

@property (nonatomic, strong) UITextField *txf_state;
@property (nonatomic, strong) UITextField *txf_end;

@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;
@property (nonatomic, strong) chooseTravelDateView *cho_datelView;//选择弹出框

@property (nonatomic , copy) RouteBlock block;

@end

NS_ASSUME_NONNULL_END
