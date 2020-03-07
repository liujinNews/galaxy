//
//  CtripDetailController.m
//  galaxy
//
//  Created by hfk on 2016/10/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CtripDetailController.h"
#import "CtripHotelModel.h"
#import "CtripFlightModel.h"
#import "CtripTrainModel.h"
@interface CtripDetailController ()
@property (copy, nonatomic)CtripHotelModel *hotelModel;//酒店Model
@property (copy, nonatomic)CtripFlightModel *flightModel;//飞机Model
@property (copy, nonatomic)CtripTrainModel *trainModel;//火车Model
@end

@implementation CtripDetailController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"订单详情", nil) backButton:YES];
    [self createScrollView];
    [self requestDetail];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

//MARK:创建主scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self createContentView];
    [self createMainView];
}

-(void)createContentView{
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;//[UIColor blueColor];//Color_White_Same_20
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    
    self.HotelView=[[UIView alloc]init];
    self.HotelView.backgroundColor=Color_form_TextFieldBackgroundColor;
    self.HotelView.layer.cornerRadius = 10.0f;
    self.HotelView.layer.shadowOffset = CGSizeMake(0, 1);
    self.HotelView.layer.shadowOpacity = 0.25;
    self.HotelView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    self.HotelView.layer.shadowOffset = CGSizeMake(2, 2);
    [self.contentView addSubview:self.HotelView];
    [self.HotelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.equalTo(self.contentView.left).offset(@15);
        make.right.equalTo(self.contentView.right).offset(@(-15));
    }];
    
    
    self.FlightView=[[UIView alloc]init];
    self.FlightView.backgroundColor=Color_form_TextFieldBackgroundColor;
    self.FlightView.layer.cornerRadius = 10.0f;
    self.FlightView.layer.shadowOffset = CGSizeMake(0, 1);
    self.FlightView.layer.shadowOpacity = 0.25;
    self.FlightView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    self.FlightView.layer.shadowOffset = CGSizeMake(2, 2);
    [self.contentView addSubview:self.FlightView];
    [self.FlightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.bottom);
        make.left.equalTo(self.contentView.left).offset(@15);
        make.right.equalTo(self.contentView.right).offset(@(-15));
    }];
    
    self.TrainView=[[UIView alloc]init];
    self.TrainView.backgroundColor=Color_form_TextFieldBackgroundColor;
    self.TrainView.layer.cornerRadius = 10.0f;
    self.TrainView.layer.shadowOffset = CGSizeMake(0, 1);
    self.TrainView.layer.shadowOpacity = 0.25;
    self.TrainView.layer.shadowColor = Color_GrayDark_Same_20.CGColor;
    self.TrainView.layer.shadowOffset = CGSizeMake(2, 2);
    [self.contentView addSubview:self.TrainView];
    [self.TrainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.bottom);
        make.left.equalTo(self.contentView.left).offset(@15);
        make.right.equalTo(self.contentView.right).offset(@(-15));
    }];
}

//MARK:-网络请求
-(void)requestDetail{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url;
    NSDictionary *parameters;
    if ([_type isEqualToString:@"DetailList"]) {
        url=[NSString stringWithFormat:@"%@",CtripGetDetail];
        parameters = @{@"OrderId":[NSString stringWithFormat:@"%@",_taskId]};
    }else{
        url=[NSString stringWithFormat:@"%@",CtripOrderDetail];
        parameters = @{@"JourneyNo":[NSString stringWithFormat:@"%@",_taskId]};
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];

}

