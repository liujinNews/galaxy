//
//  AddTravelRouteController.m
//  galaxy
//
//  Created by hfk on 2018/11/7.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddTravelRouteController.h"
#import "NewAddressViewController.h"

@interface AddTravelRouteController ()

@property (nonatomic, strong) NSMutableArray *arr_time;

@end

@implementation AddTravelRouteController

-(NSMutableArray *)arr_time{
    if (_arr_time == nil) {
        _arr_time = [NSMutableArray array];
        NSArray *type=@[Custing(@"全天", nil),Custing(@"上午", nil),Custing(@"下午", nil)];
        NSArray *code=@[@"0",@"1",@"2"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_time addObject:model];
        }
    }
    return _arr_time;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"添加行程", nil) backButton:YES];
    if (!self.dic_Data) {
        self.dic_Data = [NSDictionary dictionary];
    }
    [self initData];
    [self createViews];
    [self updateMainView];
}
-(void)initData{
    self.str_TravelTime = ([NSString isEqualToNull:self.dic_Data[@"travelTime"]]&&![[NSString stringWithFormat:@"%@",self.dic_Data[@"travelTime"]] isEqualToString:@"3"] )? [NSString stringWithFormat:@"%@",self.dic_Data[@"travelTime"]]:@"0";
    self.str_FromCityCode = self.dic_Data[@"fromCityCode"];
    self.str_ToCityCode = self.dic_Data[@"toCityCode"];
    self.str_TransId = [NSString isEqualToNull:self.dic_Data[@"transId"]] ? self.dic_Data[@"transId"]:@"";
}
-(void)createViews{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(save:)];

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
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _View_TravelDate = [[UIView alloc]init];
    _View_TravelDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TravelDate];
    [_View_TravelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelTime = [[UIView alloc]init];
    _View_TravelTime.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TravelTime];
    [_View_TravelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FromCity = [[UIView alloc]init];
    _View_FromCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_FromCity];
    [_View_FromCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelTime.bottom);
        make.left.right.equalTo(self.contentView);
    }];


    _View_ToCity = [[UIView alloc]init];
    _View_ToCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_ToCity];
    [_View_ToCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_HotelStd = [[UIView alloc]init];
    _View_HotelStd.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_HotelStd];
    [_View_HotelStd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_TransName = [[UIView alloc]init];
    _View_TransName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TransName];
    [_View_TransName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HotelStd.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelContent = [[UIView alloc]init];
    _View_TravelContent.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TravelContent];
    [_View_TravelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TransName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}
