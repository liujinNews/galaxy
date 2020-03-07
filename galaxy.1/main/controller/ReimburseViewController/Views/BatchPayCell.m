//
//  BatchPayCell.m
//  galaxy
//
//  Created by hfk on 15/11/19.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "BatchPayCell.h"

@implementation BatchPayCell
-(void)configViewWithModel:(MyApplyModel *)model withRow:(NSInteger)row withAllRow:(NSInteger)allRow wintAmount:(NSString *)money
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 60)];
    [self.contentView addSubview:self.mainView];
    if (row==allRow) {
        self.reasonLabel=[GPUtils createLable:CGRectMake(0, 0,150, 20) text:Custing(@"需付款", nil) font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
        self.reasonLabel.center=CGPointMake(90,30);
        [self.mainView addSubview:self.reasonLabel];
        
        
        
        self.moneyLabel=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-190, 20) text:[NSString stringWithFormat:@"¥%@",[GPUtils transformNsNumber:money]] font:[UIFont systemFontOfSize:16.f] textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
        self.moneyLabel.center=CGPointMake(Main_Screen_Width/2+80, 30);
        
        [self.mainView addSubview:self.moneyLabel];
        
    }else{
        self.reasonLabel=[GPUtils createLable:CGRectMake(0, 0, 150, 20) text:[NSString stringWithFormat:@"%@-%@",model.taskId,model.taskName] font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
        self.reasonLabel.center=CGPointMake(90,30);
        [self.mainView addSubview:self.reasonLabel];
    
        self.moneyLabel=[GPUtils createLable:CGRectMake(0,0, Main_Screen_Width-190, 20) text:[NSString stringWithFormat:@"¥%@",[GPUtils transformNsNumber:model.amount]] font:[UIFont systemFontOfSize:16.f] textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
        self.moneyLabel.center=CGPointMake(Main_Screen_Width/2+80, 30);
        [self.mainView addSubview:self.moneyLabel];
    
    }
//    self.reasonLabel.backgroundColor=[UIColor cyanColor];
//    self.moneyLabel.backgroundColor=[UIColor redColor];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10, 59, ScreenRect.size.width-20, 1)];
    line.backgroundColor =[GPUtils colorHString:ColorGrayGround];;
    [self.mainView addSubview:line];
    
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
