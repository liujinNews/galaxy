//
//  ProcureDetailsCell.m
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ProcureDetailsCell.h"

@implementation ProcureDetailsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
    }
    return self;
}
//*************************************************采购***************************************************************//

-(void)configCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ProcureAndArticleCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"采购明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"采购明细", nil)];
    }
    //    titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    //    NSLog(@"%@",_LookMore.titleLabel.text);
    //    if (count>1&&index<count-1) {
    //        _lineView=[[UIView alloc]initWithFrame:CGRectMake(12, HEIGHT(self.mainView)-0.5, Main_Screen_Width-12, 0.5)];
    //        _lineView.backgroundColor=Color_GrayLight_Same_20;
    //        [self.mainView addSubview:_lineView];
    //    }
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content=[ProcureDetailsCell ProcureAndArticleContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
    //    self.mainView.frame =CGRectMake(0, 0, ScreenRect.size.width, array.count*24+32);
    
}

+(CGFloat)ProcureAndArticleCellHeightWithArray:(NSMutableArray *)arr WithModel:(DeatilsModel *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        if ([models.fieldName isEqualToString:@"Attachments"]&&[NSString isEqualToNull:CellModel.Attachments]) {
            height = height + 5 + 88;
        }else{
            NSString *content=[ProcureDetailsCell ProcureAndArticleContentWithShowModel:models WithContentModel:CellModel];
            CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            if ([NSString isEqualToNull:content]) {
                CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
                height=height+5+((size.height>size1.height)?size.height:size1.height);
            }else{
                height=height+size1.height+5;
            }
        }
    }
    return height;
}
+(NSString *)ProcureAndArticleContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(DeatilsModel *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Name"]) {
        content=contentModel.Name;
        
    }else if ([showModel.fieldName isEqualToString:@"Brand"]){
        content=contentModel.Brand;
        
    }else if ([showModel.fieldName isEqualToString:@"Size"]){
        content=contentModel.Size;
        
    }else if ([showModel.fieldName isEqualToString:@"Qty"]){
        
        content=contentModel.Qty;
        
    }else if ([showModel.fieldName isEqualToString:@"Unit"]){
        content=contentModel.Unit;
        
    }else if ([showModel.fieldName isEqualToString:@"Price"]){
        content=contentModel.Price;
        
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
        
    }else if ([showModel.fieldName isEqualToString:@"SupplierId"]){
        content=contentModel.SupplierName;
        
    }else if ([showModel.fieldName isEqualToString:@"PurchaseType"]){
        content=contentModel.PurchaseType;
        
    }else if ([showModel.fieldName isEqualToString:@"Attachments"]){
        content=contentModel.Attachments;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }else if ([showModel.fieldName isEqualToString:@"No"]){
        content = contentModel.No;
    }else if ([showModel.fieldName isEqualToString:@"Description"]){
        content = contentModel.Description;
    }else if ([showModel.fieldName isEqualToString:@"CurrencyCode"]){
        content = contentModel.CurrencyCode;
    }else if ([showModel.fieldName isEqualToString:@"Currency"]){
        content = contentModel.Currency;
    }else if ([showModel.fieldName isEqualToString:@"ExpenseCode"]){
//        content = contentModel.ExpenseCode;
        content=[GPUtils getSelectResultWithArray:@[contentModel.ExpenseCat,contentModel.ExpenseType] WithCompare:@"/"];
    }else if ([showModel.fieldName isEqualToString:@"ExpenseType"]){
        content = contentModel.ExpenseType;
    }else if ([showModel.fieldName isEqualToString:@"ExpenseIcon"]){
        content = contentModel.ExpenseIcon;
    }else if ([showModel.fieldName isEqualToString:@"ExpenseCatCode"]){
        content = contentModel.ExpenseCatCode;
    }else if ([showModel.fieldName isEqualToString:@"ExpenseCat"]){
        content = contentModel.ExpenseCat;
    }else if ([showModel.fieldName isEqualToString:@"FeeAppNumber"]){
        content = contentModel.FeeAppNumber;
    }else if ([showModel.fieldName isEqualToString:@"FeeAppInfo"]){
        content = contentModel.FeeAppInfo;
    }else if ([showModel.fieldName isEqualToString:@"BusinessRequirement"]){
        content = contentModel.BusinessRequirement;
    }else if ([showModel.fieldName isEqualToString:@"TechRequirement"]){
        content = contentModel.TechRequirement;
    }else if ([showModel.fieldName isEqualToString:@"ServiceRequirement"]){
        content = contentModel.ServiceRequirement;
    }else if ([showModel.fieldName isEqualToString:@"SupplierName"]){
        content = contentModel.SupplierName;
    }else if ([showModel.fieldName isEqualToString:@"IsCrossDepartment"]){
//        content = contentModel.IsCrossDepartment;
        if ([contentModel.IsCrossDepartment isEqualToString:@"0"]) {
            content = @"No";
        }else if ([contentModel.IsCrossDepartment isEqualToString:@"1"]){
            content = @"Yes";
        }
    }else if ([showModel.fieldName isEqualToString:@"Reason"]){
        content = contentModel.Reason;
    }else if ([showModel.fieldName isEqualToString:@"Attachments"]){
        content = contentModel.Attachments;
    }else if ([showModel.fieldName isEqualToString:@"Remarks"]){
        content=contentModel.Remarks;
    }
    return content;
}
//是否跨部门数组
- (NSMutableArray *)arr_IsCrossD{
    if (!_arr_IsCrossD) {
        _arr_IsCrossD = [NSMutableArray array];
        for (int i = 0 ; i < 2; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            if (i == 0) {
                model.Id = @"0";
                model.Type = @"No";
            }else{
                model.Id = @"1";
                model.Type = @"Yes";
            }
            [_arr_IsCrossD addObject:model];
        }
    }
    return _arr_IsCrossD;
}


