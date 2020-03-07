//
//  STOnePickDateView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "STPickerView.h"
#import "chooseTravelDateView.h"

typedef void(^STPickerDateBlock)(NSString *date);

@interface STOnePickDateView : chooseTravelDateView<chooseTravelDateViewDelegate>

@property (nonatomic, strong) STPickerDateBlock STblock;

@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;//


//type = 1 yyyy/MM/dd   type = 2 yyyy/MM/dd hh:mm:ss
-(STOnePickDateView *)initWithTitle:(NSString *)title Type:(int)type Date:(NSString *)date;

@end
