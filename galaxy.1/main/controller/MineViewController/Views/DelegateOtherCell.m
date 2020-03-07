//
//  DelegateOtherCell.m
//  galaxy
//
//  Created by hfk on 2018/8/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "DelegateOtherCell.h"

@implementation DelegateOtherCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = Color_White_Same_20;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab) {
        _lab =  [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
        _lab.backgroundColor = Color_Blue_Important_20;
        _lab.layer.cornerRadius = 11.0f;
        _lab.layer.masksToBounds = YES;
        [self.contentView addSubview:_lab];
    }
    [_lab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-24, 50));
    }];
}
-(void)setTitle:(NSString *)title{
    _lab.text = [NSString stringWithFormat:@"%@“%@”%@",Custing(@"进入", nil),title,Custing(@"的代理模式", nil)];
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