///////////////////////////**********************************物品领用*********************************************///////////////////////

-(void)configItemCellWithArray:(NSMutableArray *)array withDetailsModel:(ItemRequestDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ItemCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"物品明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"物品明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content = [ProcureDetailsCell ItemContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh = (size.height>size1.height)?size.height:size1.height;
        nameLabel.frame = CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text = content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}

+(CGFloat)ItemCellHeightWithArray:(NSMutableArray *)arr WithModel:(ItemRequestDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell ItemContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)ItemContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ItemRequestDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Name"]) {
        content = [NSString stringIsExist:contentModel.Name];
    }else if ([showModel.fieldName isEqualToString:@"Brand"]){
        content = [NSString stringIsExist:contentModel.Brand];
    }else if ([showModel.fieldName isEqualToString:@"Spec"]){
        content = [NSString stringIsExist:contentModel.Spec];
    }else if ([showModel.fieldName isEqualToString:@"Unit"]){
        content = [NSString stringIsExist:contentModel.Unit];
    }else if ([showModel.fieldName isEqualToString:@"Qty"]){
        content = [NSString stringIsExist:contentModel.Qty];
    }else if ([showModel.fieldName isEqualToString:@"Price"]){
        content = [GPUtils transformNsNumber:contentModel.Price];
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content = [GPUtils transformNsNumber:contentModel.Amount];
    }else if ([showModel.fieldName isEqualToString:@"UsedPart"]){
        content = [NSString stringIsExist:contentModel.UsedPart];
    }else if ([showModel.fieldName isEqualToString:@"UsedNode"]){
        content = [NSString stringIsExist:contentModel.UsedNode];
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content = [NSString stringIsExist:contentModel.Remark];
    }
    return content;
}

///////////////////////////**********************************费用申请*********************************************///////////////////////
-(void)configFeeCellWithArray:(NSMutableArray *)array withDetailsModel:(FeeAppDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell FeeAppCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"费用明细", nil)];
    }
    //    titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    //    if (count>1&&index<count-1) {
    //        _lineView=[[UIView alloc]initWithFrame:CGRectMake(12, HEIGHT(self.mainView)-0.5, Main_Screen_Width-12, 0.5)];
    //        _lineView.backgroundColor=Color_GrayLight_Same_20;
    //        [self.mainView addSubview:_lineView];
    //    }
    //
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        //        nameLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        //        DetailLabel.backgroundColor=[UIColor cyanColor];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell FeeAppContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
    //    self.mainView.frame =CGRectMake(0, 0, ScreenRect.size.width, array.count*24+32);
    
}

+(CGFloat)FeeAppCellHeightWithArray:(NSMutableArray *)arr WithModel:(FeeAppDeatil *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell FeeAppContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)FeeAppContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(FeeAppDeatil *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"ExpenseCode"]) {
        content=[GPUtils getSelectResultWithArray:@[contentModel.ExpenseCat,contentModel.ExpenseType] WithCompare:@"/"];
        
    }else if ([showModel.fieldName isEqualToString:@"ExpenseDesc"]){
        content=contentModel.ExpenseDesc;
        
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];

    }
//    else if([showModel.fieldName isEqualToString:@"CostType"]){
//        content = [contentModel.CostType isEqualToString:@"0"]?Custing(@"资本性支出", nil):Custing(@"费用", nil);
//    }
    return content;
}



//*************************************************用印申请***************************************************************//
-(void)configMyChopCellWithArray:(NSMutableArray *)array withDetailsModel:(MyChopDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell MyChopCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"用印明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"用印明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell MyChopContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
    
}

