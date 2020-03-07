//
//  PowerMembersCell.m
//  galaxy
//
//  Created by hfk on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PowerMembersCell.h"

@implementation PowerMembersCell

//@property (nonatomic,strong)UILabel *titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
                self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configWithDict:(NSDictionary *)dict{

    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 60)];
    [self.contentView addSubview:self.mainView];

    _titleLabel=[GPUtils createLable:CGRectMake(28*SCALEH, 20, Main_Screen_Width/2, 20) text:dict[@"userName"] font:Font_cellContent_16 textColor:Color_cellContent textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:_titleLabel];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59.5, ScreenRect.size.width-30, 0.5)];
    _lineView.backgroundColor =Color_GrayLight_Same_20;
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
