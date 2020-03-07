//
//  CustomNotesCell.m
//  galaxy
//
//  Created by hfk on 16/4/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CustomNotesCell.h"

@implementation CustomNotesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
    }
    return self;
}
- (void)configViewWithCellInfo:(AddDetailsModel *)model{
    [self.mainView removeFromSuperview];
    CGSize size = [model.expenseType sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-225, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    //                NSLog(@"%f",size.height);
    //    return 56+size.height;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 50+size.height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    self.iconImageView=[[UIImageView alloc] init];
    if ([NSString isEqualToNull:model.expenseIcon]) {
        self.iconImageView.image=[UIImage imageNamed:model.expenseIcon];
    }else{
        self.iconImageView.image=[UIImage imageNamed:@"15"];
    }
    self.iconImageView.frame=CGRectMake(0,0,42,42);
    self.iconImageView.center=CGPointMake(37, (50+size.height)/2);
    [self.mainView addSubview:self.iconImageView];
    
    self.titleLabel = [GPUtils createLable:CGRectMake(67,16,Main_Screen_Width-225,size.height) text:model.expenseType font:Font_Important_15_20  textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines=0;
    //    self.titleLabel.backgroundColor=[UIColor blueColor];
    [self.mainView addSubview:self.titleLabel];
    
    self.datesLabel = [GPUtils createLable:CGRectMake(67,Y(self.titleLabel)+HEIGHT(self.titleLabel)+5,Main_Screen_Width-150, 14) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.expenseDesc],[NSString stringWithFormat:@"%@",model.remark]] WithCompare:@""] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.datesLabel];
    
    
    self.moneyLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber: model.localCyAmount]] font:Font_Important_18_20  textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentRight];
    //    self.moneyLabel.backgroundColor=[UIColor cyanColor];
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-85,(50+size.height)/2);
    [self.mainView addSubview:self.moneyLabel];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.currencyCode]]) {
        self.CurrCodeLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.currencyCode],[GPUtils transformNsNumber:model.amount]] WithCompare:@" "] font:Font_Same_12_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        //    self.CurrCodeLabel.backgroundColor=[UIColor redColor];
        self.CurrCodeLabel.center=CGPointMake(Main_Screen_Width-85, 35+size.height/2);
        [self.mainView addSubview:self.CurrCodeLabel];
    }
    
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-85, 15+size.height/2);

    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}
- (void)configViewWithCellInfo:(AddDetailsModel *)model WithCleck:(NSString *)check{
    [self.mainView removeFromSuperview];
    CGSize size = [model.expenseType sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-200, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    //                NSLog(@"%f",size.height);
    //    return 56+size.height;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 50+size.height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    self.iconImageView=[[UIImageView alloc] init];
    if ([NSString isEqualToNull:model.expenseIcon]) {
        self.iconImageView.image=[UIImage imageNamed:model.expenseIcon];
    }else{
        self.iconImageView.image=[UIImage imageNamed:@"15"];
    }
    self.iconImageView.frame=CGRectMake(0,0,42,42);
    self.iconImageView.center=CGPointMake(62, (50+size.height)/2);
    [self.mainView addSubview:self.iconImageView];
    
    
    self.titleLabel = [GPUtils createLable:CGRectMake(92,16,Main_Screen_Width-200,size.height) text:model.expenseType font:Font_Important_15_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines=0;
    //    self.titleLabel.backgroundColor=[UIColor blueColor];
    [self.mainView addSubview:self.titleLabel];
    
    self.datesLabel = [GPUtils createLable:CGRectMake(92,Y(self.titleLabel)+HEIGHT(self.titleLabel)+5,Main_Screen_Width-150, 14) text:[NSString stringWithFormat:@"%@%@",[NSString stringWithIdOnNO:model.expenseDesc],[NSString isEqualToNull:model.remark]?[NSString isEqualToNull:model.expenseDesc]?[NSString stringWithFormat:@",%@",model.remark]:model.remark:@""] font:Font_Same_12_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    [self.mainView addSubview:self.datesLabel];
    
    
    self.moneyLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:model.localCyAmount]] font:Font_Important_18_20  textColor:Color_CellDark_Same_28
                             textAlignment:NSTextAlignmentRight];
    //    self.moneyLabel.backgroundColor=[UIColor cyanColor];
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-85,(50+size.height)/2);
    [self.mainView addSubview:self.moneyLabel];
    
    //3.1版本 全部显示币种
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.currencyCode]]) {
        self.CurrCodeLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.currencyCode],[GPUtils transformNsNumber:model.amount]] WithCompare:@" "] font:Font_Same_12_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        //    self.CurrCodeLabel.backgroundColor=[UIColor redColor];
        self.CurrCodeLabel.center=CGPointMake(Main_Screen_Width-85, 35+size.height/2);
        [self.mainView addSubview:self.CurrCodeLabel];
        self.moneyLabel.center=CGPointMake(Main_Screen_Width-85, 15+size.height/2);
    }
    
    