+(CGFloat)MyChopCellHeightWithArray:(NSMutableArray *)arr WithModel:(MyChopDeatil *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell MyChopContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)MyChopContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(MyChopDeatil *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"SealTypeId"]) {
        content=contentModel.SealType;
        
    }else if ([showModel.fieldName isEqualToString:@"Qty"]){
        content=contentModel.Qty;
    }
    return content;
}


//*************************************************会议预订***************************************************************//
-(void)configConferenceCellWithArray:(NSMutableArray *)array withDetailsModel:(ConferenceDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ConferenceCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"会议议程", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"会议议程", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell ConferenceContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
    
}

+(CGFloat)ConferenceCellHeightWithArray:(NSMutableArray *)arr WithModel:(ConferenceDeatil *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell ConferenceContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)ConferenceContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ConferenceDeatil *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Subject"]) {
        content=contentModel.Subject;
    }else if ([showModel.fieldName isEqualToString:@"Spokesman"]){
        content=contentModel.Spokesman;
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
    }
    return content;
}

//*************************************************业务招待***************************************************************//

-(void)configEntertainmentCellWithArray:(NSMutableArray *)array withDetailsModel:(id)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell EntertainmentCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
   
    NSString *str;
    if ([deModel isKindOfClass:[EntertainmentDeatil class]]) {
        str=Custing(@"费用明细", nil);
    }else if ([deModel isKindOfClass:[EntertainmentSchDeatil class]]){
        str=Custing(@"接待安排", nil);
    }
    if (count>1){
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",str,(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",str];
    }
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell EntertainmentContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}
+(CGFloat)EntertainmentCellHeightWithArray:(NSMutableArray *)arr WithModel:(id)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell EntertainmentContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)EntertainmentContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(id)contentModel{
    
    NSString *content=@"";
    if ([contentModel isKindOfClass:[EntertainmentDeatil class]]) {
        EntertainmentDeatil *model=(EntertainmentDeatil *)contentModel;
        if ([showModel.fieldName isEqualToString:@"ExpenseCode"]) {
            content=[GPUtils getSelectResultWithArray:@[model.ExpenseCat,model.ExpenseType] WithCompare:@"/"];
        }else if ([showModel.fieldName isEqualToString:@"ExpenseDesc"]){
            content=model.ExpenseDesc;
        }else if ([showModel.fieldName isEqualToString:@"Amount"]){
            content=[GPUtils transformNsNumber:model.Amount];
        }else if ([showModel.fieldName isEqualToString:@"Remark"]){
            content=model.Remark;
        }
    }else if ([contentModel isKindOfClass:[EntertainmentSchDeatil class]]){
        EntertainmentSchDeatil *model=(EntertainmentSchDeatil *)contentModel;
        if ([showModel.fieldName isEqualToString:@"EntertainDate"]) {
            content=model.EntertainDate;
        }else if ([showModel.fieldName isEqualToString:@"EntertainAddr"]){
            content=model.EntertainAddr;
        }else if ([showModel.fieldName isEqualToString:@"EntertainContent"]){
            content=model.EntertainContent;
        }
    }
    return content;
}
//*************************************************来访人员***************************************************************//

-(void)configEntertainmentVisitorCellWithArray:(NSMutableArray *)array withDetailsModel:(EntertainmentVisitorDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{

    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell EntertainmentVisitorCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1){
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"来访人员信息", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"来访人员信息", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell EntertainmentVisitorContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}
+(CGFloat)EntertainmentVisitorCellHeightWithArray:(NSMutableArray *)arr WithModel:(EntertainmentVisitorDeatil *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell EntertainmentVisitorContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)EntertainmentVisitorContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(EntertainmentVisitorDeatil *)contentModel{

    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Name"]) {
        content=contentModel.Name;
    }else if ([showModel.fieldName isEqualToString:@"JobTitle"]){
        content=contentModel.JobTitle;
    }else if ([showModel.fieldName isEqualToString:@"Department"]){
        content=contentModel.Department;
    }else if ([showModel.fieldName isEqualToString:@"VisitDate"]){
        content=contentModel.VisitDate;
    }else if ([showModel.fieldName isEqualToString:@"LeaveDate"]){
        content=contentModel.LeaveDate;
    }else if ([showModel.fieldName isEqualToString:@"CostCenter"]){
        content=contentModel.CostCenter;
    }else if ([showModel.fieldName isEqualToString:@"BudgetAmt"]){
        content=[GPUtils transformNsNumber:contentModel.BudgetAmt];
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
    }
    return content;
}


//*************************************************车辆维修***************************************************************//

