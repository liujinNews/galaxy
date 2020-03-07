//
//  TravelMainCateCell.m
//  galaxy
//
//  Created by hfk on 2017/5/11.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "TravelMainCateCell.h"

@implementation TravelMainCateCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=Color_form_TextFieldBackgroundColor;
        // Initialization code
    }
    return self;
}
-(void)configCollectCellWithDict:(NSDictionary *)dict{
    
    if (!_iconImgView) {
        _iconImgView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 46, 46) imageName:nil];
        _iconImgView.center=CGPointMake(Main_Screen_Width/6, 40);
        [self.contentView addSubview:_iconImgView];
    }
    if (!_titleLabel) {
        _titleLabel= [GPUtils createLable:CGRectMake(0,0,Main_Screen_Width/3, 24) text:nil font:Font_Important_15_20 textColor: Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        _titleLabel.center=CGPointMake(Main_Screen_Width/6, 83);
        [self.contentView addSubview:_titleLabel];
    }
    
    _iconImgView.image=[UIImage imageNamed:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"image"]]]?dict[@"image"]:nil];
    _titleLabel.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?dict[@"name"]:nil;
}

@end
