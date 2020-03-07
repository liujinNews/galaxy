//
//  ReserverdLookMainView.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReserverdLookMainViewBlock)(NSInteger height);

@interface ReserverdLookMainView : UIView

@property (nonatomic, assign) NSInteger int_Height;
@property (nonatomic, strong) ReserverdLookMainViewBlock block;

+(ReserverdLookMainView *)initArr:(NSArray *)arr view:(UIView *)view block:(ReserverdLookMainViewBlock)block;

@end