-(void)configVehicleRepairCellWithArray:(NSMutableArray *)array withDetailsModel:(VehicleRepairDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell VehicleRepairCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"费用明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }

    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        //        nameLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        //        DetailLabel.backgroundColor=[UIColor cyanColor];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell VehicleRepairContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)VehicleRepairCellHeightWithArray:(NSMutableArray *)arr WithModel:(VehicleRepairDeatil *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell VehicleRepairContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)VehicleRepairContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(VehicleRepairDeatil *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"ExpenseCode"]) {
        content=[GPUtils getSelectResultWithArray:@[contentModel.ExpenseCat,contentModel.ExpenseType] WithCompare:@"/"];
    }else if ([showModel.fieldName isEqualToString:@"ExpenseDesc"]){
        content=contentModel.ExpenseDesc;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
    }
    return content;
}

//*************************************************回款信息***************************************************************//

-(void)configHasReturnAmountDetailCellWithDict:(NSDictionary *)infodict withindex:(NSInteger)index withCount:(NSInteger)count{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell HasReturnAmountCellHeightWithDict:infodict])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"已回款信息", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"已回款信息", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    NSArray *title=@[Custing(@"收款事由", nil),Custing(@"回款日期", nil),Custing(@"回款金额", nil)];
    NSArray *content=@[[NSString stringWithIdOnNO:infodict[@"reason"]],[NSString stringWithIdOnNO:infodict[@"receiveDate"]],[GPUtils transformNsNumber:infodict[@"localCyAmount"]]];
    
    for (int i=0; i<title.count; i++) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:title[i] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        CGSize size1 = [title[i] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content[i] sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content[i];
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }

}
+(CGFloat)HasReturnAmountCellHeightWithDict:(NSDictionary *)infodict{
    
    NSArray *title=@[Custing(@"收款事由", nil),Custing(@"回款日期", nil),Custing(@"回款金额", nil)];
    NSArray *content=@[[NSString stringWithIdOnNO:infodict[@"reason"]],[NSString stringWithIdOnNO:infodict[@"receiveDate"]],[GPUtils transformNsNumber:infodict[@"localCyAmount"]]];
    NSInteger height=33;
    for (int i=0; i<title.count; i++) {
        CGSize size1 = [title[i] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content[i] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        height=height+5+((size.height>size1.height)?size.height:size1.height);
    }
    return height;
}


//*************************************************供应商申请***************************************************************//
-(void)configSupplierApplyCellWithArray:(NSMutableArray *)array withDetailsModel:(SupplierDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell SupplierApplyCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"联系人", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"联系人", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell SupplierApplyContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
    
}

+(CGFloat)SupplierApplyCellHeightWithArray:(NSMutableArray *)arr WithModel:(SupplierDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell SupplierApplyContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)SupplierApplyContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(SupplierDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Name"]) {
        content=contentModel.Name;
        
    }else if ([showModel.fieldName isEqualToString:@"Sex"]){
        if ([contentModel.Sex floatValue] == 1) {
            content = Custing(@"男", nil);
        }else if ([contentModel.Sex floatValue] == 2){
            content = Custing(@"女", nil);
        }
    }else if ([showModel.fieldName isEqualToString:@"Dept"]) {
        content=contentModel.Dept;
    }else if ([showModel.fieldName isEqualToString:@"JobTitle"]) {
        content=contentModel.JobTitle;
    }else if ([showModel.fieldName isEqualToString:@"Tel"]) {
        content=contentModel.Tel;
    }else if ([showModel.fieldName isEqualToString:@"Email"]) {
        content=contentModel.Email;
    }
    return content;
}
//*************************************************开票历史***************************************************************//

-(void)configApplicationFormHistoryDetailCellWithDict:(NSDictionary *)infodict withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ApplicationFormHistoryCellHeightWithDict:infodict])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"开票历史", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"开票历史", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    
    NSArray *title=@[Custing(@"开票内容", nil),Custing(@"发票号码", nil),Custing(@"开票日期", nil),Custing(@"开票金额", nil)];
    NSArray *content=@[[NSString stringWithIdOnNO:infodict[@"invContent"]],[NSString stringWithIdOnNO:infodict[@"invNumber"]],[NSString stringWithIdOnNO:infodict[@"invDate"]],[GPUtils transformNsNumber:infodict[@"invAmount"]]];

    for (int i=0; i<title.count; i++) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:title[i] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        CGSize size1 = [title[i] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content[i] sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content[i];
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }

}
+(CGFloat)ApplicationFormHistoryCellHeightWithDict:(NSDictionary *)infodict{
    NSArray *title=@[Custing(@"开票内容", nil),Custing(@"发票号码", nil),Custing(@"开票日期", nil),Custing(@"开票金额", nil)];
    NSArray *content=@[[NSString stringWithIdOnNO:infodict[@"invContent"]],[NSString stringWithIdOnNO:infodict[@"invNumber"]],[NSString stringWithIdOnNO:infodict[@"invDate"]],[GPUtils transformNsNumber:infodict[@"invAmount"]]];
    NSInteger height=33;
    for (int i=0; i<title.count; i++) {
        CGSize size1 = [title[i] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content[i] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        height=height+5+((size.height>size1.height)?size.height:size1.height);
    }
    return height;
}

//*************************************************结算方式***************************************************************//
-(void)configPmtMethodCellWithArray:(NSMutableArray *)array withDetailsModel:(pmtMethodDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell PmtMethodCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"结算信息", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"结算信息", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell PmtMethodContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)PmtMethodCellHeightWithArray:(NSMutableArray *)arr WithModel:(pmtMethodDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell PmtMethodContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)PmtMethodContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(pmtMethodDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"PmtMethod"]) {
        content=contentModel.PmtMethod;
    }else if ([showModel.fieldName isEqualToString:@"Currency"]){
        content=contentModel.Currency;
    }else if ([showModel.fieldName isEqualToString:@"ExchangeRate"]){
        content=contentModel.ExchangeRate;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }
    return content;

}


