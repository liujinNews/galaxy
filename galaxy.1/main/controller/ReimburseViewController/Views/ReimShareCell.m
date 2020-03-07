//
//  ReimShareCell.m
//  galaxy
//
//  Created by hfk on 2017/9/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReimShareCell.h"

@implementation ReimShareCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = Color_form_TextFieldBackgroundColor;
        //        self.backgroundColor = [GPUtils randomColor];
        
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)configReimShareCellWithArray:(NSMutableArray *)array withDetailsModel:(ReimShareModel *)deModel withindex:(NSInteger)index withCount:(NSInteger)count{
    
    [self.mainView removeFromSuperview];
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, [ReimShareCell ReimShareCellHeightWithArray:array WithModel:deModel])];
    self.mainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:self.mainView];
    
    NSInteger height=5;
    for (MyProcurementModel *model in array) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 40) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        //        nameLabel.backgroundColor=[UIColor redColor];
        nameLabel.numberOfLines=2;
        [self.mainView addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        //        DetailLabel.backgroundColor=[UIColor cyanColor];
        DetailLabel.numberOfLines=0;
        [self.mainView addSubview:DetailLabel];
        
        NSString *content=[ReimShareCell getContentWithShowModel:model WithContentModel:deModel];
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
+(CGFloat)ReimShareCellHeightWithArray:(NSMutableArray *)arr WithModel:(ReimShareModel *)CellModel{
    NSInteger height=8;
    for (MyProcurementModel *models in arr) {
        
        NSString *content=[ReimShareCell getContentWithShowModel:models WithContentModel:CellModel];
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


+(NSString *)getContentWithShowModel:(MyProcurementModel *)showModel WithContentModel:(ReimShareModel *)contentModel{
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
        
    }else if ([showModel.fieldName isEqualToString:@"ExpenseCode"]){
        content=[GPUtils getSelectResultWithArray:@[contentModel.ExpenseCat,contentModel.ExpenseType]];
        
    }else if ([showModel.fieldName isEqualToString:@"Reserved1"]){
        content=contentModel.Reserved1;
        
    }else if ([showModel.fieldName isEqualToString:@"Reserved2"]){
        content=contentModel.Reserved2;
        
    }else if ([showModel.fieldName isEqualToString:@"Reserved3"]){
        content=contentModel.Reserved3;
        
    }else if ([showModel.fieldName isEqualToString:@"Reserved4"]){
        content=contentModel.Reserved4;
        
    }else if ([showModel.fieldName isEqualToString:@"Reserved5"]){
        content=contentModel.Reserved5;
        
    }else if ([showModel.fieldName isEqualToString:@"Amount"]){
        content=[GPUtils transformNsNumber:contentModel.Amount];
        
    }else if ([showModel.fieldName isEqualToString:@"Remark"]){
        content=contentModel.Remark;
    }
    return content;
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

