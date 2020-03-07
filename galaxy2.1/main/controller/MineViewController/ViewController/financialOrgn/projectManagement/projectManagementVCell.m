//
//  projectManagementVCell.m
//  galaxy
//
//  Created by 赵碚 on 16/2/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "projectManagementVCell.h"

@implementation projectManagementVCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//
-(void)configProjectManagementCellInfo:(projectManagerModel *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * TitleLa = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)-30, 49) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    TitleLa.backgroundColor = [UIColor clearColor];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.projTyp]]) {
        TitleLa.text=[NSString stringWithFormat:@"%@/%@/%@",cellInfo.projTyp,cellInfo.no,cellInfo.projName];
    }else{
        TitleLa.text=[NSString stringWithFormat:@"%@/%@",cellInfo.no,cellInfo.projName];
    }
    [self.mainView addSubview:TitleLa];
    
    
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-15, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    //    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