//*************************************************超标信息***************************************************************//
-(void)configSpecialOverStdCellWithArray:(NSMutableArray *)array withDetailsModel:(SpecialReqestDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{

    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell SpecialOverStdCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"超标信息", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"超标信息", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell SpecialOverStdContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)SpecialOverStdCellHeightWithArray:(NSMutableArray *)arr WithModel:(SpecialReqestDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell SpecialOverStdContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)SpecialOverStdContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(SpecialReqestDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"StdType"]) {
        content=contentModel.StdType;
    }else if ([showModel.fieldName isEqualToString:@"Standard"]){
        content=contentModel.Standard;
    }else if ([showModel.fieldName isEqualToString:@"ActualExecution"]){
        content=contentModel.ActualExecution;
    }else if ([showModel.fieldName isEqualToString:@"Reason"]){
        content=contentModel.Reason;
    }
    return content;
}

//*************************************************参训人员名单***************************************************************//
-(void)configEmployeeTrainingStaffCellWithArray:(NSMutableArray *)array withDetailsModel:(EmployeeTrainDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{

    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell EmployeeTrainingStaffCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"参训人员", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"参训人员", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell EmployeeTrainingStaffContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)EmployeeTrainingStaffCellHeightWithArray:(NSMutableArray *)arr WithModel:(EmployeeTrainDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell EmployeeTrainingStaffContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)EmployeeTrainingStaffContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(EmployeeTrainDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"UserName"]) {
        content=contentModel.UserName;
    }else if ([showModel.fieldName isEqualToString:@"UserDept"]){
        content=contentModel.UserDept;
    }else if ([showModel.fieldName isEqualToString:@"JobTitle"]){
        content=contentModel.JobTitle;
    }else if ([showModel.fieldName isEqualToString:@"UserLevel"]){
        content=contentModel.UserLevel;
    }
    return content;
}


-(void)configPayeeDetailCellWithArray:(NSMutableArray *)array withDetailsModel:(PayeeDetails *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell PayeeDetailCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"收款人", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"收款人", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell PayeeDetailContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)PayeeDetailCellHeightWithArray:(NSMutableArray *)arr WithModel:(PayeeDetails *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell PayeeDetailContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)PayeeDetailContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(PayeeDetails *)contentModel{
    NSString *content = @"";
    if ([showModel.fieldName isEqualToString:@"Payee"]) {
        content = [NSString stringIsExist:contentModel.Payee];
    }else if ([showModel.fieldName isEqualToString:@"DepositBank"]){
        content = [NSString stringIsExist:contentModel.DepositBank];
    }else if ([showModel.fieldName isEqualToString:@"BankAccount"]){
        content = [NSString getSecretBankAccount:contentModel.BankAccount];
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content = [GPUtils transformNsNumber:contentModel.Amount];
    }
    return content;
}


//*************************************************加班申请***************************************************************//
-(void)configOverTimeCellWithArray:(NSMutableArray *)array withDetailsModel:(OverTimeDeatil *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell OverTimeCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"加班明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"加班明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        if (![model.fieldName isEqualToString:@"ExchangeHoliday"]||[deModel.AccountingModeId isEqualToString:@"2"]) {
            UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            nameLabel.numberOfLines=0;
            [self.mainView addSubview:nameLabel];
            
            UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
            DetailLabel.numberOfLines=0;
            [self.mainView addSubview:DetailLabel];
            
            NSString *content=[ProcureDetailsCell OverTimeContentWithShowModel:model WithContentModel:deModel];
            CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
            NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
            nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
            DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
            DetailLabel.text=content;
            [nameLabel sizeToFit];
            [DetailLabel sizeToFit];
            height=height+viewHeigh+5;
        }
    }
}

