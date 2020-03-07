//
//  ContractRelectInfoCell.m
//  galaxy
//
//  Created by hfk on 2018/6/4.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ContractRelectInfoCell.h"

@implementation ContractRelectInfoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=Color_BorrowLine_Same_20;
        [self createView];
    }
    return self;
}

-(void)createView{

    if (!_lab_No) {
        _lab_No=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_No];
    }
    [_lab_No makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(@12);
        make.width.equalTo(@65);
    }];
    
    if (!_lab_Date) {
        _lab_Date=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Date];
    }
    [_lab_Date makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(@86);
        make.width.equalTo(@75);
    }];
    
    if (!_lab_Amount) {
        _lab_Amount=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Amount];
    }
    
    [_lab_Amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.lab_Date.right);
        make.right.equalTo(self.contentView).offset(@-12);
    }];
    
    if (!_line_View) {
        _line_View=[[UIView alloc]init];
        _line_View.backgroundColor=Color_LineGray_Same_20;
        [self.contentView addSubview:_line_View];
    }
    
    [_line_View makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

-(void)configCellWithDict:(NSDictionary *)dict withIndex:(NSInteger)index withTipDict:(NSDictionary *)tipDict{
    if ([tipDict[@"Key"]floatValue]==3) {
        self.lab_No.text=[NSString stringWithIdOnNO:dict[@"serialNo"]];
        self.lab_No.textColor=Color_Blue_Important_20;
    }else{
        self.lab_No.text=[NSString stringWithFormat:@"%ld",index];
        self.lab_No.textColor=Color_GrayDark_Same_20;
    }
    self.lab_Date.text=[NSString stringWithIdOnNO:dict[@"finishDate"]];
    self.lab_Amount.text=[GPUtils transformNsNumber:dict[@"amount"]];
    
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
