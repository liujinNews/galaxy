//
//  CityCollectionViewCell.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CityCollectionViewCell.h"

@implementation CityCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textLabel];
    _textLabel.layer.cornerRadius = 5.f;
    _textLabel.layer.borderWidth = 1;
    _textLabel.layer.borderColor = Color_White_Same_20.CGColor;
    _textLabel.layer.masksToBounds = YES;
    _textLabel.backgroundColor = Color_White_Same_20;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 5, ceil(WIDTH(self.contentView)), 30);
}

@end
