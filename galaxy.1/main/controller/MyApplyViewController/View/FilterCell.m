//
//  FilterCell.m
//  galaxy
//
//  Created by hfk on 16/4/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)configViewWithString:(NSString *)data withChoose:(NSString *)choose
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 46)];
    [self.contentView addSubview:self.mainView];
    
    _chooseImage=[[UIImageView alloc]initWithFrame:CGRectMake(28*SCALEH, 15, 16, 16)];
    if ([choose isEqualToString:@"1"]) {
        _chooseImage.image=[UIImage imageNamed:@"MyApprove_Select"];
    }else{
        _chooseImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
    }
    [self.mainView addSubview:_chooseImage];
    
    _nameLabel=[GPUtils createLable:CGRectMake(X(_chooseImage)+WIDTH(_chooseImage)+28*SCALEH, 0, 200, 46) text:data font:Font_cellContent_16  textColor:[XBColorSupport supportScreenListColor] textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:_nameLabel];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, 45.5, ScreenRect.size.width-30, 0.5)];
    line.backgroundColor =Color_GrayLight_Same_20;
    [self.mainView addSubview:line];
    
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
