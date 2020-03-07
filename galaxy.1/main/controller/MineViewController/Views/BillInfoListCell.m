//
//  BillInfoListCell.m
//  galaxy
//
//  Created by hfk on 2017/6/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "BillInfoListCell.h"

@implementation BillInfoListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        if (!self.nameLabel) {
            self.nameLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            self.nameLabel.numberOfLines=0;
            [self.contentView addSubview:self.nameLabel];
        }
        if (!self.selImg) {
            self.selImg = [[UIImageView alloc] init];
            self.selImg.image=[UIImage imageNamed:@"skipImage"];
            [self.contentView addSubview:self.selImg];
        }
        if (!self.lineView) {
            self.lineView = [[UIView alloc] init];
            self.lineView.backgroundColor=Color_GrayLight_Same_20;
            [self.contentView addSubview:self.lineView];
        }
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height=[BillInfoListCell cellHeightWithObj:_dict];

    self.nameLabel.frame=CGRectMake(15, 0, Main_Screen_Width-65, height);
    self.nameLabel.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dict[@"companyName"]]]?[NSString stringWithFormat:@"%@",_dict[@"companyName"]]:@"";

    self.selImg.frame=CGRectMake(Main_Screen_Width-30, (height-18)/2, 18, 18);
    
    if (_HasLine) {
        self.lineView.frame=CGRectMake(15, height-0.5, Main_Screen_Width-15, 0.5);
    }
}


+ (CGFloat)cellHeightWithObj:(id)obj {
    NSDictionary  *dict=(NSDictionary *)obj;
    CGFloat cellHeight = 0;

    CGSize size= [[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"companyName"]]]?[NSString stringWithFormat:@"%@",dict[@"companyName"]]:@"" sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    cellHeight=30+((size.height==0)?20:size.height);
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
