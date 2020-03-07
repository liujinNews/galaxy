//
//  mineTVCell.m
//  galaxy
//
//  Created by 赵碚 on 16/4/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "mineTVCell.h"

@implementation mineTVCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configViewWithMineCellInfo:(mineModel *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,[cellInfo.height integerValue])];
//    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case mineCellTypeInfo:
            [self configCoMineCellTypeInfo:cellInfo];
            break;
        case mineCellTypeDelegateInfo:
            [self configmineCellTypeDelegateInfo:cellInfo];
            break;
        case mineCellTypeCompany:
            [self configmineCellTypeCompany:cellInfo];
            break;
        case mineCellTypeCompanyInfo:
            [self configmineCellTypeCompany:cellInfo];
            break;
        case mineCellTypeMessage:
            [self configmineCellTypeMessage:cellInfo];
            break;
        case mineCellTypeShare:
            [self configmineCellTypeShare:cellInfo];
            break;
        case mineCellTypeSetting:
            [self configmineCellTypeSetting:cellInfo];
            break;
    }
}

//头像及昵称
-(void)configCoMineCellTypeInfo:(mineModel*)cellInfo{
    
//    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -560, Main_Screen_Width, 750)];
//    headerbg.image = GPImage(@"Travel_back");
//    [self.mainView addSubview:headerbg];
    
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [cellInfo.height integerValue])];
    headerbg.image = GPImage(@"my_Headerbackground");
    [self.mainView addSubview:headerbg];
    
    NSString * avatar = [NSString stringWithFormat:@"%@",cellInfo.perDic.gender];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-90, 45, 70, 70)];
    icon.image = GPImage([avatar isEqualToString:@"1"] ? @"Message_Woman" : @"Message_Man");
    icon.layer.cornerRadius = 34.5f;
    icon.layer.masksToBounds = YES;
    [self.mainView addSubview:icon];
    
    if ([FestivalStyle isEqualToString:@"1"]) {
       headerbg.image = GPImage(@"my_HeaderBKcris");
    }
    
    if ([NSString isEqualToNull:cellInfo.perDic.photoGraph]){
        [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cellInfo.perDic.photoGraph]]];
    }
    if (!self.avatorImage) {
        self.avatorImage = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width-90, 45, 70, 70)];
        self.avatorImage.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.avatorImage];
    }
    
    NSString * comNameStr;
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.perDic.company]]) {
        comNameStr = @"";
    }else{
        comNameStr = [NSString stringWithFormat:@"%@",cellInfo.perDic.company];
    }
    self.companyNameBtn = [GPUtils createButton:CGRectMake(15, 45, Main_Screen_Width-90-15, 50) action:nil delegate:self title:comNameStr font:Font_Amount_21_20 titleColor:Color_White_Same_20];
    [self.companyNameBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:21]];
    self.companyNameBtn.titleLabel.numberOfLines=2;
    self.companyNameBtn.userInteractionEnabled = NO;
    [self.mainView addSubview:self.companyNameBtn];
    self.companyNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(15, Y(self.companyNameBtn)+55, 110, 20) action:nil delegate:self title:@"" font:Font_Same_12_20 titleColor:Color_form_TextFieldBackgroundColor];
    chooseBtn.backgroundColor = Color_Green_Weak_20;
    chooseBtn.layer.cornerRadius = 10;
    chooseBtn.userInteractionEnabled = NO;
    [self.mainView addSubview:chooseBtn];
    UILabel * comNumberLbl = [GPUtils createLable:CGRectMake(1, 0, 108, 20) text:Custing(@"企业号：", nil) font:[UIFont systemFontOfSize:13.0] textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
    comNumberLbl.backgroundColor = [UIColor clearColor];
    [chooseBtn addSubview:comNumberLbl];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.perDic.coCode]]) {
        comNumberLbl.text = [NSString stringWithFormat:@"%@%@",Custing(@"企业号：", nil),cellInfo.perDic.coCode];
    }
    if ([FestivalStyle isEqualToString:@"1"]) {
        chooseBtn.backgroundColor = RGB(253, 210, 90);
        comNumberLbl.textColor = Color_Red_Festival_20;
    }
    
    UILabel * nicknameLbl = [GPUtils createLable:CGRectMake(15, [cellInfo.height integerValue] - 50, Main_Screen_Width-24, 30) text:@"" font:Font_filterTitle_17 textColor:Color_White_Same_20 textAlignment:NSTextAlignmentLeft];
    nicknameLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nicknameLbl];
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.perDic.userDspName]]) {
        nicknameLbl.text = @"";
    }else{
        nicknameLbl.text = cellInfo.perDic.userDspName;
    }
    
    CGSize size = [NSString sizeWithText:nicknameLbl.text font:Font_filterTitle_17 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    NSString * jobTitle;
    NSString * groupName = [NSString stringWithIdOnNO:cellInfo.perDic.department];
    
    UILabel * companyjobTitle = [GPUtils createLable:CGRectMake(X(nicknameLbl)+size.width, Y(nicknameLbl), Main_Screen_Width-size.width-30, 30) text:@"" font:Font_Important_15_20 textColor:Color_White_Same_20 textAlignment:NSTextAlignmentLeft];
    companyjobTitle.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:companyjobTitle];
    
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",groupName]]) {
        companyjobTitle.text = @"";
    }else{
        companyjobTitle.text = [NSString stringWithFormat:@"(%@)",groupName];
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;

}



