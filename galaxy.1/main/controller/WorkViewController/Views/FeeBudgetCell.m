//
//  FeeBudgetCell.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FeeBudgetCell.h"

@implementation FeeBudgetCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab_name) {
        _lab_name=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_name];
    }
    [_lab_name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(88, 19));
    }];
    
    if (!_lab_amount) {
        _lab_amount=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_amount];
    }
    [_lab_amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@100);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-100-55, 19));
    }];
    
    if (!_btn_delete) {
        _btn_delete = [GPUtils createButton:CGRectZero action:@selector(delete:) delegate:self];
        [_btn_delete setImage:[UIImage imageNamed:@"cell_common_delete"] forState:UIControlStateNormal];
        _btn_delete.hidden=YES;
        [self.contentView addSubview:_btn_delete];
    }
    [_btn_delete makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(40, 39));
    }];
    
    if (!_lab_content) {
        _lab_content=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_content.numberOfLines=0;
        [_lab_content sizeToFit];
        [self.contentView addSubview:_lab_content];
    }
    [_lab_content makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_name.bottom).offset(@2);
        make.left.equalTo(self.contentView).offset(@12);
        make.right.equalTo(self.contentView).offset(@-12);
    }];

    if (!_lab_remark) {
        _lab_remark=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_remark.numberOfLines=0;
        [_lab_remark sizeToFit];
        [self.contentView addSubview:_lab_remark];
    }
    [_lab_remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_content.bottom).offset(@2);
        make.left.equalTo(self.contentView).offset(@12);
        make.right.equalTo(self.contentView).offset(@-12);
    }];

}

-(void)configCellWith:(FormSubChildModel *)model withStatus:(NSInteger)status{
    self.lab_name.text = model.str_param1;
    self.lab_amount.text = model.str_param2;
    if (status==1) {
        _btn_delete.hidden =NO;
    }else{
        _btn_delete.hidden =YES;
    }
    self.lab_content.text = model.str_param3;
    self.lab_remark.text = model.str_param4;
}
-(void)delete:(id)sender{
    if (self.deleteBtnClickedBlock) {
        self.deleteBtnClickedBlock(sender);
    }
}

+ (CGFloat)cellHeightWithObj:(FormSubChildModel *)obj{
    CGFloat cellHeight =10+19+2+9;
    if (obj.str_param3) {
        CGSize size = [obj.str_param3 sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += (size.height+2);
    }
    if (obj.str_param4) {
        CGSize size = [obj.str_param4 sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += (size.height+2);
    }
    cellHeight = (cellHeight>=50?cellHeight:50);
    return cellHeight;
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
