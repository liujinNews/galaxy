//
//  BorrowFormCell.m
//  galaxy
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BorrowFormCell.h"

@implementation BorrowFormCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)configViewWithModel:(ChooseCateFreModel *)model withIdArray:(NSMutableArray *)IdArray hideLine:(BOOL)hideLine{

    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 66)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];

    
    self.img_select = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
    self.img_select.center = CGPointMake(12+9, 33);
    [self.mainView addSubview:self.img_select];

    NSString *MarkId = [NSString stringWithFormat:@"%@",model.taskId];
    if ([IdArray containsObject:MarkId]) {
        self.img_select.image = [UIImage imageNamed:@"MyApprove_Select"];
    }else{
        self.img_select.image = [UIImage imageNamed:@"MyApprove_UnSelect"];
    }
    
    self.lab_title = [GPUtils createLable:CGRectMake(50, 12, Main_Screen_Width - 12-50-12, 19) text:[GPUtils getSelectResultWithArray:@[model.serialNo,model.reason] WithCompare:@"/"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.lab_title];

    self.lab_amount = [GPUtils createLable:CGRectMake(50, 35, Main_Screen_Width - 12-50-12, 18) text:[GPUtils getSelectResultWithArray:@[Custing(@"借款金额", nil),[GPUtils transformNsNumber:model.advanceAmount]] WithCompare:@" : "] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.lab_amount];


    self.view_line = [[UIView alloc]initWithFrame:CGRectMake(50, 65.4, Main_Screen_Width-50, 0.5)];
    self.view_line.backgroundColor = Color_GrayLight_Same_20;
    self.view_line.hidden = hideLine;
    [self.mainView addSubview:self.view_line];

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
