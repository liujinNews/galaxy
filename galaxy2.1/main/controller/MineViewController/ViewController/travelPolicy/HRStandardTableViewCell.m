//
//  HRStandardTableViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "HRStandardTableViewCell.h"

@implementation HRStandardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configHRSTandardCellInfo:(HRStandardData *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,[cellInfo.cellHeight integerValue])];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case hrstCellTypeNo:
            [self configHRSTandardCellNo:cellInfo];
            break;
        case hrstCellTypeYes:
            [self configHRSTandardCellYes:cellInfo];
            break;
        case hrstCellTypeAll:
            [self configHRSTandardCellNo:cellInfo];
            break;
        case ForStCellType:
            [self configForStandardListCellInfo:cellInfo];
            break;
    }
}
//未设置
-(void)configHRSTandardCellNo:(HRStandardData *)cellInfo{
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 1, 60, 53) text:[NSString stringWithFormat:@"%@", cellInfo.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    codeLa.numberOfLines = 0;
    [self.mainView addSubview:codeLa];
    if ([cellInfo.userLevel isEqualToString:@"(null)"]||[cellInfo.userLevel isEqualToString:@"<null>"]||[cellInfo.userLevel isEqualToString:@""]) {
        codeLa.text = @"";
    }
    
    UILabel * contentLa = [GPUtils createLable:CGRectMake(75, 1, Main_Screen_Width - 115, 53) text:Custing(@"请设置限制标准", nil) font:Font_Important_15_20 textColor:Color_GrayLight_Same_20 textAlignment:NSTextAlignmentLeft];
    contentLa.backgroundColor = [UIColor clearColor];
    contentLa.numberOfLines = 0;
    [self.mainView addSubview:contentLa];
    if (cellInfo.type == hrstCellTypeAll) {
        contentLa.textColor = Color_Blue_Important_20;
        contentLa.font = Font_Important_15_20;
        contentLa.text = [NSString stringWithFormat:@"%@ %@%@",Custing(@"所有城市，房价最高", nil),cellInfo.housePrice0,Custing(@"元", nil)];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 18.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//已设置设置
-(void)configHRSTandardCellYes:(HRStandardData *)cellInfo{
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 20, 60, 20) text:[NSString stringWithFormat:@"%@", cellInfo.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    codeLa.numberOfLines = 0;
    [self.mainView addSubview:codeLa];
    if ([cellInfo.userLevel isEqualToString:@"(null)"]||[cellInfo.userLevel isEqualToString:@"<null>"]||[cellInfo.userLevel isEqualToString:@""]) {
        codeLa.text = @"";
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 21, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UILabel * content1La = [GPUtils createLable:CGRectMake(75, -2, Main_Screen_Width-115, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"一线城市，房价最高", nil),cellInfo.housePrice1,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    content1La.backgroundColor = [UIColor clearColor];
    content1La.numberOfLines = 0;
    [self.mainView addSubview:content1La];
    
    UILabel * content2La = [GPUtils createLable:CGRectMake(75, 31, Main_Screen_Width-115, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"二线城市，房价最高", nil),cellInfo.housePrice2,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    content2La.backgroundColor = [UIColor clearColor];
    content2La.numberOfLines = 0;
    [self.mainView addSubview:content2La];
    
    UILabel * content3La = [GPUtils createLable:CGRectMake(75, 63, Main_Screen_Width-115, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"三线城市，房价最高", nil),cellInfo.housePrice3,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    content3La.backgroundColor = [UIColor clearColor];
    content3La.numberOfLines = 0;
    [self.mainView addSubview:content3La];
    
    UILabel * content4La = [GPUtils createLable:CGRectMake(75, 94, Main_Screen_Width-115, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"港澳台，房价最高", nil),cellInfo.housePrice4,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    content4La.backgroundColor = [UIColor clearColor];
    content4La.numberOfLines = 0;
    [self.mainView addSubview:content4La];
    
    UILabel * content5La = [GPUtils createLable:CGRectMake(75, 125, Main_Screen_Width-115, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"国际城市，房价最高", nil),cellInfo.housePrice5,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    content5La.backgroundColor = [UIColor clearColor];
    content5La.numberOfLines = 0;
    [self.mainView addSubview:content5La];
    
    
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//补贴列表
-(void)configForStandardListCellInfo:(HRStandardData *)cellInfo {
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 1, 60, 53) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    codeLa.numberOfLines = 0;
    [self.mainView addSubview:codeLa];
    if ([NSString isEqualToNull:cellInfo.userLevel]) {
        codeLa.text = [NSString stringWithFormat:@"%@", cellInfo.userLevel];
    }
    
    if (cellInfo.StdAllowances.count == 0) {
        UILabel * contentLa = [GPUtils createLable:CGRectMake(75, 1, Main_Screen_Width - 115, 53) text:Custing(@"请设置限制标准", nil) font:Font_Important_15_20 textColor:Color_GrayLight_Same_20 textAlignment:NSTextAlignmentLeft];
        contentLa.backgroundColor = [UIColor clearColor];
        contentLa.numberOfLines = 0;
        [self.mainView addSubview:contentLa];
    }else {
        for (int j = 0 ; j < [cellInfo.StdAllowances count] ; j ++ ) {
            NSString * typeStr = [[cellInfo.StdAllowances objectAtIndex:j]  objectForKey:@"expenseType"];
            NSString * amountStr = [[cellInfo.StdAllowances objectAtIndex:j]  objectForKey:@"amount"];
            NSString * unitStr = [NSString stringWithFormat:@"%@",[[cellInfo.StdAllowances objectAtIndex:j]  objectForKey:@"unit"]];
            if ([unitStr isEqualToString:@"1"]) {
                unitStr = Custing(@"2天", nil);
            }else if ([unitStr isEqualToString:@"2"]) {
                unitStr = Custing(@"2月", nil);
            }else if ([unitStr isEqualToString:@"3"]) {
                unitStr = Custing(@"2年", nil);
            }else {
                unitStr = Custing(@"2天", nil);
            }
            if (![NSString isEqualToNull:typeStr]) {
                typeStr = @"";
            }
            if (![NSString isEqualToNull:amountStr]) {
                amountStr = @"0";
            }
            

           UILabel * nameLa = [GPUtils createLable:CGRectMake(75, j*30, WIDTH(self.mainView)-115, 30) text:[NSString stringWithFormat:@"%@:%@%@%@",typeStr,amountStr,Custing(@"2元", nil),unitStr] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
            [self.mainView  addSubview:nameLa];
            if (cellInfo.StdAllowances.count == 1) {
                nameLa.frame = CGRectMake(75, 1, Main_Screen_Width - 115, 53);
            }
        }
    }
    
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 18.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


//修改补贴
-(void)configForStandardCellInfo:(HRStandardData *)cellInfo {
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,57)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 1, 70, 55) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:codeLa];
    
    if ([NSString isEqualToNull:cellInfo.expenseType]) {
        codeLa.text = cellInfo.expenseType;
    }
    
//    self.hrandTF =[[GkTextField alloc]initWithFrame:CGRectMake(90, 1, 120, 55)];
//    self.hrandTF.placeholder = Custing(@"请输入限制金额", nil);
//    self.hrandTF.font = Font_Important_15_20;
//    self.hrandTF.textColor = Color_Blue_Important_20;
//    self.hrandTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
//    [self.hrandTF setAutocorrectionType:UITextAutocorrectionTypeNo];
//    self.hrandTF.adjustsFontSizeToFitWidth = YES;
//    self.hrandTF.keyboardType = UIKeyboardTypeDecimalPad;
//    [self.mainView addSubview:self.hrandTF];
//    if ([NSString isEqualToNull:cellInfo.amount]) {
//        self.hrandTF.text = cellInfo.amount;
//    }
    NSString * str;
    if ([cellInfo.unit isEqualToString:@"1"]) {
        str = Custing(@"2天", nil);
    }else if ([cellInfo.unit isEqualToString:@"2"]) {
        str = Custing(@"2月", nil);
    }else if ([cellInfo.unit isEqualToString:@"3"]) {
        str = Custing(@"2年", nil);
    }else{
        str = Custing(@"2天", nil);
    }
    
    self.tongBtn = [GPUtils createButton:CGRectMake(Main_Screen_Width-120, 1, 105, 55) action:nil delegate:self title:[NSString stringWithFormat:@"%@%@",Custing(@"2元", nil),str] font:Font_Important_15_20 titleColor:Color_Black_Important_20];
    self.tongBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.tongBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    self.tongBtn.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.tongBtn];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 18, 20, 20)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

///、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
///、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
///、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、

- (void)configLookHRSTandardCellInfo:(HRStandardData *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,[cellInfo.cellHeight integerValue])];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case hrstCellTypeNo:
            [self configLookHRSTandardCellNo:cellInfo];
            break;
        case hrstCellTypeYes:
            [self configLookHRSTandardCellYes:cellInfo];
            break;
        case hrstCellTypeAll:
            [self configLookHRSTandardCellNo:cellInfo];
            break;
        case ForStCellType:
            [self configLookForStandardListCellInfo:cellInfo];
            break;
    }
}
//未设置
-(void)configLookHRSTandardCellNo:(HRStandardData *)cellInfo{
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 1, 60, 53) text:[NSString stringWithFormat:@"%@", cellInfo.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    codeLa.numberOfLines = 0;
    [self.mainView addSubview:codeLa];
    if ([cellInfo.userLevel isEqualToString:@"(null)"]||[cellInfo.userLevel isEqualToString:@"<null>"]||[cellInfo.userLevel isEqualToString:@""]) {
        codeLa.text = @"";
    }
    
    UILabel * contentLa = [GPUtils createLable:CGRectMake(75, 1, Main_Screen_Width - 90, 53) text:Custing(@"请设置限制标准", nil) font:Font_Important_15_20 textColor:Color_GrayLight_Same_20 textAlignment:NSTextAlignmentLeft];
    contentLa.backgroundColor = [UIColor clearColor];
    contentLa.numberOfLines = 0;
    [self.mainView addSubview:contentLa];
    if (cellInfo.type == hrstCellTypeAll) {
        contentLa.textColor = Color_Black_Important_20;
        contentLa.font = Font_Important_15_20;
        contentLa.text = [NSString stringWithFormat:@"%@ %@%@",Custing(@"所有城市，房价最高", nil),cellInfo.housePrice0,Custing(@"元", nil)];
    }
    
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//已设置设置
-(void)configLookHRSTandardCellYes:(HRStandardData *)cellInfo{
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 20, 60, 20) text:[NSString stringWithFormat:@"%@", cellInfo.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    codeLa.numberOfLines = 0;
    [self.mainView addSubview:codeLa];
    if ([cellInfo.userLevel isEqualToString:@"(null)"]||[cellInfo.userLevel isEqualToString:@"<null>"]||[cellInfo.userLevel isEqualToString:@""]) {
        codeLa.text = @"";
    }
    
    
    UILabel * content1La = [GPUtils createLable:CGRectMake(75, -2, Main_Screen_Width-90, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"一线城市，房价最高", nil),cellInfo.housePrice1,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    content1La.backgroundColor = [UIColor clearColor];
    content1La.numberOfLines = 0;
    [self.mainView addSubview:content1La];
    
    UILabel * content2La = [GPUtils createLable:CGRectMake(75, 31, Main_Screen_Width-90, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"二线城市，房价最高", nil),cellInfo.housePrice2,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    content2La.backgroundColor = [UIColor clearColor];
    content2La.numberOfLines = 0;
    [self.mainView addSubview:content2La];
    
    UILabel * content3La = [GPUtils createLable:CGRectMake(75, 63, Main_Screen_Width-90, 40) text:[NSString stringWithFormat:@"%@ %@%@",Custing(@"三线城市，房价最高", nil),cellInfo.housePrice3,Custing(@"元", nil)] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    content3La.backgroundColor = [UIColor clearColor];
    content3La.numberOfLines = 0;
    [self.mainView addSubview:content3La];
    
    
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//补贴列表
-(void)configLookForStandardListCellInfo:(HRStandardData *)cellInfo {
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 1, 60, 53) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    codeLa.numberOfLines = 0;
    [self.mainView addSubview:codeLa];
    if ([NSString isEqualToNull:cellInfo.userLevel]) {
        codeLa.text = [NSString stringWithFormat:@"%@", cellInfo.userLevel];
    }
    
    if (cellInfo.StdAllowances.count == 0) {
        UILabel * contentLa = [GPUtils createLable:CGRectMake(75, 1, Main_Screen_Width - 90, 53) text:Custing(@"请设置限制标准", nil) font:Font_Important_15_20 textColor:Color_GrayLight_Same_20 textAlignment:NSTextAlignmentLeft];
        contentLa.backgroundColor = [UIColor clearColor];
        contentLa.numberOfLines = 0;
        [self.mainView addSubview:contentLa];
    }else {
        for (int j = 0 ; j < [cellInfo.StdAllowances count] ; j ++ ) {
            NSString * typeStr = [[cellInfo.StdAllowances objectAtIndex:j]  objectForKey:@"expenseType"];
            NSString * amountStr = [[cellInfo.StdAllowances objectAtIndex:j]  objectForKey:@"amount"];
            NSString * unitStr = [NSString stringWithFormat:@"%@",[[cellInfo.StdAllowances objectAtIndex:j]  objectForKey:@"unit"]];
            if ([unitStr isEqualToString:@"1"]) {
                unitStr = Custing(@"2天", nil);
            }else if ([unitStr isEqualToString:@"2"]) {
                unitStr = Custing(@"2月", nil);
            }else if ([unitStr isEqualToString:@"3"]) {
                unitStr = Custing(@"2年", nil);
            }else {
                unitStr = Custing(@"2天", nil);
            }
            
            if (![NSString isEqualToNull:typeStr]) {
                typeStr = @"";
            }
            if (![NSString isEqualToNull:amountStr]) {
                amountStr = @"0";
            }
            
            
            UILabel * nameLa = [GPUtils createLable:CGRectMake(75, j*30, WIDTH(self.mainView)-115, 30) text:[NSString stringWithFormat:@"%@:%@%@%@",typeStr,amountStr,Custing(@"2元", nil),unitStr] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.mainView  addSubview:nameLa];
            
            if (cellInfo.StdAllowances.count == 1) {
                nameLa.frame = CGRectMake(75, 1, Main_Screen_Width - 115, 53);
            }
        }
    }
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-30, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
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
