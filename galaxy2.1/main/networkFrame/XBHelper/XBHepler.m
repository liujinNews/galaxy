//
//  XBHepler.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "XBHepler.h"
//#import "UILabel+XBHelper.h"
//#import "UITextField+XBHelper.h"

@implementation XBHepler

+(UIView *)creation_textField:(UITextField *)txf model:(MyProcurementModel *)model  isUser:(BOOL)isbool{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    UILabel *lab_title = [GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width, 50) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    lab_title.numberOfLines = 0;
    [view addSubview:lab_title];
    
    txf.font = Font_Important_15_20;
    txf.textColor = Color_form_TextField_20;
    txf.frame=CGRectMake(XBHelper_Title_Width + 27,0,Main_Screen_Width-XBHelper_Title_Width-39, 50);
    txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请输入",nil);
    txf.userInteractionEnabled = isbool;
    [view addSubview:txf];
    if ([NSString isEqualToNull:model.fieldValue]) {
        txf.text = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    return view;
}

+(UIView *)creation_textField:(UITextField *)txf model:(MyProcurementModel *)model  isUser:(BOOL)isbool Y:(NSInteger)Y{
    UIView *view = [self creation_textField:txf model:model isUser:isbool];
    view.frame = CGRectMake(0, Y, WIDTH(view), HEIGHT(view));
    return view;
}


+(UIView *)creation_Lable:(UILabel *)lab model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block{
    NSInteger height = 32;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Y, Main_Screen_Width-30, 48)];
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 maxSize:CGSizeMake(XBHelper_Title_Width, MAXFLOAT)];
    UILabel *title;
    if (size.height<32) {
        title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width,32) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    }else{
        height = size.height+10;
        title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width,height) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    }
    title.numberOfLines = 0;
    [view addSubview:title];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        lab.frame = CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-39,32);
        lab.font = Font_Important_15_20;
        lab.textColor = Color_form_TextField_20;
        lab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab];
        lab.numberOfLines=0;
        CGSize size = [model.fieldValue sizeCalculateWithFont:lab.font constrainedToSize:CGSizeMake(lab.frame.size.width, 10000) lineBreakMode:lab.lineBreakMode];
        lab.text=model.fieldValue;
        lab.frame = CGRectMake(X(lab), Y(lab), WIDTH(lab), 10+size.height);
        if (10+size.height<height) {
            lab.frame = CGRectMake(X(lab), Y(lab), WIDTH(lab), height);
        }else{
            height = 10 +size.height;
        }
        view.frame = CGRectMake(X(view), Y, WIDTH(view), height);
    }
    if (block) {
        block(height);
    }
    return view;
}

+(UIView *)creation_Lable:(UILabel *)lab model:(MyProcurementModel *)model Y:(NSInteger)Y IsAmount:(NSInteger)IsAmount  block:(XBHepler_Look_Block)block{
    UIView *view = [self creation_Lable:lab model:model Y:Y block:block];
    if (IsAmount == 1) {
        lab.text = [GPUtils transformNsNumber:lab.text];
    }
    if (IsAmount == 2) {
        lab.text = [GPUtils TransformNsNumber:lab.text];
    }
    return view;
}

+(UIView *)creation_Txf:(UITextField *)txf model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block{
    NSInteger height = 32;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Y, Main_Screen_Width-30, 48)];
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 maxSize:CGSizeMake(XBHelper_Title_Width, MAXFLOAT)];
    UILabel *title;
    if (size.height<32) {
        title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width,32) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    }else{
        height = size.height+10;
        title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width,height) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    }
    title.numberOfLines = 0;
    [view addSubview:title];
