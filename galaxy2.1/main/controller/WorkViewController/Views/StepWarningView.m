//
//  StepWarningView.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "StepWarningView.h"
@implementation StepWarningView

static StepWarningView_Click _StepBlock;

+(void)initWithViews:(NSInteger)Type view:(StepWarningView *)view controller:(UIViewController *)controller Click:(StepWarningView_Click)Index
{
    _StepBlock = [Index copy];
    __block StepWarningView *step = (StepWarningView *)self;
    if (view) {
        view = [[StepWarningView alloc]init];
    }
    view.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
    view.backgroundColor = [UIColor colorWithRed:((float) 181 / 255.0f) green:((float) 181 / 255.0f) blue:((float) 181 / 255.0f) alpha:0.4f];
    [controller.view addSubview:view];
    step = view;
    
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(30, ((Main_Screen_Height-NavigationbarHeight)/2)-184/2, Main_Screen_Width-60, 184)];
    showView.backgroundColor = Color_form_TextFieldBackgroundColor;
    showView.layer.cornerRadius = 10;
    showView.layer.masksToBounds = YES;
    showView.userInteractionEnabled = YES;
    [view addSubview:showView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH(showView)-(WIDTH(showView)*0.6))/2, 120, WIDTH(showView)*0.6, 40)];
    btn.tag = 1;
    [btn addTarget:view action:@selector(btn_clicks:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:Color_Blue_Important_20];
    [btn setTitle:Custing(@"新的审批步骤", nil) forState:UIControlStateNormal];
    [btn.titleLabel setFont:Font_Same_14_20];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [showView addSubview:btn];
    
    UIButton *btn_x = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(showView)-28, 15, 14, 14)];
    [btn_x setImage:[UIImage imageNamed:@"step_x"] forState:UIControlStateNormal];
    [btn_x addTarget:view action:@selector(btn_clicks:) forControlEvents:UIControlEventTouchUpInside];
    btn_x.tag = 0;
    [showView addSubview:btn_x];
    
    UIImageView *img_w = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(showView)/2-17, 20, 34, 34)];
    [img_w setImage:[UIImage imageNamed:@"step_warning"]];
    [showView addSubview:img_w];
    
    UILabel *lab_1 = [GPUtils createLable:CGRectMake(15, 64, WIDTH(showView)-30, 20) text:Custing(@"当前审批步骤已经被移除", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    [showView addSubview:lab_1];
    
    UILabel *lab_2 = [GPUtils createLable:CGRectMake(15, 84, WIDTH(showView)-30, 20) text:Custing(@"请选择新的审批步骤", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    [showView addSubview:lab_2];
}


-(void)btn_clicks:(UIButton *)btn
{
    if (_StepBlock) {
        _StepBlock(2);
    }
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
