//
//  PurContractSinglePayCell.m
//  galaxy
//
//  Created by hfk on 2019/1/7.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "PurContractSinglePayCell.h"

@interface PurContractSinglePayCell ()

@property (nonatomic, strong) UILabel *lab_index;
@property (nonatomic, strong) UILabel *lab_date;
@property (nonatomic, strong) UILabel *lab_money;
@property (nonatomic, strong) UIView *view_line;

@end

@implementation PurContractSinglePayCell
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
   
    if (!_lab_index) {
        _lab_index = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_index];
    }
    [_lab_index mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.width.equalTo(70);
    }];
    
    
    if (!_lab_date) {
        _lab_date = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_date];
    }
    [_lab_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(90);
        make.width.equalTo(100);
    }];


    if (!_lab_money) {
        _lab_money = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_money];
    }
    [_lab_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
        make.width.equalTo(Main_Screen_Width - 190 - 12);
    }];
    
    if (!_view_line) {
        _view_line = [[UIView alloc]init];
        _view_line.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_view_line];
    }
    [_view_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.equalTo(1);
    }];
}

-(void)configCellWithDict:(NSDictionary *)dict WithIndex:(NSInteger)index{
    
    self.lab_index.text = [NSString stringWithFormat:@"%ld",index+1];
    self.lab_date.text = [NSString stringWithIdOnNO:dict[@"paymentDate"]];
    self.lab_money.text = [GPUtils transformNsNumber:dict[@"amount"]];
}
+ (CGFloat)cellHeight{
    return 30;
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