-(void)updateMainView{
    for (MyProcurementModel *model in self.arr_ShowArray) {
        if (self.index) {
            NSMutableString *fieldName = [NSMutableString stringWithFormat:@"%@",model.fieldName];
            NSString *head = [[fieldName substringToIndex:1] lowercaseString];
            [fieldName replaceCharactersInRange:NSMakeRange(0, 1) withString:head];
            model.fieldValue = [NSString stringWithIdOnNO:self.dic_Data[fieldName]];
        }else{
            model.fieldValue = @"";
        }
        if ([model.fieldName isEqualToString:@"TravelDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTravelDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"TravelTime"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTravelTimeView:model];
            }
        }else if ([model.fieldName isEqualToString:@"FromCity"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateFromCityViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ToCity"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateToCityViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"HotelStd"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateHotelStdViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"TransName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTransNameView:model];
            }
        }else if ([model.fieldName isEqualToString:@"TravelContent"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTravelContentView:model];
            }
        }
    }
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_TravelContent).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:更新日期
-(void)updateTravelDateViewWithModel:(MyProcurementModel *)model{
    _txf_TravelDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TravelDate WithContent:_txf_TravelDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TravelDate addSubview:view];
}
//MARK:更新时间
-(void)updateTravelTimeView:(MyProcurementModel *)model{
    _txf_TravelTime = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TravelTime WithContent:_txf_TravelTime WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[self.arr_time[[self.str_TravelTime integerValue]] valueForKey:@"Type"]}];
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        __weak typeof(self) weakSelf = self;
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_TravelTime = Model.Id;
            weakSelf.txf_TravelTime.text = Model.Type;
        }];
        picker.typeTitle=Custing(@"时间", nil);
        picker.DateSourceArray = self.arr_time;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id = self.str_TravelTime;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    [_View_TravelTime addSubview:view];
}
//MARK:更新出发地
-(void)updateFromCityViewWithModel:(MyProcurementModel *)model{
    _txf_FromCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromCity WithContent:_txf_FromCity WithFormType:formViewSelect  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf FromCityClick];
    }];
    [_View_FromCity addSubview:view];

}
//MARK:更新目的地
-(void)updateToCityViewWithModel:(MyProcurementModel *)model{
    _txf_ToCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ToCity WithContent:_txf_ToCity WithFormType:formViewSelect  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf ToCityClick];
    }];
    [_View_ToCity addSubview:view];
}
//MARK:更新住宿标准
-(void)updateHotelStdViewWithModel:(MyProcurementModel *)model{
    _txf_HotelStd = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_HotelStd WithContent:_txf_HotelStd WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_HotelStd addSubview:view];
}
//MARK:更新交通工具
-(void)updateTransNameView:(MyProcurementModel *)model{
    _txf_TransName = [[UITextField alloc]init];
    
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TransName WithContent:_txf_TransName WithFormType:[model.ctrlTyp isEqualToString:@"text"] ? formViewEnterText:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.isMultiSelect = [model.ctrlTyp isEqualToString:@"multi"];
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            NSMutableArray *arrayName = [NSMutableArray array];
            NSMutableArray *arrayId = [NSMutableArray array];
            for (ChooseCateFreModel *model in array) {
                [arrayName addObject:model.name];
                [arrayId addObject:model.Id];
            }
            weakSelf.txf_TransName.text = [GPUtils getSelectResultWithArray:arrayName WithCompare:@","];
            weakSelf.str_TransId = [GPUtils getSelectResultWithArray:arrayId WithCompare:@","];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_TransName addSubview:view];
}
//MARK:更新内容
-(void)updateTravelContentView:(MyProcurementModel *)model{
    _txv_TravelContent = [[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TravelContent WithContent:_txv_TravelContent WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_TravelContent addSubview:view];
}

//MARK:出发地选择
-(void)FromCityClick{
    NewAddressViewController * address = [[NewAddressViewController alloc]init];
    address.status = @"2";
    address.Type = 1;
    address.isGocity = @"2";
    address.OnlyInternal = NO;
    __weak typeof(self) weakSelf = self;
    [address setSelectAddressBlock:^(NSArray *array, NSString *start) {
        NSDictionary *dict = array[0];
        weakSelf.str_FromCityCode = [NSString stringWithIdOnNO:dict[@"cityCode"]];
        weakSelf.txf_FromCity.text = [weakSelf.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dict[@"cityName"]]:[NSString stringWithIdOnNO:dict[@"cityNameEn"]];
    }];
    [self.navigationController pushViewController:address animated:YES];

}
//MARK:目的地选择
-(void)ToCityClick{
    NewAddressViewController * address = [[NewAddressViewController alloc]init];
    address.status = @"2";
    address.Type = 1;
    address.isGocity = @"2";
    address.OnlyInternal = NO;
    __weak typeof(self) weakSelf = self;
    [address setSelectAddressBlock:^(NSArray *array, NSString *start) {
        NSDictionary *dict = array[0];
        weakSelf.str_ToCityCode = [NSString stringWithIdOnNO:dict[@"cityCode"]];
        weakSelf.str_ToCityType = [NSString stringWithIdOnNO:dict[@"cityType"]];
        weakSelf.txf_ToCity.text = [weakSelf.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dict[@"cityName"]]:[NSString stringWithIdOnNO:dict[@"cityNameEn"]];
        [weakSelf getHotelStd];
    }];
    [self.navigationController pushViewController:address animated:YES];
}
//MARK:请求住宿标准
-(void)getHotelStd{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"Tag":@"Hotel",
                                 @"CityType":self.str_ToCityType,
                                 @"CityCode":self.str_ToCityCode,
                                 @"CheckInDate":self.txf_TravelDate.text,
                                 @"UserId":self.userId
                                 };
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = responceDic[@"result"];
                if ([result[@"basis"] floatValue] == 1||[result[@"basis"] floatValue] == 3) {
                    self.txf_HotelStd.text = [NSString stringWithIdOnNO:result[@"amount"]];
                }else{
                    if ([result[@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                        NSString *standard=nil;
                        NSDictionary *stdOutput = result[@"stdOutput"];
                        NSString *amount = [NSString stringWithIdOnNO:stdOutput[@"amount"]];
                        NSString *currencyCode = [NSString stringWithIdOnNO:stdOutput[@"currencyCode"]];
                        NSString *exchangeRate = [NSString stringWithIdOnNO:stdOutput[@"exchangeRate"]];
                        if (![NSString isEqualToNull:currencyCode]) {
                            standard = amount;
                        }else{
                            standard = [GPUtils decimalNumberMultipWithString:amount with:exchangeRate];
                        }
                        self.txf_HotelStd.text = [GPUtils getRoundingOffNumber:standard afterPoint:2];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}


//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//MARK:保存
-(void)save:(id)sender{
    NSDictionary *dict = @{@"travelDate":self.txf_TravelDate.text,
                           @"travelTime":self.View_TravelTime.zl_height > 0 ? self.str_TravelTime:@"3",
                           @"fromCityCode":self.str_FromCityCode,
                           @"fromCity":self.txf_FromCity.text,
                           @"toCityCode":self.str_ToCityCode,
                           @"toCity":self.txf_ToCity.text,
                           @"hotelStd":self.txf_HotelStd.text,
                           @"transId":self.str_TransId,
                           @"transName":self.txf_TransName.text,
                           @"travelContent":self.txv_TravelContent.text
                           };
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isShow = 1 && isRequired = 1"];
    NSArray *filterArray = [self.arr_ShowArray filteredArrayUsingPredicate:pred];
    for (MyProcurementModel *model in filterArray) {
        NSMutableString *fieldName = [NSMutableString stringWithFormat:@"%@",model.fieldName];
        NSString *head = [[fieldName substringToIndex:1] lowercaseString];
        [fieldName replaceCharactersInRange:NSMakeRange(0, 1) withString:head];
        if (![NSString isEqualToNull:[dict valueForKey:fieldName]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:model.tips duration:2.0];
            return;
        }
    }
    
    if (self.addTravelRouteBlock) {
        self.addTravelRouteBlock(self.index, dict);
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
