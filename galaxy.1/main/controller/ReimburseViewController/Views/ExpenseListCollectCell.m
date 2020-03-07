//
//  ExpenseListCollectCell.m
//  galaxy
//
//  Created by hfk on 2018/5/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ExpenseListCollectCell.h"

@implementation ExpenseListCollectCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel=[GPUtils createLable:CGRectMake(0, 0,(Main_Screen_Width-54)/3, 30) text:nil font:Font_Same_14_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
        _titleLabel.layer.masksToBounds=YES;
        _titleLabel.layer.cornerRadius=3.0f;
        _titleLabel.layer.borderWidth=1.0;
        [self addSubview:_titleLabel];
    }
    return self;
}
-(void)configCollectCellWithData:(NSMutableArray *)array withIndex:(NSIndexPath *)indexPath{
    _titleLabel.textColor=Color_Black_Important_20;
    _titleLabel.backgroundColor=Color_FilterBackColor_Weak_20;
    _titleLabel.layer.borderColor=Color_FilterBackColor_Weak_20.CGColor;
    CostCateNewSubModel *model=array[indexPath.row];
    _titleLabel.text=[NSString stringWithIdOnNO:model.expenseType];
}

@end
