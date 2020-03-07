//
//  personDocTVCell.m
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "personDocTVCell.h"

@implementation personDocTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configViewWithPersonDocCellInfo:(personDocModel *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width,[cellInfo.height integerValue])];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case personDocCellTypeAvater:
            [self configPersonDocCellTypeAvater:cellInfo];
            break;
        case personDocCellTypeName:
            [self configPersonDocCellTypeName:cellInfo];
            [self createGrayLine];
            break;
        case personDocCellTypeDept:
            [self configPersonDocCellTypeDept:cellInfo];
            [self createGrayLine];
            break;
        case personDocCellTypeBankCard:
            [self configPersonDocCellTypeBankCard:cellInfo];
            [self createGrayLine];
            break;
        case personDocCellTypePhoneHidden:
            [self configPersonDocCellTypePhoneHidden:cellInfo];
            break;
        case personDocCellTypeLookReportRoot:
            [self configPersonDocCellTypeLookReportRoot:cellInfo];
            break;
        case personDocCellTypeSignature:
            [self configPersonDocCellTypeSignature:cellInfo];
            break;
    }
}
-(void)createGrayLine{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, HEIGHT(self.mainView)-0.5, ScreenRect.size.width-30, 0.5)];
    line.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView addSubview:line];
}

//签名
-(void)configPersonDocCellTypeSignature:(personDocModel*)cellInfo {
    
    UILabel * companyInfoLbl = [GPUtils createLable:CGRectMake(15, 1, WIDTH(self.mainView)/3*2, 35) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    companyInfoLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:companyInfoLbl];
    
    self.HeadPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-187, 9.5, 150, 40)];
    self.HeadPortrait.image = nil;
    [self.mainView addSubview:self.HeadPortrait];
    
    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"signature"]]];
    
    if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
        NSString * photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        [self.HeadPortrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoGraph]]];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 26, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UILabel * numberHLbl = [GPUtils createLable:CGRectMake(15, 50, WIDTH(self.mainView)-30, 20) text:Custing(@"报销单据打印后，审批人显示为签名图片", nil) font:[UIFont systemFontOfSize:13.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    numberHLbl.backgroundColor = [UIColor clearColor];
    numberHLbl.numberOfLines = 0;
    [self.mainView addSubview:numberHLbl];
}


//头像
-(void)configPersonDocCellTypeAvater:(personDocModel*)cellInfo{
    
    UILabel * companyInfoLbl = [GPUtils createLable:CGRectMake(15, 1, WIDTH(self.mainView)/3*2, 57) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    companyInfoLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:companyInfoLbl];
    
    NSString * avatar;
    if ([[NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"gender"]] isEqualToString:@"0"]) {
        avatar =@"Message_Man";
    }else{
        avatar = @"Message_Woman";
    }
    self.HeadPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-79, 7.5, 45, 45)];
    self.HeadPortrait.image = GPImage(avatar);
    [self.mainView addSubview:self.HeadPortrait];
    
    self.HeadPortrait.layer.cornerRadius = 22.0f;
    self.HeadPortrait.layer.masksToBounds = YES;
    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"photoGraph"]]];
    
    if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
        NSString * photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        [self.HeadPortrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoGraph]]];
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 20.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    
}

