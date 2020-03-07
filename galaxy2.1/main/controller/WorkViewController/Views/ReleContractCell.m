//
//  ReleContractCell.m
//  galaxy
//
//  Created by hfk on 2018/4/24.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ReleContractCell.h"

@implementation ReleContractCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

-(void)createView{
    
    if (!_lab_Amount) {
        _lab_Amount=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Amount];
    }
    [_lab_Amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@12);
        make.right.equalTo(self.contentView).offset(@-12);
        make.size.equalTo(CGSizeMake(130, 20));
    }];
    
    
    if (!_lab_ContractDate) {
        _lab_ContractDate=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_ContractDate];
    }
    [_lab_ContractDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.bottom).offset(@-30);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake((Main_Screen_Width-24)/2, 15));
    }];
    
    if (!_lab_Title) {
        _lab_Title=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_Title.numberOfLines=0;
        [self.contentView addSubview:_lab_Title];
    }
    [_lab_Title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@12);
        make.left.equalTo(self.contentView).offset(@12);
        make.width.equalTo(@(Main_Screen_Width-12-130-12));
        make.bottom.equalTo(self.lab_ContractDate.top).offset(@-8);
    }];
}

-(void)configCellWithDict:(NSDictionary *)dict{
    NSString *title=[GPUtils getSelectResultWithArray:@[dict[@"contractNo"],dict[@"contractName"]] WithCompare:@"/"];
    self.lab_Title.text=title;
    [self.lab_Title sizeToFit];
    
    self.lab_Amount.text=[GPUtils transformNsNumber:dict[@"totalAmount"]];
    [self.lab_Amount sizeToFit];
    
    self.lab_ContractDate.text=[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"contractDate"]],[NSString stringWithFormat:@"%@",dict[@"effectiveDate"]]] WithCompare:@" ~ "];
    
//    NSString *str1=Custing(@"签订日期", nil);
//    NSMutableAttributedString *astr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ : %@",str1,[NSString stringWithIdOnNO:dict[@"contractDate"]]]];
//    [astr1 addAttribute:NSForegroundColorAttributeName value:Color_Black_Important_20 range:NSMakeRange(0, astr1.length)];
//    [astr1 addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, str1.length)];
//    self.lab_ContractDate.attributedText=astr1;
 
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    
    NSDictionary *dict=(NSDictionary *)obj;
    CGFloat cellHeight =30+12+8;
    NSString *title=[GPUtils getSelectResultWithArray:@[dict[@"contractNo"],dict[@"contractName"]] WithCompare:@"/"];
    CGSize size = [title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-130-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height>20) {
        cellHeight += size.height;
    }else{
        cellHeight += 20;
    }
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
