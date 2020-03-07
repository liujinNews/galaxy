//
//  BusiTvlOrderCell.m
//  galaxy
//
//  Created by APPLE on 2019/12/11.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "BusiTvlOrderCell.h"
#define RouteCellHeightByDidi 198

@interface BusiTvlOrderCell ()

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *img_isEdit;
@property (nonatomic, strong) UILabel *lab_carType;
@property (nonatomic, strong) UIButton *btn_status;
@property (nonatomic, strong) UIView *view_line;
@property (nonatomic, strong) UIImageView *img_deparT;
@property (nonatomic, strong) UILabel *lab_deparT;
@property (nonatomic, strong) UIImageView *img_arrT;
@property (nonatomic, strong) UILabel *lab_arrT;
@property (nonatomic, strong) UIImageView *img_deparN;
@property (nonatomic, strong) UILabel *lab_deparN;
@property (nonatomic, strong) UIImageView *img_arrN;
@property (nonatomic, strong) UILabel *lab_arrN;
@property (nonatomic, strong) UIImageView *img_milN;
@property (nonatomic, strong) UILabel *lab_milN;

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *serCodeLab;
@property (nonatomic, strong) UILabel *destiLab;//到达地址
@property (nonatomic, strong) UIView  *toView;//直达分割线
@property (nonatomic, strong) UILabel *deparLab;//开始地址
@property (nonatomic, strong) UILabel *amountLab;//数量
@property (nonatomic, strong) UILabel *startLab;//开始时间
@property (nonatomic, strong) UILabel *lineLab;//分割线
@property (nonatomic, strong) UILabel *endlab;//结束时间
@property (nonatomic, strong) UILabel *serviceName;//服务商名称
@property (nonatomic, strong) UILabel *ordStuLab;//订单状态
@property (nonatomic, assign) float choosedWidth;
@property (nonatomic, strong) RouteDidiModel *ddModel;


@end
@implementation BusiTvlOrderCell

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
    
    if (!_view) {
        _view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        _view.backgroundColor=Color_White_Same_20;
        [self.contentView addSubview:_view];
    }
    [_view makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];
