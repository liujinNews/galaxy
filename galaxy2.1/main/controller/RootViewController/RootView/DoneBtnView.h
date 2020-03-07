//
//  DoneBtnView.h
//  galaxy
//
//  Created by hfk on 2017/7/24.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoneBtnView : UIView

@property ( nonatomic, strong) NSArray *sizeArray;

@property ( nonatomic, strong) NSArray *titleArray;
@property ( nonatomic, strong) NSArray *titleColor;
@property ( nonatomic, strong) NSArray *titleBgColor;
@property ( nonatomic, strong) NSArray *titleLineColor;
@property (nonatomic, copy) void (^btnClickBlock)(NSInteger index);
-(void)updateNewFormViewWithTitleArray:(NSArray *)title;
-(void)updateLookFormViewWithTitleArray:(NSArray *)title;

-(void)updateViewWithTitleArray:(NSArray *)title WithTitleColorArray:(NSArray *)titleColor WithBgColor:(NSArray *)bgColor WithLineColroArray:(NSArray *)lineColor WithLineStyle:(NSInteger)style;

-(void)updateViewWithTitleArray:(NSArray *)title WithSizeArray:(NSArray *)sizeArray WithTitleColorArray:(NSArray *)titleColor WithBgColor:(NSArray *)bgColor WithLineColroArray:(NSArray *)lineColor;


@property ( nonatomic, strong) UIButton *btn_SelectAll;

-(void)updateBatchBtnWithTitle:(NSString *)title;
-(void)updateSelectAllBtnWithTitle:(NSString *)title withSelected:(BOOL)selected;
@end
