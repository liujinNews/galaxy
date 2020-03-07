//
//  PayMentBankCell.m
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentBankCell.h"

@implementation PayMentBankCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        if (!self.bankImg) {
            self.bankImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            self.bankImg.center=CGPointMake(27, 25);
            [self.contentView addSubview:self.bankImg];
        }
        if (!self.nameLabel) {
            self.nameLabel = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-108, 50) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.nameLabel];
        }
        if (!self.selImg) {
            self.selImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            self.selImg.center=CGPointMake(Main_Screen_Width-27, 25);
            [self.contentView addSubview:self.selImg];
        }
        if (!self.lineView) {
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, Main_Screen_Width, 0.5)];
            self.lineView.backgroundColor=Color_GrayLight_Same_20;
            [self.contentView addSubview:self.lineView];
        }
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.bankImg.image=[UIImage imageNamed:_model.image];
    self.nameLabel.text=_model.name;
    if (_model.select) {
        self.selImg.image=[UIImage imageNamed:@"Bank_selected"];
    }else{
        self.selImg.image=[UIImage imageNamed:@"Bank_unselected"];
    }
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
