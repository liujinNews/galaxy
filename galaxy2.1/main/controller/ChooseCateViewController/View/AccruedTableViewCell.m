//
//  AccruedTableViewCell.m
//  galaxy
//
//  Created by APPLE on 2020/1/2.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedTableViewCell.h"

@implementation AccruedTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configViewWithModel:(AccruedDetailModel *)model withIdArray:(NSMutableArray *)IdArray withType:(NSString *)type{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Main_Screen_Width, 197)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSString *MarkId=[AccruedTableViewCell getModelSignWithModel:model WithType:type];
    float gapH = 15.0;
    float gapW = 10.0;
    float labH = 20.0;
    float width_Amount_Per = (Main_Screen_Width - 4*gapW)/10.0;
    //预提明细描述
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(gapW, gapW+6, Main_Screen_Width - 2*gapW, labH)];
    _descriptionLabel.textColor = Color_Black_Important_20;
    _descriptionLabel.font = Font_Important_15_20;
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.text = [NSString stringWithFormat:@"%@/%@-%@",model.serialNo,model.reason,model.gridOrder];
    [self.mainView addSubview:_descriptionLabel];
    //预提明细类别
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(gapW, MaxY(self.descriptionLabel)+gapW, Main_Screen_Width - 2*gapW, labH)];
    _categoryLabel.textColor = Color_Black_Important_20;
    _categoryLabel.font = Font_Important_15_20;
    _categoryLabel.textAlignment = NSTextAlignmentLeft;
    _categoryLabel.text = [NSString stringWithFormat:@"%@",[model.expense stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]];
    [self.mainView addSubview:_categoryLabel];
    //时间
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(gapW, MaxY(self.categoryLabel)+gapW, Main_Screen_Width - 2*gapW, labH)];
    _dateLabel.textColor = Color_GrayDark_Same_20;
    _dateLabel.font = Font_Same_14_20;
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.text = [NSString stringWithFormat:@"%@/%@",model.createTime,model.supplierName];
    [self.mainView addSubview:_dateLabel];
//    //部门（人员）
//    self.departLabel = [[UILabel alloc] initWithFrame:CGRectMake(gapW, gapW, Main_Screen_Width - 2*gapW, labH)];
//    _departLabel.textColor = Color_GrayDark_Same_20;
//    _departLabel.font = Font_Important_15_20;
//    //_departLabel.text;
//    [self.mainView addSubview:_departLabel];
//    //公司
//    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(gapW, gapW, Main_Screen_Width - 2*gapW, labH)];
//    _companyLabel.textColor = Color_GrayDark_Same_20;
//    _companyLabel.font = Font_Important_15_20;
//    //_companyLabel.text;
//    [self.mainView addSubview:_companyLabel];
    //创建分割线
    _gapLineView = [[UIView alloc] initWithFrame:CGRectMake(gapW, MaxY(self.dateLabel)+gapH - 0.25, Main_Screen_Width - gapW, 0.5)];
    _gapLineView.backgroundColor = Color_LineGray_Same_20;
    [self.mainView addSubview:_gapLineView];
    //预提金额
    self.accruedAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(gapW,  MaxY(self.gapLineView)+gapW - 0.25, 4*width_Amount_Per, labH)];
    _accruedAmountLabel.textColor = Color_Black_Important_20;
    _accruedAmountLabel.font = Font_Important_15_20;
    _accruedAmountLabel.textAlignment = NSTextAlignmentLeft;
    _accruedAmountLabel.text = [NSString isEqualToNullAndZero:model.localCyAmount]?[NSString stringWithFormat:@"%@",model.localCyAmount]:@"0.00";
    [self.mainView addSubview:_accruedAmountLabel];
    UILabel *accruedAmountSignLab = [[UILabel alloc] initWithFrame:CGRectMake(gapW, MaxY(self.accruedAmountLabel)+gapW, 4*width_Amount_Per, labH)];
    accruedAmountSignLab.textColor = Color_GrayDark_Same_20;
    accruedAmountSignLab.font = Font_Same_14_20;
    accruedAmountSignLab.textAlignment = NSTextAlignmentLeft;
    accruedAmountSignLab.text = Custing(@"预提金额(CNY)", nil);
    [self.mainView addSubview:accruedAmountSignLab];
    //已冲销金额
    self.writeOffsLabel = [[UILabel alloc] initWithFrame:CGRectMake( MaxX(self.accruedAmountLabel)+gapW, MaxY(self.gapLineView)+gapW - 0.5, 3*width_Amount_Per, labH)];
    _writeOffsLabel.textColor = Color_Black_Important_20;
    _writeOffsLabel.font = Font_Important_15_20;
    _writeOffsLabel.textAlignment = NSTextAlignmentLeft;
    _writeOffsLabel.text = [NSString isEqualToNullAndZero:model.writeOffAmount]?[NSString stringWithFormat:@"%@",model.writeOffAmount]:@"0.00";
    [self.mainView addSubview:_writeOffsLabel];
    UILabel *writeOffsSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(accruedAmountSignLab) + gapW, MaxY(self.writeOffsLabel)+gapW, 3*width_Amount_Per, labH)];
    writeOffsSignLabel.textColor = Color_GrayDark_Same_20;
    writeOffsSignLabel.font = Font_Same_14_20;
    writeOffsSignLabel.text = Custing(@"已冲销金额", nil);
    writeOffsSignLabel.textAlignment = NSTextAlignmentLeft;
    [self.mainView addSubview:writeOffsSignLabel];
    //剩余金额
    self.surplusLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.writeOffsLabel) + gapW, MaxY(self.gapLineView)+gapW - 0.5, 3*width_Amount_Per, labH)];
    _surplusLabel.textColor = Color_Black_Important_20;
    _surplusLabel.font = Font_Important_15_20;
    _surplusLabel.text = [NSString isEqualToNullAndZero:model.surplusAmount]?[NSString stringWithFormat:@"%@",model.surplusAmount]:@"0.00";
    _surplusLabel.textAlignment = NSTextAlignmentLeft;
    [self.mainView addSubview:_surplusLabel];
    UILabel *surplusSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(writeOffsSignLabel)+gapW, MaxY(self.surplusLabel)+gapW, 3*width_Amount_Per, labH)];
    surplusSignLabel.textColor = Color_GrayDark_Same_20;
    surplusSignLabel.font = Font_Same_14_20;
    surplusSignLabel.text = Custing(@"剩余金额", nil);
    surplusSignLabel.textAlignment = NSTextAlignmentLeft;
    [self.mainView addSubview:surplusSignLabel];
    
    if ([IdArray containsObject:MarkId]) {
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(Main_Screen_Width-25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_Select"];
        [self.mainView addSubview:self.selectImageView];
    }else{
        self.selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
        self.selectImageView.center=CGPointMake(Main_Screen_Width-25, 25);
        self.selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        [self.mainView addSubview:self.selectImageView];
    }
    UIView *gapView = [[UIView alloc]initWithFrame:CGRectMake(0, 187, Main_Screen_Width, 10)];
    gapView.backgroundColor = Color_White_Same_20;
    [self.mainView addSubview:gapView];
}
+(NSString *)getModelSignWithModel:(AccruedDetailModel *)model WithType:(NSString *)type{
    NSString *MarkId=@"";
    MarkId=[NSString stringWithFormat:@"%@",model.taskId];
    return MarkId;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
