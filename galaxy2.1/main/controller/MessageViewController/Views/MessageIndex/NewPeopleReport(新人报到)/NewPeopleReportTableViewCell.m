//
//  NewPeopleReportTableViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "NewPeopleReportTableViewCell.h"

@implementation NewPeopleReportTableViewCell

-(void)layoutSubviews
{
    _lab_applyJoin.text = Custing(@"申请加入", nil);
    _lab_name.text = [NSString isEqualToNull:_dic[@"requestor"]]?_dic[@"requestor"]:@"";
    _lab_phone.text = [NSString isEqualToNull:_dic[@"requestorAccount"]]?_dic[@"requestorAccount"]:@"";
    userData *data = [userData shareUserData];
    _lab_company.text = data.company;
    if ([_dic[@"isActivated"]intValue]==1) {
        [_btn_OK setBackgroundImage:[UIImage imageNamed:@"NewPeopleReport_BtnOK"] forState:UIControlStateNormal];
        [_btn_OK setTitle:Custing(@"已同意", nil)  forState:UIControlStateNormal];
        _lau_btn_ok_top.constant = 25;
        _btn_OK.userInteractionEnabled = NO;
        _btn_Reject.hidden = YES;
    }
    [_img_icon setImage:[_dic[@"gender"] intValue]==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"]];
    
    if ([NSString isEqualToNull:_dic[@"photoGraph"]]) {
        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:_dic[@"photoGraph"]];
        if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
            [_img_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
        }
    }
    CGSize size_title = [NSString sizeWithText:_lab_applyJoin.text font:_lab_applyJoin.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _lay_applyJoin_width.constant = size_title.width+6.5;
}

- (IBAction)btn_Click:(id)sender {
    [self.delegate NewPeopleReportTableViewCellClickedLoadBtn:_dic isReject:0];
}

- (IBAction)btn_Reject_click:(id)sender {
    [self.delegate NewPeopleReportTableViewCellClickedLoadBtn:_dic isReject:1];
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