//
    NSInteger originX = 60;
    NSInteger originY = 25;
    NSInteger gapH = 5;
    NSInteger gapW = 10;
    NSInteger labHeight = 20;
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(gapW, originY, 40, 40)];
        [self.contentView addSubview:_iconImg];
    }

    if (!_deparLab) {
        _deparLab = [[UILabel alloc] init];
        _deparLab.frame = CGRectMake(originX, originY, 0, labHeight);
        _deparLab.font = Font_Same_14_20;
        _destiLab.textColor = Color_Black_Important_20;
        [self.contentView addSubview:_deparLab];
    }
    [_deparLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.right).offset(gapW);
        make.height.equalTo(labHeight);
        make.top.equalTo(self.view.bottom).offset(15);
    }];
    if (!_toView) {
        _toView = [[UILabel alloc] init];
        _toView.frame = CGRectMake(125, originY + 9.5, 5, 1);
        _toView.backgroundColor = Color_Black_Important_20;
        [self.contentView addSubview:_toView];
    }
    [_toView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deparLab.right);
        make.top.equalTo(self.view.bottom).offset(originY+9.5);
        make.height.equalTo(1);
        make.width.equalTo(5);
    }];
    if (!_destiLab) {
        _destiLab = [[UILabel alloc] init];
        _destiLab.frame = CGRectMake(140, originY, 50, labHeight);
        _destiLab.font = Font_Same_14_20;
        _destiLab.textColor = Color_Black_Important_20;
        [self.contentView addSubview:_destiLab];
    }
    [_destiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toView.right);
        make.top.equalTo(self.view.bottom).offset(15);
        make.height.equalTo(labHeight);
    }];
    
    if (!_serCodeLab) {
        _serCodeLab = [[UILabel alloc] init];
        _serCodeLab.frame = CGRectMake(200, originY, 70, labHeight);
        _serCodeLab.textColor = Color_GrayDark_Same_20;
        _serCodeLab.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_serCodeLab];
       }
    [_serCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.destiLab.right).offset(5);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(labHeight);
        make.width.equalTo(70);
    }];
    
    if (!_amountLab) {
        _amountLab = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width - 75 - gapW, originY, 75, labHeight)];
        _amountLab.textAlignment = NSTextAlignmentRight;
        _amountLab.font = [UIFont systemFontOfSize:15.0];
        _amountLab.textColor = Color_Black_Important_20;
        [self.contentView addSubview:_amountLab];
       }
    if (!_startLab) {
           _startLab = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY + labHeight + gapH, Main_Screen_Width - 70, labHeight)];
           _startLab.textColor = Color_GrayDark_Same_20;
           _startLab.font = Font_Same_13_20;
           [self.contentView addSubview:_startLab];
       }

    if (!_serviceName) {
        _serviceName = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY + 2*labHeight + 3*gapH, 100, labHeight)];
        _serviceName.textColor = Color_GrayDark_Same_20;
        _serviceName.font = Font_Same_14_20;
        [self.contentView addSubview:_serviceName];
       }
    if (!_ordStuLab) {
        _ordStuLab = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width - 70 - gapW, originY + 2*labHeight + 3*gapH, 70, labHeight)];
        _ordStuLab.textAlignment = NSTextAlignmentRight;
        _ordStuLab.font = Font_Same_14_20;
        _ordStuLab.textColor = Color_GrayDark_Same_20;
        [self.contentView addSubview:_ordStuLab];
       }
    
    if (!_img_isEdit) {
        _img_isEdit = [GPUtils createImageViewFrame:CGRectZero imageName:nil];
        [self.contentView addSubview:_img_isEdit];
    }

    [_img_isEdit makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(@((RouteCellHeightByDidi-10)/2));
        make.top.equalTo(self.contentView).offset(@80);
        make.left.equalTo(self.contentView).offset(@0);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
//
//    if (!_lab_carType) {
//        _lab_carType = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_lab_carType];
//    }
//    [_lab_carType mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(@10);
//        make.left.equalTo(self.contentView).offset(@12);
//        make.size.equalTo(CGSizeMake(Main_Screen_Width/2, 38));
//    }];
//
//    if (!_btn_status) {
//        _btn_status = [GPUtils createButton:CGRectMake(0, 0, 60, 38) action:nil delegate:self title:nil font:Font_Important_15_20 titleColor:Color_LabelPlaceHolder_Same_20];
//        _btn_status.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [self.contentView addSubview:_btn_status];
//    }
//    [_btn_status mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(@10);
//        make.right.equalTo(self.contentView).offset(-15);
//        make.size.equalTo(CGSizeMake(60, 38));
//    }];
//
//    if (!_view_line) {
//        _view_line = [[UIView alloc]initWithFrame:CGRectMake(12, 48, Main_Screen_Width-12, 0.5)];
//        _view_line.backgroundColor = Color_LineGray_Same_20;
//        [self.contentView addSubview:_view_line];
//    }
//
//    //出发时间
//    if (!_img_deparT) {
//        _img_deparT = [GPUtils createImageViewFrame:CGRectZero imageName:nil];
//        [_img_deparT setImage:[UIImage imageNamed:@"Route_Time"]];
//        [self.contentView addSubview:_img_deparT];
//    }
//
//    [_img_deparT mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_carType.bottom).offset(@18);
//        make.left.equalTo(self.img_isEdit.right).offset(@12);
//        make.size.equalTo(CGSizeMake(10, 10));
//    }];
//
//    if (!_lab_deparT) {
//        _lab_deparT = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_lab_deparT];
//    }
//
//    [_lab_deparT mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.img_deparT.top).offset(@-5);
//        make.left.equalTo(self.img_deparT.right).offset(@12);
//        make.size.equalTo(CGSizeMake(Main_Screen_Width-100, 20));
//    }];
//
//    //到达时间
//    if (!_img_arrT) {
//        _img_arrT = [[UIImageView alloc]init];
//        [_img_arrT setImage:[UIImage imageNamed:@"Route_Time"]];
//        [self.contentView addSubview:_img_arrT];
//
//    }
//    [_img_arrT mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_deparT.bottom).offset(@12);
//        make.left.equalTo(self.img_isEdit.right).offset(@12);
//        make.size.equalTo(CGSizeMake(10, 10));
//    }];
//
//    if (!_lab_arrT) {
//        _lab_arrT = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_lab_arrT];
//    }
//    [_lab_arrT mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.img_arrT.top).offset(@-5);
//        make.left.equalTo(self.img_arrT.right).offset(@12);
//        make.size.equalTo(CGSizeMake(Main_Screen_Width-100, 20));
//    }];
//
//    //出发地点
//    if (!_img_deparN) {
//        _img_deparN = [[UIImageView alloc]init];
//        [_img_deparN setImage:[UIImage imageNamed:@"Self_Drive_Green"]];
//        [self.contentView addSubview:_img_deparN];
//    }
//    [_img_deparN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_arrT.bottom).offset(@12);
//        make.left.equalTo(self.img_isEdit.right).offset(@12);
//        make.size.equalTo(CGSizeMake(10, 10));
//    }];
//
//    if (!_lab_deparN) {
//        _lab_deparN = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_lab_deparN];
//    }
//
//    [_lab_deparN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.img_deparN.top).offset(@-5);
//        make.left.equalTo(self.img_deparN.right).offset(@12);
//        make.size.equalTo(CGSizeMake(Main_Screen_Width-100, 20));
//    }];
//
//    //到达地点
//    if (!_img_arrN) {
//        _img_arrN = [[UIImageView alloc]init];
//        [_img_arrN setImage:[UIImage imageNamed:@"Self_Drive_Red"]];
//        [self.contentView addSubview:_img_arrN];
//    }
//    [self.img_arrN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_deparN.bottom).offset(@12);
//        make.left.equalTo(self.img_isEdit.right).offset(@12);
//        make.size.equalTo(CGSizeMake(10, 10));
//    }];
//    if (!_lab_arrN) {
//        _lab_arrN = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_lab_arrN];
//    }
//    [self.lab_arrN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.img_arrN.top).offset(@-5);
//        make.left.equalTo(self.img_arrN.right).offset(@12);
//        make.size.equalTo(CGSizeMake(Main_Screen_Width-100, 20));
//    }];
//
//
//    //公里
//    if (!_img_milN) {
//        _img_milN = [[UIImageView alloc]init];
//        [_img_milN setImage:[UIImage imageNamed:@"Route_Mileage"]];
//        [self.contentView addSubview:_img_milN];
//    }
//    [_img_milN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_arrN.bottom).offset(@12);
//        make.left.equalTo(self.img_isEdit.right).offset(@12);
//        make.size.equalTo(CGSizeMake(10, 10));
//    }];
//    if (!_lab_milN) {
//        _lab_milN = [GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_lab_milN];
//    }
//    [_lab_milN mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.img_milN.top).offset(@-5);
//        make.left.equalTo(self.img_milN.right).offset(@12);
//        make.size.equalTo(CGSizeMake(Main_Screen_Width-100, 20));
//    }];
}

