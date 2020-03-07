//
//  BudgetProjectDetailCell.m
//  galaxy
//
//  Created by hfk on 2019/1/16.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BudgetProjectDetailCell.h"
#import "userData.h"

#define cell_width (Main_Screen_Width-24)/3

@interface BudgetProjectDetailCell ()

@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UILabel  *lab_tolAmt;
@property (nonatomic, strong) UILabel  *lab_projName;
@property (nonatomic, strong) UILabel  *lab_proActivity;
@property (nonatomic, strong) UILabel  *lab_expenseType;
@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UILabel  *lab_budAmt;
@property (nonatomic, strong) UILabel  *lab_budAmtTitle;
@property (nonatomic, strong) UILabel  *lab_surAmt;
@property (nonatomic, strong) UILabel  *lab_surAmtTitle;
@property (nonatomic, strong) UILabel  *lab_overAmt;
@property (nonatomic, strong) UILabel  *lab_overAmtTitle;
@property (nonatomic, strong) userData *userdatas;

@end

@implementation BudgetProjectDetailCell

- (userData *)userdatas{
    if (!_userdatas) {
        _userdatas = [userData shareUserData];
    }
    return _userdatas;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = Color_White_Same_20;
        
        if (!_bgView) {
            _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 145)];
            _bgView.backgroundColor = Color_form_TextFieldBackgroundColor;
            [self.contentView addSubview:_bgView];
        }
        
        
        if (!_lab_tolAmt) {
            _lab_tolAmt = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:_lab_tolAmt];
        }
        [self.lab_tolAmt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-12);
            make.size.equalTo(CGSizeMake(130, 20));
        }];
        
        
        if (!_lab_projName) {
            _lab_projName = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_lab_projName];
        }
        [self.lab_projName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.lab_tolAmt.mas_left);
            make.height.equalTo(20);
        }];
        
        
        if (!_lab_proActivity) {
            _lab_proActivity = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Same_12_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_lab_proActivity];
        }
        [self.lab_proActivity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lab_projName.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
            make.height.equalTo(16);
        }];
        
        
        if (!_lab_expenseType) {
            _lab_expenseType = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Same_12_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_lab_expenseType];
        }
        [self.lab_expenseType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lab_proActivity.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
            make.height.equalTo(16);
        }];
        
        if (!_lineView) {
            _lineView = [[UIView alloc] initWithFrame:CGRectZero];
            _lineView.backgroundColor = Color_GrayLight_Same_20;
            [self.contentView addSubview:_lineView];
        }
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lab_expenseType.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView);
            make.height.equalTo(0.5);
        }];
        
        if (!_lab_budAmt) {
            _lab_budAmt = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_lab_budAmt];
        }
        [self.lab_budAmt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(12);
            make.size.equalTo(CGSizeMake(cell_width, 16));
        }];
        if (!_lab_budAmtTitle) {
            _lab_budAmtTitle = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:Custing(@"预算金额", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_lab_budAmtTitle];
        }
        [self.lab_budAmtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lab_budAmt.mas_bottom).offset(5);
            make.left.equalTo(self.contentView).offset(12);
            make.size.equalTo(CGSizeMake(cell_width, 16));
        }];
        
        if (!_lab_surAmt) {
            _lab_surAmt = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:_lab_surAmt];
        }
        [self.lab_surAmt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.left.equalTo(self.lab_budAmt.mas_right);
            make.size.equalTo(CGSizeMake(cell_width, 16));
        }];
        
        NSString *lastRtext;
        if ([self.userdatas.companyId isEqualToString:@"11888"]) {
            lastRtext = Custing(@"上次剩余预算", nil);
        }else{
            lastRtext = Custing(@"剩余金额", nil);
        }
        if (!_lab_surAmtTitle) {
            _lab_surAmtTitle = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:lastRtext font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:_lab_surAmtTitle];
        }
        [self.lab_surAmtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lab_surAmt.mas_bottom).offset(5);
            make.left.equalTo(self.lab_budAmtTitle.mas_right);
            make.size.equalTo(CGSizeMake(cell_width, 16));
        }];
        
        
        if (!_lab_overAmt) {
            _lab_overAmt = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Same_14_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:_lab_overAmt];
        }
        [self.lab_overAmt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.left.equalTo(self.lab_surAmt.mas_right);
            make.size.equalTo(CGSizeMake(cell_width, 16));
        }];
        if (!_lab_overAmtTitle) {
            _lab_overAmtTitle = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:Custing(@"超预算", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:_lab_overAmtTitle];
        }
        [self.lab_overAmtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lab_overAmt.mas_bottom).offset(5);
            make.left.equalTo(self.lab_surAmtTitle.mas_right);
            make.size.equalTo(CGSizeMake(cell_width, 16));
        }];

    }
    return self;
}

-(void)configCellWithDict:(NSDictionary *)projDict{
    
    self.lab_tolAmt.text = [GPUtils transformNsNumber:projDict[@"totalAmount"]];

    self.lab_projName.text = [NSString stringWithIdOnNO:projDict[@"projName"]];
    
    NSString *proActivity = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",projDict[@"projectActivityLv1Name"]],[NSString stringWithFormat:@"%@",projDict[@"projectActivityLv2Name"]]] WithCompare:@"/"];
    if (proActivity.length > 0) {
        self.lab_proActivity.text = [NSString stringWithFormat:@"%@%@",Custing(@"项目活动 : ", nil),proActivity];
        [self.lab_proActivity addAttrDict:@{NSForegroundColorAttributeName: Color_GrayDark_Same_20} toStr:Custing(@"项目活动 : ", nil)];
    }else{
        self.lab_proActivity.text = @"";
    }
    
    self.lab_expenseType.text = [NSString stringWithFormat:@"%@%@",Custing(@"费用类别 : ", nil),[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",projDict[@"expenseCat"]],[NSString stringWithFormat:@"%@",projDict[@"expenseType"]]] WithCompare:@"/"]];
    [self.lab_expenseType addAttrDict:@{NSForegroundColorAttributeName: Color_GrayDark_Same_20} toStr:Custing(@"费用类别 : ", nil)];

    self.lab_budAmt.text = [GPUtils transformNsNumber:projDict[@"budAmount"]];
    
    self.lab_surAmt.text = [GPUtils transformNsNumber:projDict[@"surplusAmount"]];

    self.lab_overAmt.text = [GPUtils transformNsNumber:projDict[@"overAmount"]];

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
