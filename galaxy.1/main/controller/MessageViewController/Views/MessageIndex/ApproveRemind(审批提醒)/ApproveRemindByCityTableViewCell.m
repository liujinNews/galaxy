//
//  ApproveRemindByCityTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ApproveRemindByCityTableViewCell.h"

@implementation ApproveRemindByCityTableViewCell

-(void)layoutSubviews
{
//    _view_backView.layer.shadowOffset = CGSizeMake(0, 1);
//    _view_backView.layer.shadowOpacity = 0.25;
//    _view_backView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
//    _view_backView.layer.shadowOffset = CGSizeMake(2, 2);
//    _view_backView.layer.cornerRadius = 15;
    
    NSString *str_module=[NSString stringWithFormat:@"%@",_dic[@"module"]];

    _lab_urge.layer.cornerRadius = 8.0f;
    _lab_urge.layer.masksToBounds = YES;
    _lab_urge.text = Custing(@"催办", nil);
    _lab_urge.hidden = ![str_module isEqualToString:@"urge"];

    [_btn_Approval setTitle:[NSString stringWithFormat:@"%@%@",Custing(@"单号:", nil),[NSString isEqualToNull:_dic[@"serialNo"]]?_dic[@"serialNo"]:@""] forState:UIControlStateNormal];
    _lab_Destination.text = Custing(@"目的地", nil);
    _lab_SeeDetails.text = Custing(@"查看详情", nil);
    _lab_depa.text = [NSString isEqualToNull:_dic[@"requestorDept"]]?_dic[@"requestorDept"]:@"";
    
    if ([str_module isEqualToString:@"demand"]) {
        _img_right_icon.image=nil;
        _lab_content.text =[NSString isEqualToNull:_dic[@"reason"]] ? [NSString stringWithFormat:@"%@",_dic[@"reason"]]:@"";
        [_btn_title setTitle:Custing(@"出差期间", nil) forState:UIControlStateNormal];
        _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
        _lab_city.text = [NSString isEqualToNull:_dic[@"reserved2"]]?_dic[@"reserved2"]:@"";
        //1是已读
        if ([[NSString stringWithFormat:@"%@",_dic[@"isRead"]]isEqualToString:@"1"]) {
            [_img_Redround setHidden:YES];
        }
        CGSize size_title = [NSString sizeWithText:_btn_title.titleLabel.text font:_btn_title.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _lay_btnTitle_width.constant = size_title.width+30;
        
        CGSize size_depar = [NSString sizeWithText:_lab_Destination.text font:_lab_Destination.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _lay_labDestination_width.constant = size_depar.width+1.5;

        _lab_right_title.text = @"";
    }else{
        if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"1"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_ing",nil)];
            _lab_right_title.text = Custing(@"待审批",nil);
            
            _lab_content.text = [NSString stringWithFormat:@"%@%@",_dic[@"requestor"],Custing(@"的出差申请需要您审批", nil)];
            [_btn_title setTitle:Custing(@"出差期间", nil) forState:UIControlStateNormal];
            _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
            _lab_city.text = [NSString isEqualToNull:_dic[@"reserved2"]]?_dic[@"reserved2"]:@"";
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"2"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_return",nil)];
            _lab_right_title.text = Custing(@"被退回",nil);
            _lab_content.text = [NSString stringWithFormat:@"%@",Custing(@"您提交的出差申请被退回",nil)];
            [_btn_title setTitle:Custing(@"出差期间",nil) forState:UIControlStateNormal];
            _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
            _lab_city.text = [NSString isEqualToNull:_dic[@"reserved2"]]?_dic[@"reserved2"]:@"";
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"3"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_reject",nil)];
            _lab_right_title.text = Custing(@"被拒绝",nil);
            
            _lab_content.text = [NSString stringWithFormat:@"%@",Custing(@"您提交的出差申请被拒绝", nil) ];
            [_btn_title setTitle:Custing(@"出差期间",nil) forState:UIControlStateNormal];
            _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
            _lab_city.text = [NSString isEqualToNull:_dic[@"reserved2"]]?_dic[@"reserved2"]:@"";
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"4"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_OK",nil)];
            _lab_right_title.text = Custing(@"已同意",nil);
            
            _lab_content.text = [NSString stringWithFormat:@"%@",Custing(@"您的出差申请已同意，请知晓", nil) ];
            [_btn_title setTitle:Custing(@"出差期间",nil) forState:UIControlStateNormal];
            _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
            _lab_city.text = [NSString isEqualToNull:_dic[@"reserved2"]]?_dic[@"reserved2"]:@"";
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"5"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_pay",nil)];
            _lab_right_title.text = Custing(@"支付完成",nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"6"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_recall",nil)];
            _lab_right_title.text = Custing(@"已撤回", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"7"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_invalid",nil)];
            _lab_right_title.text = Custing(@"作废",nil);
        }
        CGSize size_title = [NSString sizeWithText:_btn_title.titleLabel.text font:_btn_title.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _lay_btnTitle_width.constant = size_title.width+30;
        
        CGSize size_depar = [NSString sizeWithText:_lab_Destination.text font:_lab_Destination.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _lay_labDestination_width.constant = size_depar.width+1.5;
        
        //1是已读
        if ([[NSString stringWithFormat:@"%@",_dic[@"isRead"]]isEqualToString:@"1"]) {
            [_img_Redround setHidden:YES];
        }
        _lab_right_title.text = @"";
    }
    self.view_backView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.lab_content.textColor = [XBColorSupport darkColor];
    self.img_Line.backgroundColor = [XBColorSupport supportimgLine];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