-(void)configCellWithModel:(RouteDidiModel *)model isEdit:(BOOL)isEdit isChoosed:(NSString *)choosed{
    
    self.isEdit = isEdit;
    self.ddModel = model;
    __weak typeof(self) weakSelf = self;
    [self.img_isEdit updateConstraints:^(MASConstraintMaker *make) {
        if (isEdit) {
//            make.left.equalTo(@12);
            make.left.equalTo(@20);
            make.size.equalTo(CGSizeMake(20, 20));
            self.img_isEdit.hidden = NO;
            weakSelf.choosedWidth = 100;
        }else{
            make.left.equalTo(@0);
            make.size.equalTo(CGSizeMake(0, 0));
            self.img_isEdit.hidden = YES;
            weakSelf.choosedWidth = 0;
        }
//        [weakSelf reDrawCellUI];
    }];
    self.choosed = choosed;
//
//    [self.img_isEdit setImage:[choosed isEqualToString:@"1"] ?[UIImage imageNamed:@"MyApprove_Select"]:[UIImage imageNamed:@"MyApprove_UnSelect"]];

//    self.lab_carType.text = [model.use_car_type integerValue]==1?Custing(@"出租车", nil):[model.use_car_type integerValue]==2?Custing(@"专车", nil):[model.use_car_type integerValue]==3?Custing(@"快车", nil):Custing(@"代驾", nil);
//
//    [self.btn_status setTitle:[model.status integerValue]==2?Custing(@"已支付", nil):[model.status integerValue]==3?Custing(@"已退款", nil):[model.status integerValue]==4?Custing(@"已取消", nil):Custing(@"部分退款", nil) forState:UIControlStateNormal];
//
//    self.lab_deparT.text = [NSString stringWithIdOnNO:model.departure_time];
//    self.lab_arrT.text = [NSString stringWithIdOnNO:model.finish_time];
//    self.lab_deparN.text = [NSString stringWithIdOnNO:model.start_name];
//    self.lab_arrN.text = [NSString stringWithIdOnNO:model.end_name];
//
//    self.lab_milN.text = [NSString stringWithFormat:@"%@ KM",[NSString stringWithIdOnNO:model.normal_distance]];
    NSInteger originX = 60;
    NSInteger originY = 25;
//    NSInteger gapH = 5;
//    NSInteger gapW = 10;
    CGFloat spaceW = 5;
//    NSInteger labHeight = 20;

    CGFloat deparWith;
    NSString *destination;
    if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"4"]) {
        self.toView.alpha = 0;
        self.destiLab.alpha = 0;
        deparWith = 160;
        destination = @"";
        self.iconImg.image = [UIImage imageNamed:@"travelTicketHotel"];
    }else{
        destination = [NSString stringWithFormat:@"%@",model.destination];
        self.toView.alpha = 1;
        self.destiLab.alpha = 1;
        deparWith = 80;
        if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"6"]) {
            self.iconImg.image = [UIImage imageNamed:@"Travel_Car"];
        }else if([model.orderType isEqualToString:@"16"]){
            self.iconImg.image = [UIImage imageNamed:@"travelTicketPlan"];
        }else if ([model.orderType isEqualToString:@"2"]){
            self.iconImg.image = [UIImage imageNamed:@"travelTicketTrain"];
        }
    }
    
    NSString *departure = [NSString stringWithFormat:@"%@",model.departure];
    CGRect deparRect = [departure boundingRectWithSize:CGSizeMake(deparWith, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font_Same_14_20} context:nil];
    
    CGRect destiRect = [destination boundingRectWithSize:CGSizeMake(80, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font_Same_14_20} context:nil];
    
