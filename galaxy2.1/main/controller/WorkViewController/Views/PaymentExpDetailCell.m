//
//  PaymentExpDetailCell.m
//  galaxy
//
//  Created by hfk on 2018/11/14.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PaymentExpDetailCell.h"

@interface PaymentExpDetailCell ()

@property (nonatomic, strong) UILabel  *lab_gridOrder;
@property (nonatomic, strong) UIImageView *img_cate;
@property (nonatomic, strong) UILabel  *lab_cate;
@property (nonatomic, strong) UILabel  *lab_date;
@property (nonatomic, strong) UILabel  *lab_money;
@property (nonatomic, strong) UILabel  *lab_currency;
@property (nonatomic, strong) UILabel *lab_tips;
@property (nonatomic, strong) UIView  *view_line;

@end

@implementation PaymentExpDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab_gridOrder) {
        _lab_gridOrder=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_gridOrder];
    }
    [_lab_gridOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@5);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    if (!_img_cate) {
        _img_cate = [GPUtils createImageViewFrame:CGRectZero imageName:nil];
        [self.contentView addSubview:_img_cate];
    }
    [_img_cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    if (!_lab_cate) {
        _lab_cate = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_cate];
    }
    [_lab_cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@56);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-208, 15));
    }];
    
    if (!_lab_date) {
        _lab_date = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_date];
    }
    [_lab_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@30);
        make.left.equalTo(self.contentView).offset(@56);
        make.size.equalTo(CGSizeMake(70, 15));
    }];

    
    if (!_lab_money) {
        _lab_money = [GPUtils createLable:CGRectZero text:nil font:Font_Important_18_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_money];
    }
    [_lab_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@8);
        make.right.equalTo(self.contentView).offset(@-12);
        make.size.equalTo(CGSizeMake(140, 18));
    }];
    
    
    if (!_lab_currency) {
        _lab_currency = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_currency];
    }
    [_lab_currency mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@28);
        make.right.equalTo(self.contentView).offset(@-12);
        make.size.equalTo(CGSizeMake(140, 15));
    }];
    
    
    if (!_lab_tips) {
        _lab_tips = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
        _lab_tips.numberOfLines = 0;
        [self.contentView addSubview:_lab_tips];
    }
    [_lab_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_date.mas_bottom).offset(2);
        make.left.equalTo(self.contentView).offset(@56);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-7);
    }];
    
    if (!_view_line) {
        _view_line = [[UIView alloc]init];
        _view_line.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_line];
    }
    [_view_line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0.1);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}
-(void)configCellWithPaymentExpDetail:(PaymentExpDetail *)PaymentExpDetail{
    if (self.editType != 1) {
        self.lab_gridOrder.text = [NSString stringWithFormat:@"%ld",(long)self.index+1];
        [self.lab_gridOrder mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(34, 34));
        }];
    }else{
        [self.img_cate mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(34, 34));
        }];
        if ([NSString isEqualToNull:PaymentExpDetail.ExpenseIcon]) {
            self.img_cate.image = [UIImage imageNamed:PaymentExpDetail.ExpenseIcon];
        }else{
            self.img_cate.image = [UIImage imageNamed:@"15"];
        }
    }
    
    self.lab_cate.text = [GPUtils getSelectResultWithArray:@[PaymentExpDetail.ExpenseCat,PaymentExpDetail.ExpenseType]];
    self.lab_date.text = [NSString stringWithIdOnNO:PaymentExpDetail.ExpenseDate];
    
    userData *userdatas = [userData shareUserData];
    self.lab_money.text = [userdatas.multiCyPayment isEqualToString:@"1"] ? [GPUtils transformNsNumber: PaymentExpDetail.InvPmtAmount] : [GPUtils transformNsNumber: PaymentExpDetail.LocalCyAmount];
    
    self.lab_currency.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",PaymentExpDetail.CurrencyCode],[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",PaymentExpDetail.Amount]]] WithCompare:@" "];
    
    self.lab_tips.text = nil;
    
    if (self.editType == 1 && [PaymentExpDetail.isIntegrity integerValue] == 1) {
        self.lab_tips.text = Custing(@"信息填写不完整", nil);
    }else{
        if ([[NSString stringWithFormat:@"%@",PaymentExpDetail.IsExpExpired]isEqualToString:@"1"]) {
            self.lab_tips.text = Custing(@"超期费用", nil);
            self.lab_tips.textAlignment = NSTextAlignmentRight;
        }
    }

    if (self.index == 0) {
        [_view_line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
        }];
    }else{
        [_view_line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
        }];
    }
    
}
+ (CGFloat)cellHeightWithModel:(PaymentExpDetail *)model withEditType:(NSInteger)editType{
    CGSize size = CGSizeZero;
    if (editType == 1 && [model.isIntegrity integerValue] == 1) {
        size = [Custing(@"信息填写不完整", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width - 89 - 10, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    }else{
        if ([[NSString stringWithFormat:@"%@",model.IsExpExpired]isEqualToString:@"1"]) {
            size = CGSizeMake(10, 15);
        }
    }
    return 54 + size.height;
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
