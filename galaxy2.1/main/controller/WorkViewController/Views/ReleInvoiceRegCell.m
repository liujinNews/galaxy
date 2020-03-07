//
//  ReleInvoiceRegCell.m
//  galaxy
//
//  Created by hfk on 2018/12/17.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "ReleInvoiceRegCell.h"

@interface ReleInvoiceRegCell ()

@property (nonatomic, strong) NSDictionary *dict_info;
@property (nonatomic, strong) UIView *bg_View;
@property (nonatomic, strong) UIView *lineUp_View;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_serialNo;
@property (nonatomic, strong) UIView *lineDown_View;
@property (nonatomic, strong) UILabel *lab_invoiceNo;
@property (nonatomic, strong) UILabel *lab_taxRate;
@property (nonatomic, strong) UILabel *lab_invoiceCode;
@property (nonatomic, strong) UILabel *lab_tax;
@property (nonatomic, strong) UILabel *lab_invoiceAmount;
@property (nonatomic, strong) UILabel *lab_exclTax;

@end


@implementation ReleInvoiceRegCell

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
    
    if (!_bg_View) {
        _bg_View = [[UIView alloc]init];
        _bg_View.backgroundColor = Color_NewDark_Same_20;
        [self.contentView addSubview:_bg_View];
    }
    [_bg_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(40);
    }];
    
    if (!_lineUp_View) {
        _lineUp_View = [[UIView alloc]init];
        _lineUp_View.backgroundColor = Color_GrayLight_Same_20;
        [self.bg_View addSubview:_lineUp_View];
    }
    [_lineUp_View makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View);
        make.left.right.equalTo(self.bg_View);
        make.height.equalTo(0.5);
    }];
    
    if (!_lab_date) {
        _lab_date = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.bg_View addSubview:_lab_date];
    }
    [_lab_date makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineUp_View.mas_bottom);
        make.right.equalTo(self.bg_View).offset(-12);
        make.size.equalTo(CGSizeMake(100, 38.5));
    }];
    
    if (!_lab_serialNo) {
        _lab_serialNo = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_serialNo.userInteractionEnabled = YES;
        [self.bg_View addSubview:_lab_serialNo];
    }
    [_lab_serialNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineUp_View.mas_bottom);
        make.left.equalTo(self.bg_View).offset(12);
        make.right.equalTo(self.lab_date.mas_left);
        make.height.equalTo(38.9);
    }];
    
    if (!_lineDown_View) {
        _lineDown_View = [[UIView alloc]init];
        _lineDown_View.backgroundColor = Color_GrayLight_Same_20;
        [self.bg_View addSubview:_lineDown_View];
    }
    [_lineDown_View makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_serialNo.mas_bottom);
        make.left.right.equalTo(self.bg_View);
        make.height.equalTo(0.6);
    }];
    
    
    if (!_lab_invoiceNo) {
        _lab_invoiceNo = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_invoiceNo];
    }
    [_lab_invoiceNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-12, 18));
    }];
    
    
    if (!_lab_taxRate) {
        _lab_taxRate = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_taxRate];
    }
    [_lab_taxRate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-24, 18));
    }];
    
    
    if (!_lab_invoiceCode) {
        _lab_invoiceCode = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_invoiceCode];
    }
    [_lab_invoiceCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_invoiceNo.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-12, 18));
    }];
    
    
    if (!_lab_tax) {
        _lab_tax = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_tax];
    }
    [_lab_tax makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_taxRate.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-24, 18));
    }];
    
    
    if (!_lab_invoiceAmount) {
        _lab_invoiceAmount = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_invoiceAmount];
    }
    [_lab_invoiceAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_invoiceCode.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-12, 18));
    }];
    
    
    if (!_lab_exclTax) {
        _lab_exclTax = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_exclTax];
    }
    [_lab_exclTax makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_tax.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-24, 18));
    }];
    
}

-(void)configCellWithInfoDict:(NSDictionary *)dict{
    
    self.dict_info = dict;
    
    self.lab_serialNo.text = [NSString stringWithIdOnNO:dict[@"serialNo"]];
    __weak typeof(self) weakSelf = self;
    [self.lab_serialNo bk_whenTapped:^{
        if (weakSelf.serialNoBtnClickedBlock) {
            weakSelf.serialNoBtnClickedBlock(weakSelf.dict_info);
        }
    }];
    self.lab_date.text = [NSString stringWithIdOnNO:dict[@"invoiceDate"]];
    
    NSString *invoiceNo = [NSString stringWithIdOnNO:dict[@"invoiceNo"]];
    self.lab_invoiceNo.text = [GPUtils getSelectResultWithArray:@[Custing(@"发票号码", nil),invoiceNo] WithCompare:@" : "];
    [self.lab_invoiceNo addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:invoiceNo];

    NSString *taxRate = [NSString isEqualToNull:dict[@"taxRate"]] ? [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%@",dict[@"taxRate"]]]:@"";
    self.lab_taxRate.text = [GPUtils getSelectResultWithArray:@[Custing(@"税率", nil),taxRate] WithCompare:@" : "];
    [self.lab_taxRate addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:taxRate];

    NSString *invoiceCode = [NSString stringWithIdOnNO:dict[@"invoiceCode"]];
    self.lab_invoiceCode.text = [GPUtils getSelectResultWithArray:@[Custing(@"发票代码", nil),invoiceCode] WithCompare:@" : "];
    [self.lab_invoiceCode addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:invoiceCode];

    NSString *tax = [GPUtils transformNsNumber:dict[@"tax"]];
    self.lab_tax.text = [GPUtils getSelectResultWithArray:@[Custing(@"税额", nil),tax] WithCompare:@" : "];
    [self.lab_tax addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:tax];

    
    NSString *invoiceAmount = [GPUtils transformNsNumber:dict[@"invoiceAmount"]];
    self.lab_invoiceAmount.text = [GPUtils getSelectResultWithArray:@[Custing(@"发票金额", nil),invoiceAmount] WithCompare:@" : "];
    [self.lab_invoiceAmount addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:invoiceAmount];

    
    NSString *exclTax = [GPUtils transformNsNumber:dict[@"exclTax"]];
    self.lab_exclTax.text = [GPUtils getSelectResultWithArray:@[Custing(@"不含税金额", nil),exclTax] WithCompare:@" : "];
    [self.lab_exclTax addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:exclTax];
    
}

+ (CGFloat)cellHeight{
    return 40 + 86;
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
