//
//  BaseFormSumCell.m
//  galaxy
//
//  Created by hfk on 2019/6/30.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BaseFormSumCell.h"
#import "CurrencySumModel.h"
#import "HasSubmitDetailModel.h"
#import "ReimShareDeptSumModel.h"

@interface BaseFormSumCell ()

@property (nonatomic, strong) UILabel *lab_title;
@property (nonatomic, strong) UILabel *lab_sum;

@end

@implementation BaseFormSumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab_sum) {
        _lab_sum = [GPUtils createLable:CGRectZero text:nil font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_sum];
    }
    [_lab_sum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-65);
        make.width.equalTo(140);
    }];
    
    if (!_lab_title) {
        _lab_title = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_title.numberOfLines = 0;
        [self.contentView addSubview:_lab_title];
    }
    [_lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.lab_sum.mas_left).offset(5);
    }];
}
-(void)configBaseFormSumCellWithModel:(id)obj WithType:(NSInteger)type{
    if (type == 1) {
        CurrencySumModel *model = (CurrencySumModel *)obj;
        self.lab_title.text = [NSString stringWithIdOnNO:model.Currency];
        self.lab_sum.text = [GPUtils transformNsNumber:[model.SumAmount stringValue]];
        
    }else if (type == 2){
        HasSubmitDetailModel *model = (HasSubmitDetailModel *)obj;
        self.lab_title.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
        userData *userdatas = [userData shareUserData];
        self.lab_sum.text = [userdatas.multiCyPayment isEqualToString:@"1"] ? [GPUtils transformNsNumber: model.invPmtAmount] : [GPUtils transformNsNumber: model.amount];

    }else if (type == 3){
        ReimShareDeptSumModel *model = (ReimShareDeptSumModel *)obj;
        self.lab_title.text = [NSString stringWithIdOnNO:model.RequestorDept];
        self.lab_sum.text = [GPUtils transformNsNumber:model.Amount];

    }
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
