//
//  ContractBatchPayCell.m
//  galaxy
//
//  Created by hfk on 2019/1/7.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "ContractBatchPayCell.h"

@interface ContractBatchPayCell ()

@property (nonatomic, strong) UIImageView *img_note;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_index;
@property (nonatomic, strong) UILabel *lab_paymoney;
@property (nonatomic, strong) UILabel *lab_money;
@property (nonatomic, strong) UILabel *lab_paidmoney;
@property (nonatomic, strong) UIView *view_line;


@end

@implementation ContractBatchPayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = Color_BorrowLine_Same_20;
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_img_note) {
        _img_note = [GPUtils createImageViewFrame:CGRectZero imageName:@"paymentContDetailDtoList_Icon"];
        [self.contentView addSubview:_img_note];
    }
    [_img_note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    if (!_lab_date) {
        _lab_date = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_cellTitle textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_date];
    }
    [_lab_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.img_note.right).offset(14);
        make.size.equalTo(CGSizeMake(200, 20));
    }];
    
    if (!_lab_index) {
        _lab_index = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_index];
    }
    [_lab_index mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img_note.bottom).offset(8);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2 - 12, 20));
    }];
    
    if (!_lab_paymoney) {
        _lab_paymoney = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_paymoney];
    }
    [_lab_paymoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img_note.bottom).offset(8);
        make.left.equalTo(self.contentView).offset(Main_Screen_Width/2);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2 - 12, 20));
    }];


    if (!_lab_money) {
        _lab_money = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_money];
    }
    [_lab_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_index.bottom).offset(8);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2 - 12, 20));
    }];
    
    if (!_lab_paidmoney) {
        _lab_paidmoney = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_paidmoney];
    }
    [_lab_paidmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_paymoney.bottom).offset(8);
        make.left.equalTo(self.contentView).offset(Main_Screen_Width/2);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2 - 12, 20));
    }];
}

-(void)configCellWithDict:(NSDictionary *)dict WithHideLine:(BOOL)hideLine{
    self.lab_date.text = [NSString stringWithIdOnNO:dict[@"paymentDate"]];
    self.lab_index.text = [GPUtils getSelectResultWithArray:@[Custing(@"付款批次", nil),[NSString stringWithFormat:@"%@",dict[@"gridOrder"]]] WithCompare:@" "];
    self.lab_paymoney.text = [GPUtils getSelectResultWithArray:@[Custing(@"付款金额", nil),[GPUtils transformNsNumber:dict[@"paymentAmount"]]] WithCompare:@" "];
    self.lab_money.text = [GPUtils getSelectResultWithArray:@[Custing(@"应付金额", nil),[GPUtils transformNsNumber:dict[@"amount"]]] WithCompare:@" "];
    self.lab_paidmoney.text = [GPUtils getSelectResultWithArray:@[Custing(@"已付金额", nil),[GPUtils transformNsNumber:dict[@"paidAmount"]]] WithCompare:@" "];
    self.view_line.hidden = hideLine;
    
}
+ (CGFloat)cellHeight{
    return 92;
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
