//
//  travelHasSubmitCell.m
//  galaxy
//
//  Created by hfk on 16/5/3.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "travelHasSubmitCell.h"

@implementation travelHasSubmitCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.backgroundColor = [GPUtils randomColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self createView];

    }
    return self;
}
-(void)createView{
    
    if (!_lab_GridOrder) {
        _lab_GridOrder=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_GridOrder];
    }
    [_lab_GridOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@5);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(32, 20));
    }];
    
    if (!_lab_Type) {
        _lab_Type=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Type];
    }
    [_lab_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@5);
        make.left.equalTo(self.contentView).offset(@44);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12-32-130-60-12, 20));
    }];

    if (!_lab_Date) {
        _lab_Date=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_Date];
    }
    [_lab_Date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Type.mas_bottom);
        make.left.equalTo(self.contentView).offset(@44);
        make.size.equalTo(CGSizeMake(75, 15));
    }];

    if (!_Img_Attachment) {
        _Img_Attachment=[GPUtils createImageViewFrame:CGRectZero imageName:@"Approve_Custom_FJ"];
        [self.contentView addSubview:_Img_Attachment];
    }
    [_Img_Attachment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lab_Date.centerY);
        make.left.equalTo(self.contentView).offset(@44);
        make.size.equalTo(CGSizeMake(6, 12));
    }];
    
    
    if (!_btn_Sure) {
        _btn_Sure=[GPUtils createButton:CGRectZero action:nil delegate:nil title:Custing(@"确认", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
        [_btn_Sure.layer setMasksToBounds:YES];
        [_btn_Sure.layer setBorderWidth:1.0];
        _btn_Sure.layer.borderColor=Color_LabelPlaceHolder_Same_20.CGColor;
        _btn_Sure.backgroundColor=Color_LabelPlaceHolder_Same_20;
        [self.contentView addSubview:_btn_Sure];
    }
    [_btn_Sure makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@16);
        make.right.equalTo(self.contentView).offset(@-12);
        make.size.equalTo(CGSizeMake(48, 28));
    }];
    
    
    if (!_lab_Money) {
        _lab_Money=[GPUtils createLable:CGRectZero text:nil font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Money];
    }
    [_lab_Money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).equalTo(@5);
        make.right.equalTo(self.btn_Sure.left).offset(-5);
        make.size.equalTo(CGSizeMake(130, 20));
    }];
    
    
    if (!_lab_Currency) {
        _lab_Currency=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_Currency];
    }
    [_lab_Currency makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Money.bottom);
        make.right.equalTo(self.lab_Money.right);
        make.width.equalTo(@130);
    }];
    
    
    if (!_btn_OverBud) {
        _btn_OverBud= [GPUtils createButton:CGRectZero action:nil delegate:self title:nil font:Font_Same_11_20 titleColor:Color_Red_Weak_20];
        [_btn_OverBud.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:_btn_OverBud];
    }
    [_btn_OverBud makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Currency.bottom);
        make.right.equalTo(self.lab_Money.right);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    
    if (!_lab_OverTime) {
        _lab_OverTime = [GPUtils createLable:CGRectMake(0, 0, 65, 20) text:@"" font:Font_Same_11_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_OverTime];
    }
    [_lab_OverTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn_OverBud.bottom);
        make.right.equalTo(self.lab_Money.right);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    if (!_img_PayWay) {
        _img_PayWay = [GPUtils createImageViewFrame:CGRectMake(0, 0, 45, 13) imageName:@"AddDetail_CompanyPay"];
        [self.contentView addSubview:_img_PayWay];
    }
    [_img_PayWay makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_OverTime.bottom).offset(@2);
        make.right.equalTo(self.lab_Money.right);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    if (!_lab_Att_Content) {
        _lab_Att_Content=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Att_Content.numberOfLines=0;
        [self.contentView addSubview:_lab_Att_Content];
    }
    [_lab_Att_Content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Date.mas_bottom).offset(@-2);
        make.left.equalTo(self.contentView).offset(@44);
        make.width.equalTo(@190);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

