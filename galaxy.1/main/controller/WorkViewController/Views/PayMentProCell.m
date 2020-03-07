//
//  PayMentProCell.m
//  galaxy
//
//  Created by hfk on 2017/6/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentProCell.h"

@implementation PayMentProCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        if (!self.typeImg) {
            self.typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            self.typeImg.center=CGPointMake(37, 38);
            [self.contentView addSubview:self.typeImg];
        }
        if (!self.reasonLabel) {
            self.reasonLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            self.reasonLabel.lineBreakMode=NSLineBreakByCharWrapping;
            self.reasonLabel.numberOfLines=0;
            [self.contentView addSubview:self.reasonLabel];
        }
        
        if (!self.moneyLabel) {
            self.moneyLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:self.moneyLabel];
        }
        
        if (!self.statusLabel) {
            self.statusLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:self.statusLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height=[PayMentProCell cellHeightWithObj:_model];
    
    NSDictionary *imageDict=[VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@",_model.flowCode]];
    self.typeImg.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];

    
    self.reasonLabel.frame=CGRectMake(74, 5, Main_Screen_Width-221, height-37);
    self.reasonLabel.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.taskName]]?[NSString stringWithFormat:@"%@",_model.taskName]:@"";
    
    self.moneyLabel.frame=CGRectMake(0,0, 132, 13);
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-81, 26);
    self.moneyLabel.text=[GPUtils transformNsNumber:_model.amount];
    
    self.statusLabel.frame=CGRectMake(Main_Screen_Width-147, 34, 132, 20);
    self.statusLabel.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.statusStr]]?[NSString stringWithFormat:@"%@",_model.statusStr]:@"";
}

+ (CGFloat)cellHeightWithObj:(id)obj {
    PayMentProModel *model=(PayMentProModel *)obj;
    CGFloat cellHeight = 0;
    
    CGSize size= [[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.taskName]]?[NSString stringWithFormat:@"%@",model.taskName]:@"" sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-221, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    cellHeight=55+((size.height==0)?20:size.height);
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
