//
//  BudgetCostCenterDetailCell.m
//  galaxy
//
//  Created by hfk on 2019/1/16.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BudgetCostCenterDetailCell.h"


#define cell_width (Main_Screen_Width-24)/3

@implementation BudgetCostCenterDetailCell

- (userData *)userdatas{
    if (!_userdatas) {
        _userdatas = [userData shareUserData];
    }
    return _userdatas;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = Color_White_Same_20;
        
        if (!self.bgView) {
            self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 140)];
            self.bgView.backgroundColor = Color_form_TextFieldBackgroundColor;
            [self.contentView addSubview:self.bgView];
        }
        
        if (!self.TimeLalel) {
            self.TimeLalel = [GPUtils createLable:CGRectMake(0, 0, 0, 0) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.TimeLalel];
            
        }
        
        if (!self.TitleLal1) {
            self.TitleLal1 = [GPUtils createLable:CGRectMake(12, 25, cell_width, 15) text:Custing(@"成本中心", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.TitleLal1];
        }
        if (!self.SubLal1) {
            self.SubLal1 = [GPUtils createLable:CGRectMake(12, 40, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            self.SubLal1.numberOfLines=2;
            [self.contentView addSubview:self.SubLal1];
        }
        
        
        if (!self.TitleLal2) {
            self.TitleLal2 = [GPUtils createLable:CGRectMake(12+cell_width, 25, cell_width, 15) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:self.TitleLal2];
        }
        if (!self.SubLal2) {
            self.SubLal2 = [GPUtils createLable:CGRectMake(12+cell_width, 40, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
            self.SubLal2.numberOfLines=2;
            [self.contentView addSubview:self.SubLal2];
        }
    
        if (!self.TitleLal3) {
            self.TitleLal3 = [GPUtils createLable:CGRectMake(12+cell_width*2, 25, cell_width, 15) text:Custing(@"预算金额", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:self.TitleLal3];
        }
        if (!self.SubLal3) {
            self.SubLal3 = [GPUtils createLable:CGRectMake(12+cell_width*2, 40, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
            self.SubLal3.numberOfLines=2;
            [self.contentView addSubview:self.SubLal3];
        }
        if ([self.userdatas.companyId isEqualToString:@"11888"]) {
            if (!self.TitleLal5) {
                self.TitleLal5 = [GPUtils createLable:CGRectMake(12, 85, cell_width, 15) text:Custing(@"本次使用预算", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
                [self.contentView addSubview:self.TitleLal5];
            }
            
            if (!self.SubLal5) {
                self.SubLal5 = [GPUtils createLable:CGRectMake(12, 100, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
                self.SubLal5.numberOfLines=2;
                [self.contentView addSubview:self.SubLal5];
            }
            
            
            if (!self.TitleLal4) {
                self.TitleLal4 = [GPUtils createLable:CGRectMake(12+cell_width, 85, cell_width, 15) text:Custing(@"上次剩余预算", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
                [self.contentView addSubview:self.TitleLal4];
            }
            if (!self.SubLal4) {
                self.SubLal4 = [GPUtils createLable:CGRectMake(12+cell_width, 100, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
                self.SubLal4.numberOfLines=2;
                [self.contentView addSubview:self.SubLal4];
            }
        }else{
        
        if (!self.TitleLal4) {
            self.TitleLal4 = [GPUtils createLable:CGRectMake(12, 85, cell_width, 15) text:Custing(@"剩余预算", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:self.TitleLal4];
        }
        
        if (!self.SubLal4) {
            self.SubLal4 = [GPUtils createLable:CGRectMake(12, 100, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            self.SubLal4.numberOfLines=2;
            [self.contentView addSubview:self.SubLal4];
        }
        
        
        if (!self.TitleLal5) {
            self.TitleLal5 = [GPUtils createLable:CGRectMake(12+cell_width, 85, cell_width, 15) text:Custing(@"本次报销金额", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:self.TitleLal5];
        }
        if (!self.SubLal5) {
            self.SubLal5 = [GPUtils createLable:CGRectMake(12+cell_width, 100, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
            self.SubLal5.numberOfLines=2;
            [self.contentView addSubview:self.SubLal5];
        }
        }
        if (!self.TitleLal6) {
            self.TitleLal6 = [GPUtils createLable:CGRectMake(12+cell_width*2, 85, cell_width, 15) text:Custing(@"超预算", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:self.TitleLal6];
        }
        if (!self.SubLal6) {
            self.SubLal6 = [GPUtils createLable:CGRectMake(12+cell_width*2, 100, cell_width, 40) text:nil font:Font_Important_15_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentRight];
            self.SubLal6.numberOfLines=2;
            [self.contentView addSubview:self.SubLal6];
        }
    }
    return self;
}
-(void)configCellWithDict:(NSDictionary *)dict withType:(NSInteger)type{
    if ([NSString isEqualToNullAndZero:dict[@"dimType"]] || type == 2) {
        self.bgView.frame = CGRectMake(0, 0, Main_Screen_Width, 165);
        self.TimeLalel.frame = CGRectMake(12, 15, Main_Screen_Width-24, 20);
        self.TitleLal1.frame = CGRectMake(12, 50, cell_width, 15);
        self.SubLal1.frame = CGRectMake(12, 65, cell_width, 40);
        self.TitleLal2.frame = CGRectMake(12+cell_width, 50, cell_width, 15);
        self.SubLal2.frame = CGRectMake(12+cell_width, 65, cell_width, 40);
        self.TitleLal3.frame = CGRectMake(12+cell_width*2, 50, cell_width, 15);
        self.SubLal3.frame = CGRectMake(12+cell_width*2, 65, cell_width, 40);
        self.TitleLal4.frame = CGRectMake(12, 110, cell_width, 15);
        self.SubLal4.frame = CGRectMake(12, 125, cell_width, 40);
        self.TitleLal5.frame = CGRectMake(12+cell_width, 110, cell_width, 15);
        self.SubLal5.frame = CGRectMake(12+cell_width, 125, cell_width, 40);
        self.TitleLal6.frame = CGRectMake(12+cell_width*2, 110, cell_width, 15);
        self.SubLal6.frame = CGRectMake(12+cell_width*2, 125, cell_width, 40);
    }else{
        self.bgView.frame = CGRectMake(0, 0, Main_Screen_Width, 140);
        self.TimeLalel.frame = CGRectZero;
        self.TitleLal1.frame = CGRectMake(12, 25, cell_width, 15);
        self.SubLal1.frame = CGRectMake(12, 40, cell_width, 40);
        self.TitleLal2.frame = CGRectMake(12+cell_width, 25, cell_width, 15);
        self.SubLal2.frame = CGRectMake(12+cell_width, 40, cell_width, 40);
        self.TitleLal3.frame = CGRectMake(12+cell_width*2, 25, cell_width, 15);
        self.SubLal3.frame = CGRectMake(12+cell_width*2, 40, cell_width, 40);
        self.TitleLal4.frame = CGRectMake(12, 85, cell_width, 15);
        self.SubLal4.frame = CGRectMake(12, 100, cell_width, 40);
        self.TitleLal5.frame = CGRectMake(12+cell_width, 85, cell_width, 15);
        self.SubLal5.frame = CGRectMake(12+cell_width, 100, cell_width, 40);
        self.TitleLal6.frame = CGRectMake(12+cell_width*2, 85, cell_width, 15);
        self.SubLal6.frame = CGRectMake(12+cell_width*2, 100, cell_width, 40);
    }
    NSString *timeStr = @"";
    if (type == 1) {
        self.TitleLal2.text = Custing(@"费用类别", nil);
        self.SubLal2.text = [NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]];
        if ([[NSString stringWithFormat:@"%@",dict[@"dimType"]]isEqualToString:@"1"]) {
            timeStr = [NSString stringWithFormat:@"%@: %@",Custing(@"月份", nil),[NSString isEqualToNullAndZero:dict[@"budgetMth"]] ? dict[@"budgetMth"]:@"1"];
        }else if ([[NSString stringWithFormat:@"%@",dict[@"dimType"]]isEqualToString:@"2"]){
            NSString *month = [NSString isEqualToNullAndZero:dict[@"budgetMth"]] ? dict[@"budgetMth"]:@"123";
            NSString *quter = @"1";
            if ([month floatValue] == 123 || [month floatValue] == 1 || [month floatValue] == 2 || [month floatValue] == 3) {
                quter = @"1";
            }else if ([month floatValue] == 456  || [month floatValue] == 4  || [month floatValue] == 5  || [month floatValue] == 6){
                quter = @"2";
            }else if ([month floatValue] == 789 || [month floatValue] == 7 || [month floatValue] == 8 || [month floatValue] == 9){
                quter = @"3";
            }else if ([month floatValue] == 101112 || [month floatValue] == 10 || [month floatValue] == 11 || [month floatValue] == 12){
                quter = @"4";
            }
            timeStr = [NSString stringWithFormat:@"%@: %@",Custing(@"季度", nil),quter];
        }else if ([[NSString stringWithFormat:@"%@",dict[@"dimType"]]isEqualToString:@"3"]){
            NSString *month = [NSString isEqualToNullAndZero:dict[@"budgetMth"]] ? dict[@"budgetMth"]:@"123456";
            NSString *quter = @"1";
            if ([[NSString stringWithFormat:@"%@",month]isEqualToString:@"123456"] ) {
                quter = Custing(@"上半年", nil);
            }else if ([[NSString stringWithFormat:@"%@",month]isEqualToString:@"789101112"]){
                quter = Custing(@"下半年", nil);
            }
            timeStr = quter;
        }
    }else{
        self.TitleLal2.text = Custing(@"辅助核算项目", nil);
        self.SubLal2.text = [NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",dict[@"accountItem"]]];
        timeStr = [NSString stringWithFormat:@"%@: %@",Custing(@"月份", nil),[NSString isEqualToNullAndZero:dict[@"budgetMth"]] ? dict[@"budgetMth"]:@"1"];
    }
    self.TimeLalel.text = timeStr;
    self.SubLal1.text = [NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",dict[@"costCenter"]]];
    self.SubLal3.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"budAmount"]]]?[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",dict[@"budAmount"]]]:@"0.00";
    self.SubLal4.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"surplusAmount"]]]?[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",dict[@"surplusAmount"]]]:@"0.00";
    self.SubLal5.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"totalAmount"]]]?[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",dict[@"totalAmount"]]]:@"0.00";
    self.SubLal6.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"overAmount"]]]?[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",dict[@"overAmount"]]]:@"0.00";

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