-(void)configViewWithArray:(NSMutableArray *)array withIndex:(NSInteger)index withNeedSure:(BOOL)needSure withComePlace:(NSString *)place{
    
    HasSubmitDetailModel *cellInfo=(HasSubmitDetailModel*)array[index];
    
    self.lab_GridOrder.text=[NSString stringWithFormat:@"%ld",index+1];
    self.lab_Type.text=[GPUtils getSelectResultWithArray:@[cellInfo.expenseCat,cellInfo.expenseType]];
    self.lab_Date.text=[NSString stringWithIdOnNO:cellInfo.expenseDate];
    if ([NSString isEqualToNull:cellInfo.attachments]&&![cellInfo.attachments isEqualToString:@"[]"]) {
        self.Img_Attachment.hidden=NO;
    }else{
        self.Img_Attachment.hidden=YES;
    }
    self.Img_Attachment.hidden=YES;

    userData *userdatas = [userData shareUserData];
    
    self.lab_Money.text = [userdatas.multiCyPayment isEqualToString:@"1"] ? [GPUtils transformNsNumber: cellInfo.invPmtAmount] : [GPUtils transformNsNumber: cellInfo.amount];
        
    NSInteger height1=0;
    NSInteger height2=0;
    CGFloat btnWidth=0;
    
    if ([NSString isEqualToNull:cellInfo.currencyCode]) {
        height1=15;
        self.lab_Currency.text=[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",cellInfo.currencyCode],[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",cellInfo.localCyAmount]]] WithCompare:@" "];
    }

    if ([NSString isEqualToNull:cellInfo.overStd]&&[cellInfo.overStd floatValue]>0){
        height2=15;
        NSString *str = Custing(@"超标准", nil);
        if ([NSString isEqualToNullAndZero:cellInfo.overStdAmt]) {
            str = [NSString stringWithFormat:@"%@%@",Custing(@"超标准", nil),[NSString stringWithFormat:@"%@",cellInfo.overStdAmt]];
        }
        CGSize size = [str sizeCalculateWithFont:Font_Same_11_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 100) lineBreakMode:NSLineBreakByCharWrapping];
        btnWidth=size.width;
//        CGFloat titleWidth=size.width;
//        CGFloat imageWidth = 17;
//        btnWidth = titleWidth +imageWidth;
//        _OverBudBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -imageWidth+8);
//        _OverBudBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -imageWidth+8);
//        [_OverBudBtn setImage:[UIImage imageNamed:@"share_ReBack"] forState:UIControlStateNormal];
        [_btn_OverBud setTitle:str forState:UIControlStateNormal];
    }

    [_lab_Currency updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height1);
    }];
    
    [_btn_OverBud updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(btnWidth, height2));
    }];
    
    if ([[NSString stringWithFormat:@"%@",cellInfo.isExpExpired]isEqualToString:@"1"]) {
        [_lab_OverTime updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(65, 20));
        }];
        _lab_OverTime.text =  Custing(@"超期费用", nil);
    }else{
        [_lab_OverTime updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        _lab_OverTime.text = @"";
    }

    [_img_PayWay updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo( [[NSString stringWithFormat:@"%@",cellInfo.payTypeId]isEqualToString:@"2"] ? CGSizeMake(45, 13):CGSizeMake(0, 0));
    }];
    
    if (needSure&&[NSString isEqualToNull:cellInfo.overStd]&&[cellInfo.overStd floatValue]>0) {
        _btn_Sure.hidden=NO;
        _btn_Sure.userInteractionEnabled=YES;
        [_btn_Sure setTitleColor:[cellInfo.hasSured isEqualToString:@"0"]?Color_Blue_Important_20:Color_GrayDark_Same_20 forState:UIControlStateNormal];
        _btn_Sure.layer.borderColor=[cellInfo.hasSured isEqualToString:@"0"]?Color_Blue_Important_20.CGColor:Color_LabelPlaceHolder_Same_20.CGColor;
        _btn_Sure.backgroundColor=[cellInfo.hasSured isEqualToString:@"0"]?Color_form_TextFieldBackgroundColor:Color_LabelPlaceHolder_Same_20;
//        [_btn_Sure updateConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(48, 28));
//        }];
    }else{
        _btn_Sure.hidden=YES;
        _btn_Sure.userInteractionEnabled=NO;
//        [_btn_Sure updateConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(0, 0));
//        }];
    }
    
    self.lab_Att_Content.text=[NSString stringWithIdOnNO:cellInfo.att_content];
    
}
+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight =48;
    
    CGFloat height=0;
    HasSubmitDetailModel *model=(HasSubmitDetailModel *)obj;
    if ([NSString isEqualToNull:model.att_content]) {
        NSString *desStr=[NSString stringWithFormat:@"%@",model.att_content];
        CGSize size = [desStr sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(190, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        height += size.height;
    }else{
        height+=15;
    }
    
    CGFloat height1=8;
    
    if ([[NSString stringWithFormat:@"%@",model.isExpExpired]isEqualToString:@"1"]) {
        height1 += 25;
    }
    if ([[NSString stringWithFormat:@"%@",model.payTypeId]isEqualToString:@"2"]) {
        height1 += 17;
    }
    
    cellHeight += (height > height1 ? height:height1);
  
    return cellHeight;
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