//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"====%@",responceDic);
    _resultDict=responceDic;
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        //        NSLog(@"%@",error);
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
            [self dealWithDates];
            break;
        default:
            break;
    }
    
}
//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:处理数据
-(void)dealWithDates{
    NSDictionary *result=_resultDict[@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        NSDictionary *hotelDict=result[@"hotel"];
        NSDictionary *flightDict=result[@"flight"];
        NSDictionary *trainDict=result[@"train"];
        if (![hotelDict isKindOfClass:[NSNull class]]) {
            _hotelModel=[[CtripHotelModel alloc]init];
            [_hotelModel setValuesForKeysWithDictionary:hotelDict];
            [self updateHotelView];
        }
        if (![flightDict isKindOfClass:[NSNull class]]) {
            _flightModel=[[CtripFlightModel alloc]init];
            [_flightModel setValuesForKeysWithDictionary:flightDict];
            [self updateFightView];
        }
        if (![trainDict isKindOfClass:[NSNull class]]){
            _trainModel=[[CtripTrainModel alloc]init];
            [_trainModel setValuesForKeysWithDictionary:trainDict];
            [self updateTrainView];
        }
    }else{
    
    
    }
    [self updateBottomView];
}
//MARK:更新酒店订单
-(void)updateHotelView{
    [self.HotelView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@15);
    }];
    
    UIView *H_StatusView=[[UIView alloc]init];
    H_StatusView.backgroundColor=Color_Blue_Important_20;
    [self.HotelView addSubview:H_StatusView];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Main_Screen_Width-30, 90) byRoundingCorners: UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shaper = [[CAShapeLayer alloc]init];
    shaper.frame = H_StatusView.bounds;
    shaper.path = path.CGPath;
    H_StatusView.layer.mask = shaper;
    
    [H_StatusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.top);
        make.left.equalTo(self.HotelView.left);
        make.right.equalTo(self.HotelView.right);
        make.height.equalTo(@65);
    }];
    