//Delegate头像及昵称
-(void)configmineCellTypeDelegateInfo:(mineModel*)cellInfo{
    
    UIImageView *headerbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [cellInfo.height integerValue])];
    headerbg.image = GPImage(@"my_HeaderDelegate");
    [self.mainView addSubview:headerbg];
    
    NSString * avatar = [NSString stringWithFormat:@"%@",cellInfo.perDic.gender];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)/2-35, [cellInfo.height floatValue]/4-10, 70, 70)];
    icon.image = GPImage([avatar isEqualToString:@"1"] ? @"Message_Woman" : @"Message_Man");
    icon.layer.cornerRadius = 34.5f;
    icon.layer.masksToBounds = YES;
    [self.mainView addSubview:icon];
    
//    if (FestivalStyle == 1) {
//        headerbg.image = GPImage(@"my_HeaderBKcris");
//        
//        UIImageView *Avatarcris = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)/2-44.5, Y(icon)-9, 44.5, 50)];
//        Avatarcris.image = GPImage(@"my_HeaderAvatarcris");
//        Avatarcris.backgroundColor = [UIColor clearColor];
//        [self.mainView addSubview:Avatarcris];
//    }
    
    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString isEqualToNull:cellInfo.perDic.photoGraph]?cellInfo.perDic.photoGraph:@""];
    
    if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
        NSString * photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoGraph]]];
    }
    
    if (!self.avatorImage) {
        self.avatorImage = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-35, [cellInfo.height floatValue]/4-10, 70, 70)];
        self.avatorImage.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.avatorImage];
    }
    
    UILabel * nicknameLbl = [GPUtils createLable:CGRectMake(15, Y(icon)+25, WIDTH(self.mainView)/2-75, 20) text:@"" font:Font_Important_15_20 textColor:Color_White_Same_20 textAlignment:NSTextAlignmentRight];
    nicknameLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:nicknameLbl];
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.perDic.userDspName]]) {
        nicknameLbl.text = @"";
    }else{
        nicknameLbl.text = cellInfo.perDic.userDspName;
    }
    
