//
//  CostClassesCell.m
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CostClassesCell.h"

@implementation CostClassesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configViewWithModel:(CostClassesModel *)model withType:(NSString *)type withStatus:(NSInteger)status{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    [self.contentView addSubview:self.mainView];
    
    NSString *num;
    if ([type isEqualToString:@"1"]) {
        num=[NSString stringWithFormat:@"%@",model.expenseTypeName];
        _titleLable=[GPUtils createLable:CGRectMake(42, 14.5, Main_Screen_Width-100, 20) text:[NSString stringWithFormat:@"%@  %@",model.expenseType,num] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:_titleLable];
    }else{
        _titleLable=[GPUtils createLable:CGRectMake(48, 14.5, Main_Screen_Width -120, 20) text:[NSString stringWithFormat:@"%@",model.expenseType] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.mainView addSubview:_titleLable];
    
    }
    
    if (status==0) {
        _statusImgView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 8, 8) imageName:@"share_unAble"];
        _titleLable.textColor=Color_GrayDark_Same_20;
        _numLable.textColor=Color_GrayDark_Same_20;
    }else if (status==1){
        _statusImgView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 8, 8) imageName:@"costClass_icon"];
    }
    _statusImgView.center=CGPointMake(28, 24.5);
    [self.mainView addSubview:_statusImgView];
   
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(X(_titleLable), HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-X(_titleLable), 0.5)];
    _lineView.backgroundColor =Color_GrayLight_Same_20;
    [self.mainView addSubview:_lineView];

}
-(void)configBranchViewWithDict:(NSDictionary *)dict hideLine:(BOOL)hideLine{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 50)];
    [self.contentView addSubview:self.mainView];
    
    _titleLable = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width - 28 - 12, 50) text:[NSString stringWithIdOnNO:dict[@"groupName"]] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:_titleLable];

    _statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20, 20)];
    _statusImgView.center = CGPointMake(Main_Screen_Width-18, 25);
    _statusImgView.image = [UIImage imageNamed:@"skipImage"];
    [self.mainView addSubview:_statusImgView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self.mainView) - 1, Main_Screen_Width, 1)];
    _lineView.backgroundColor = Color_GrayLight_Same_20;
    _lineView.hidden = hideLine;
    [self.mainView addSubview:_lineView];

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