//    if ([NSString isEqualToNull:model.fieldValue]) {
        txf.frame = CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-39,20);
        txf.font = Font_Important_15_20;
        txf.textColor = Color_form_TextField_20;
        txf.textAlignment = NSTextAlignmentLeft;
        [view addSubview:txf];
        CGSize size1 = [model.fieldValue sizeCalculateWithFont:txf.font constrainedToSize:CGSizeMake(txf.frame.size.width, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text=model.fieldValue;
        }
        txf.placeholder = model.tips;
        if (10+size1.height<height) {
            txf.frame = CGRectMake(X(txf), Y(txf), WIDTH(txf), height);
        }else{
            height = 10 +size1.height;
        }
        view.frame = CGRectMake(X(view), Y, WIDTH(view), height);
//    }
    if (block) {
        block(height);
    }
    return view;
}

+(UIView *)creation_Txf_Right:(UITextField *)txf model:(MyProcurementModel *)model Y:(NSInteger)Y block:(XBHepler_Look_Block)block{
    NSInteger height = 32;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Y, Main_Screen_Width-30, 48)];
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 maxSize:CGSizeMake(XBHelper_Title_Width, MAXFLOAT)];
    UILabel *title;
    if (size.height<32) {
        title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width,32) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    }else{
        height = size.height+10;
        title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width,height) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    }
    title.numberOfLines = 0;
    [view addSubview:title];
    txf.frame = CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-39,20);
    txf.font = Font_Important_15_20;
    txf.textColor = Color_form_TextField_20;
    txf.textAlignment = NSTextAlignmentLeft;
    [view addSubview:txf];
    CGSize size1 = [model.fieldValue sizeCalculateWithFont:txf.font constrainedToSize:CGSizeMake(txf.frame.size.width, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        txf.text=model.fieldValue;
    }
    txf.placeholder = model.tips;
    if (10+size1.height<height) {
        txf.frame = CGRectMake(X(txf), Y(txf), WIDTH(txf), height);
    }else{
        height = 10 +size1.height;
    }
    view.frame = CGRectMake(X(view), Y, WIDTH(view), height);
    
    UIImageView *image = [UIImageView imageViewWithImage:[UIImage imageNamed:@"skipImage"]];
    image.frame = CGRectMake(Main_Screen_Width-12-20, 7.5, 20, 20);
    [view addSubview:image];
    
    if (block) {
        block(height);
    }
    return view;
}

+(UIView *)creation_State_Lab:(NSString *)state{
    UILabel *lab;
    if ([NSString isEqualToNull:state]) {
        if ([state isEqualToString:@"4"]||[state isEqualToString:@"5"]||[state isEqualToString:@"6"]) {
            lab = [GPUtils createLable:CGRectMake(Main_Screen_Width-55, 55, 43, 18) text:Custing(@"审批完成", nil) font:Font_Same_12_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
            lab.layer.cornerRadius = 8.5;
            lab.layer.masksToBounds = YES;
            lab.layer.borderWidth = 0.5;
            if ([state isEqualToString:@"4"]) {
                lab.layer.borderColor = Color_Through_LineColor.CGColor;
                lab.layer.backgroundColor = Color_Through_BackColor.CGColor;
                lab.text = Custing(@"审批完成", nil);
            }
            if ([state isEqualToString:@"5"]){
                lab.layer.borderColor = Color_NoPay_LineColor.CGColor;
                lab.layer.backgroundColor = Color_NoPay_BackColor.CGColor;
                lab.text = Custing(@"审批完成(未支付)", nil);
            }
            if ([state isEqualToString:@"6"]){
                lab.layer.borderColor = Color_Through_LineColor.CGColor;
                lab.layer.backgroundColor = Color_Through_BackColor.CGColor;
                lab.text = Custing(@"审批完成(已支付)", nil);
            }
            CGSize size = [NSString sizeWithText:lab.text font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, 17)];
            if (size.width>=26) {
                lab.frame = CGRectMake(Main_Screen_Width-size.width-29, 55, size.width+17, 17);
            }
        }
    }
    if (lab == nil) {
        lab = [UILabel new];
    }
    return lab;
}


@end
