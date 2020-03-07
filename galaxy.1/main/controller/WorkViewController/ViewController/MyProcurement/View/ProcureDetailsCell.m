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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
//*************************************************采购***************************************************************//

-(void)configCellWithArray:(NSMutableArray *)array withDetailsModel:(DeatilsModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count withComePlace:(NSString *)place{
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ProcureDetailsCell ProcureAndArticleCellHeightWithArray:array WithModel:deModel])];
    //    self.mainView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.mainView];
    
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_CellDark_Same_28 textAlignment:NSTextAlignmentLeft];
    if (count>1) {
        if ([place isEqualToString:@"Article"]) {
            titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"物品明细", nil),(long)(index+1)];
        }else if ([place isEqualToString:@"ProcureMent"]){
            titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"采购明细", nil),(long)(index+1)];
        }
    }else{
        if ([place isEqualToString:@"Article"]) {
            titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"物品明细", nil)];
        }else if ([place isEqualToString:@"ProcureMent"]){
            titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"采购明细", nil)];
        }
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
        NSString *content=[ProcureDetailsCell ProcureAndArticleContentWithShowModel:models WithContentModel:CellModel];
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
        
    }else if ([showModel.fieldName isEqualToString:@"Attachments"]){
        content=contentModel.Attachments;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }
    return content;
}


///////////////////////////**********************************物品领用*********************************************///////////////////////

-(void)configItemCellWithArray:(NSMutableArray *)array withDetailsModel:(ItemRequestDetail *)deModel withindex:(NSInteger)index withCount:(NSInteger)count withComePlace:(NSString *)place{
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
        NSString *content=[ProcureDetailsCell ItemContentWithShowModel:model WithContentModel:deModel];
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
        content=contentModel.Name;
        
    }else if ([showModel.fieldName isEqualToString:@"Qty"]){
        
        content=contentModel.Qty;
        
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
        
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
    NSString *content=@"";
    if ([showModel.fieldName isEqualToString:@"Payee"]) {
        content=contentModel.Payee;
    }else if ([showModel.fieldName isEqualToString:@"DepositBank"]){
        content=contentModel.DepositBank;
    }else if ([showModel.fieldName isEqualToString:@"BankAccount"]){
        content=contentModel.BankAccount;
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
    }
    return content;
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

