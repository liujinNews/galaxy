//
//  PayMentResultCell.m
//  galaxy
//
//  Created by hfk on 2017/6/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentResultCell.h"

@implementation PayMentResultCell
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
        
        if (!self.noLabel) {
            self.noLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.noLabel];
        }
        
        if (!self.statusLabel) {
            self.statusLabel = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            self.statusLabel.lineBreakMode=NSLineBreakByCharWrapping;
            [self.contentView addSubview:self.statusLabel];
        }
        if (!self.statusImg) {
            self.statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
            self.statusImg.center=CGPointMake(Main_Screen_Width-24, 25);
            [self.contentView addSubview:self.statusImg];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height=[PayMentResultCell cellHeightWithObj:_dict];
    
    NSDictionary *imageDict = [VoiceDataManger getFlowShowInfo:[NSString stringWithFormat:@"%@|%@",_dict[@"flowGuid"],_dict[@"flowCode"]]];
    self.typeImg.image=[UIImage imageNamed:imageDict[@"FlowBaseIcon"]];
    
    self.reasonLabel.frame=CGRectMake(74, 5, Main_Screen_Width-221, height-37);
    self.reasonLabel.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dict[@"taskName"]]]?[NSString stringWithFormat:@"%@",_dict[@"taskName"]]:@"";
    

    self.noLabel.frame=CGRectMake(74, Y(self.reasonLabel)+HEIGHT(self.reasonLabel), Main_Screen_Width-221, 15);
    self.noLabel.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dict[@"serialNo"]]]?[NSString stringWithFormat:@"%@%@",Custing(@"单号:", nil),_dict[@"serialNo"]]:Custing(@"单号:", nil);;
    
    self.statusImg.image=[UIImage imageNamed:[[NSString stringWithFormat:@"%@",_dict[@"resultType"]] isEqualToString:@"0"]?@"share_ReBack":@"share_submit"];

    NSString *status=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dict[@"resultMessage"]]]?[NSString stringWithFormat:@"%@",_dict[@"resultMessage"]]:@"";
    self.statusLabel.text=status;
    if (status.length>10) {
        self.statusLabel.frame=CGRectMake(Main_Screen_Width-150, 34, 140, 40);
        self.statusLabel.numberOfLines=2;
    }else{
        self.statusLabel.frame=CGRectMake(Main_Screen_Width-150, 34, 140, 20);
    }
    
    
    
}

+ (CGFloat)cellHeightWithObj:(id)obj {
    NSDictionary *dict=(NSDictionary *)obj;
    CGFloat cellHeight = 0;
    
    CGSize size= [[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"taskName"]]]?[NSString stringWithFormat:@"%@",dict[@"taskName"]]:@"" sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-221, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    cellHeight=55+((size.height==0)?20:size.height);
    return cellHeight;
    return 0;
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
