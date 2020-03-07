//
//  ChooseVehicleCarCell.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ChooseVehicleCarCell.h"

@implementation ChooseVehicleCarCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab_carNo) {
        _lab_carNo=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_carNo];
    }
    [_lab_carNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(100, 19));
    }];
    
    if (!_lab_carModel) {
        _lab_carModel=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_carModel];
    }
    [_lab_carModel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.left.equalTo(self.contentView).offset(@114);
        make.size.equalTo(CGSizeMake(120, 19));
    }];
    
    
    if (!_lab_seatType) {
        _lab_seatType=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_lab_seatType];
    }
    [_lab_seatType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@10);
        make.right.equalTo(self.contentView).offset(@-12);
        make.size.equalTo(CGSizeMake(100, 19));
    }];
    
    
    if (!_lab_carDesc) {
        _lab_carDesc=[GPUtils createLable:CGRectMake(12, 35, Main_Screen_Width-24, 40) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_carDesc.numberOfLines=0;
        [_lab_carDesc sizeToFit];
        [self.contentView addSubview:_lab_carDesc];
    }
    [_lab_carDesc makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_carNo.bottom).offset(@4);
        make.left.equalTo(self.contentView).offset(@12);
        make.right.equalTo(self.contentView).offset(@-12);
    }];
    
    if (!_line_View) {
        _line_View = [[UIView alloc]init];
        _line_View.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_line_View];
    }
    [_line_View makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_carDesc.bottom).offset(@8);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    if (!_image_Time) {
        _image_Time = [GPUtils createImageViewFrame:CGRectZero imageName:@"Meeting_Room_Choose"];
        [self.contentView addSubview:_image_Time];
    }
    [_image_Time makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line_View.bottom).offset(@9);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
    if (!_lab_TimeTitle) {
        _lab_TimeTitle = [GPUtils createLable:CGRectZero text:Custing(@"已预订时间段", nil) font:Font_Same_11_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_TimeTitle];
    }
    [_lab_TimeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line_View.bottom);
        make.left.equalTo(self.contentView).offset(@30);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-30-12, 30));
    }];
    
    if (!_lab_Time) {
        _lab_Time=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Time.numberOfLines=0;
        [_lab_Time sizeToFit];
        [self.contentView addSubview:_lab_Time];
    }
    [_lab_Time makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_TimeTitle.bottom);
        make.left.equalTo(self.contentView).offset(@12);
        make.right.equalTo(self.contentView).offset(@-12);
    }];
}
-(void)setDict_carInfo:(NSDictionary *)dict_carInfo{
    _lab_carNo.text = [NSString stringWithIdOnNO:dict_carInfo[@"carNo"]];
    _lab_carModel.text = [NSString stringWithIdOnNO:dict_carInfo[@"carModel"]];
    NSMutableArray *arr = [NSMutableArray array];
    if ([[NSString stringWithFormat:@"%@",dict_carInfo[@"type"]]isEqualToString:@"2"]) {
        [arr addObject:Custing(@"(私车)", nil)];
    }
    if ([NSString isEqualToNull:dict_carInfo[@"seats"]]) {
        [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",dict_carInfo[@"seats"]],Custing(@"座", nil)]];
    }
    _lab_seatType.text = [arr componentsJoinedByString:@""];
    _lab_carDesc.text = [NSString stringWithIdOnNO:dict_carInfo[@"carDesc"]];
    
    NSArray *array = [dict_carInfo[@"reserveRecords"]isKindOfClass:[NSArray class]] ? dict_carInfo[@"reserveRecords"]:[NSArray array];
    if (array.count > 0) {
        _line_View.hidden = NO;
        _image_Time.hidden = NO;
        _lab_TimeTitle.hidden = NO;
        _lab_Time.hidden = NO;
        
        NSMutableArray *timeArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            [timeArray addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"startDate"]],[NSString stringWithFormat:@"%@",dict[@"endDate"]]] WithCompare:@" ~ "]];
        }
        _lab_Time.text = [GPUtils getSelectResultWithArray:timeArray WithCompare:@"\n"];
    }else{
        _line_View.hidden = YES;
        _image_Time.hidden = YES;
        _lab_TimeTitle.hidden = YES;
        _lab_Time.hidden = YES;

    }
}
+ (CGFloat)cellHeightWithObj:(NSDictionary *)obj{
    
    CGFloat cellHeight =10+19+2+8+9;
    
    if ([NSString isEqualToNull:obj[@"carDesc"]]) {
        CGSize size = [obj[@"carDesc"] sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += size.height;
    }
    NSArray *array = [obj[@"reserveRecords"]isKindOfClass:[NSArray class]] ? obj[@"reserveRecords"]:[NSArray array];
    if (array.count > 0) {
        cellHeight += (30+array.count*14);
    }
    return cellHeight>60 ? cellHeight:60;
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
