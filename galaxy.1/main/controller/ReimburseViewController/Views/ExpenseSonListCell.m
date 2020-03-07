//
//  ExpenseSonListCell.m
//  galaxy
//
//  Created by hfk on 2019/7/4.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "ExpenseSonListCell.h"

@interface ExpenseSonListCell ()

@property (nonatomic, strong) UIImageView *img_select;
@property (nonatomic, strong) UIImageView *img_type;
@property (nonatomic, strong) UILabel *lab_type;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UIImageView *img_payWay;
@property (nonatomic, strong) UILabel *lab_money;
@property (nonatomic, strong) UILabel *lab_currcyMoney;
@property (nonatomic, strong) UILabel *lab_tips;
@property (nonatomic, strong) UIButton *btn_select;
@property (nonatomic, strong) UIView *view_line;

@end

@implementation ExpenseSonListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_White_Same_20;
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_img_select) {
        _img_select = [[UIImageView alloc]init];
        [self.contentView addSubview:_img_select];
    }
    [_img_select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.left.equalTo(self.contentView).offset(14);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    
    if (!_img_type) {
        _img_type = [[UIImageView alloc]init];
        [self.contentView addSubview:_img_type];
    }
    [_img_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.left.equalTo(self.contentView).offset(45);
        make.size.equalTo(CGSizeMake(34, 34));
    }];
    
    
    if (!_lab_money) {
        _lab_money = [GPUtils createLable:CGRectZero text:nil font:Font_Important_18_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_money];
    }
    [_lab_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.equalTo(CGSizeMake(140, 18));
    }];
    
    
    if (!_lab_type) {
        _lab_type = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_type];
    }
    [_lab_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.img_type.mas_right).offset(10);
        make.right.equalTo(self.lab_money.mas_left).offset(4);
        make.height.equalTo(15);
    }];

    
    if (!_lab_date) {
        _lab_date = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_date];
    }
    [_lab_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_type.mas_bottom).offset(1);
        make.left.equalTo(self.img_type.mas_right).offset(10);
        make.size.equalTo(CGSizeMake(70, 15));
    }];
    
    
    if (!_img_payWay) {
        _img_payWay = [GPUtils createImageViewFrame:CGRectZero imageName:@"AddDetail_CompanyPay"];
        [self.contentView addSubview:_img_payWay];
    }
    [_img_payWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_type.mas_bottom).offset(2);
        make.left.equalTo(self.lab_date.mas_right);
        make.size.equalTo(CGSizeMake(45, 13));
    }];
    
    
    if (!_lab_currcyMoney) {
        _lab_currcyMoney = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_currcyMoney];
    }
    [_lab_currcyMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_money.mas_bottom).offset(2);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.equalTo(CGSizeZero);
    }];
    
    
    if (!_lab_tips) {
        _lab_tips = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
        _lab_tips.numberOfLines = 0;
        [self.contentView addSubview:_lab_tips];
    }
    [_lab_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_date.mas_bottom).offset(2);
        make.left.equalTo(self.img_type.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
    
    if (!_btn_select) {
        _btn_select = [GPUtils createButton:CGRectZero action:@selector(expClicked:) delegate:self];
        [self.contentView addSubview:_btn_select];
    }
    [_btn_select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(50);
    }];
    
    if (!_view_line) {
        _view_line = [[UIView alloc]init];
        _view_line.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_line];
    }
    [_view_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView);
        make.height.equalTo(0.6);
    }];
}
-(void)configCellWithModel:(AddDetailsModel *)model withHasLine:(BOOL)hasLine{
    
    self.img_select.image = [UIImage imageNamed:[model.checked isEqualToString:@"1"] ? @"MyApprove_Select":@"MyApprove_UnSelect"];
    
    self.img_type.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon] ? model.expenseIcon:@"15"];
    
    userData *userdatas=[userData shareUserData];
    self.lab_money.text = [userdatas.multiCyPayment isEqualToString:@"1"] ? [GPUtils transformNsNumber: model.invPmtAmount] : [GPUtils transformNsNumber: model.localCyAmount];;
    
    self.lab_type.text = [GPUtils getSelectResultWithArray:@[model.expenseType]];
    
    self.lab_date.text = model.expenseDate;
    
    self.img_payWay.hidden = ![[NSString stringWithFormat:@"%@",model.payTypeId]isEqualToString:@"2"];
    
    if ([NSString isEqualToNull:model.currencyCode]) {
        self.lab_currcyMoney.hidden = NO;
        self.lab_currcyMoney.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.currencyCode],[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",model.amount]]] WithCompare:@" "];
        [self.lab_money mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
        }];
        [self.lab_currcyMoney mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(150, 18));
        }];
    }else{
        self.lab_currcyMoney.hidden = YES;
        self.lab_currcyMoney.text = nil;
        [self.lab_money mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
        }];
        [self.lab_currcyMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeZero);
        }];
    }
    self.lab_tips.text = [model.isIntegrity integerValue] == 1 ? Custing(@"信息填写不完整", nil):nil;
    self.view_line.hidden = !hasLine;
}

-(void)expClicked:(id)sender{
    if (self.expClickedBlock) {
        self.expClickedBlock();
    }
}
+ (CGFloat)cellHeightWithModel:(AddDetailsModel *)model{
    CGSize size = CGSizeZero;
    if ([model.isIntegrity integerValue] == 1) {
        size = [Custing(@"信息填写不完整", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width - 89 -10, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    }
    return 56 + size.height;
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
