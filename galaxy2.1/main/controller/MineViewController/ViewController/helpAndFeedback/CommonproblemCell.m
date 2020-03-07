//
//  CommonproblemCell.m
//  galaxy
//
//  Created by hfk on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CommonproblemCell.h"

@implementation CommonproblemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configCellWithDict:(NSDictionary *)dict{

    NSInteger height;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"question"]]]) {
        CGSize size = [dict[@"question"] sizeCalculateWithFont:Font_cellContent_16 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        height = 30+size.height;
    }else{
        height = 30;
    }
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,height)];
    [self.contentView addSubview:self.mainView];
    
    

    _titleLable=[GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-50, height) text:dict[@"question"] font:Font_cellContent_16 textColor:Color_cellContent textAlignment:NSTextAlignmentLeft];
    _titleLable.backgroundColor=[UIColor clearColor];
    [self.mainView addSubview:_titleLable];
    _titleLable.numberOfLines = 0;
    

    _InImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    _InImageView.frame=CGRectMake(Main_Screen_Width-35, height/2-9, 18, 18);
    [self.mainView addSubview:_InImageView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, ScreenRect.size.width-30, 0.5)];
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