//    self.deparLab.frame = CGRectMake(originX, originY, deparRect.size.width, 20);

//    if ([[NSString stringWithFormat:@"%@",model.orderType] isEqualToString:@"4"]) {
//        self.toView.frame = CGRectMake(originX + deparRect.size.width, originY + 9.5, 0, 0);
//        self.destiLab.frame = CGRectMake(originX + deparRect.size.width, originY, 0, 0);
//        self.serCodeLab.frame = CGRectMake(originX + deparRect.size.width +spaceW, originY, 50, 20);
//
//    }else{
//        self.toView.frame = CGRectMake(originX + deparRect.size.width + spaceW, originY + 9.5, 5, 1);
//        self.destiLab.frame = CGRectMake(originX + deparRect.size.width + 3*spaceW, originY, destiRect.size.width, 20);
//        self.serCodeLab.frame = CGRectMake(originX + deparRect.size.width +4*spaceW + destiRect.size.width, originY, 55, 20);
//
//    }
    
    [_deparLab makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(deparRect.size.width);
    }];
    [_destiLab makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(destiRect.size.width);
    }];
    [_toView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(0);
    }];

//    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(gapW, originY, 40, 40)];
//    _amountLab.frame = CGRectMake(Main_Screen_Width - 75 - gapW, originY, 75, labHeight);
//_startLab.frame = CGRectMake(originX, originY + labHeight + gapH, Main_Screen_Width - 70, labHeight);
//    _serviceName.frame = CGRectMake(originX, originY + 2*labHeight + 3*gapH, 100, labHeight);
//    _ordStuLab.frame = CGRectMake(Main_Screen_Width - 70 - gapW, originY + 2*labHeight + 3*gapH, 70, labHeight);
    
    self.deparLab.text = [NSString stringWithFormat:@"%@",model.departure];
    self.destiLab.text = [NSString stringWithFormat:@"%@",model.destination];
    self.startLab.text = [NSString stringWithFormat:@"%@ - %@",model.startDate,model.endDate];
    
    self.serCodeLab.text = model.serviceProviderCode;
    self.amountLab.text = [GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",model.amount]];
    self.serviceName.text = model.serviceProviderName;
    self.ordStuLab.text = model.orderStatus;
}
-(void)setChoosed:(NSString *)choosed{
    _choosed = choosed;
    [self.img_isEdit setImage:[choosed isEqualToString:@"1"] ?[UIImage imageNamed:@"MyApprove_Select"]:[UIImage imageNamed:@"MyApprove_UnSelect"]];
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