//姓名、性别、手机、邮箱
-(void)configPersonDocCellTypeName:(personDocModel*)cellInfo{

    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 1, WIDTH(self.mainView)/3-15, 47) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 15.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"姓名", nil)]) {
        self.nameLbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-35, 47) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
        NSString * userDspName = [NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"userDspName"]];
        if ([NSString isEqualToNull:userDspName]) {
            self.nameLbl.text = userDspName;
        }
        self.nameLbl.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.nameLbl];
    }else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"性别", nil)]){
        BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
        self.sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-((lan)?75:115), 14.5, 20, 20)];
        self.sexLbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)-((lan)?55:95), 1, ((lan)?20:60), 47) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
        self.sexLbl.backgroundColor = [UIColor clearColor];
        if ([[NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"gender"]]isEqualToString:@"1"]) {
            self.sexImage.image = GPImage(@"my_sexwoman");
            self.sexLbl.text = Custing(@"女", nil);
        }else{
            self.sexImage.image = GPImage(@"my_sexman");
            self.sexLbl.text = Custing(@"男", nil);
             self.sexImage.frame = CGRectMake(WIDTH(self.mainView)-((lan)?75:95), 14.5, 20, 20);
        }
        [self.mainView addSubview:self.sexLbl];
        [self.mainView addSubview:self.sexImage];
    }else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"手机", nil)]){
        self.phoneStr = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-15, 47) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        NSString * mobile = [NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"mobile"]];
        if ([NSString isEqualToNull:mobile]) {
            self.phoneStr.text = mobile;
        }
        self.phoneStr.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.phoneStr];
        skipImage.hidden = YES;
    }else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"工号", nil)]){
        self.hrid = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-15, 47) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        NSString * mobile = [NSString stringWithFormat:@"%@",[NSString isEqualToNull:[cellInfo.perDoc objectForKey:@"hrid"]]?[cellInfo.perDoc objectForKey:@"hrid"]:@""];
        if ([NSString isEqualToNull:mobile]) {
            self.hrid.text = mobile;
        }
        self.hrid.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.hrid];
        skipImage.hidden = YES;
    }else{
        self.emailLbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-35, 47) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
        NSString * email = [NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"email"]];
        if ([NSString isEqualToNull:email]) {
            self.emailLbl.text = email;
        }
        self.emailLbl.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:self.emailLbl];
    }
    
    
}

//部门、职位、级别、成本中心、公司
-(void)configPersonDocCellTypeDept:(personDocModel*)cellInfo{
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)/3-15, 50) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.numberOfLines = 0;
    [self.mainView addSubview:titleLbl];
    
    UILabel * contentLbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-15, [cellInfo.height integerValue]) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    
    //部门、职位
    NSString * jobTitle = @"";
//    NSString * groupName;
    NSArray * userGroup = [cellInfo.perDoc objectForKey:@"userGroup"];
    if ([userGroup isKindOfClass:[NSNull class]] || userGroup == nil|| userGroup.count == 0||!userGroup){
        
    }else{
//        NSArray * userarray = [userGroup subarrayWithRange:NSMakeRange(0, 1)];
        
        for (int i = 0; i<userGroup.count; i++) {
            NSDictionary * listDic = userGroup[i];
            if (i==userGroup.count-1) {
                jobTitle = [NSString stringWithFormat:@"%@%@/%@",jobTitle,[listDic objectForKey:@"groupName"],[listDic objectForKey:@"jobTitle"]];
            }else{
                jobTitle = [NSString stringWithFormat:@"%@%@/%@ \n",jobTitle,[listDic objectForKey:@"groupName"],[listDic objectForKey:@"jobTitle"]];
            }
        }
        
//        for (NSDictionary * listDic in userGroup) {
//           
////            groupName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupName"]];
//            jobTitle = [NSString stringWithFormat:@"%@%@/%@ \n",jobTitle,[listDic objectForKey:@"jobTitle"],[listDic objectForKey:@"groupName"]];
//        }
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 15.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"部门/职位", nil)]) {
        skipImage.hidden = YES;
//        contentLbl.frame = CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-35, 47);
        if ([NSString isEqualToNull:jobTitle]) {
            contentLbl.text = [NSString stringWithFormat:@"%@",jobTitle];
            contentLbl.numberOfLines = 0;
        }
    }
//    else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"", nil)]){
//        contentLbl.frame = CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-35, 47);
//        if ([NSString isEqualToNull:jobTitle]) {
//            contentLbl.text = jobTitle;
//        }
//    }
    else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"级别", nil)]){
        skipImage.hidden = YES;
        if ([NSString isEqualToNull:[cellInfo.perDoc objectForKey:@"userLevel"]]) {
            contentLbl.text = [cellInfo.perDoc objectForKey:@"userLevel"];
        }
    }else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"成本中心", nil)]){
        skipImage.hidden = YES;
        NSString * costCenter = [NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"costCenter"]];
        if ([NSString isEqualToNull:costCenter]) {
            contentLbl.text = costCenter;
        }
    }else if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"公司", nil)]){
        skipImage.hidden = YES;
        NSString * branchName = [NSString stringWithFormat:@"%@",[cellInfo.perDoc objectForKey:@"branchName"]];
        if ([NSString isEqualToNull:branchName]) {
            contentLbl.text = branchName;
        }
    }
    contentLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:contentLbl];
    
}

