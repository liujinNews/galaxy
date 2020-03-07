//
//  DelegateSelfCell.m
//  galaxy
//
//  Created by hfk on 2018/8/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "DelegateSelfCell.h"

@implementation DelegateSelfCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_view_headLine) {
        _view_headLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        _view_headLine.backgroundColor = Color_White_Same_20;
        [self.contentView addSubview:_view_headLine];
    }
    if (!_lab_dele) {
        _lab_dele =  [GPUtils createLable:CGRectZero text:Custing(@"代理人", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_dele.numberOfLines = 0;
        [self.contentView addSubview:_lab_dele];
    }
    [_lab_dele makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(XBHelper_Title_Width, 50));
    }];
    
    if (!_lab_deleValue) {
        _lab_deleValue =  [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_deleValue];
    }
    [_lab_deleValue makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@(12+15+XBHelper_Title_Width));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12-15-12-XBHelper_Title_Width, 50));
    }];
    
    if (!_lab_power) {
        _lab_power =  [GPUtils createLable:CGRectZero text:Custing(@"授权范围", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_power.numberOfLines = 0;
        [self.contentView addSubview:_lab_power];
    }
    [_lab_power makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@60);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(XBHelper_Title_Width, 50));
    }];
    
    if (!_lab_powerValue) {
        _lab_powerValue =  [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_powerValue];
    }
    [_lab_powerValue makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@60);
        make.left.equalTo(self.contentView).offset(@(12+15+XBHelper_Title_Width));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12-15-12-XBHelper_Title_Width, 50));
    }];
  
    if (!_view_line) {
        _view_line = [[UIView alloc]initWithFrame:CGRectMake(0, 60, Main_Screen_Width, 0.5)];
        _view_line.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_line];
    }
}

-(void)setDict:(NSDictionary *)dict{
    self.lab_deleValue.text = [NSString stringWithIdOnNO:dict[@"agentUserName"]];
    self.lab_powerValue.text = [[NSString stringWithFormat:@"%@",dict[@"taskApproval"]]isEqualToString:@"1"] ? Custing(@"审批单据", nil):Custing(@"提交单据", nil);
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
