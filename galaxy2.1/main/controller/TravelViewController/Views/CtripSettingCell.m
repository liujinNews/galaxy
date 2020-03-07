//
//  CtripSettingCell.m
//  galaxy
//
//  Created by hfk on 2017/10/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "CtripSettingCell.h"

@implementation CtripSettingCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return self;
}
-(void)configItemWithDict:(NSDictionary *)dict{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    [self addSubview:self.mainView];
    
    UILabel *label=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-12-46, 30) text:[NSString isEqualToNull:dict[@"userName"]]?[NSString stringWithFormat:@"%@",dict[@"userName"]]:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:label];
    
    UILabel *label1=[GPUtils createLable:CGRectMake(Main_Screen_Width-50, 0, 50, 30) text:Custing(@"删除", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.mainView addSubview:label1];

    
    _deletBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
    [self.mainView addSubview:_deletBtn];
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
