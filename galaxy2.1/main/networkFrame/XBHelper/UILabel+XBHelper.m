//
//  UILabel+XBHelper.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "UILabel+XBHelper.h"

@implementation UILabel (XBHelper)

//-(UILabel *)initWith_ByTitle_Frame:(CGRect)frame Title:(NSString *)title{
//    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
//    lab.font = Font_Important_15_20;
//    lab.textColor = Color_GrayDark_Same_20;
//    lab.text = title;
//    return lab;
//}

+(UIView *)creation_Lable:(UILabel *)lab model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block{
    NSInteger height = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Y, Main_Screen_Width-30, 32)];
    UILabel *title=[GPUtils createLable:CGRectMake(15,0,XBHelper_Title_Width,20) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view addSubview:title];
    
    CGSize size_title = [@"1" sizeCalculateWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width, 10000) lineBreakMode:title.lineBreakMode];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        lab.frame = CGRectMake(XBHelper_Title_Width+10,0,Main_Screen_Width-XBHelper_Title_Width-25,20);
        lab.font = Font_Important_15_20;
        lab.textColor = Color_form_TextField_20;
        lab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab];
        lab.numberOfLines=0;
        CGSize size = [model.fieldValue sizeCalculateWithFont:lab.font constrainedToSize:CGSizeMake(lab.frame.size.width, 10000) lineBreakMode:lab.lineBreakMode];
        lab.text=model.fieldValue;
        height = 10+size.height;
        lab.frame = CGRectMake(X(lab), Y(lab), WIDTH(lab), height);
        view.frame = CGRectMake(X(view), Y, WIDTH(view), height);
    }else{
        height = 10+size_title.height;
    }
    if (block) {
        block(height);
    }
    return view;
}

@end