//银行卡号、证件号
-(void)configPersonDocCellTypeBankCard:(personDocModel*)cellInfo{
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 1, WIDTH(self.mainView)/3-15, 57) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.numberOfLines = 0;
    [self.mainView addSubview:titleLbl];
    
    //请添加
    UILabel * contentLbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 1, WIDTH(self.mainView)/3*2-35, 57) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    contentLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:contentLbl];
    //卡名称
    UILabel * cardNLbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 30, WIDTH(self.mainView)/3*2-35, 29) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    cardNLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cardNLbl];
    //卡号
    UILabel * cardILbl = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/3, 0, WIDTH(self.mainView)/3*2-35, 30) text:@"" font:[UIFont systemFontOfSize:14.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    cardILbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:cardILbl];
    
    
    if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"收款人", nil)]) {
        NSDictionary * bankInfoDic = [cellInfo.perDoc objectForKey:@"bankAccountInfo"];
        if ([bankInfoDic isKindOfClass:[NSNull class]] ||bankInfoDic == nil||bankInfoDic.count == 0||!bankInfoDic){
            contentLbl.text = Custing(@"请输入", nil);
        }else{
            if ([NSString isEqualToNull:[bankInfoDic objectForKey:@"bankAccount"]]) {
                NSString * identityStr = [bankInfoDic objectForKey:@"bankAccount"];
                if (identityStr !=nil&&identityStr.length>=6) {
                    NSString *a = [identityStr substringToIndex:6];
                    NSString *b = [identityStr substringFromIndex:identityStr.length -4];
                    cardILbl.text = [NSString stringWithFormat:@"%@***%@",a,b];
                }
            }
            if ([NSString isEqualToNull:[bankInfoDic objectForKey:@"bankName"]]) {
                cardNLbl.text = [bankInfoDic objectForKey:@"bankName"];
            }
            
        }
        
    }
    
    if ([Custing(cellInfo.title, nil) isEqualToString:Custing(@"证件号", nil)]) {
        
        if ([NSString isEqualToNull:[cellInfo.perDoc objectForKey:@"identityCardId"]]) {
            if ([NSString isEqualToNull:[cellInfo.perDoc objectForKey:@"credentialType"]]) {
                cardNLbl.text = Custing([cellInfo.perDoc objectForKey:@"credentialType"], nil);
            }
            NSString * identityStr = [cellInfo.perDoc objectForKey:@"identityCardId"];
            if (identityStr.length>=5) {
                cardILbl.text = [identityStr stringByReplacingCharactersInRange:NSMakeRange(floor(identityStr.length/2)-1,3) withString:@"***"];
            }else{
                cardILbl.text =identityStr;
            }
        }else{
            contentLbl.text = Custing(@"请输入", nil);
        }
        
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.mainView)-35, 20.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    
}

//号码隐藏
-(void)configPersonDocCellTypePhoneHidden:(personDocModel*)cellInfo{
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)/3*2, 35) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    UILabel * numberHLbl = [GPUtils createLable:CGRectMake(15, 30, WIDTH(self.mainView)-30, 35) text:Custing(@"号码隐藏后，通讯录中不再显示手机号码", nil) font:[UIFont systemFontOfSize:13.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    numberHLbl.backgroundColor = [UIColor clearColor];
    numberHLbl.numberOfLines = 0;
    [self.mainView addSubview:numberHLbl];
    
    
}

//查看报表权限
-(void)configPersonDocCellTypeLookReportRoot:(personDocModel*)cellInfo{
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 0, WIDTH(self.mainView)/3*2, 35) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLbl];
    
    
    UILabel *lab_content = [GPUtils createLable:CGRectMake(15, 35, Main_Screen_Width-30, 50) text:Custing(@"开启后有权限查看本部门、以及下级部门员工提交的报销，生成的部门费用统计表。", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    lab_content.numberOfLines = 0;
    [self.mainView addSubview:lab_content];
    
    
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
