//
//  ApproveRemindTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ApproveRemindTableViewCell.h"

@interface ApproveRemindTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *view_backView;

@end

@implementation ApproveRemindTableViewCell

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

    
    if ([str_module isEqualToString:@"repayment"]){
        [_view_backView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@80);
        }];
        
        [_btn_Approval updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@70);
        }];
        
        [_btn_Approval setTitle:Custing(@"催款", nil) forState:UIControlStateNormal];
        
        [_lab_content updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view_backView.left).offset(@12);
            make.right.equalTo(self.view_backView.right).offset(@-12);
        }];
        _lab_content.text = [NSString stringWithFormat:@"%@",_dic[@"reason"]];

        _img_right_icon.hidden=YES;
        _lab_right_title.hidden =YES;
        _btn_title.hidden =YES;
        _lab_SeeDetails.hidden = YES;
        _img_Line.hidden=YES;
        _img_Right_Jian.hidden=YES;
        //1是已读
        if ([[NSString stringWithFormat:@"%@",_dic[@"isRead"]]isEqualToString:@"1"]) {
            [_img_Redround setHidden:YES];
        }
        
    }else if ([str_module isEqualToString:@"invoice"]) {
        [_btn_Approval updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@70);
        }];
        [_btn_Approval setTitle:Custing(@"催票", nil) forState:UIControlStateNormal];
        
        [_lab_content updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view_backView.left).offset(@12);
            make.right.equalTo(self.view_backView.right).offset(@-12);
        }];
        _lab_content.text = [NSString stringWithFormat:@"%@",_dic[@"reason"]];

        _img_right_icon.hidden=YES;
        _lab_right_title.hidden =YES;
        _btn_title.hidden =YES;
        _lab_SeeDetails.text = Custing(@"查看详情", nil);
        
        //1是已读
        if ([[NSString stringWithFormat:@"%@",_dic[@"isRead"]]isEqualToString:@"1"]) {
            [_img_Redround setHidden:YES];
        }
        
    }else if ([str_module isEqualToString:@"notices"]) {
        [_btn_Approval updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@120);
        }];
        [_btn_Approval setTitle:Custing(@"公告", nil) forState:UIControlStateNormal];
        
        [_lab_content updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view_backView.left).offset(@12);
            make.right.equalTo(self.view_backView.right).offset(@-12);
            make.height.equalTo(@15);
        }];
        _lab_content.text =[GPUtils getSelectResultWithArray:@[_dic[@"requestorDate"],_dic[@"requestor"]] WithCompare:@" "];
        _lab_content.font=Font_Same_14_20;
        _lab_content.textColor=Color_GrayDark_Same_20;
        
        _lab_depa.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
        _lab_depa.font=Font_Important_15_20;
        _lab_depa.textColor=Color_Black_Important_20;

        _img_right_icon.hidden=YES;
        _lab_right_title.hidden =YES;
        _btn_title.hidden =YES;
        _lab_SeeDetails.text = Custing(@"查看详情", nil);
        //1是已读
        if ([[NSString stringWithFormat:@"%@",_dic[@"isRead"]]isEqualToString:@"1"]) {
            [_img_Redround setHidden:YES];
        }
        
    }else{
        
        [_btn_Approval setTitle:[NSString stringWithFormat:@"%@%@",Custing(@"单号:", nil),[NSString isEqualToNull:_dic[@"serialNo"]]?_dic[@"serialNo"]:@""] forState:UIControlStateNormal];
        _lab_SeeDetails.text = Custing(@"查看详情", nil);
        _lab_depa.text = [NSString isEqualToNull:_dic[@"requestorDept"]]?_dic[@"requestorDept"]:@"";
        
        if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"1"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_ing", nil)];
            _lab_right_title.text = Custing(@"待审批", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"2"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_return",nil)];
            _lab_right_title.text = Custing(@"被退回", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"3"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_reject",nil)];
            _lab_right_title.text = Custing(@"被拒绝", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"4"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_OK",nil)];
            _lab_right_title.text = Custing(@"已同意", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"5"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_pay",nil)];
            _lab_right_title.text = Custing(@"支付完成", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"6"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_recall",nil)];
            _lab_right_title.text = Custing(@"已撤回", nil);
        }else if ([[NSString stringWithFormat:@"%@",_dic[@"status"]]isEqualToString:@"7"]) {
            _img_right_icon.image = [UIImage imageNamed:Custing(@"Approve_invalid",nil)];
            _lab_right_title.text = Custing(@"作废", nil);
        }
        //eflow
        if ([_dic[@"flowCode"]isEqual:[NSNull null]]) {
            _btn_title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _btn_title.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [_btn_title setImage:nil forState:UIControlStateNormal];
            
            [_btn_title setTitle:[NSString isEqualToNull:_dic[@"requestorDate"]]?_dic[@"requestorDate"]:@"" forState:UIControlStateNormal];
            [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
            _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
            if ([NSString isEqualToNull:_dic[@"status"]]) {
                if ([[NSString stringWithFormat:@"%@",_dic[@"status"]] isEqualToString:@"0"]) {
                    _img_right_icon.hidden = YES;
                }
            }
            _lab_content.text = _dic[@"reason"];
        }else{
            if ([_dic[@"flowCode"]isEqualToString:@"F0001"]) {
                [_btn_title setTitle:Custing(@"报销金额:",nil) forState:UIControlStateNormal];
                _lab_money.text = [GPUtils transformNsNumber:[NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"0"];
                [_btn_title setTitle:Custing(@"出差期间",nil) forState:UIControlStateNormal];
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0002"]) {
                [_btn_title setTitle:Custing(@"报销金额:", nil)  forState:UIControlStateNormal];
                _lab_money.text = [GPUtils transformNsNumber:[NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"0"];
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0003"]) {
                [_btn_title setTitle:Custing(@"报销金额:", nil)  forState:UIControlStateNormal];
                _lab_money.text = [GPUtils transformNsNumber:[NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"0"];
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0004"]) {
                [_btn_title setTitle:Custing(@"请假天数",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_time"] forState:UIControlStateNormal];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0005"]) {
                
                [_btn_title setTitle:Custing(@"采购金额",nil) forState:UIControlStateNormal];
                _lab_money.text = [GPUtils transformNsNumber:[NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"0"];
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0006"]) {
                [_btn_title setTitle:Custing(@"借款金额", nil)  forState:UIControlStateNormal];
                _lab_money.text = [GPUtils transformNsNumber:[NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"0"];
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0007"]) {
                [_btn_title setTitle:Custing(@"用途",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_yong"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0008"]) {
                [_btn_title setTitle:Custing(@"内容",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0009"]) {
                [_btn_title setTitle:Custing(@"付款金额",nil) forState:UIControlStateNormal];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0010"]) {
                [_btn_title setTitle:Custing(@"报销金额",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0011"]) {
                [_btn_title setTitle:Custing(@"还款单",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0012"]) {
                [_btn_title setTitle:Custing(@"费用申请单",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0013"]) {
                [_btn_title setTitle:Custing(@"合同审批",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0014"]) {
                [_btn_title setTitle:Custing(@"用车申请",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0015"]) {
                _btn_title.hidden=YES;
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0016"]) {
                _btn_title.hidden=YES;
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0017"]) {
                [_btn_title setTitle:Custing(@"加班时间",nil) forState:UIControlStateNormal];
                [_btn_title setImage:[UIImage imageNamed:@"Approve_content"] forState:UIControlStateNormal];
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0018"]) {
                _btn_title.hidden=YES;
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }else if ([_dic[@"flowCode"]isEqualToString:@"F0019"]) {
                _btn_title.hidden=YES;
                [_btn_title setFrame:CGRectMake(X(_btn_title), Y(_btn_title), 60, HEIGHT(_btn_title))];
                _lab_money.text = [NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"";
                
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            } else{
                _btn_title.hidden=YES;
                //                [_btn_title setTitle:Custing(@"报销金额:",nil) forState:UIControlStateNormal];
                //                _lab_money.text = [GPUtils transformNsNumber:[NSString isEqualToNull:_dic[@"reserved1"]]?_dic[@"reserved1"]:@"0"];
                //                [_btn_title setTitle:Custing(@"出差期间",nil) forState:UIControlStateNormal];
                _lab_content.text = [NSString isEqualToNull:_dic[@"reason"]]?_dic[@"reason"]:@"";
            }
        }
        CGSize size_title = [NSString sizeWithText:_btn_title.titleLabel.text font:_btn_title.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        _lay_title_width.constant = size_title.width+30;
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
