//
//  WeChatViewCell.m
//  galaxy
//
//  Created by hfk on 2017/11/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "WeChatViewCell.h"

@implementation WeChatViewCell
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configCellWithModel:(WeChatInvoiceModel *)model{
    
    _Lab_Title_Shoupiao.text=Custing(@"收票方", nil);
    if ([NSString isEqualToNull:model.title]) {
        CGSize size = [model.title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-105-2-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
//        [_Lab_Sub_Shoupiao updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(size.height+11));
//        }];
        _Height_Shoupiao.constant = (size.height+11);
//        self.height.constant+=100;

        
        _Lab_Sub_Shoupiao.numberOfLines=3;
        _Lab_Sub_Shoupiao.text=[NSString stringWithFormat:@"%@",model.title];
        [_Lab_Sub_Shoupiao sizeToFit];
    }else{
//        [_Lab_Sub_Shoupiao updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@30);
//        }];
        _Height_Shoupiao.constant = (30);

    }
    
    
    _Lab_Title_ShoupiaoNum.text=Custing(@"收票方识别号", nil);
    _Lab_Sub_ShoupiaoNum.text=[NSString isEqualToNull:model.buyer_number]?[NSString stringWithFormat:@"%@",model.buyer_number]:@"";
    
    
    _Lab_Title_Kaipiao.text=Custing(@"开票方", nil);
    if ([NSString isEqualToNull:model.payee]) {
        CGSize size = [model.title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-105-2-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
//        [_Lab_Sub_Kaipiao updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(size.height+11));
//        }];
        _Height_Kaipiao.constant = (size.height+11);

        _Lab_Sub_Kaipiao.numberOfLines=3;
        _Lab_Sub_Kaipiao.text=[NSString stringWithFormat:@"%@",model.payee];
        [_Lab_Sub_Kaipiao sizeToFit];
    }else{
//        [_Lab_Sub_Kaipiao updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@30);
//        }];
        _Height_Kaipiao.constant = (30);

    }
    
    _Lab_Title_Amount.text=Custing(@"开票金额", nil);
    _Lab_Sub_Amount.text=[GPUtils transformNsNumber:model.fee];
    
    _Lab_Title_Tax.text=Custing(@"税额", nil);
    _Lab_Sub_Tax.text=[GPUtils transformNsNumber:model.tax];
    
    _Lab_Title_Date.text=Custing(@"开票日期", nil);
    _Lab_Sub_Date.text=[NSString isEqualToNull:model.billing_time]?[[NSString stringWithFormat:@"%@",model.billing_time] stringByReplacingOccurrencesOfString:@"-" withString:@"/"]:@"";
    
    _Lab_Title_FapiaoCode.text=Custing(@"发票代码", nil);
    _Lab_Sub_FapiaoCode.text=[NSString isEqualToNull:model.billing_code]?[NSString stringWithFormat:@"%@",model.billing_code]:@"";
    
    
    _Lab_Title_FapiaoNum.text=Custing(@"发票号码", nil);
    _Lab_Sub_FapiaoNum.text=[NSString isEqualToNull:model.billing_no]?[NSString stringWithFormat:@"%@",model.billing_no]:@"";
    
    if ([NSString isEqualToNull:model.pdf_url]) {
        [_Btn_LookPdf setImage:[UIImage imageNamed:@"skipImage"] forState:UIControlStateNormal];
        [_Btn_LookPdf setTitle:Custing(@"电子发票Pdf文件", nil) forState:UIControlStateNormal];
        CGSize size = [Custing(@"电子发票Pdf文件", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 100) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 20;
        CGFloat btnwidth=Main_Screen_Width-24;
        _Btn_LookPdf.titleEdgeInsets = UIEdgeInsetsMake(0, -(btnwidth-titleWidth+imageWidth), 0, 0);
        _Btn_LookPdf.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(btnwidth-imageWidth+titleWidth));
    }else{
        _Img_LineView.hidden=YES;
        _Btn_LookPdf.hidden=YES;
    }
    
    self.Img_Diffent.hidden = ![[NSString stringWithFormat:@"%@",model.code] isEqualToString:@"1000"];
    
    
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    WeChatInvoiceModel *model=(WeChatInvoiceModel *)obj;
    NSInteger height=0;
    if ([NSString isEqualToNull:model.title]) {
        CGSize size = [model.title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-105-2-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        height=height+size.height+11;
    }else{
        height=height+30;
    }
    if ([NSString isEqualToNull:model.payee]) {
        CGSize size = [model.title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-105-2-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        height=height+size.height+11;
    }else{
        height=height+30;
    }
    
    if ([NSString isEqualToNull:model.pdf_url]) {
        height=height+55;
    }
    
    height=height+210;
    
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
