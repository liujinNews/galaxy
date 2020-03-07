//
//  InfoViewCell.m
//  galaxy
//
//  Created by hfk on 2017/2/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "InfoViewCell.h"

@implementation InfoViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_WhiteWeak_Same_20;
        _NoImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_NoImageView];

        _titleLabel=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines=0;
//        _titleLabel.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_titleLabel];
        
        _InfoLabel=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _InfoLabel.numberOfLines=0;
//        _InfoLabel.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_InfoLabel];
    }
    return self;
}
-(void)configViewInfoWithDict:(NSDictionary *)dict withIndex:(NSIndexPath *)index{
    _NoImageView.frame=CGRectMake(15, 13, 20, 20);
    _NoImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"Info_%ld",index.section+1]];
    CGSize size;
    CGSize size1;
    size1 = [dict[@"Info"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    if (![dict[@"title"]isEqualToString:@""]) {
        size = [dict[@"title"] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        _titleLabel.frame=CGRectMake(50, 12, size.width, size.height);
        _titleLabel.text=[NSString stringWithFormat:@"%@",dict[@"title"]];
        
        _InfoLabel.frame=CGRectMake(50, _titleLabel.frame.origin.y+HEIGHT(_titleLabel)+5, size1.width, size1.height);
        _InfoLabel.text=[NSString stringWithFormat:@"%@",dict[@"Info"]];
    }else{
        _InfoLabel.frame=CGRectMake(50,12, size1.width, size1.height);
        _InfoLabel.text=[NSString stringWithFormat:@"%@",dict[@"Info"]];
    }
   
    
    
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
