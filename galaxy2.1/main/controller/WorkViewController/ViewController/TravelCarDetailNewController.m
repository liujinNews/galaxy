//
//  TravelCarDetailNewController.m
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "TravelCarDetailNewController.h"
#import "NewAddressViewController.h"
#import "TravelCarChooseAddressController.h"

@interface TravelCarDetailNewController ()<UIScrollViewDelegate>

@end

@implementation TravelCarDetailNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"用车需求单", nil) backButton:YES];
    if (!self.TravelCarDetail) {
        self.TravelCarDetail = [[TravelCarDetail alloc]init];
    }
    [self createScrollView];
    [self createMainView];
    [self updateMainView];
}
//MARK:创建scrollView
-(void)createScrollView{
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    self.dockView = [[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled = YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            [weakSelf saveData];
        }
    };
}
//MARK:创建主视图
-(void)createMainView{
    
    _View_VehicleDate = [[UIView alloc]init];
    _View_VehicleDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VehicleDate];
    [_View_VehicleDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_FromCity = [[UIView alloc]init];
    _View_FromCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FromCity];
    [_View_FromCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Departure = [[UIView alloc]init];
    _View_Departure.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Departure];
    [_View_Departure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromCity.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToCity = [[UIView alloc]init];
    _View_ToCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ToCity];
    [_View_ToCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Departure.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Destination = [[UIView alloc]init];
    _View_Destination.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Destination];
    [_View_Destination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Destination.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
-(void)updateMainView{
    for (MyProcurementModel *model in self.arr_show) {
        
        if ([model.fieldName isEqualToString:@"VehicleDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateVehicleDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Departure"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateFromCityViewWithModel:model];
                [self updateDepartureViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Destination"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateToCityViewWithModel:model];
                [self updateDestinationViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateRemarkViewWithModel:model];
            }
        }
    }
    [self updateContentView];
}
//MARK:更新日期
-(void)updateVehicleDateViewWithModel:(MyProcurementModel *)model{
    _txf_VehicleDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_VehicleDate WithContent:_txf_VehicleDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.TravelCarDetail.VehicleDate}];
    [_View_VehicleDate addSubview:view];
}
//MARK:更新出发城市
-(void)updateFromCityViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"出发城市", nil);
    model1.tips = Custing(@"请选择出发城市", nil);
    model1.isRequired = model.isRequired;
    model1.isShow = model.isShow;
    
    _txf_FromCity = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_FromCity WithContent:_txf_FromCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model1 WithInfodict:@{@"value1":self.TravelCarDetail.FromCity}];
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        NewAddressViewController *vc = [[NewAddressViewController alloc]init];
        vc.Type = 1;
        vc.isGocity = @"1";
        vc.OnlyInternal = YES;
        vc.selectAddressBlock = ^(NSArray *array, NSString *start) {
            NSDictionary *dic = array[0];
            weakSelf.TravelCarDetail.FromCity = [NSString stringIsExist:[self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"]];
            weakSelf.TravelCarDetail.FromCityCode = [NSString stringIsExist:dic[@"cityCode"]];
            weakSelf.txf_FromCity.text = weakSelf.TravelCarDetail.FromCity;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_View_FromCity addSubview:view];
}
//MARK:更新出发地视图
-(void)updateDepartureViewWithModel:(MyProcurementModel *)model{
    _txf_Departure = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Departure WithContent:_txf_Departure WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.TravelCarDetail.Departure}];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        TravelCarChooseAddressController *vc = [[TravelCarChooseAddressController alloc]init];
        vc.type = 1;
        vc.block = ^(AMapPOI * _Nonnull Poi) {
            weakSelf.TravelCarDetail.Departure = Poi.name;
            weakSelf.TravelCarDetail.FromLocation = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%f",Poi.location.longitude],[NSString stringWithFormat:@"%f",Poi.location.latitude]] WithCompare:@","];
            weakSelf.txf_Departure.text = Poi.name;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_View_Departure addSubview:view];
}

//MARK:更新目的城市视图
-(void)updateToCityViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"目的城市", nil);
    model2.tips = Custing(@"请选择目的城市", nil);
    model2.isRequired = model.isRequired;
    model2.isShow = model.isShow;
    
    _txf_ToCity = [[UITextField alloc]init];
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:_View_ToCity WithContent:_txf_ToCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model2 WithInfodict:@{@"value1":self.TravelCarDetail.ToCity}];
    view1.FormClickedBlock = ^(MyProcurementModel *model) {
        NewAddressViewController *vc = [[NewAddressViewController alloc]init];
        vc.Type = 1;
        vc.isGocity = @"1";
        vc.OnlyInternal = YES;
        vc.selectAddressBlock = ^(NSArray *array, NSString *start) {
            NSDictionary *dic = array[0];
            weakSelf.TravelCarDetail.ToCity = [NSString stringIsExist:[self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"]];
            weakSelf.TravelCarDetail.ToCityCode = [NSString stringIsExist:dic[@"cityCode"]];
            weakSelf.txf_ToCity.text = weakSelf.TravelCarDetail.ToCity;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_View_ToCity addSubview:view1];
}
//MARK:更新目的地视图
-(void)updateDestinationViewWithModel:(MyProcurementModel *)model{
    
    _txf_Destination = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Destination WithContent:_txf_Destination WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.TravelCarDetail.Destination}];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        TravelCarChooseAddressController *vc = [[TravelCarChooseAddressController alloc]init];
        vc.type = 2;
        vc.block = ^(AMapPOI * _Nonnull Poi) {
            weakSelf.TravelCarDetail.Destination = Poi.name;
            weakSelf.TravelCarDetail.ToLocation = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%f",Poi.location.longitude],[NSString stringWithFormat:@"%f",Poi.location.latitude]] WithCompare:@","];
            weakSelf.txf_Destination.text = Poi.name;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_View_Destination addSubview:view];
}
//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.TravelCarDetail.Remark}];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Remark.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}

-(void)saveData{
    self.TravelCarDetail.VehicleDate = _txf_VehicleDate.text;
    self.TravelCarDetail.Departure = self.txf_Departure.text;
    self.TravelCarDetail.Destination = self.txf_Destination.text;
    self.TravelCarDetail.Remark = _txv_Remark.text;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isShow = 1 && isRequired = 1"];
    NSArray *filterArray = [self.arr_show filteredArrayUsingPredicate:pred];
    for (MyProcurementModel *model in filterArray) {
        NSMutableString *fieldName = [NSMutableString stringWithFormat:@"%@",model.fieldName];
        if ([fieldName isEqualToString:@"Departure"] && ![NSString isEqualToNullAndZero:self.TravelCarDetail.FromCityCode]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择出发城市", nil) duration:2.0];
            return;
        }else if ([fieldName isEqualToString:@"Destination"] && ![NSString isEqualToNullAndZero:self.TravelCarDetail.ToCityCode]){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择目的城市", nil) duration:2.0];
            return;
        }
        if (![NSString isEqualToNull:[self.TravelCarDetail valueForKey:fieldName]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:model.tips duration:2.0];
            return;
        }
    }
    if (self.TravelCarAddEditBlock) {
        self.TravelCarAddEditBlock(self.TravelCarDetail, self.type);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
