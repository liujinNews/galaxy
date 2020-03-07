//
//  CtripLeadCell.m
//  galaxy
//
//  Created by hfk on 2019/8/26.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "CtripLeadCell.h"

@interface CtripLeadCell ()

@property (nonatomic, strong) UIImageView *img_select;
@property (nonatomic, strong) UIImageView *img_type;
@property (nonatomic, strong) UILabel *lab_money;
@property (nonatomic, strong) UILabel *lab_name;
@property (nonatomic, strong) UILabel *lab_status;
@property (nonatomic, strong) UILabel *lab_date;

//@property (nonatomic, strong) UIImageView *img_type;
//@property (nonatomic, strong) UILabel *lab_type;
//@property (nonatomic, strong) UILabel *lab_date;
//@property (nonatomic, strong) UIImageView *img_payWay;
//@property (nonatomic, strong) UILabel *lab_money;
//@property (nonatomic, strong) UILabel *lab_currcyMoney;
//@property (nonatomic, strong) UILabel *lab_tips;
//@property (nonatomic, strong) UIButton *btn_select;
//@property (nonatomic, strong) UIView *view_line;

@end

@implementation CtripLeadCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_img_select) {
        _img_select = [[UIImageView alloc]init];
        _img_select.contentMode = UIViewContentModeRight;
        [self.contentView addSubview:_img_select];
    }
    [_img_select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.equalTo(0);
    }];
    
    
    if (!_img_type) {
        _img_type = [[UIImageView alloc]init];
        [self.contentView addSubview:_img_type];
    }
    [_img_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.left.equalTo(self.img_select.mas_right).offset(12);
        make.size.equalTo(CGSizeMake(42, 42));
    }];
    
    
    if (!_lab_money) {
        _lab_money = [GPUtils createLable:CGRectZero text:nil font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_money];
    }
    [_lab_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(100, 18));
    }];
    
    
    if (!_lab_status) {
        _lab_status = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:nil textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_status];
    }
    [_lab_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_money.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(80, 15));
    }];
    
    
    if (!_lab_date) {
        _lab_date = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_date];
    }
    [_lab_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.img_type.mas_right).offset(10);
        make.size.equalTo(CGSizeMake(Main_Screen_Width - 182, 14));
    }];
    
    
    if (!_lab_name) {
        _lab_name = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_name.numberOfLines = 0;
        [self.contentView addSubview:_lab_name];
    }
    [_lab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.img_type.mas_right).offset(10);
        make.width.equalTo(Main_Screen_Width - 204);
        make.bottom.equalTo(self.lab_date.mas_top).offset(-8);
    }];
    
    
    
}

- (void)configCtripViewCellWithModel:(CtripLeadModel *)model withIsEdit:(BOOL)isEdit withIndex:(NSInteger)index{

    if (index == 0 && isEdit) {
        [_img_select mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(28);
        }];
        _img_select.image = [UIImage imageNamed:[model.isChoosed isEqualToString:@"1"] ? @"MyApprove_Select":@"MyApprove_UnSelect"];
    }else{
        [_img_select mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(0);
        }];
        _img_select.image = nil;
    }
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",model.orderType];
    if ([NSString isEqualToNull:typeStr]) {
        if ([typeStr isEqualToString:@"2"]) {
            self.img_type.image=[UIImage imageNamed:@"01"];
        }else if ([typeStr isEqualToString:@"3"]){
            self.img_type.image=[UIImage imageNamed:@"02"];
        }else if ([typeStr isEqualToString:@"4"]){
            self.img_type.image=[UIImage imageNamed:@"05"];
        }
    }
    
    self.lab_money.text = [GPUtils transformNsNumber:model.amount];
    
    if (index == 0) {
        self.lab_status.textColor = Color_Orange_Weak_20;
        self.lab_status.text = [NSString stringIsExist:model.orderStatus];
    }else if (index == 1){
        self.lab_status.text = Custing(@"已导入", nil) ;
        self.lab_status.textColor = Color_Blue_Important_20;
    }
    
    self.lab_date.text = [NSString stringIsExist:model.orderDate];
    
    self.lab_name.text = [NSString stringIsExist:model.name];
    
}

+ (CGFloat)cellHeightWithModel:(CtripLeadModel *)model{
    CGSize size = [[NSString isEqualToNull:model.name] ? model.name:@" " sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width - 204, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return 43 + size.height;
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