+(CGFloat)OverTimeCellHeightWithArray:(NSMutableArray *)arr WithModel:(OverTimeDeatil *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        if ([models.fieldName isEqualToString:@"ExchangeHoliday"]&&![CellModel.AccountingModeId isEqualToString:@"2"]) {
            height += 0;
        }else{
            NSString *content=[ProcureDetailsCell OverTimeContentWithShowModel:models WithContentModel:CellModel];
            CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            if ([NSString isEqualToNull:content]) {
                CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
                height=height+5+((size.height>size1.height)?size.height:size1.height);
            }else{
                height=height+size1.height+5;
            }
        }
    }
    return height;
}
+(NSString *)OverTimeContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(OverTimeDeatil *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"FromDate"]) {
        content=contentModel.FromDate;
    }else if ([showModel.fieldName isEqualToString:@"ToDate"]){
        content=contentModel.ToDate;
    }else if ([showModel.fieldName isEqualToString:@"OverTime"]){
        content=contentModel.OverTime;
    }else if ([showModel.fieldName isEqualToString:@"Type"]){
        if ([NSString isEqualToNull:contentModel.Type]) {
            switch ([contentModel.Type integerValue]) {
                case 1:
                    content = Custing(@"工作日", );
                    break;
                case 2:
                    content = Custing(@"双休日", );
                    break;
                case 3:
                    content = Custing(@"法定节假日", );
                    break;
                case 4:
                    content = Custing(@"公司节假日", );
                    break;
                default:
                    break;
            }
        }
    }else if ([showModel.fieldName isEqualToString:@"AccountingModeId"]){
        content=contentModel.AccountingMode;
    }else if ([showModel.fieldName isEqualToString:@"ExchangeHoliday"]){
        content=contentModel.ExchangeHoliday;
    }else if ([showModel.fieldName isEqualToString:@"Reason"]){
        content=contentModel.Reason;
    }
    return content;
}


//*************************************************记一笔分摊***************************************************************//
-(void)configAddReimShareCellWithArray:(NSMutableArray *)array withDetailsModel:(AddReimShareModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell AddReimShareCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用分摊", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"费用分摊", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell AddReimShareContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}

+(CGFloat)AddReimShareCellHeightWithArray:(NSMutableArray *)arr WithModel:(AddReimShareModel *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell AddReimShareContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)AddReimShareContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(AddReimShareModel *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"BranchId"]) {
        content=contentModel.Branch;
    }else if ([showModel.fieldName isEqualToString:@"RequestorDeptId"]){
        content=contentModel.RequestorDept;
    }else if ([showModel.fieldName isEqualToString:@"RequestorBusDeptId"]){
        content=contentModel.RequestorBusDept;
    }else if ([showModel.fieldName isEqualToString:@"CostCenterId"]){
        content=contentModel.CostCenter;
    }else if ([showModel.fieldName isEqualToString:@"ProjId"]){
        content=contentModel.ProjName;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }else if ([showModel.fieldName isEqualToString:@"Remark"]||[showModel.fieldName isEqualToString:@"ShareRatio"]||[showModel.fieldName containsString:@"Reserved"]){
        content = [contentModel valueForKey:showModel.fieldName];
    }
    return content;
}



//*************************************************合同条款明细***************************************************************//
-(void)configContractTermCellWithArray:(NSMutableArray *)array withDetailsModel:(ContractTermDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ContractTermCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"合同条款", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"合同条款", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell ContractTermContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)ContractTermCellHeightWithArray:(NSMutableArray *)arr WithModel:(ContractTermDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell ContractTermContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)ContractTermContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ContractTermDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"No"]) {
        content=contentModel.No;
    }else if ([showModel.fieldName isEqualToString:@"Terms"]){
        content=contentModel.Terms;
    }
    return content;
}

//*************************************************付款方式明细***************************************************************//
-(void)configContractPayMethodCellWithArray:(NSMutableArray *)array withDetailsModel:(ContractPayMethodDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ContractPayMethodCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"付款方式", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"付款方式", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell ContractPayMethodContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
}
+(CGFloat)ContractPayMethodCellHeightWithArray:(NSMutableArray *)arr WithModel:(ContractPayMethodDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell ContractPayMethodContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)ContractPayMethodContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ContractPayMethodDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"No"]) {
        content=contentModel.No;
    }else if ([showModel.fieldName isEqualToString:@"PayRatio"]){
        content=contentModel.PayRatio;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }else if ([showModel.fieldName isEqualToString:@"PayDate"]){
        content=contentModel.PayDate;
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
    }else if ([showModel.fieldName isEqualToString:@"PaymentClause"]){
        content=contentModel.PaymentClause;
    }
    return content;
}

///////////////////////////**********************************入库单*********************************************///////////////////////

