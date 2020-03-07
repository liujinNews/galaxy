//
//  BroadcastTableViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BroadcastTableViewCell.h"

@implementation BroadcastTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//
-(void)configBroadcastCellInfo:(BroadcastData *)cellInfo{
    
    NSInteger rowHeight;
    NSInteger imageHeight;
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.attachment]]) {
//        NSURL *url = [NSURL URLWithString:cellInfo.attachment];
//        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//        if (imagea ==nil) {
//            imageHeight = 0;
//        }else{
//            imageHeight =  (Main_Screen_Width-50)/imagea.size.width *imagea.size.height;
//        }
        imageHeight = (Main_Screen_Width-50) / 9 * 5;
    }else{
        imageHeight = 0;
    }
    
    if ([NSString isEqualToNull:cellInfo.title]) {
        NSString *str = cellInfo.title;
        CGSize size = [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-50, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        rowHeight=100+imageHeight+size.height;
    }else{
        rowHeight = 100+imageHeight;
    }
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, ScreenRect.size.width-30, rowHeight)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    self.mainView.layer.cornerRadius = 10.0f;
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.layer.borderColor = Color_GrayLight_Same_20.CGColor;
    [self.contentView addSubview:self.mainView];
    
    if ([NSString isEqualToNull:cellInfo.title]) {
        NSString *str = cellInfo.title;
        self.TitleLa = [GPUtils createLable:CGRectMake(10,10, WIDTH(self.mainView)-20, 30) text:str font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        self.TitleLa.numberOfLines=0;
        CGSize size = [str sizeCalculateWithFont:self.TitleLa.font constrainedToSize:CGSizeMake(self.TitleLa.frame.size.width, 10000) lineBreakMode:self.TitleLa.lineBreakMode];
        self.TitleLa.frame = CGRectMake(10,10,WIDTH(self.mainView)-20,size.height);
        self.TitleLa.text=str;
        [self.mainView addSubview:self.TitleLa];
    }
    
    
    UILabel * timeLa = [GPUtils createLable:CGRectMake(10, 15+HEIGHT(self.TitleLa), WIDTH(self.mainView)-20, 30) text:@"" font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    timeLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:timeLa];
    if ([NSString isEqualToNull:cellInfo.published]) {
        timeLa.text = cellInfo.published;
    }
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.attachment]]) {
        UIImageView * avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, Y(timeLa)+HEIGHT(timeLa), WIDTH(self.mainView)-20, imageHeight)];
        [avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cellInfo.attachment]]];
        avatarImage.contentMode = UIViewContentModeScaleToFill;
        [self.mainView addSubview:avatarImage];
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10, Y(timeLa)+HEIGHT(timeLa)+15+imageHeight, WIDTH(self.mainView)-20, 1)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:line];
    
    UILabel * lookLa = [GPUtils createLable:CGRectMake(10, Y(line)+5, WIDTH(self.mainView)-20, 30) text:Custing(@"查看详情", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lookLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:lookLa];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-65, Y(lookLa)+5, 20, 20)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
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
