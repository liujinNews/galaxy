//
//  PayMentDetailCell.m
//  galaxy
//
//  Created by hfk on 2017/5/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentDetailCell.h"

@implementation PayMentDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        if (!self.ReasonLabel) {
            self.ReasonLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            self.ReasonLabel.numberOfLines=0;
            self.ReasonLabel.lineBreakMode=NSLineBreakByCharWrapping;
            [self.contentView addSubview:self.ReasonLabel];
        }
        if (!self.nameLabel) {
            self.nameLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.nameLabel];
        }
        if (!self.bankLabel) {
            self.bankLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.bankLabel];
        }
        if (!self.cardLabel) {
            self.cardLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.cardLabel];
        }
        if (!self.amountLabel) {
            self.amountLabel = [GPUtils createLable:CGRectMake(Main_Screen_Width-147, 20, 132, 20) text:nil font:Font_Important_15_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:self.amountLabel];
        }
        
        if (!self.typeImg) {
            self.typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            self.typeImg.center=CGPointMake(37, 38);
            [self.contentView addSubview:self.typeImg];
        }
        
        if (!self.lineView) {
            self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
            self.lineView.backgroundColor=Color_GrayLight_Same_20;
            [self.contentView addSubview:self.lineView];
        }
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height=[PayMentDetailCell cellHeightWithObj:_model];
    
    NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",_model.flowGuid,_model.flowCode]];
    self.typeImg.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

    self.amountLabel.text=[GPUtils transformNsNumber:_model.amountPayable];

    self.ReasonLabel.frame=CGRectMake(74, 5, Main_Screen_Width-221, height-77);
    self.ReasonLabel.text=_model.taskName;
    
    self.nameLabel.frame=CGRectMake(74, Y(self.ReasonLabel)+HEIGHT(self.ReasonLabel)+5, Main_Screen_Width-89, 10);
    self.nameLabel.text=_model.name;
    
    self.bankLabel.frame=CGRectMake(74, Y(self.nameLabel)+HEIGHT(self.nameLabel)+10, Main_Screen_Width-89, 10);
    self.bankLabel.text=_model.bankName;
    
    self.cardLabel.frame=CGRectMake(74, Y(self.bankLabel)+HEIGHT(self.bankLabel)+10, Main_Screen_Width-89, 10);
    self.cardLabel.text=_model.bankAccount;
    
    self.lineView.frame=CGRectMake(0, height-0.5, Main_Screen_Width, 0.5);
}
+ (CGFloat)cellHeightWithObj:(id)obj {
    PayMentDetailModel *model=(PayMentDetailModel *)obj;
    CGFloat cellHeight = 0;
    
    CGSize size= [model.taskName sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-221, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    cellHeight=95+((size.height==0)?20:size.height);
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
