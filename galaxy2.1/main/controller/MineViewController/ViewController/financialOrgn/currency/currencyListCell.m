//
//  currencyListCell.m
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "currencyListCell.h"

@implementation currencyListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//币种列表
-(void)configCurrencyCellInfo:(currencyData *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 49)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    
    UILabel * codeLa = [GPUtils createLable:CGRectMake(15, 0, ScreenRect.size.width/5-15, 49) text:[NSString stringWithFormat:@"%@", cellInfo.currencyCode] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    codeLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:codeLa];
    if ([cellInfo.currencyCode isEqualToString:@"(null)"]||[cellInfo.currencyCode isEqualToString:@"<null>"]||[cellInfo.currencyCode isEqualToString:@""]) {
        codeLa.text = @"";
    }
    
    UILabel * currencyLa = [GPUtils createLable:CGRectMake(ScreenRect.size.width/5*2, 0, ScreenRect.size.width/5*2-5, 49) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:currencyLa];
    
    if ([cellInfo.stdMoney isEqualToString:@"1"]) {
        currencyLa.text=[NSString stringWithFormat:@"%@%@",cellInfo.currency,Custing(@"(本位币)", nil)];
    }else{
        currencyLa.text=[NSString stringWithFormat:@"%@",cellInfo.currency];
    }

    UILabel * currencyexLa = [GPUtils createLable:CGRectMake(ScreenRect.size.width/5*4-15, 0, ScreenRect.size.width/5, 49) text:[NSString stringWithFormat:@"%@",[GPUtils TransformNsNumber:cellInfo.ExchangeRate]] font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    currencyexLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:currencyexLa];
    if ([cellInfo.ExchangeRate isEqualToString:@"(null)"]||[cellInfo.ExchangeRate isEqualToString:@"<null>"]||[cellInfo.ExchangeRate isEqualToString:@""]) {
        currencyexLa.text = @"";
    }
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, WIDTH(self.mainView)-15, 0.5)];
    self.line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView  addSubview:self.line];
    //    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
//MARK:cell删除背景的线
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            subview.backgroundColor=Color_Sideslip_TableView;
        }
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