//    UIImage *imgQuestionBgMiddle =[UIImage imageNamed:@"CustomNote_MarkBg"];
//    float tileHeight =HEIGHT(self.mainView);
//    float tileWidth = WIDTH(self.mainView);
//    float imageHeight = tileHeight;
//    UIGraphicsBeginImageContext(CGSizeMake(tileWidth,imageHeight));
//    [imgQuestionBgMiddle drawAsPatternInRect:CGRectMake(0, 0,tileWidth, imageHeight)];
//    UIImage* imgBg = UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
//    _MarkImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, imgBg.size.width, imgBg.size.height) imageName:nil];
//    _MarkImageView.image=imgBg;
//    _MarkImageView.clipsToBounds = YES;
//    [self.mainView addSubview:_MarkImageView];
    

    _MarkImageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, WIDTH(self.mainView), HEIGHT(self.mainView)) imageName:nil];
    _MarkImageView.backgroundColor=Color_Black_Important_20;
    [self.mainView addSubview:_MarkImageView];
    
    
    _MarkLabel=[GPUtils createLable:CGRectMake(0, 0, 70, 50) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    _MarkLabel.center=self.mainView.center;
    [self.mainView addSubview:_MarkLabel];
    
    _MarkIconImg=[GPUtils createImageViewFrame:CGRectMake(0, 0, 18, 18) imageName:nil];
    _MarkIconImg.center=CGPointMake(25, HEIGHT(self.mainView)/2);
    [self.mainView addSubview:_MarkIconImg];
    
    if ([check isEqualToString:@"1"]) {
//        _MarkLabel.text=Custing(@"已标记", nil);
        _MarkIconImg.image=[UIImage imageNamed:@"MyApprove_Select"];
        _MarkImageView.alpha=0.2;
    }else if ([check isEqualToString:@"0"]){
        _MarkLabel.text=@"";
        _MarkIconImg.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        _MarkImageView.alpha=0;
    }
    if ([NSString isEqualToNull:check]) {
        _MarkLabel.text=@"";
        _MarkIconImg.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
        _MarkIconImg.highlightedImage=[UIImage imageNamed:@"MyApprove_Select"];
        _MarkImageView.alpha=0;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)configLeadHotelViewWithCellInfo:(LeadHotelModel *)model withIndex:(NSInteger)index{
    
    [self.mainView removeFromSuperview];
    CGSize size = [model.hotelName sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-225, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    //                NSLog(@"%f",size.height);
    //    return 56+size.height;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 50+size.height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    self.iconImageView=[[UIImageView alloc] init];
    self.iconImageView.image=[UIImage imageNamed:@"05"];
    self.iconImageView.frame=CGRectMake(0,0,42,42);
    self.iconImageView.center=CGPointMake(37, (50+size.height)/2);
    [self.mainView addSubview:self.iconImageView];
    
    
    self.titleLabel = [GPUtils createLable:CGRectMake(67,16,Main_Screen_Width-225,size.height) text:model.hotelName font:Font_Same_14_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines=0;
    //    self.titleLabel.backgroundColor=[UIColor blueColor];
    
    [self.mainView addSubview:self.titleLabel];
    
    self.datesLabel = [GPUtils createLable:CGRectMake(67,Y(self.titleLabel)+HEIGHT(self.titleLabel)+5,160, 14) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    //    self.datesLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.datesLabel];
    if ([NSString isEqualToNull:model.checkInDate]&&[NSString isEqualToNull:model.checkOutDate]) {
        self.datesLabel.text=[NSString stringWithFormat:@"%@-%@",model.checkInDate,model.checkOutDate];
    }else if ([NSString isEqualToNull:model.checkInDate]&&![NSString isEqualToNull:model.checkOutDate]){
        self.datesLabel.text=[NSString stringWithFormat:@"%@",model.checkInDate];
    }
    
    self.moneyLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber: model.price]] font:Font_Important_18_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    //        self.moneyLabel.backgroundColor=[UIColor cyanColor];
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-85, (50+size.height)/2-10);
    [self.mainView addSubview:self.moneyLabel];
    
    self.statusLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:nil font:Font_Same_14_20  textColor:nil textAlignment:NSTextAlignmentRight];
    //    self.statusLabel.backgroundColor=[UIColor cyanColor];
    if (index==0) {
        if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"1"]) {
            self.statusLabel.text=Custing(@"预定中", nil) ;
            self.statusLabel.textColor=Color_Orange_Weak_20;
        }else if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"2"]){
            self.statusLabel.text=Custing(@"已付款", nil) ;
            self.statusLabel.textColor=Color_Blue_Important_20;
            
        }else if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"3"]){
            self.statusLabel.text=Custing(@"已取消", nil) ;
            self.statusLabel.textColor=Color_GrayDark_Same_20;
        }
    }else if (index==1){
        self.statusLabel.text=Custing(@"已导入", nil) ;
        self.statusLabel.textColor=Color_Blue_Important_20;
    }
    
    self.statusLabel.center=CGPointMake(Main_Screen_Width-85, (50+size.height)/2+10);
    [self.mainView addSubview:self.statusLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configDetailCtripViewWithCellInfo:(CtripLeadModel *)model withIndex:(NSInteger)index{
    [self.mainView removeFromSuperview];
    CGSize size = [model.name sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-225, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    //                NSLog(@"%f",size.height);
    //    return 56+size.height;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 50+size.height)];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    self.iconImageView=[[UIImageView alloc] init];
    if (index==0) {
        self.iconImageView.image=[UIImage imageNamed:@"01"];
    }else if (index==1){
        self.iconImageView.image=[UIImage imageNamed:@"02"];
    }else if (index==2){
        self.iconImageView.image=[UIImage imageNamed:@"05"];
    }
    
    self.iconImageView.frame=CGRectMake(0,0,42,42);
    self.iconImageView.center=CGPointMake(37, (50+size.height)/2);
    [self.mainView addSubview:self.iconImageView];
    
    
    self.titleLabel = [GPUtils createLable:CGRectMake(67,16,Main_Screen_Width-225,size.height) text:model.name font:Font_Same_14_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines=0;
    //    self.titleLabel.backgroundColor=[UIColor blueColor];
    
    [self.mainView addSubview:self.titleLabel];
    
    self.datesLabel = [GPUtils createLable:CGRectMake(67,Y(self.titleLabel)+HEIGHT(self.titleLabel)+5,Main_Screen_Width-165, 14) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    //        self.datesLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:self.datesLabel];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.orderDate]]) {
        self.datesLabel.text=[NSString stringWithFormat:@"%@",model.orderDate];
    }
    
    self.moneyLabel = [GPUtils createLable:CGRectMake(0, 0, 140, 18) text:[NSString stringWithFormat:@"%@",[GPUtils transformNsNumber: model.amount]] font:Font_Important_18_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    //        self.moneyLabel.backgroundColor=[UIColor cyanColor];
    self.moneyLabel.center=CGPointMake(Main_Screen_Width-85, (50+size.height)/2-10);
    [self.mainView addSubview:self.moneyLabel];
    
    self.statusLabel = [GPUtils createLable:CGRectMake(0, 0, 80, 18) text:nil font:Font_Same_14_20  textColor:nil textAlignment:NSTextAlignmentRight];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.orderStatus]]) {
        self.statusLabel.text=[NSString stringWithFormat:@"%@",model.orderStatus] ;
        self.statusLabel.textColor=Color_Orange_Weak_20;
    }

    self.statusLabel.center=CGPointMake(Main_Screen_Width-55, (50+size.height)/2+10);
    [self.mainView addSubview:self.statusLabel];
    
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
