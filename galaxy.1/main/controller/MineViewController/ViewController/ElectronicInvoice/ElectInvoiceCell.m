//
//  ElectInvoiceCell.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ElectInvoiceCell.h"

@implementation ElectInvoiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configViewWithElectResultCellInfo:(ElectInvoiceData *)cellInfo
{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,[cellInfo.height integerValue])];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mainView];
    switch (cellInfo.type) {
        case electCellTypeTitle:
            [self configElectCellTypeTitle:cellInfo];
            break;
        default:
            break;
    }
}

//title
-(void)configElectCellTypeTitle:(ElectInvoiceData*)cellInfo {
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width-60, 43) text:Custing(cellInfo.title, nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLa];
    
    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 13.5, 18, 18)];
    skipImage.image = GPImage(@"skipImage");
    [self.mainView addSubview:skipImage];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.5, Main_Screen_Width-30, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:lineView];
}


//Selected
-(void)configElectListCellTypeSelected:(NSDictionary*)cellInfo {
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width,57)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mainView];
    
    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20.5, 16, 16)];
    self.selectedImage.image = GPImage(@"MyApprove_Select");
    if ([cellInfo[@"type"] isEqualToString:@"0"]) {
        self.selectedImage.image = GPImage(@"MyApprove_UnSelect");
    }
    [self.mainView addSubview:self.selectedImage];
    
    UIImageView * invoiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(45, 13, 15, 15)];
    invoiceImage.image = GPImage(@"quaryInvoiceIcon");
    [self.mainView addSubview:invoiceImage];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(65, 10, Main_Screen_Width-165, 20) text:[NSString isEqualToNull:cellInfo[@"gmF_MC"]] ?cellInfo[@"gmF_MC"] :@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLa];
    
    UILabel * dateLa = [GPUtils createLable:CGRectMake(65, 30, Main_Screen_Width-165, 20) text:[NSString isEqualToNull:cellInfo[@"type"]] ?cellInfo[@"type"] :@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    dateLa.backgroundColor = [UIColor clearColor];
//    [self.mainView addSubview:dateLa];
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-100, 11, 85, 35) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:[NSString isEqualToNull:cellInfo[@"jshj"]] ?cellInfo[@"jshj"] :@""]] font:Font_filterTitle_17 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:lineView];
}


//companySelected
-(void)configCompanyElectListCellTypeSelected:(NSDictionary*)cellInfo {
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width,57)];
    self.mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mainView];
    
    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20.5, 16, 16)];
    self.selectedImage.image = GPImage(@"MyApprove_Select");
    if ([cellInfo[@"type"] isEqualToString:@"0"]) {
        self.selectedImage.image = GPImage(@"MyApprove_UnSelect");
    }
    [self.mainView addSubview:self.selectedImage];
    
    UIImageView * invoiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(45, 13, 15, 15)];
    invoiceImage.image = GPImage(@"quaryInvoiceIcon");
    [self.mainView addSubview:invoiceImage];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(65, 10, Main_Screen_Width-165, 20) text:[NSString isEqualToNull:cellInfo[@"xsF_MC"]] ?cellInfo[@"xsF_MC"] :@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:titleLa];
    
    UILabel * dateLa = [GPUtils createLable:CGRectMake(65, 30, Main_Screen_Width-165, 20) text:[NSString isEqualToNull:cellInfo[@"bX_RQ"]] ?cellInfo[@"bX_RQ"] :@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    dateLa.backgroundColor = [UIColor clearColor];
        [self.mainView addSubview:dateLa];
    
    UILabel * amountLa = [GPUtils createLable:CGRectMake(Main_Screen_Width-100, 11, 85, 35) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:[NSString isEqualToNull:cellInfo[@"invoicE_AMT"]] ?cellInfo[@"invoicE_AMT"] :@""]] font:Font_filterTitle_17 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    amountLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:amountLa];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:lineView];
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
