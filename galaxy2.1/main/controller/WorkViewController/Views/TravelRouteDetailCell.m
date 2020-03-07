//
//  TravelRouteDetailCell.m
//  galaxy
//
//  Created by hfk on 2018/11/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "TravelRouteDetailCell.h"

@interface TravelRouteDetailCell ()

@property (nonatomic, strong) UILabel *lab_FromCity;
@property (nonatomic, strong) UIImageView *image_Allow;
@property (nonatomic, strong) UILabel *lab_ToCity;
@property (nonatomic, strong) UILabel *lab_SubContent;
@property (nonatomic, strong) UILabel *lab_Content;
@property (nonatomic, strong) UIView *line_View;

@end

@implementation TravelRouteDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab_FromCity) {
        _lab_FromCity = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_FromCity];
    }
    [_lab_FromCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    
    if (!_image_Allow) {
        _image_Allow = [GPUtils createImageViewFrame:CGRectZero imageName:@"Img_TravelReqForm_Allow"];
        [self.contentView addSubview:_image_Allow];
    }
    [_image_Allow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.lab_FromCity.right).offset(12);
        make.size.equalTo(CGSizeMake(22, 7));
    }];
    
    
    if (!_lab_ToCity) {
        _lab_ToCity = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_ToCity];
    }
    [_lab_ToCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.image_Allow.right).offset(12);
        make.size.equalTo(CGSizeMake(0, 0));
    }];

    if (!_lab_SubContent) {
        _lab_SubContent=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_SubContent];
    }
    [_lab_SubContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(32);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(15);
    }];


    if (!_lab_Content) {
        _lab_Content=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Content.numberOfLines = 0;
        [self.contentView addSubview:_lab_Content];
    }
    [_lab_Content makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(52);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView);
    }];
    
    if (!_line_View) {
        _line_View = [[UIView alloc]init];
        _line_View.backgroundColor = Color_GrayLight_Same_20;
        [self.contentView addSubview:_line_View];
    }
    [_line_View makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.1);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

-(void)setDict_Info:(NSDictionary *)dict_Info{
    
    _dict_Info = dict_Info;
    NSString *fromCity = [NSString stringWithIdOnNO:dict_Info[@"fromCity"]];
    CGSize size = [fromCity sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(10000, 19) lineBreakMode:NSLineBreakByCharWrapping];
    [_lab_FromCity updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(size.width, 19));
    }];
    _lab_FromCity.text = fromCity;
    
    NSString *toCity = [NSString stringWithIdOnNO:dict_Info[@"toCity"]];
    CGSize size1 = [toCity sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(10000, 19) lineBreakMode:NSLineBreakByCharWrapping];
    [_lab_ToCity updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(size1.width, 19));
    }];
    _lab_ToCity.text = toCity;
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dict_Info[@"travelDate"]];
    if ([dict_Info[@"travelTime"] floatValue] == 1) {
        [array addObject:Custing(@"上午", nil)];
    }else if ([dict_Info[@"travelTime"] floatValue] == 2){
        [array addObject:Custing(@"下午", nil)];
    }else if ([dict_Info[@"travelTime"] floatValue] == 3){
    }else{
        [array addObject:Custing(@"全天", nil)];
    }
    [array addObject:dict_Info[@"transName"]];
    
    if ([NSString isEqualToNull:dict_Info[@"hotelStd"]]) {
        [array addObject:[NSString stringWithFormat:@"%@%@",dict_Info[@"hotelStd"],Custing(@"元", nil)]];
    }

    self.lab_SubContent.text = [GPUtils getSelectResultWithArray:array WithCompare:@"  "];
    
    if ([NSString isEqualToNull:dict_Info[@"travelContent"]]) {
        [_lab_Content updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-5-3);
        }];
        self.lab_Content.text = dict_Info[@"travelContent"];
    }
    
    self.line_View.hidden = self.bool_hideLine;

}
+ (CGFloat)cellHeightWithObj:(NSDictionary *)obj{
    CGFloat cellHeight = 8+19+5+15+5+3;
    if ([NSString isEqualToNull:obj[@"travelContent"]]) {
        CGSize size = [obj[@"travelContent"] sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += (size.height+5);
    }
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