//    UIImageView  *H_statusImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_Save"]];
//    [H_StatusView addSubview:H_statusImg];
//    [H_statusImg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(H_StatusView.top).offset(@24);
//        make.left.equalTo(H_StatusView.left).offset(@12);
//        make.size.equalTo(CGSizeMake(20, 20));
//    }];
    
    //@"已完成"
    UILabel *H_statusLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_hotelModel.orderStatus] font:Font_Amount_21_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    //    H_statusLal.backgroundColor=Color_Unsel_TitleColor;
    [H_StatusView addSubview:H_statusLal];
    [H_statusLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_StatusView.top).offset(@22);
        make.left.equalTo(H_StatusView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-60, 24));
    }];

    UILabel *H_TitleLal=[GPUtils createLable:CGRectZero text:Custing(@"酒店订单", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentRight];
//    TitleLal.backgroundColor=Color_Unsel_TitleColor;
    [H_StatusView addSubview:H_TitleLal];
    [H_TitleLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_StatusView.top).offset(@22);
        make.right.equalTo(H_StatusView.right).offset(@(-18));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-33, 24));
    }];
    
    //@"到店支付"
    UILabel *H_payWayLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_hotelModel.payType] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.HotelView addSubview:H_payWayLal];
    [H_payWayLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.top).offset(@80);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(100, 24));
    }];
    
    //@"378.00"
    UILabel *H_payMoneyLal=[GPUtils createLable:CGRectZero text:[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",_hotelModel.amount]] font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentLeft];
    [self.HotelView addSubview:H_payMoneyLal];
    [H_payMoneyLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.top).offset(@80);
        make.left.equalTo(H_payWayLal.right).offset(@(10));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60-100, 24));
    }];
    
    UIView *H_lineView0=[[UIView alloc]init];//Color_White_Same_20
    H_lineView0.backgroundColor=Color_GrayLight_Same_20;
    [self.HotelView addSubview:H_lineView0];
    [H_lineView0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.top).offset(@120);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    
    UIImageView  *H_HotelImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_Hotel"]];
    [self.HotelView addSubview:H_HotelImg];
    [H_HotelImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.top).offset(@133);
        make.left.equalTo(self.HotelView.left).offset(@15);
        make.size.equalTo(CGSizeMake(18,18));
    }];
    
    //@"汉庭酒店 (北京奥运村店)"
    UILabel *H_HotelInfoLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_hotelModel.hotelName] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    H_HotelInfoLal.numberOfLines=0;
    [self.HotelView addSubview:H_HotelInfoLal];
    CGSize size = [[NSString stringWithFormat:@"%@",_hotelModel.hotelName] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-86, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    [H_HotelInfoLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.top).offset(@130);
        make.left.equalTo(H_HotelImg.right).offset(@(8));
        make.size.equalTo(size);
    }];
    
    UIView *H_lineView1=[[UIView alloc]init];//Color_White_Same_20
    H_lineView1.backgroundColor=Color_GrayLight_Same_20;
    [self.HotelView addSubview:H_lineView1];
    [H_lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_HotelInfoLal.bottom).offset(@12);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    UIImageView  *H_PlaceImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_PlaceB"]];
    [self.HotelView addSubview:H_PlaceImg];
    [H_PlaceImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_lineView1.bottom).offset(@13);
        make.left.equalTo(self.HotelView.left).offset(@15);
        make.size.equalTo(CGSizeMake(18,18));
    }];
    
    //@"北苑路甲78号"
    UILabel *H_HotelPlaceLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_hotelModel.address] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    H_HotelPlaceLal.numberOfLines=0;
    [self.HotelView addSubview:H_HotelPlaceLal];
    CGSize size1 = [[NSString stringWithFormat:@"%@",_hotelModel.address] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-86, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    [H_HotelPlaceLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_lineView1.bottom).offset(@10);
        make.left.equalTo(H_PlaceImg.right).offset(@(8));
        make.size.equalTo(size1);
    }];
    
    UIView *H_lineView2=[[UIView alloc]init];//Color_White_Same_20
    H_lineView2.backgroundColor=Color_GrayLight_Same_20;
    [self.HotelView addSubview:H_lineView2];
    [H_lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_HotelPlaceLal.bottom).offset(@15);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    //@"标准间 (内宾)"
    UILabel *H_RoomInfoLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_hotelModel.roomName] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.HotelView addSubview:H_RoomInfoLal];
    [H_RoomInfoLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_lineView2.bottom).offset(@16);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 18));
    }];
    
    //@"4月14日-4月15日 1晚 1间"
    UILabel *H_DurTimeLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@-%@ %@%@ %@%@",_hotelModel.startDate,_hotelModel.endDate,_hotelModel.roomDays,Custing(@"晚", nil),_hotelModel.roomQuantity,Custing(@"间", nil)] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.HotelView addSubview:H_DurTimeLab];
    [H_DurTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_RoomInfoLal.bottom).offset(@8);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 14));
    }];
   
    //@"无早|双床|全部放假呢wifi,有线宽带免费"
    UILabel *H_orderInfoLab=[GPUtils createLable:CGRectZero text:[[NSString stringWithFormat:@"%@",_hotelModel.hasBreakfast]isEqualToString:@"1"]?Custing(@"有早餐", nil):Custing(@"无早餐", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    H_orderInfoLab.numberOfLines=0;
    [self.HotelView addSubview:H_orderInfoLab];
    CGSize size2 =[[[NSString stringWithFormat:@"%@",_hotelModel.hasBreakfast]isEqualToString:@"1"]?Custing(@"有早餐", nil):Custing(@"无早餐", nil) sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-60, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    [H_orderInfoLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_DurTimeLab.bottom).offset(@8);
        make.left.equalTo(self.HotelView.left).offset(@15);
        make.size.equalTo(size2);
    }];
    
    UIView *H_lineView3=[[UIView alloc]init];//Color_White_Same_20
    H_lineView3.backgroundColor=Color_GrayLight_Same_20;
    [self.HotelView addSubview:H_lineView3];
    [H_lineView3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_orderInfoLab.bottom).offset(@15);
        make.left.equalTo(self.HotelView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];

//    //@"乘客: 张三,历史"
//    UILabel *H_PersonLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"入住人: %@",_hotelModel.passenger] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
//    H_PersonLal.numberOfLines=0;
//    [self.HotelView addSubview:H_PersonLal];
//    CGSize size3 = [[NSString stringWithFormat:@"入住人: %@",_hotelModel.passenger] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-60, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//    [H_PersonLal makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(H_lineView3.bottom).offset(@15);
//        make.left.equalTo(self.HotelView.left).offset(@(15));
//        make.size.equalTo(size3);
//    }];
    
    //@"订单编码: 23884828893"
    UILabel *H_orderLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@: %@",Custing(@"订单编号", nil),_hotelModel.orderID] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.HotelView addSubview:H_orderLab];
    [H_orderLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_lineView3.bottom).offset(@15);
        make.left.equalTo(self.HotelView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 18));
    }];
    
    //@"预定日期: 2016-04-14"
    UILabel *H_advanceDateLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@: %@",Custing(@"预定日期", nil),_hotelModel.orderDate] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.HotelView addSubview:H_advanceDateLab];
    [H_advanceDateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H_orderLab.bottom).offset(@8);
        make.left.equalTo(self.HotelView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 15));
    }];
    
    [self.HotelView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(H_advanceDateLab.bottom).offset(@30);
    }];
    
}
//MARK:更新飞机订单
-(void)updateFightView{
    
    [self.FlightView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.HotelView.bottom).offset(@15);
    }];
    
    UIView *F_StatusView=[[UIView alloc]init];
    F_StatusView.backgroundColor=Color_Blue_Important_20;
    [self.FlightView addSubview:F_StatusView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Main_Screen_Width-30, 65) byRoundingCorners: UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shaper = [[CAShapeLayer alloc]init];
    shaper.frame = F_StatusView.bounds;
    shaper.path = path.CGPath;
    F_StatusView.layer.mask = shaper;
    
    [F_StatusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top);
        make.left.equalTo(self.FlightView.left);
        make.right.equalTo(self.FlightView.right);
        make.height.equalTo(@65);
    }];

    
    //@"待支付"
    UILabel *F_statusLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_flightModel.orderStatus] font:Font_Amount_21_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    [F_StatusView addSubview:F_statusLal];
    [F_statusLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(F_StatusView.top).offset(@22);
        make.left.equalTo(F_StatusView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-60, 24));
    }];
    
    UILabel *F_TitleLal=[GPUtils createLable:CGRectZero text:Custing(@"机票订单", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentRight];
    [F_StatusView addSubview:F_TitleLal];
    [F_TitleLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(F_StatusView.top).offset(@22);
        make.right.equalTo(F_StatusView.right).offset(@(-18));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-33, 24));
    }];
    
    UILabel *F_type=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
    [F_type.layer setMasksToBounds:YES];
    [F_type.layer setCornerRadius:5.0];
    F_type.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_flightModel.flightWay]]?[NSString stringWithFormat:@"%@",_flightModel.flightWay]:@"";
    F_type.backgroundColor=Color_Blue_Important_20;
    [self.FlightView addSubview:F_type];
    [F_type makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@75);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(45, 24));
    }];
    
    //@"1808.00"
    UILabel *F_typeDetail=[GPUtils createLable:CGRectZero text:nil font:Font_Amount_21_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    NSString *startPlace=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_flightModel.dCityName]]?[NSString stringWithFormat:@"%@",_flightModel.dCityName]:@"";
    NSString *endPlace=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_flightModel.aCityName]]?[NSString stringWithFormat:@"%@",_flightModel.aCityName]:@"";
    F_typeDetail.text=[NSString stringWithFormat:@"%@-%@",startPlace,endPlace];
    [self.FlightView addSubview:F_typeDetail];
    [F_typeDetail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@75);
        make.left.equalTo(F_type.right).offset(@(10));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60-60, 24));
    }];
    
    
    
    UILabel *F_TotalLal=[GPUtils createLable:CGRectZero text:Custing(@"订单总价", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.FlightView addSubview:F_TotalLal];
    [F_TotalLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@105);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(70, 24));
    }];
    
    //@"1808.00"
    UILabel *F_payMoneyLal=[GPUtils createLable:CGRectZero text:[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",_flightModel.amount]] font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentLeft];
    [self.FlightView addSubview:F_payMoneyLal];
    [F_payMoneyLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@105);
        make.left.equalTo(F_TotalLal.right).offset(@(10));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60-70, 24));
    }];
    
    UIView *F_lineView0=[[UIView alloc]init];//Color_White_Same_20
    F_lineView0.backgroundColor=Color_GrayLight_Same_20;
    [self.FlightView addSubview:F_lineView0];
    [F_lineView0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@140);//120
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    //@"17:35"
    UILabel *F_startLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_flightModel.takeoffTime] font:Font_Amount_21_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
