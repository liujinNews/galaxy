//
//  ReleRemittanceCell.m
//  galaxy
//
//  Created by hfk on 2018/12/17.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "ReleRemittanceCell.h"

@interface ReleRemittanceCell ()

@property (nonatomic, strong) NSDictionary *dict_info;
@property (nonatomic, strong) UIView *bg_View;
@property (nonatomic, strong) UIView *lineUp_View;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_serialNo;
@property (nonatomic, strong) UIView *lineDown_View;
@property (nonatomic, strong) UILabel *lab_claimAmount;
@property (nonatomic, strong) UILabel *lab_approvalAmount;
@property (nonatomic, strong) UILabel *lab_paymentAmount;
@property (nonatomic, strong) UILabel *lab_claimAmountTitle;
@property (nonatomic, strong) UILabel *lab_approvalAmountTitle;
@property (nonatomic, strong) UILabel *lab_paymentAmountTitle;
@property (nonatomic, strong) UILabel *lab_reason;

@end

@implementation ReleRemittanceCell

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
    
    if (!_lab_claimAmount) {
        _lab_claimAmount = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_claimAmount];
    }
    [_lab_claimAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake((Main_Screen_Width - 24)/3, 18));
    }];
    
    
    if (!_lab_approvalAmount) {
        _lab_approvalAmount = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_lab_approvalAmount];
    }
    [_lab_approvalAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake((Main_Screen_Width - 24)/3, 18));
    }];
    
    
    if (!_lab_paymentAmount) {
        _lab_paymentAmount = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_paymentAmount];
    }
    [_lab_paymentAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake((Main_Screen_Width - 24)/3, 18));
    }];
    
    
    if (!_lab_claimAmountTitle) {
        _lab_claimAmountTitle = [GPUtils createLable:CGRectZero text:Custing(@"申领金额", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_claimAmountTitle];
    }
    [_lab_claimAmountTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_claimAmount.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake((Main_Screen_Width - 24)/3, 18));
    }];
    
    
    if (!_lab_approvalAmountTitle) {
        _lab_approvalAmountTitle = [GPUtils createLable:CGRectZero text:Custing(@"审批金额", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_lab_approvalAmountTitle];
    }
    [_lab_approvalAmountTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_approvalAmount.mas_bottom).offset(6);
        make.centerX.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake((Main_Screen_Width - 24)/3, 18));
    }];
    
    
    if (!_lab_paymentAmountTitle) {
        _lab_paymentAmountTitle = [GPUtils createLable:CGRectZero text:Custing(@"付款金额", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_paymentAmountTitle];
    }
    [_lab_paymentAmountTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_paymentAmount.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-12);
        make.size.equalTo(CGSizeMake((Main_Screen_Width - 24)/3, 18));
    }];
    
    if (!_lab_reason) {
        _lab_reason = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_reason];
    }
    [_lab_reason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_claimAmountTitle.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(18);
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
    
    self.lab_claimAmount.text = [GPUtils transformNsNumber:dict[@"claimAmount"]];
    self.lab_approvalAmount.text = [GPUtils transformNsNumber:dict[@"approvalAmount"]];
    self.lab_paymentAmount.text = [GPUtils transformNsNumber:dict[@"paymentAmount"]];
    
    NSString *reason = [NSString stringWithIdOnNO:dict[@"reason"]];
    self.lab_reason.text = [GPUtils getSelectResultWithArray:@[Custing(@"请款事由", nil),reason] WithCompare:@" : "];
    [self.lab_reason addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:reason];
    
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
