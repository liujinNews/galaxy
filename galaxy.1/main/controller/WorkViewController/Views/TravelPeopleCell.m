//
//  TravelPeopleCell.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "TravelPeopleCell.h"

@implementation TravelPeopleCell
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
    if (!_lab_city) {
        _lab_city=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_city];
    }
    [_lab_city makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(88, 19));
    }];
    
    if (!_lab_name) {
        _lab_name=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_name.numberOfLines=0;
        [self.contentView addSubview:_lab_name];
    }
    [_lab_name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.equalTo(self.contentView).offset(@100);
        make.right.equalTo(self.contentView).offset(@-55);
        make.height.equalTo(19);
    }];
    
    
    if (!_lab_date) {
        _lab_date=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_date.numberOfLines=0;
        [self.contentView addSubview:_lab_date];
    }
    
    [_lab_date makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_city.bottom).offset(@2);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(88, 30));
    }];
    
    if (!_lab_idNum) {
        _lab_idNum=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_idNum];
    }
    [_lab_idNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_name.bottom).offset(@2);
        make.left.equalTo(self.contentView).offset(@100);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-100-12, 15));
    }];
    
    if (!_lab_remark) {
        _lab_remark=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_remark.numberOfLines=0;
        [_lab_remark sizeToFit];
        [self.contentView addSubview:_lab_remark];
    }
    [_lab_remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_idNum.bottom).offset(@2);
        make.left.equalTo(self.contentView).offset(@100);
        make.right.equalTo(self.contentView).offset(@-55);
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
}

-(void)configCellWith:(FormSubChildModel *)model withStatus:(NSInteger)status{
    self.lab_city.text = model.str_param1;
    if (model.str_param2) {
        CGSize size = [model.str_param2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-100-55, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        [self.lab_name updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(size.height);
        }];
    }
    self.lab_name.text = model.str_param2;
    self.lab_date.text = model.str_param3;
    self.lab_idNum.text = model.str_param4;
    self.lab_remark.text = model.str_param5;
    if (status==1) {
        _btn_delete.hidden =NO;
    }else{
        _btn_delete.hidden =YES;
    }
}
-(void)delete:(id)sender{
    if (self.deleteBtnClickedBlock) {
        self.deleteBtnClickedBlock(sender);
    }
}

+ (CGFloat)cellHeightWithObj:(FormSubChildModel *)obj{
    CGFloat cellHeight =10+2+15+9+5;
    if (obj.str_param2) {
        CGSize size = [obj.str_param2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-100-55, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += size.height;
    }
    if (obj.str_param5) {
        CGSize size = [obj.str_param5 sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-100-55, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += (size.height);
    }
    cellHeight = (cellHeight>=63?cellHeight:63);
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