//    NSString * jobTitle;
    NSString * groupName = [NSString stringWithIdOnNO:cellInfo.perDic.department];
    
    UILabel * companyjobTitle = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/2+60, Y(icon)+25, WIDTH(self.mainView)/2-75, 20) text:@"" font:Font_Important_15_20 textColor:Color_White_Same_20 textAlignment:NSTextAlignmentLeft];
    companyjobTitle.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:companyjobTitle];
    
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",groupName]]) {
        companyjobTitle.text = @"";
    }else{
        companyjobTitle.text = groupName;
    }
    
    NSString * comNameStr;
    if (![NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.perDic.company]]) {
        comNameStr = @"";
    }else{
        comNameStr = [NSString stringWithFormat:@"%@",cellInfo.perDic.company];
    }
    self.companyNameBtn = [GPUtils createButton:CGRectMake(0, [cellInfo.height floatValue]/100*62, WIDTH(self.mainView), 15) action:nil delegate:self title:comNameStr font:[UIFont systemFontOfSize:13.0] titleColor:Color_White_Same_20];
    self.companyNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -17.5, 0, 0);
    [self.mainView addSubview:self.companyNameBtn];
    
    CGSize size = [NSString sizeWithText:self.companyNameBtn.titleLabel.text font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIImageView * downImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2+size.width/2 - 5, 0, 15, 15)];
    downImage.image = [UIImage imageNamed:@"my_companyQie"];
    [self.companyNameBtn addSubview:downImage];
    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(Main_Screen_Width/2-55, [cellInfo.height floatValue]/100*76, 110, 20) action:nil delegate:self title:@"" font:[UIFont systemFontOfSize:13.0] titleColor:Color_form_TextFieldBackgroundColor];
    chooseBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
    chooseBtn.layer.cornerRadius = 10;
    chooseBtn.userInteractionEnabled = NO;
    [self.mainView addSubview:chooseBtn];
    
    UILabel * comNumberLbl = [GPUtils createLable:CGRectMake(1, 0, 108, 20) text:Custing(@"企业号：", nil) font:[UIFont systemFontOfSize:13.0] textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
    comNumberLbl.backgroundColor = [UIColor clearColor];
    [chooseBtn addSubview:comNumberLbl];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",cellInfo.perDic.coCode]]) {
        comNumberLbl.text = [NSString stringWithFormat:@"%@%@",Custing(@"企业号：", nil),cellInfo.perDic.coCode];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    userData *data = [userData shareUserData];
    if (data.SystemType == 1) {
        [self.avatorImage setImage:[UIImage imageNamed:[NSString isEqualToNull:data.SystemphotoGraph]?data.SystemphotoGraph:[avatar isEqualToString:@"1"] ? @"Message_Woman" : @"Message_Man"] forState:UIControlStateNormal];
        nicknameLbl.text = data.SystemRequestor;
        companyjobTitle.text = data.SystemRequestorDept;
    }
}


//公司管理、邀请、分享
-(void)configmineCellTypeCompany:(mineModel*)cellInfo{
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.mainView), 0.5)];
    lineView.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:lineView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 22, 22)];
    icon.image = cellInfo.iconImage;
    [self.mainView addSubview:icon];
    
    UILabel *titleLbl = [GPUtils createLable:CGRectMake(52, 13, WIDTH(self.mainView)-87, 22) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 15, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(52, 47.4, WIDTH(self.mainView)-52, 0.5)];
    lineView1.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:lineView1];
    
}

//财务管理、帮助与反馈
-(void)configmineCellTypeMessage:(mineModel*)cellInfo{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 22, 22)];
    icon.image = cellInfo.iconImage;
    [self.mainView addSubview:icon];
    
    UILabel *titleLbl = [GPUtils createLable:CGRectMake(52, 13, WIDTH(self.mainView)-87, 22) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 15, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 47.4, WIDTH(self.mainView), 0.5)];
    lineView1.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:lineView1];
    
}

//分享
-(void)configmineCellTypeShare:(mineModel*)cellInfo{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 22, 22)];
    icon.image = cellInfo.iconImage;
    [self.mainView addSubview:icon];
    
    UILabel *titleLbl = [GPUtils createLable:CGRectMake(52, 13, WIDTH(self.mainView)-87, 22) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 15, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(52, 47.4, WIDTH(self.mainView)-52, 0.5)];
    lineView1.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:lineView1];
    
}
//设置
-(void)configmineCellTypeSetting:(mineModel*)cellInfo{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 22, 22)];
    icon.image = cellInfo.iconImage;
    [self.mainView addSubview:icon];
    
    UILabel *titleLbl = [GPUtils createLable:CGRectMake(52, 13, WIDTH(self.mainView)-87, 22) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 15, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.mainView), 0.5)];
    lineView.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:lineView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 47.4, WIDTH(self.mainView), 0.5)];
    lineView1.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:lineView1];
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