//    startLab.backgroundColor=[UIColor cyanColor];
    [self.FlightView addSubview:F_startLab];
    [F_startLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@188);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    //@"04-02 周六"
    UILabel *F_startMonthLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@-%@ %@",_flightModel.takeoffMonth,_flightModel.takeoffDay,_flightModel.takeoffWeek] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.FlightView addSubview:F_startMonthLab];
    [F_startMonthLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@158);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    //@"浦东T1"
    UILabel *F_startPlaceLab=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    NSString *startAir=[NSString stringWithFormat:@"%@",_flightModel.dAirportShortname];
    if ([NSString isEqualToNull:startAir]) {
        if (startAir.length>2) {
            _flightModel.dAirportShortname=[startAir substringToIndex:2];
        }
    }else{
        _flightModel.dAirportShortname=@"";
    }
    F_startPlaceLab.text= [NSString stringWithFormat:@"%@%@",_flightModel.dPortName, _flightModel.dAirportShortname];
    [self.FlightView addSubview:F_startPlaceLab];
    [F_startPlaceLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@218);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    
    //@"21:50"
    UILabel *F_endLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_flightModel.arrivalTime] font:Font_Amount_21_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
//    endLab.backgroundColor=[UIColor cyanColor];
    [self.FlightView addSubview:F_endLab];
    [F_endLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@188);
        make.right.equalTo(self.FlightView.right).offset(@(-15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    //@"04-02 周六"
    UILabel *F_endMonthLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@-%@ %@",_flightModel.arrivalMonth,_flightModel.arrivalDay,_flightModel.arrivalWeek] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.FlightView addSubview:F_endMonthLab];
    [F_endMonthLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@158);
        make.right.equalTo(self.FlightView.right).offset(@(-15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    //@"浦东T1"
    UILabel *F_endPlaceLab=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.FlightView addSubview:F_endPlaceLab];
    NSString *endAir=[NSString stringWithFormat:@"%@",_flightModel.aAirportShortname];
    if ([NSString isEqualToNull:endAir]) {
        if (endAir.length>2) {
            _flightModel.aAirportShortname=[endAir substringToIndex:2];
        }
    }else{
        _flightModel.aAirportShortname=@"";
    }
    F_endPlaceLab.text= [NSString stringWithFormat:@"%@%@",_flightModel.aPortName, _flightModel.aAirportShortname];
    [F_endPlaceLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@218);
        make.right.equalTo(self.FlightView.right).offset(@(-15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    
    UIImageView  *F_allowImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_Arrow"]];
    [self.FlightView addSubview:F_allowImg];
    [F_allowImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@196);
        make.left.equalTo(self.FlightView.left).offset(@(Main_Screen_Width/3-5));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 4));
    }];
    
    UILabel *F_TrainInfoLab=[GPUtils createLable:CGRectZero text:Custing(@"经停", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.FlightView addSubview:F_TrainInfoLab];
    [F_TrainInfoLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@179);
        make.left.equalTo(self.FlightView.left).offset(@(Main_Screen_Width/3-5));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 16));
    }];
    
    //@"约4小时15分钟"
    UILabel *F_intervalTimeLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@%@",Custing(@"约", nil),_flightModel.totalTime] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.FlightView addSubview:F_intervalTimeLab];
    [F_intervalTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@203);
        make.left.equalTo(self.FlightView.left).offset(@(Main_Screen_Width/3-5));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 16));
    }];
    
    UIImageView  *F_FlightImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_Flight"]];
    [self.FlightView addSubview:F_FlightImg];
    [F_FlightImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@251);
        make.left.equalTo(self.FlightView.left).offset(@15);
        make.size.equalTo(CGSizeMake(12,12));
    }];

    //@"东方航空MU5615|机型330(中) 经济舱"
    UILabel *F_InfoLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@%@|%@",_flightModel.airLineName,_flightModel.flight,_flightModel.className] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    F_InfoLal.numberOfLines=0;
    [self.FlightView addSubview:F_InfoLal];
    CGSize size = [[NSString stringWithFormat:@"%@%@|%@",_flightModel.airLineName,_flightModel.flight,_flightModel.className] sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-60, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    [F_InfoLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.top).offset(@248);
        make.left.equalTo(F_FlightImg.right).offset(@(8));
        make.size.equalTo(size);
    }];
    
    UIView *F_lineView1=[[UIView alloc]init];
    F_lineView1.backgroundColor=Color_GrayLight_Same_20;
    [self.FlightView addSubview:F_lineView1];
    [F_lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(F_InfoLal.bottom).offset(@15);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    //@"乘客: 张三,历史"
    UILabel *F_PersonLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@: %@",Custing(@"乘客", nil),_flightModel.passenger] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    F_PersonLal.numberOfLines=0;
    [self.FlightView addSubview:F_PersonLal];
    CGSize size1 = [[NSString stringWithFormat:@"%@: %@",Custing(@"乘客", nil),_flightModel.passenger] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-60, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    [F_PersonLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(F_lineView1.bottom).offset(@15);
        make.left.equalTo(self.FlightView.left).offset(@(15));
        make.size.equalTo(size1);
    }];
    
    //@"订单编码: 23884828893"
    UILabel *F_orderLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@: %@",Custing(@"订单编号", nil),_flightModel.orderID] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.FlightView addSubview:F_orderLab];
    [F_orderLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(F_PersonLal.bottom).offset(@10);
        make.left.equalTo(self.FlightView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 18));
    }];
    
    [self.FlightView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(F_orderLab.bottom).offset(@30);
    }];
    
}
//MARK:更新火车订单
-(void)updateTrainView{
    [self.TrainView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FlightView.bottom).offset(@15);
    }];
    
    UIView *T_StatusView=[[UIView alloc]init];
    T_StatusView.backgroundColor=Color_Blue_Important_20;
    [self.TrainView addSubview:T_StatusView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Main_Screen_Width-30, 65) byRoundingCorners: UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shaper = [[CAShapeLayer alloc]init];
    shaper.frame = T_StatusView.bounds;
    shaper.path = path.CGPath;
    T_StatusView.layer.mask = shaper;
    
    [T_StatusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top);
        make.left.equalTo(self.TrainView.left);
        make.right.equalTo(self.TrainView.right);
        make.height.equalTo(@65);
    }];
    
