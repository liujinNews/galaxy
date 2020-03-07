//
//  quaryResultCell.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "quaryResultCell.h"

@implementation quaryResultCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configViewWithQuaryResultCellInfo:(quaryResultData *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-30,[cellInfo.height integerValue])];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case quaryCellTypeTitle:
            [self configQuaryCellTypeTitle:cellInfo];
            break;
        case quaryCellTypeContent:
            [self configQuaryCellTypeContent:cellInfo];
            break;
        case quaryCellTypeResult:
            [self configQuaryCellTypeResult:cellInfo];
            break;
            
    }
}

//title
-(void)configQuaryCellTypeTitle:(quaryResultData*)cellInfo {
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width-60, 40) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    titleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLa];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, Main_Screen_Width-30, 1)];
    lineView.backgroundColor = Color_Blue_Important_20;
    [self.mainView addSubview:lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//content
-(void)configQuaryCellTypeContent:(quaryResultData*)cellInfo {
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(10, 0, 100, 45) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLa.numberOfLines = 0;
    titleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLa];
    
    UILabel * resultLa = [GPUtils createLable:CGRectMake(115, 0, Main_Screen_Width-140, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    resultLa.numberOfLines = 0;
    resultLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:resultLa];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, WIDTH(self.mainView)-20, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cellInfo.title isEqualToString:@"发票代码"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"fP_DM"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"fP_DM"]] :@"";
    }else if ([cellInfo.title isEqualToString:@"发票号码"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"fP_HM"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"fP_HM"]] :@"";
    }else if ([cellInfo.title isEqualToString:@"开票日期"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"kprq"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"kprq"]] :@"";
    }else if ([cellInfo.title isEqualToString:@"开票金额"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"jshj"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"jshj"]] :@"";
    }else if ([cellInfo.title isEqualToString:@"销售方税号"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"xsF_NSRSBH"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"xsF_NSRSBH"]] :@"";
    }else if ([cellInfo.title isEqualToString:@"销售名称"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"xsF_MC"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"xsF_MC"]] :@"";
    }else if ([cellInfo.title isEqualToString:@"购买方名称"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"gmF_MC"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"gmF_MC"]] :@"";
    }
    
}


//result
-(void)configQuaryCellTypeResult:(quaryResultData*)cellInfo {
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(10, 0, 100, 45) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLa.numberOfLines = 0;
    titleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLa];
    
    UILabel * resultLa = [GPUtils createLable:CGRectMake(138, 0, Main_Screen_Width-173, 45) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    resultLa.numberOfLines = 0;
    resultLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:resultLa];
    
    //tips_message_failed
    UIImageView * tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, 13.5, 18, 18)];
    tipImage.backgroundColor = [UIColor clearColor];
    tipImage.image = nil;
    [self.mainView addSubview:tipImage];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, WIDTH(self.mainView)-20, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cellInfo.title isEqualToString:@"查验结果"]) {
        resultLa.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"deaL_MSG"]]] ?[NSString stringWithFormat:@"%@",[cellInfo.quaryDoc objectForKey:@"deaL_MSG"]] :@"";
        tipImage.image = GPImage([[cellInfo.quaryDoc objectForKey:@"deaL_CODE"] isEqualToString:@"0000"] ?@"quaryResultTrue" :@"quaryResultFalse");
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
