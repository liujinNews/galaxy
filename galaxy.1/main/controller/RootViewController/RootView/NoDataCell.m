//
//  NoDataCell.m
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "NoDataCell.h"

@implementation NoDataCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellAccessoryNone;
        if (!_lab_NoData) {
            _lab_NoData=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:_lab_NoData];
        }
        if (!_imv_NoData) {
            _imv_NoData=[GPUtils createImageViewFrame:CGRectZero imageName:nil];
            [self.contentView addSubview:_imv_NoData];
        }
    }
    return self;
}
-(void)ConfigNoDataViewWithCellHeight:(NSInteger)height WithImageName:(NSString *)imgName WithTitle:(NSString *)title{

    UIImage *image=[UIImage imageNamed:imgName];
    
    [_imv_NoData updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@(height/2-image.size.height/2-20));
        make.left.equalTo(self.contentView.left).offset(@((Main_Screen_Width-image.size.width)/2));
        make.size.equalTo(image.size);
    }];
    _imv_NoData.image=image;
    
    [_lab_NoData updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imv_NoData.bottom);
        make.left.equalTo(self.contentView.left);
        make.size.equalTo(CGSizeMake(Main_Screen_Width, 18));
    }];
    _lab_NoData.text=title;
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
