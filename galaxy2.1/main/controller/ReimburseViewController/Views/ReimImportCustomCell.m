//
//  ReimImportCustomCell.m
//  galaxy
//
//  Created by hfk on 2018/10/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ReimImportCustomCell.h"

@interface ReimImportCustomCell ()

@property (nonatomic, strong) UIImageView *img_Select;
@property (nonatomic, strong) UILabel *lab_Tyep;
@property (nonatomic, strong) UILabel *lab_Des;
@property (nonatomic, strong) UILabel *lab_Money;
@property (nonatomic, strong) UILabel *lab_Currency;
@property (nonatomic, strong) UIView *view_Line;

@end

@implementation ReimImportCustomCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_img_Select) {
        _img_Select = [GPUtils createImageViewFrame:CGRectMake(0, 0, 18, 18) imageName:nil];
        [self.contentView addSubview:_img_Select];
    }
    [_img_Select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.size.equalTo(CGSizeMake(18, 18));
        make.centerY.equalTo(self.contentView);
    }];
    
    if (!_lab_Money) {
        _lab_Money = [GPUtils createLable:CGRectZero text:nil font:Font_Important_18_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Money];
    }
    [_lab_Money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.centerY).offset(-3);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(140, 18));
    }];
    
    if (!_lab_Currency) {
        _lab_Currency = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Currency];
    }
    [_lab_Currency mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.centerY).offset(3);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(140, 18));
    }];

    if (!_lab_Tyep) {
        _lab_Tyep=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_Tyep.numberOfLines = 0;
        [self.contentView addSubview:_lab_Tyep];
    }
    [_lab_Tyep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(45);
        make.right.equalTo(self.lab_Money.mas_left);
        make.height.equalTo(18);
    }];

    if (!_lab_Des) {
        _lab_Des=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Des];
    }
    [_lab_Des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Tyep.bottom).offset(5);
        make.left.equalTo(self.contentView).offset(45);
        make.right.equalTo(self.lab_Money.mas_left);
        make.height.equalTo(14);
    }];
    
    if (!_view_Line) {
        _view_Line = [[UIView alloc]init];
        _view_Line.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_Line];
    }
    
    [_view_Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(0.5);
    }];
    
}

-(void)configCellWithDict:(NSMutableDictionary *)dict WithIsLast:(BOOL)isLast{
    self.img_Select.image = [[NSString stringWithFormat:@"%@",dict[@"checked"]]isEqualToString:@"1"] ? [UIImage imageNamed:@"MyApprove_Select"]:[UIImage imageNamed:@"MyApprove_UnSelect"];
    self.lab_Money.text = [GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",dict[@"localCyAmount"]]];
    self.lab_Currency.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"currencyCode"]],[GPUtils transformNsNumber:dict[@"amount"]]] WithCompare:@" "];
    self.lab_Des.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithIdOnNO:dict[@"expenseDesc"]],[NSString isEqualToNull:dict[@"remark"]]?[NSString isEqualToNull:dict[@"expenseDesc"]]?[NSString stringWithFormat:@",%@",dict[@"remark"]]:dict[@"remark"]:@""];
    CGSize size = [[NSString stringIsExist:dict[@"expenseType"]] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    self.lab_Tyep.text = dict[@"expenseType"];
    [self.lab_Tyep mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(size.height);
    }];
    
    [_view_Line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(isLast ? 0:12);
    }];
}

+ (CGFloat)cellHeightWithObj:(NSMutableDictionary *)dict{
    CGSize size = [[NSString stringIsExist:dict[@"expenseType"]] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return 50+size.height;
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
