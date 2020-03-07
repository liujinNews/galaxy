//
//  ReleStatementCell.m
//  galaxy
//
//  Created by hfk on 2018/12/17.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "ReleStatementCell.h"

@interface ReleStatementCell ()

@property (nonatomic, strong) NSDictionary *dict_info;
@property (nonatomic, strong) UIView *bg_View;
@property (nonatomic, strong) UIView *lineUp_View;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_serialNo;
@property (nonatomic, strong) UIView *lineDown_View;
@property (nonatomic, strong) UILabel *lab_totalAmount;
@property (nonatomic, strong) UILabel *lab_epcName;
@property (nonatomic, strong) UILabel *lab_subcontractorName;

@end

@implementation ReleStatementCell

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
    
    
    if (!_lab_totalAmount) {
        _lab_totalAmount = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_totalAmount];
    }
    [_lab_totalAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg_View.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(18);
    }];
    
    if (!_lab_epcName) {
        _lab_epcName = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_epcName];
    }
    [_lab_epcName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_totalAmount.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(18);
    }];
    
    if (!_lab_subcontractorName) {
        _lab_subcontractorName = [GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_subcontractorName];
    }
    [_lab_subcontractorName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_epcName.mas_bottom).offset(6);
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
    self.lab_date.text = [NSString stringWithIdOnNO:dict[@"requestorDate"]];
    
    NSString *totalAmount = [GPUtils transformNsNumber:dict[@"totalAmount"]];
    self.lab_totalAmount.text = [GPUtils getSelectResultWithArray:@[Custing(@"双方确认总价", nil),totalAmount] WithCompare:@" : "];
    [self.lab_totalAmount addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:totalAmount];

    NSString *epcName = [NSString stringWithIdOnNO:dict[@"epcName"]];
    self.lab_epcName.text = [GPUtils getSelectResultWithArray:@[Custing(@"总包单位名称", nil),epcName] WithCompare:@" : "];
    [self.lab_epcName addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:epcName];

    NSString *subcontractorName = [NSString stringWithIdOnNO:dict[@"subcontractorName"]];
    self.lab_subcontractorName.text = [GPUtils getSelectResultWithArray:@[Custing(@"分包单位名称", nil),subcontractorName] WithCompare:@" : "];
    [self.lab_subcontractorName addAttrDict:@{NSForegroundColorAttributeName: Color_Black_Important_20} toStr:subcontractorName];
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
