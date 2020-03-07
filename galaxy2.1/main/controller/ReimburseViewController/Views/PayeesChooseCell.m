//
//  PayeesChooseCell.m
//  galaxy
//
//  Created by hfk on 2018/8/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PayeesChooseCell.h"

@interface PayeesChooseCell()

@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UILabel  *TypeLabel;
@property(nonatomic,strong)UIImageView *selectImageView;

@end

@implementation PayeesChooseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)configPayeesChoosesWithModel:(ChooseCateFreModel *)model{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 70)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
   
    self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
    self.selectImageView.center=CGPointMake(25, 35);
    self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
    [self.mainView addSubview:self.selectImageView];


    _TypeLabel = [GPUtils createLable:CGRectMake(50, 10, Main_Screen_Width-65, 19) text:model.payee font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:_TypeLabel];
    
    UILabel *sub1 = [GPUtils createLable:CGRectMake(50, 29+2, Main_Screen_Width-65, 15) text:model.depositBank font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:sub1];
    
    UILabel *sub2 = [GPUtils createLable:CGRectMake(50, 29+2+15+2, Main_Screen_Width-65, 15) text:[NSString getSecretBankAccount:model.bankAccount] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:sub2];
  
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