//    UIImageView  *T_statusImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_Save"]];
//    [T_StatusView addSubview:T_statusImg];
//    [T_statusImg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(T_StatusView.top).offset(@24);
//        make.left.equalTo(T_StatusView.left).offset(@12);
//        make.size.equalTo(CGSizeMake(20, 20));
//    }];
    
    //@"已完成"
    UILabel *T_statusLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_trainModel.orderStatus] font:Font_Amount_21_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    [T_StatusView addSubview:T_statusLal];
    [T_statusLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(T_StatusView.top).offset(@22);
        make.left.equalTo(T_StatusView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-60, 24));
    }];
    
    UILabel *T_TitleLal=[GPUtils createLable:CGRectZero text:Custing(@"火车票订单", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentRight];
    [T_StatusView addSubview:T_TitleLal];
    [T_TitleLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(T_StatusView.top).offset(@22);
        make.right.equalTo(T_StatusView.right).offset(@(-18));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/2-33, 24));
    }];
    
    //@"订单总价"
    UILabel *T_TotalLal=[GPUtils createLable:CGRectZero text:Custing(@"订单总价", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.TrainView addSubview:T_TotalLal];
    [T_TotalLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@80);
        make.left.equalTo(self.TrainView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(70, 24));
    }];
    
    //@"213.00"
    UILabel *T_payMoneyLal=[GPUtils createLable:CGRectZero text:[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",_trainModel.amount]] font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentLeft];
    [self.TrainView addSubview:T_payMoneyLal];
    [T_payMoneyLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@80);
        make.left.equalTo(T_TotalLal.right).offset(@(10));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60-70, 24));
    }];
    
    UIView *T_lineView0=[[UIView alloc]init];//Color_White_Same_20
    T_lineView0.backgroundColor=Color_GrayLight_Same_20;
    [self.TrainView addSubview:T_lineView0];
    [T_lineView0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@120);
        make.left.equalTo(self.TrainView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    //@"2016-01-12  12:40开"
    UILabel *T_TimeLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@%@ %@",_trainModel.departureDate,_trainModel.departureTime,Custing(@"开", nil)] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.TrainView addSubview:T_TimeLab];
    [T_TimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@133);
        make.left.equalTo(self.TrainView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 16));
    }];
    
    //@"上海"
    UILabel *T_startLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_trainModel.departureStationName] font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
    [self.TrainView addSubview:T_startLab];
    [T_startLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@165);
        make.left.equalTo(self.TrainView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    //@"北京"
    UILabel *T_endLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_trainModel.arrivalStationName] font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.TrainView addSubview:T_endLab];
    [T_endLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@165);
        make.right.equalTo(self.TrainView.right).offset(@(-15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 18));
    }];
    
    UIImageView  *T_allowImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ctrip_Arrow"]];
    [self.TrainView addSubview:T_allowImg];
    [T_allowImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@173);
        make.left.equalTo(self.TrainView.left).offset(@(Main_Screen_Width/3));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-30, 4));
    }];

    //@"G112"
    UILabel *T_TrainInfoLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_trainModel.trainName] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [self.TrainView addSubview:T_TrainInfoLab];
    [T_TrainInfoLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@156);
        make.left.equalTo(self.TrainView.left).offset(@(Main_Screen_Width/3-5));
        make.size.equalTo(CGSizeMake(Main_Screen_Width/3-20, 16));
    }];
    
    //@"一等座|5车|17号"
    UILabel *T_NumLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@",_trainModel.firstSeatTypeName] font:Font_Same_12_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
    [self.TrainView addSubview:T_NumLab];
    [T_NumLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@198);
        make.left.equalTo(self.TrainView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 16));
    }];
    
    
    UIView *T_lineView1=[[UIView alloc]init];
    T_lineView1.backgroundColor=Color_GrayLight_Same_20;
    [self.TrainView addSubview:T_lineView1];
    [T_lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@228);
        make.left.equalTo(self.TrainView.left).offset(@(15));
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 1));
    }];
    
    //@"乘客: 张三,历史"
    UILabel *T_PersonLal=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@: %@",Custing(@"乘客", nil),_trainModel.passenger] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    T_PersonLal.numberOfLines=0;
    [self.TrainView addSubview:T_PersonLal];
    CGSize size = [[NSString stringWithFormat:@"%@: %@",Custing(@"乘客", nil),_trainModel.passenger] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-60, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    [T_PersonLal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TrainView.top).offset(@238);
        make.left.equalTo(self.TrainView.left).offset(@(15));
        make.size.equalTo(size);
    }];
    
    
    UILabel *T_orderLab=[GPUtils createLable:CGRectZero text:[NSString stringWithFormat:@"%@: %@",Custing(@"订单编号", nil),_trainModel.orderID] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self.TrainView addSubview:T_orderLab];
    [T_orderLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(T_PersonLal.bottom).offset(@10);
        make.left.equalTo(self.TrainView.left).offset(@15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-60, 18));
    }];
    
    [self.TrainView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(T_orderLab.bottom).offset(@30);
    }];
}
//MARK:更新底层视图
-(void)updateBottomView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.TrainView.bottom).offset(@15);
    }];
    [self.contentView layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