-(void)configWareHouseEntryCellWithArray:(NSMutableArray *)array withDetailsModel:(WareHouseEntryDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell WareHouseEntryCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"入库物品明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"入库物品明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content = [ProcureDetailsCell WareHouseEntryContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh = (size.height>size1.height)?size.height:size1.height;
        nameLabel.frame = CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text = content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}

+(CGFloat)WareHouseEntryCellHeightWithArray:(NSMutableArray *)arr WithModel:(WareHouseEntryDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell WareHouseEntryContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)WareHouseEntryContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(WareHouseEntryDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Name"]) {
        content = [NSString stringIsExist:contentModel.Name];
    }else if ([showModel.fieldName isEqualToString:@"Brand"]){
        content = [NSString stringIsExist:contentModel.Brand];
    }else if ([showModel.fieldName isEqualToString:@"Spec"]){
        content = [NSString stringIsExist:contentModel.Spec];
    }else if ([showModel.fieldName isEqualToString:@"Unit"]){
        content = [NSString stringIsExist:contentModel.Unit];
    }else if ([showModel.fieldName isEqualToString:@"Qty"]){
        content = [NSString stringIsExist:contentModel.Qty];
    }else if ([showModel.fieldName isEqualToString:@"Price"]){
        content = [GPUtils transformNsNumber:contentModel.Price];
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content = [GPUtils transformNsNumber:contentModel.Amount];
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content = [NSString stringIsExist:contentModel.Remark];
    }
    return content;
}

///////////////////////////********************************合同审批新增年度费用*********************************************///////////////////////

-(void)configContractYearExpCellWithArray:(NSMutableArray *)array withDetailsModel:(ContractYearExpDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ContractYearExpCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"年度费用", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"年度费用", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content = [ProcureDetailsCell ContractYearExpContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh = (size.height>size1.height)?size.height:size1.height;
        nameLabel.frame = CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text = content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}

+(CGFloat)ContractYearExpCellHeightWithArray:(NSMutableArray *)arr WithModel:(ContractYearExpDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell ContractYearExpContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)ContractYearExpContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ContractYearExpDetail *)contentModel{
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Year"]) {
        content = [NSString stringIsExist:contentModel.Year];
    }else if ([showModel.fieldName isEqualToString:@"TotalAmount"]){
        content = [NSString stringIsExist:contentModel.TotalAmount];
    }else if ([showModel.fieldName isEqualToString:@"Tax"]){
        content = [NSString stringIsExist:contentModel.Tax];
    }else if ([showModel.fieldName isEqualToString:@"ExclTax"]){
        content = [NSString stringIsExist:contentModel.ExclTax];
    }
    return content;
}


