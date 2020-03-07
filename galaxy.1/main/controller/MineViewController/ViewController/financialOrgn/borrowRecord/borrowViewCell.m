//
//  borrowViewCell.m
//  galaxy
//
//  Created by 赵碚 on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "borrowViewCell.h"

@implementation borrowViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//员工借款
-(void)configBorrowRecordCellInfo:(borrowModel *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * TitleLa = [GPUtils createLable:CGRectMake(15, 10, WIDTH(self.mainView)/4-15, 30) text:[NSString isEqualToNull:cellInfo.requestor]?cellInfo.requestor:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    TitleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:TitleLa];
    
    UILabel * jobLa = [GPUtils createLable:CGRectMake(15, 40, WIDTH(self.mainView)-30, 20) text:[NSString isEqualToNull:cellInfo.requestorDept]?cellInfo.requestorDept:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    jobLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:jobLa];
    
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/4, 10, WIDTH(self.mainView)/4*3-98, 30) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber: cellInfo.amount]] font:Font_filterTitle_17 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if (![NSString isEqualToNull:cellInfo.amount]) {
        amountLa.text = @"";
    }
    
    UILabel * huankLa = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)-98, 15, 83, 40) text:Custing(@"还款", nil) font:Font_selectTitle_15 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentRight];
    huankLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:huankLa];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configEditBorrowRecordCellInfo:(borrowModel*)cellInfo withStatus:(NSString *)status{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UIImageView  *selImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,16,16)];
    selImage.center=CGPointMake(20, 35);
    if ([status isEqualToString:@"1"]) {
        selImage.image=[UIImage imageNamed:@"MyApprove_Select"];
    }else{
        selImage.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
    }
    [self.mainView addSubview:selImage];

    
    UILabel * TitleLa = [GPUtils createLable:CGRectMake(48, 10, 100, 30) text:[NSString isEqualToNull:cellInfo.requestor]?cellInfo.requestor:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    TitleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:TitleLa];
    
    UILabel * jobLa = [GPUtils createLable:CGRectMake(48, 40, Main_Screen_Width-60, 20) text:[NSString isEqualToNull:cellInfo.requestorDept]?cellInfo.requestorDept:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    jobLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:jobLa];
    
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(148, 10, Main_Screen_Width-148-12, 30) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber: cellInfo.amount]] font:Font_filterTitle_17 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if (![NSString isEqualToNull:cellInfo.amount]) {
        amountLa.text = @"";
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



//借款记录
-(void)configItsEmployeeRecordsCellInfo:(borrowModel *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 70)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    UILabel * TitleLa = [GPUtils createLable:CGRectMake(15, 10, WIDTH(self.mainView)/2-15, 30) text:[GPUtils getSelectResultWithArray:@[cellInfo.requestor,cellInfo.requestorDept] WithCompare:@"/"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    TitleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:TitleLa];
    
    UILabel * timeLa = [GPUtils createLable:CGRectMake(15, 40, WIDTH(self.mainView)/2-15, 20) text:[NSString isEqualToNull:cellInfo.operatorDate]?cellInfo.operatorDate:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    timeLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:timeLa];

    NSString * str;
    if ([NSString isEqualToNull:cellInfo.amount]) {
        str =[NSString stringWithFormat:@"+%@",[GPUtils transformNsNumber: cellInfo.amount]];
    }else if ([NSString isEqualToNull:cellInfo.repayAmount]) {
        str = [NSString stringWithFormat:@"-%@",[GPUtils transformNsNumber: cellInfo.repayAmount]];
    }else {
        str = @"";
    }
    UILabel * amountLa = [GPUtils createLable:CGRectMake(ScreenRect.size.width/2-15, 10, ScreenRect.size.width/2, 30) text:str font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([str isEqualToString:@"-0.00"] ||[str isEqualToString:@"+0.00"]) {
        amountLa.text = @"0.00";
    }
    if ([NSString isEqualToNull:cellInfo.amount]) {
        amountLa.textColor = Color_form_TextField_20;
    }else if ([NSString isEqualToNull:cellInfo.repayAmount]) {
        amountLa.textColor = Color_form_TextField_20;
    }else {
        amountLa.textColor = [UIColor clearColor];
    }
    
    UILabel * remarkLa = [GPUtils createLable:CGRectMake(ScreenRect.size.width/2, 40, ScreenRect.size.width/2-15, 20) text:[NSString isEqualToNull:cellInfo.comment]?[NSString stringWithFormat:@"%@", cellInfo.comment]:@"" font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    remarkLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:remarkLa];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//员工账单明细
-(void)configBorrowInfoListCellInfo:(borrowModel *)cellInfo{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 60)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSString *request = @"";
    if ([NSString isEqualToNull:cellInfo.reason]) {
        request = cellInfo.reason;
    }
    UILabel * TitleLa = [GPUtils createLable:CGRectMake(15, 5, WIDTH(self.mainView)/2-15, 30) text:request font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    TitleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:TitleLa];
    
    NSString *dateStr = @"";
    if ([NSString isEqualToNull:cellInfo.requestorDate]) {
        dateStr = cellInfo.requestorDate;
        
    }
    UILabel * dateLa = [GPUtils createLable:CGRectMake(15, 35, WIDTH(self.mainView)/2-15, 25) text:dateStr font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    dateLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:dateLa];
    
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(WIDTH(self.mainView)/2-10, 15, WIDTH(self.mainView)/2-28, 30) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber: cellInfo.amount]] font:Font_filterTitle_17 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    if ([cellInfo.amount isEqualToString:@"(null)"]||[cellInfo.amount isEqualToString:@"<null>"]||[cellInfo.amount isEqualToString:@""]) {
        amountLa.text = @"";
    }
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 21, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5, Main_Screen_Width, 0.5)];
    line1View.backgroundColor = Color_GrayLight_Same_20;
    [self.mainView addSubview:line1View];
    
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
