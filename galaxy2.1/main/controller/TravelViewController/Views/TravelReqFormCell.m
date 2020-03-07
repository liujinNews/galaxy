//
//  TravelReqFormCell.m
//  galaxy
//
//  Created by hfk on 2018/5/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "TravelReqFormCell.h"

@implementation TravelReqFormCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView{
    if (!_lab_cityOne) {
        _lab_cityOne=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_cityOne];
    }
    [_lab_cityOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.size.equalTo(CGSizeMake(30, 20));
    }];
    
    if (!_img_Allow) {
        _img_Allow=[GPUtils createImageViewFrame:CGRectZero imageName:@"Img_TravelReqForm_Allow"];
        [self.contentView addSubview:_img_Allow];
    }
    [_img_Allow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@16);
        make.left.equalTo(self.lab_cityOne.right).offset(@20);
        make.size.equalTo(CGSizeMake(22, 7));
    }];
    
    if (!_lab_cityTwo) {
        _lab_cityTwo=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_cityTwo];
    }
    [_lab_cityTwo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.equalTo(self.img_Allow.right).offset(@20);
        make.size.equalTo(CGSizeMake(30, 20));
    }];
    
    if (!_lab_SerNo) {
        _lab_SerNo=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_SerNo];
    }
    [_lab_SerNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.size.equalTo(CGSizeMake(100, 20));
    }];


    if (!_lab_SubContent) {
        _lab_SubContent=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_SubContent.numberOfLines=0;
        [self.contentView addSubview:_lab_SubContent];
    }
    [_lab_SubContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_cityOne.bottom);
        make.left.equalTo(self.contentView).offset(@12);
        make.width.equalTo(@(Main_Screen_Width-24));
        make.height.equalTo(@30);
    }];
    
    if (!_lab_Remark) {
        _lab_Remark=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Remark.numberOfLines=0;
        [self.contentView addSubview:_lab_Remark];
    }
    [_lab_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_SubContent.bottom);
        make.left.equalTo(self.contentView).offset(@12);
        make.width.equalTo(@(Main_Screen_Width-24));
        make.bottom.equalTo(self.contentView).offset(@-8);
    }];
}


-(void)configTravelReqFormCellWithModel:(TravelReqFormModel *)model withIndex:(NSInteger)index{
    
    NSString *city1;
    NSString *city2;
    if (index==0) {
        city1=[NSString stringIsExist:model.fromCity];
        city2=[NSString stringIsExist:model.toCity];
        [_img_Allow updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(22, 7));
        }];
    }else if (index==1){
        city1=[NSString stringIsExist:model.checkInCity];
        [_img_Allow updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
    }else if (index==2){
        city1=[NSString stringIsExist:model.fromCity];
        city2=[NSString stringIsExist:model.toCity];
        [_img_Allow updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(22, 7));
        }];
    }
    
    _lab_SerNo.text=[GPUtils getSelectResultWithArray:@[Custing(@"单号:", nil),model.serialNo] WithCompare:@""];
    
    CGSize size = [city1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByCharWrapping];
    [_lab_cityOne updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(size.width>30 ? size.width :30, 20));
    }];
    _lab_cityOne.text=city1;

    CGSize size1 = [city2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByCharWrapping];
    [_lab_cityTwo updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(size1.width>30 ? size1.width :30, 20));
    }];
    _lab_cityTwo.text=city2;;

    NSString *content=[TravelReqFormCell getSubContentWithModel:model withIndex:index];
    CGSize size3 = [content sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    [_lab_SubContent updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((size3.height>20 ? size3.height+15:30));
    }];
    _lab_SubContent.text=content;
    
    _lab_Remark.text=[NSString stringIsExist:model.remark];
    
}

+ (CGFloat)cellHeightWithObj:(id)obj withIndex:(NSInteger)index{

    CGFloat cellHeight =40;
    TravelReqFormModel *model=(TravelReqFormModel *)obj;
    NSString *subContent=[TravelReqFormCell getSubContentWithModel:model withIndex:index];
    CGSize size = [subContent sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height>20) {
        cellHeight += (size.height+15);
    }else{
        cellHeight += 30;
    }

    NSString *remark=[NSString isEqualToNull:model.remark]?model.remark:nil;
    CGSize size1 = [remark sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size1.height>20) {
        cellHeight += (size1.height+5);
    }else if (size1.height>0&&size1.height<20){
        cellHeight += 20;
    }
    return cellHeight;
}

+(NSString *)getSubContentWithModel:(TravelReqFormModel *)model withIndex:(NSInteger)index{
    NSString *content=nil;
    if (index==0) {
        content=[GPUtils getSelectResultWithArray:@[model.departureDateStr, model.flyPeople] WithCompare:@"   "];
    }else if (index==1){
        NSString *during=[GPUtils getSelectResultWithArray:@[model.checkInDateStr, model.checkOutDateStr] WithCompare:@" ~ "];
        NSString *rooms=@"";
        if ([NSString isEqualToNullAndZero:model.numberOfRooms]) {
            rooms=[NSString stringWithFormat:@"%@%@",model.numberOfRooms,Custing(@"间", nil)];
        }
        content=[GPUtils getSelectResultWithArray:@[during, rooms] WithCompare:@"   "];
    }else if (index==2){
        content=[GPUtils getSelectResultWithArray:@[model.departureDateStr, model.passenger] WithCompare:@"   "];
    }
    if ([content isEqualToString:@""]) {
        content=nil;
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