///////////////////////////**********************************礼品费*********************************************///////////////////////
-(void)configGiftFeeCellWithArray:(NSMutableArray *)array withDetailsModel:(GiftFeeDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell GiftFeeAppCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"礼品费明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"礼品费明细", nil)];
    }
    //    titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:titleLabel];
    
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    //    if (count>1&&index<count-1) {
    //        _lineView=[[UIView alloc]initWithFrame:CGRectMake(12, HEIGHT(self.mainView)-0.5, Main_Screen_Width-12, 0.5)];
    //        _lineView.backgroundColor=Color_GrayLight_Same_20;
    //        [self.mainView addSubview:_lineView];
    //    }
    //
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        //        nameLabel.backgroundColor=[UIColor redColor];
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        //        DetailLabel.backgroundColor=[UIColor cyanColor];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ProcureDetailsCell GiftFeeAppContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        
    }
    //    self.mainView.frame =CGRectMake(0, 0, ScreenRect.size.width, array.count*24+32);
    
}
//MARK:礼品费
+(CGFloat)GiftFeeAppCellHeightWithArray:(NSMutableArray *)arr WithModel:(GiftFeeDetail *)CellModel{
    NSInteger height=33;
    for (MyProcurementModel *models in arr) {
        NSString *content=[ProcureDetailsCell GiftFeeAppContentWithShowModel:models WithContentModel:CellModel];
        CGSize size1 = [models.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        if ([NSString isEqualToNull:content]) {
            CGSize size = [content sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-XBHelper_Title_Width-39, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            height=height+5+((size.height>size1.height)?size.height:size1.height);
        }else{
            height=height+size1.height+5;
        }
    }
    return height;
}
+(NSString *)GiftFeeAppContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(GiftFeeDetail *)contentModel{
    NSString *content=@"";
    if([showModel.fieldName isEqualToString:@"TCompanyName"]){
        content=contentModel.TCompanyName;
    }else if([showModel.fieldName isEqualToString:@"TRecipient"]){
        content=contentModel.TRecipient;
    }else if([showModel.fieldName isEqualToString:@"GiftName"]){
        content=contentModel.GiftName;
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }
    return content;
}
//MARK:采购金额明细
-(void)configPurAmCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ProcureAndArticleCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"采购金额明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"采购金额明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content=[ProcureDetailsCell ProcureAndArticleContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
    }
}
//MARK:采购内容明细
-(void)configPurBuCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ProcureAndArticleCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"采购内容明细", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"采购内容明细", nil)];
    }
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content=[ProcureDetailsCell ProcureAndArticleContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        if ([model.fieldName isEqualToString:@"Attachments"]&&[NSString isEqualToNull:deModel.Attachments]) {
            WorkFormFieldsModel *model_Files = [[WorkFormFieldsModel alloc]initialize];
            model_Files.view_View = [[UIView alloc]init];
            model_Files.view_View.frame = CGRectMake(0, CGRectGetMaxY(nameLabel.frame), Main_Screen_Width, 118);
            [self.mainView addSubview:model_Files.view_View];
            EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 88) withEditStatus:2];
            view.maxCount=10;
            [view.gapView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0);
            }];
            [model_Files.view_View addSubview:view];
            deModel.arr_FilesTotal = [NSMutableArray array];
            deModel.arr_FilesImage = [NSMutableArray array];
            if ([NSString isEqualToNull:deModel.Attachments]) {
                NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",deModel.Attachments]];
                for (NSDictionary *dict in array) {
                    [deModel.arr_FilesTotal addObject:dict];
                }
                [GPUtils updateImageDataWithTotalArray:deModel.arr_FilesTotal WithImageArray:deModel.arr_FilesImage WithMaxCount:10];
            }
            [view updateWithTotalArray:deModel.arr_FilesTotal WithImgArray:deModel.arr_FilesImage];
            [self.mainView addSubview:model_Files.view_View];
            [DetailLabel removeFromSuperview];
        }
    }
    
}
//MARK:单一采购来源清单
-(void)configPurSoCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ProcureAndArticleCellHeightWithArray:array WithModel:deModel])];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"单一采购来源清单", nil),(long)(index+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"单一采购来源清单", nil)];
    }
    //    titleLabel.backgroundColor=[UIColor cyanColor];
    [self.mainView addSubview:titleLabel];
    
    if (index==0&&count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
        _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        _LookMore.titleLabel.font=Font_Important_15_20;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [self.mainView addSubview:_LookMore];
    }
    
    NSInteger height=32;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=0;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        NSString *content=[ProcureDetailsCell ProcureAndArticleContentWithShowModel:model WithContentModel:deModel];
        CGSize size1 = [model.Description sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(XBHelper_Title_Width, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size = [content sizeCalculateWithFont:DetailLabel.font constrainedToSize:CGSizeMake(DetailLabel.frame.size.width, 10000) lineBreakMode:DetailLabel.lineBreakMode];
        NSInteger viewHeigh=(size.height>size1.height)?size.height:size1.height;
        nameLabel.frame=CGRectMake(12, height, XBHelper_Title_Width, viewHeigh);
        DetailLabel.frame = CGRectMake(XBHelper_Title_Width+27, Y(nameLabel), size.width, viewHeigh);
        DetailLabel.text=content;
        [nameLabel sizeToFit];
        [DetailLabel sizeToFit];
        height=height+viewHeigh+5;
        if ([model.fieldName isEqualToString:@"Attachments"]&&[NSString isEqualToNull:deModel.Attachments]) {
            WorkFormFieldsModel *model_Files = [[WorkFormFieldsModel alloc]initialize];
            model_Files.view_View = [[UIView alloc]init];
            model_Files.view_View.frame = CGRectMake(0, CGRectGetMaxY(nameLabel.frame), Main_Screen_Width, 118);
            [self.mainView addSubview:model_Files.view_View];
            
            EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 88) withEditStatus:2];
            view.maxCount=10;
            [view.gapView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0);
            }];
            [model_Files.view_View addSubview:view];
            deModel.arr_FilesTotal = [NSMutableArray array];
            deModel.arr_FilesImage = [NSMutableArray array];
            if ([NSString isEqualToNull:deModel.Attachments]) {
                NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",deModel.Attachments]];
                for (NSDictionary *dict in array) {
                    [deModel.arr_FilesTotal addObject:dict];
                }
                [GPUtils updateImageDataWithTotalArray:deModel.arr_FilesTotal WithImageArray:deModel.arr_FilesImage WithMaxCount:10];
            }
            [view updateWithTotalArray:deModel.arr_FilesTotal WithImgArray:deModel.arr_FilesImage];
            [self.mainView addSubview:model_Files.view_View];
            [DetailLabel removeFromSuperview];
        }
    }
}

-(void)setIsOpen:(BOOL)isOpen{
    if (_LookMore) {
        [_LookMore setImage: isOpen ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [_LookMore setTitle: isOpen ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
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

