//
//  TravelCarDetailCell.m
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "TravelCarDetailCell.h"

@interface TravelCarDetailCell ()

@property (nonatomic, strong) UILabel *lab_time;
@property (nonatomic, strong) UIImageView *img_departure;
@property (nonatomic, strong) UILabel *lab_departure;
@property (nonatomic, strong) UIImageView *img_destination;
@property (nonatomic, strong) UILabel *lab_destination;
@property (nonatomic, strong) UILabel  *lab_remark;

@end

@implementation TravelCarDetailCell

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
    if (!_lab_time) {
        _lab_time = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_time];
    }
    [_lab_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(15);
    }];
    
    
    if (!_lab_departure) {
        _lab_departure = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_departure];
    }
    [_lab_departure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_time.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(32);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(20);
    }];
    
    
    if (!_img_departure) {
        _img_departure = [GPUtils createImageViewFrame:CGRectZero imageName:@"TravelCarDetail_GreenCircle"];
        [self.contentView addSubview:_img_departure];
    }
    [_img_departure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lab_departure);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(8, 8));
    }];
    
    
    if (!_lab_destination) {
        _lab_destination = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20  textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_destination];
    }
    [_lab_destination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_departure.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(32);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(20);
    }];
    
    
    if (!_img_destination) {
        _img_destination = [GPUtils createImageViewFrame:CGRectZero imageName:@"TravelCarDetail_RedCircle"];
        [self.contentView addSubview:_img_destination];
    }
    [_img_destination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lab_destination);
        make.left.equalTo(self.contentView).offset(@12);
        make.size.equalTo(CGSizeMake(8, 8));
    }];
    
    
    if (!_lab_remark) {
        _lab_remark = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20  textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_remark.numberOfLines = 0;
        [self.contentView addSubview:_lab_remark];
    }
    [_lab_remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_destination.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

-(void)configCellWithModel:(TravelCarDetail *)model{
    
    self.lab_time.text = [NSString stringIsExist:model.VehicleDate];
    self.lab_departure.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.Departure],[NSString stringWithFormat:@"(%@)",model.FromCity]] WithCompare:@" "];
    self.lab_destination.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.Destination],[NSString stringWithFormat:@"(%@)",model.ToCity]] WithCompare:@" "];
    self.lab_remark.text = [NSString stringIsExist:model.Remark];
}

+ (CGFloat)cellHeightWithModel:(TravelCarDetail *)model{
    CGFloat cellHeight = 80;
    TravelCarDetail *obj = (TravelCarDetail *)model;
    if ([NSString isEqualToNull:obj.Remark]) {
        NSString *remark = [NSString stringWithFormat:@"%@",obj.Remark];
        CGSize size = [remark sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-24, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        cellHeight += size.height + 5;
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
