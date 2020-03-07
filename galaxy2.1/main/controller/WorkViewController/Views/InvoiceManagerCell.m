//
//  InvoiceManagerCell.m
//  galaxy
//
//  Created by hfk on 2017/11/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "InvoiceManagerCell.h"

@implementation InvoiceManagerCell
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configCellWithModel:(InvoiceManagerModel *)model{
    if ([NSString isEqualToNull:model.salesName]) {
        CGSize size = [model.salesName sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12-130, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        [_Lab_Invoice_Title updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(size.height+11));
        }];
        _Lab_Invoice_Title.numberOfLines=0;
        _Lab_Invoice_Title.text=[NSString stringWithFormat:@"%@",model.salesName];
        [_Lab_Invoice_Title sizeToFit];
    }else{
        [_Lab_Invoice_Title updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
        }];
    }
    
    if ([model.invoiceType isEqualToString:@"1"]) {
        _Img_Invoice_Type.image=[UIImage imageNamed:@"Invoice_1"];
    }else if ([model.invoiceType isEqualToString:@"2"]){
        _Img_Invoice_Type.image=[UIImage imageNamed:@"Invoice_2"];
    }else if ([model.invoiceType isEqualToString:@"3"]){
        _Img_Invoice_Type.image=[UIImage imageNamed:@"Invoice_3"];
    }
    
    _Lab_Invoice_Amount.text=[GPUtils transformNsNumber:model.amountTax];
    _Lab_Invoice_Amount.font=[UIFont fontWithName:@"Helvetica"size:18];

    _Lab_Invoice_Date.text=[NSString isEqualToNull:model.billingDate]?[NSString stringWithFormat:@"%@",model.billingDate]:@"";

    NSString *type=@"";
    if ([model.flowCode isEqualToString:@"F0002"]) {
        type=Custing(@"差旅费", nil);
    }else if ([model.flowCode isEqualToString:@"F0003"]){
        type=Custing(@"日常费", nil);
    }else if ([model.flowCode isEqualToString:@"F0010"]){
        type=Custing(@"专项费", nil);
    }else if ([model.flowCode isEqualToString:@"F0009"]){
        type=Custing(@"付款", nil);
    }
    NSArray *arr=@[type,model.expenseType];
    
    NSString *status=@"";
    if ([model.status floatValue]==1) {
        status=Custing(@"未报销", nil);
    }else if ([model.status floatValue]==2){
        status=Custing(@"审批中", nil);
    }else if ([model.status floatValue]==3){
        status=Custing(@"审批完成", nil);
    }else if ([model.status floatValue]==4){
        status=Custing(@"已支付", nil);
    }else if ([model.status floatValue]==5){
        status=Custing(@"已入账", nil);
    }
    _Lab_Invoice_SubTitle.text=[GPUtils getSelectResultWithArray:@[[GPUtils getSelectResultWithArray:arr],status] WithCompare:@"-"];
    
    if ([[NSString stringWithFormat:@"%@",model.source]isEqualToString:@"12"]) {
        _Lab_DateSource.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"百望电子", nil)];
    }else if ([[NSString stringWithFormat:@"%@",model.source]isEqualToString:@"15"]){
        _Lab_DateSource.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"发票扫描", nil)];
    }else if ([[NSString stringWithFormat:@"%@",model.source]isEqualToString:@"16"]){
        _Lab_DateSource.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"微信卡包", nil)];
    }else if ([[NSString stringWithFormat:@"%@",model.source]isEqualToString:@"18"]){
        _Lab_DateSource.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"发票拍照", nil)];
    }else if ([[NSString stringWithFormat:@"%@",model.source]isEqualToString:@"21"]){
        _Lab_DateSource.text = [NSString stringWithFormat:@"%@ : %@",Custing(@"发票来源", nil),Custing(@"发票拍照", nil)];
    }
    self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
}
+ (CGFloat)cellHeightWithObj:(id)obj{
    InvoiceManagerModel *model=(InvoiceManagerModel *)obj;
    NSInteger height=0;
    if ([NSString isEqualToNull:model.salesName]) {
        CGSize size = [model.salesName sizeCalculateWithFont:Font_filterTitle_17 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12-130, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        height=height+size.height+12;
    }else{
        height=height+30;
    }
    
    height=height+12+10+20+28;
    return height;
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
