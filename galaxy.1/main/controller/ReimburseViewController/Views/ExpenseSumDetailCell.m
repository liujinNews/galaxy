//
//  ExpenseSumDetailCell.m
//  galaxy
//
//  Created by hfk on 2018/4/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ExpenseSumDetailCell.h"

@implementation ExpenseSumDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_lab_No) {
        _lab_No=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_No];
    }
    [_lab_No mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@15);
        make.left.equalTo(self.contentView.mas_left).offset(@12);
        make.size.equalTo(CGSizeMake(28, 20));
    }];
    
    if (!_lab_Tyep) {
        _lab_Tyep=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Tyep];
    }
    [_lab_Tyep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@15);
        make.left.equalTo(self.contentView.mas_left).offset(@40);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-40-120, 20));
    }];
    
    if (!_lab_Date) {
        _lab_Date=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Date];
    }
    [_lab_Date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Tyep.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(@40);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-40-130, 15));
    }];
    
    if (!_lab_LocAmount) {
        _lab_LocAmount=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_LocAmount];
    }
    [_lab_LocAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@15);
        make.right.equalTo(self.contentView.mas_right).offset(@-12);
        make.size.equalTo(CGSizeMake(120, 20));
    }];
    
    if (!_lab_Amount) {
        _lab_Amount=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Amount];
    }
    [_lab_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_LocAmount.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(@-12);
        make.size.equalTo(CGSizeMake(130, 15));
    }];
    
    
    if (!_lab_Des) {
        _lab_Des=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Des.numberOfLines=0;
        [self.contentView addSubview:_lab_Des];
    }
    [_lab_Des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.mas_bottom).offset(@5);
        make.left.equalTo(self.contentView.mas_left).offset(@40);
        make.right.equalTo(self.contentView.mas_right).offset(@-12);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(@-10);
    }];
    
    if (!_view_Line) {
        _view_Line=[[UIView alloc]init];
        _view_Line.backgroundColor=Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_Line];
    }
    [_view_Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(@-0.1);
        make.left.equalTo(self.contentView.mas_left).offset(@12);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}
-(void)configCellWithModel:(AddDetailsModel *)model WithIndex:(NSInteger)index{
    
    self.lab_No.text=[NSString stringWithFormat:@"%ld",index+1];
    
    self.lab_Tyep.text=[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.expenseCat],[NSString stringWithFormat:@"%@",model.expenseType]] WithCompare:@"/"];
    
    self.lab_Date.text =[NSString isEqualToNull:model.expenseDate]?[NSString stringWithFormat:@"%@",model.expenseDate]:@"";
    
    
    
    userData *userdatas = [userData shareUserData];
    self.lab_LocAmount.text = [userdatas.multiCyPayment isEqualToString:@"1"] ? [GPUtils transformNsNumber:model.invPmtAmount]:[GPUtils transformNsNumber:model.amount];
    
    self.lab_Amount.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.currencyCode],[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",model.localCyAmount]]] WithCompare:@" "];

    self.lab_Des.text=[NSString isEqualToNull:model.expenseDesc]?[NSString stringWithFormat:@"%@",model.expenseDesc]:@"";
    [self.lab_Des sizeToFit];
    
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight =65;
    HasSubmitDetailModel *model=(HasSubmitDetailModel *)obj;
    if ([NSString isEqualToNull:model.expenseDesc]) {
        NSString *desStr=[NSString stringWithFormat:@"%@",model.expenseDesc];
        CGSize size = [desStr sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-40-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        NSLog(@"%@",NSStringFromCGSize(size));
        cellHeight += size.height;
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
