//
//  NewBusinessPlanViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NewBusinessPlanViewController.h"
#import "NewAddressViewController.h"
#define NUMBERS @"0123456789\n"
@interface NewBusinessPlanViewController ()<UIScrollViewDelegate,UITextViewDelegate,NewAddressVCDelegate>

@property (nonatomic, strong) UIScrollView *scr_rootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *contentView; //滚动视图contentView

@property (nonatomic, strong) UIView *view_1;
@property (nonatomic, strong) UIView *view_flType;
@property (nonatomic, strong) UIView *view_2;
@property (nonatomic, strong) UIView *view_3;
@property (nonatomic, strong) UIView *view_4;
@property (nonatomic, strong) UIView *view_5;
@property (nonatomic, strong) UITextField *txf_text1;
@property (nonatomic, strong) UITextField *txf_flType;
@property (nonatomic, strong) UITextField *txf_text2;
@property (nonatomic, strong) UITextField *txf_text3;
@property (nonatomic, strong) UITextField *txf_text4;
@property (nonatomic, strong) UITextView *txv_textView;

@property (nonatomic, strong) NSString *str_id2;
@property (nonatomic, strong) NSString *str_id3;

@property (nonatomic, strong) NSString *str_fromcityType;
@property (nonatomic, strong) NSString *str_tocityType;
@property (nonatomic, strong) NSString *str_IsInternational;


@property (nonatomic, strong) NSArray *arr_city2;
@property (nonatomic, strong) NSArray *arr_city3;

@property (nonatomic, strong) NSMutableArray *arr_People;

@property (nonatomic, strong) TravelFlightDetailModel *model_flight;
@property (nonatomic, strong) TravelHotelDetailModel *model_hotel;
@property (nonatomic, strong) TravelTrainDetailModel *model_train;

@property (nonatomic, strong) NSMutableArray *flightTArr;

@end

@implementation NewBusinessPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _str_id2 = @"";
    _str_id3 = @"";
    _arr_city2 = [NSArray array];
    _arr_city3 = [NSArray array];
    _arr_People = [NSMutableArray array];
    [self updateMainView];
    [self updateShowData];
}

-(void)updateMainView{
    //设置确定按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right_click:)];
    
    UIScrollView *scrollView = UIScrollView.new;
    _scr_rootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [_scr_rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _contentView =[[BottomView alloc]init];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [_scr_rootScrollView addSubview:_contentView];
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_rootScrollView);
        make.width.equalTo(self.scr_rootScrollView);
    }];
    
    
    _view_1=[[UIView alloc]init];
    _view_1.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_1];
    [_view_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    //isInternational    机票类型/酒店类型
    _view_flType=[[UIView alloc]init];
       _view_flType.backgroundColor=Color_WhiteWeak_Same_20;
       [_contentView addSubview:_view_flType];
       [_view_flType mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view_1.bottom);
           make.left.right.equalTo(self.contentView);
       }];
    
    _view_2=[[UIView alloc]init];
    _view_2.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_2];
    [_view_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_flType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_3=[[UIView alloc]init];
    _view_3.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_3];
    [_view_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_4=[[UIView alloc]init];
    _view_4.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_4];
    [_view_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_5=[[UIView alloc]init];
    _view_5.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_5];
    [_view_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_4.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    if (_Type == 1) {
        [self setTitle:Custing(@"添加机票需求单", nil) backButton:YES];
        [self updateFlightFormFieldsView];
    }else if (_Type == 2) {
        [self setTitle:Custing(@"添加住宿需求单", nil) backButton:YES];
        [self updateHotelFormFieldsView];
    }else if (_Type == 3) {
        [self setTitle:Custing(@"添加火车票需求单", nil) backButton:YES];
        [self updateTrainFormFieldsView];
    }
    [self updateBottenView];
}

-(void)updateBottenView{
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_5.bottom);
    }];
}

-(void)updateFlightFormFieldsView{
    for (int i = 0; i<_arr_Main.count; i++) {
        MyProcurementModel *model = _arr_Main[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"DepartureDate"]) {
                model.ctrlTyp = @"date";
                [self update_txf1:model ByType:0];
            }
            if ([model.fieldName isEqualToString:@"FromCityCode"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf2:model ByType:1];
            }
            if ([model.fieldName isEqualToString:@"ToCityCode"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf3:model ByType:1];
            }
            if ([model.fieldName isEqualToString:@"FlyPeopleId"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf4:model ByType:2];
            }
            if ([model.fieldName isEqualToString:@"Remark"]) {
                [self update_txv:model];
            }
            if ([model.fieldName isEqualToString:@"IsInternational"]) {
                model.ctrlTyp = @"dialog";
                [self update_txfFlType:model ByType:1];
            }
        }
    }
}

-(void)updateHotelFormFieldsView{
    for (int i = 0; i<_arr_Main.count; i++) {
        MyProcurementModel *model = _arr_Main[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"CheckInCity"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf1:model ByType:1];
            }
            if ([model.fieldName isEqualToString:@"CheckInDate"]) {
                model.ctrlTyp = @"date";
                [self update_txf2:model ByType:0];
            }
            if ([model.fieldName isEqualToString:@"CheckOutDate"]) {
                model.ctrlTyp = @"date";
                [self update_txf3:model ByType:0];
            }
            if ([model.fieldName isEqualToString:@"NumberOfRooms"]) {
                model.ctrlTyp = @"text";
                [self update_txf4:model ByType:0];
                _txf_text4.keyboardType = UIKeyboardTypeNumberPad;
                _txf_text4.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^BOOL(UITextField *txf, NSRange range, NSString *string) {
                    NSCharacterSet *cs;
                    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
                    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                    BOOL basicTest = [string isEqualToString:filtered];
                    if(!basicTest)
                    {
                        return NO;
                    }
                    //其他的类型不需要检测，直接写入
                    return YES;
                };
            }
            if ([model.fieldName isEqualToString:@"Remark"]) {
                [self update_txv:model];
            }
            if ([model.fieldName isEqualToString:@"IsInternational"]) {
                model.ctrlTyp = @"dialog";
                [self update_txfFlType:model ByType:1];
            }
        }
    }
}

-(void)updateTrainFormFieldsView{
    for (int i = 0; i<_arr_Main.count; i++) {
        MyProcurementModel *model = _arr_Main[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"DepartureDate"]) {
                model.ctrlTyp = @"date";
                [self update_txf1:model ByType:0];
            }
            if ([model.fieldName isEqualToString:@"FromCityCode"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf2:model ByType:1];
            }
            if ([model.fieldName isEqualToString:@"ToCityCode"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf3:model ByType:0];
            }
            if ([model.fieldName isEqualToString:@"PassengerId"]) {
                model.ctrlTyp = @"dialog";
                [self update_txf4:model ByType:3];
            }
            if ([model.fieldName isEqualToString:@"Remark"]) {
                [self update_txv:model];
            }
        }
    }
}

//type 1 跳转城市 2 跳转联系人 3 联系人多选
-(void)update_txf1:(MyProcurementModel *)model ByType:(NSInteger)type{
    [_view_1 updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_1 addSubview:[self createLineView]];
    
    _txf_text1 = [[UITextField alloc]init];
    __weak NewBusinessPlanViewController *weakSelf = self;
    [_view_1 addSubview:[[ReservedView alloc]init:_txf_text1 model:model titleWidthNoChangeContent:80 block:^(MyProcurementModel *model, UITextField *contextFiled) {
        [weakSelf btn_Click:weakSelf.txf_text1];
    } ]];
}

- (void)update_txfFlType:(MyProcurementModel *)model ByType:(NSInteger)type{
    [_view_flType updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_flType addSubview:[self createLineView]];
    _txf_flType = [[UITextField alloc] init];
    __weak NewBusinessPlanViewController *weakSelf = self;
    [_view_flType addSubview:[[ReservedView alloc] init:_txf_flType model:model titleWidthNoChangeContent:80 block:^(MyProcurementModel *model, UITextField *contextFiled) {
        [weakSelf btn_Click:weakSelf.txf_flType];
    } ]];
}

-(void)update_txf2:(MyProcurementModel *)model ByType:(NSInteger)type{
    [_view_2 updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_2 addSubview:[self createLineView]];
    
    _txf_text2 = [[UITextField alloc]init];
    __weak typeof(self) weakSelf = self;
    [_view_2 addSubview:[[ReservedView alloc]init:_txf_text2 model:model titleWidthNoChangeContent:80 block:^(MyProcurementModel *model, UITextField *contextFiled) {
        [weakSelf btn_Click:weakSelf.txf_text2];
    } ]];
}

-(void)update_txf3:(MyProcurementModel *)model ByType:(NSInteger)type{
    [_view_3 updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_3 addSubview:[self createLineView]];
    
    _txf_text3 = [[UITextField alloc]init];
    __weak NewBusinessPlanViewController *weakSelf = self;
    [_view_3 addSubview:[[ReservedView alloc]init:_txf_text3 model:model titleWidthNoChangeContent:80 block:^(MyProcurementModel *model, UITextField *contextFiled) {
        [weakSelf btn_Click:weakSelf.txf_text3];
    } ]];
}

-(void)update_txf4:(MyProcurementModel *)model ByType:(NSInteger)type{
    [_view_4 updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_4 addSubview:[self createLineView]];
    
    _txf_text4 = [[UITextField alloc]init];
    __weak NewBusinessPlanViewController *weakSelf = self;
    [_view_4 addSubview:[[ReservedView alloc]init:_txf_text4 model:model titleWidthNoChangeContent:80 block:^(MyProcurementModel *model, UITextField *contextFiled) {
        [weakSelf btn_Click:weakSelf.txf_text4];
    } ]];
}

-(void)update_txv:(MyProcurementModel *)model{
    _txv_textView=[[UITextView alloc]init];
    
    if (_Type == 1) {
        if (_model_Show_flight!=nil) {
            model.fieldValue = _model_Show_flight.remark;
        }
    }
    if (_Type == 2) {
        if (_model_Show_hotel!=nil) {
            model.fieldValue = _model_Show_hotel.remark;
        }
    }
    if (_Type == 3) {
        if (_model_Show_train!=nil) {
            model.fieldValue = _model_Show_train.remark;
        }
    }
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_5 WithContent:_txv_textView WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_view_5 addSubview:view];
}

-(void)updateShowData{
    if (_Type == 1) {
        if (_model_Show_flight != nil) {
            _txf_text1.text = _model_Show_flight.departuredate;
            _txf_text2.text = _model_Show_flight.fromcity;
            _str_id2 = _model_Show_flight.fromcitycode;
            _str_fromcityType = [NSString isEqualToNullAndZero:_model_Show_flight.fromcitytype] ? _model_Show_flight.fromcitytype:@"1";
            _txf_text3.text = _model_Show_flight.tocity;
            _str_id3 = _model_Show_flight.tocitycode;
            _str_tocityType = [NSString isEqualToNullAndZero:_model_Show_flight.tocitytype] ? _model_Show_flight.tocitytype:@"1";
            _txf_text4.text = _model_Show_flight.flypeople;
            _txv_textView.text = [NSString stringWithIdOnNO:_model_Show_flight.remark];
            if ([NSString isEqualToNull:_model_Show_flight.isInternational]) {
                _txf_flType.text = [[NSString stringWithFormat:@"%@",_model_Show_flight.isInternational] isEqualToString:@"0"]?Custing(@"国内", nil):Custing(@"国际", nil);
            }
        }
    }else if (_Type == 2) {
        if (_model_Show_hotel != nil) {
            _txf_text1.text = _model_Show_hotel.checkincity;
            _txf_text2.text = _model_Show_hotel.checkindate;
            _str_id2 = _model_Show_hotel.checkincitycode;
            _str_fromcityType = [NSString isEqualToNullAndZero:_model_Show_hotel.citytype] ? _model_Show_hotel.citytype:@"1";
            _txf_text3.text = _model_Show_hotel.checkoutdate;
            _txf_text4.text = [NSString stringWithIdOnNO:_model_Show_hotel.numberofrooms];
            _txv_textView.text = [NSString stringWithIdOnNO:_model_Show_hotel.remark];
            if ([NSString isEqualToNull:_model_Show_hotel.isInternational]) {
                _txf_flType.text = [[NSString stringWithFormat:@"%@",_model_Show_hotel.isInternational] isEqualToString:@"0"]?Custing(@"国内", nil):Custing(@"国际", nil);
            }
        }
    }else if (_Type == 3) {
        if (_model_Show_train != nil) {
            _txf_text1.text = _model_Show_train.departuredate;
            _txf_text2.text = _model_Show_train.fromcity;
            _str_id2 = _model_Show_train.fromcitycode;
            _str_fromcityType = [NSString isEqualToNullAndZero:_model_Show_train.fromcitytype] ? _model_Show_train.fromcitytype:@"1";
            _txf_text3.text = _model_Show_train.tocity;
            _str_id3 = _model_Show_train.tocitycode;
            _str_tocityType = [NSString isEqualToNullAndZero:_model_Show_train.tocitytype] ? _model_Show_train.tocitytype:@"1";
            _txf_text4.text = _model_Show_train.passenger;
            _txv_textView.text = [NSString stringWithIdOnNO:_model_Show_train.remark];
        }
    }
}

-(BOOL)testRequestData{
    for (int i = 0; i<_arr_Main.count; i++) {
        MyProcurementModel *model = _arr_Main[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.isRequired] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"DepartureDate"]||[model.fieldName isEqualToString:@"CheckInCity"]) {
                if (![NSString isEqualToNull:_txf_text1.text]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]];
                    return NO;
                }
            }
            if ([model.fieldName isEqualToString:@"IsInternational"]) {
                if (![NSString isEqualToNull:self.str_IsInternational]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                }
            }
            if ([model.fieldName isEqualToString:@"FromCityCode"]||[model.fieldName isEqualToString:@"CheckInDate"]) {
                if (![NSString isEqualToNull:_txf_text2.text]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                    return NO;
                }
            }
            if ([model.fieldName isEqualToString:@"ToCityCode"]||[model.fieldName isEqualToString:@"CheckOutDate"]) {
                if (![NSString isEqualToNull:_txf_text3.text]) {
                    if ([model.fieldName isEqualToString:@"ToCityCode"]) {
                        [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description]];
                        return NO;
                    }else{
                        [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]];
                        return NO;
                    }
                }
            }
            if ([model.fieldName isEqualToString:@"FlyPeopleId"]||[model.fieldName isEqualToString:@"NumberOfRooms"]||[model.fieldName isEqualToString:@"PassengerId"]) {
                if (![NSString isEqualToNull:_txf_text4.text]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]];
                    return NO;
                }
            }
            if ([model.fieldName isEqualToString:@"Remark"]) {
                if (![NSString isEqualToNull:_txv_textView.text]) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description]];
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (NSMutableArray *)flightTArr{
    if (_flightTArr == nil) {
        _flightTArr = [NSMutableArray array];
        NSArray *typeArr = @[Custing(@"国内", nil),Custing(@"国际", nil)];
        NSArray *idArr = @[@"0",@"1"];
        for (int i = 0 ; i < idArr.count; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc] init];
            model.Id = idArr[i];
            model.Type = typeArr[i];
            [_flightTArr addObject:model];
        }
    }
    return _flightTArr;
}

#pragma mark - action

-(void)btn_Click:(UITextField *)txf{
    if (txf == _txf_text1) {
        if (_Type == 2) {
            NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
            addVc.Type=1;
            addVc.isGocity = @"1";
            addVc.arr_Click_Citys = _arr_city2;
            addVc.status = @"21";
            addVc.delegate=self;
            [self.navigationController pushViewController:addVc animated:YES];
        }
    }else if (txf == _txf_flType){
        if (_Type == 1||_Type == 2) {
            STOnePickView *picker = [[STOnePickView alloc] init];
            picker.DateSourceArray = self.flightTArr;
            __weak typeof(self) weakSelf = self;
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakSelf.txf_flType.text = Model.Type;
                weakSelf.str_IsInternational = Model.Id;
            }];
            [picker UpdatePickUI];
            if (_Type == 1) {
                picker.typeTitle = Custing(@"机票类型", nil);
            }else{
              picker.typeTitle = Custing(@"酒店类型", nil);
            }
            
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }
    }else if (txf == _txf_text2) {
        if (_Type == 1) {
            NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
            addVc.Type=1;
            addVc.isGocity = @"1";
            addVc.arr_Click_Citys = _arr_city2;
            addVc.status = @"12";
            addVc.delegate=self;
            addVc.isXiecheng = YES;
//            addVc.OnlyInternal = [NSString isEqualToNull:_str_isRelateTravelForm]?[_str_isRelateTravelForm integerValue]==1?YES:NO:NO;
            [self.navigationController pushViewController:addVc animated:YES];
        }
        if (_Type == 3) {
            NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
            addVc.Type=1;
            addVc.isGocity = @"1";
            addVc.arr_Click_Citys = _arr_city2;
            addVc.status = @"32";
            addVc.delegate=self;
            addVc.OnlyInternal = YES;
            [self.navigationController pushViewController:addVc animated:YES];
        }
    }else if (txf == _txf_text3) {
        if (_Type == 1) {
            NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
            addVc.Type=1;
            addVc.isGocity = @"1";
            addVc.arr_Click_Citys = _arr_city3;
            addVc.status = @"13";
            addVc.delegate=self;
            addVc.isXiecheng = YES;
//            addVc.OnlyInternal = [NSString isEqualToNull:_str_isRelateTravelForm]?[_str_isRelateTravelForm integerValue]==1?YES:NO:NO;
            [self.navigationController pushViewController:addVc animated:YES];
        }
        if (_Type == 3) {
            NewAddressViewController *addVc=[[NewAddressViewController alloc]init];
            addVc.Type=1;
            addVc.isGocity = @"1";
            addVc.arr_Click_Citys = _arr_city3;
            addVc.status = @"33";
            addVc.delegate=self;
            addVc.OnlyInternal = YES;
            [self.navigationController pushViewController:addVc animated:YES];
        }
    }else if (txf == _txf_text4) {
        __weak typeof(self) weakSelf = self;
        if (_Type == 1) {
            contactsVController *contactVC=[[contactsVController alloc]init];
            contactVC.status = @"3";
            contactVC.arrClickPeople = _arr_People;
            contactVC.menutype = 2;
            contactVC.itemType = 99;
            contactVC.Radio = @"2";
            [contactVC setBlock:^(NSMutableArray *array) {
                weakSelf.arr_People = [[NSMutableArray alloc]init];
                NSMutableArray *nameArr = [NSMutableArray array];
                NSMutableArray *idArr = [NSMutableArray array];
                if (array.count>0) {
                    for (buildCellInfo *info in array) {
                        if ([NSString isEqualToNull:info.requestor]) {
                            [nameArr addObject:[NSString stringWithFormat:@"%@",info.requestor]];
                        }
                        if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]]) {
                            [idArr addObject:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];
                        }
                        NSDictionary *dic = @{@"requestorUserId":[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]};
                        [weakSelf.arr_People addObject:dic];
                    }
                }
                weakSelf.txf_text4.text = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
        }
        if (_Type == 3) {
            contactsVController *contactVC=[[contactsVController alloc]init];
            contactVC.status = @"3";
            contactVC.arrClickPeople = _arr_People;
            contactVC.menutype=2;
            contactVC.itemType = 99;
            contactVC.Radio = @"2";
            [contactVC setBlock:^(NSMutableArray *array) {
                weakSelf.arr_People = [[NSMutableArray alloc]init];
                NSMutableArray *nameArr = [NSMutableArray array];
                NSMutableArray *idArr = [NSMutableArray array];
                if (array.count>0) {
                    for (buildCellInfo *bul in array) {
                        NSDictionary *dic = @{@"requestorUserId":[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]};
                        if ([NSString isEqualToNull:bul.requestor]) {
                            [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                        }
                        if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]) {
                            [idArr addObject:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
                        }
                        [weakSelf.arr_People addObject:dic];
                    }
                }
                weakSelf.txf_text4.text = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
        }
    }
}

-(void)btn_right_click:(UIButton *)btn{
    if ([self testRequestData]) {
        if (_Type == 1) {
            _model_flight = [[TravelFlightDetailModel alloc]init];
            _model_flight.departuredate = [NSString isEqualToNull:_txf_text1.text]?_txf_text1.text:@"";
            _model_flight.fromcity = [NSString isEqualToNull:_txf_text2.text]?_txf_text2.text:@"";
            _model_flight.fromcitycode = _str_id2;
            _model_flight.fromcitytype = _str_fromcityType;
            _model_flight.tocity = [NSString isEqualToNull:_txf_text3.text]?_txf_text3.text:@"";
            _model_flight.tocitycode = _str_id3;
            _model_flight.tocitytype = _str_tocityType;
            _model_flight.flypeople = [NSString isEqualToNull:_txf_text4.text]?_txf_text4.text:@"";
            _model_flight.remark = [NSString isEqualToNull:_txv_textView.text]?_txv_textView.text:@"";
            _model_flight.isInternational = [NSString isEqualToNull:_str_IsInternational]?_str_IsInternational:@"";
            if (_model_Show_flight!=nil) {
                _model_flight.indexid = _model_Show_flight.indexid;
            }
            [self.delegate NewBusinessPlanViewController_btnClick_Delegate:@[_model_flight] Type:_Type];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (_Type == 2) {
            _model_hotel = [[TravelHotelDetailModel alloc]init];
            _model_hotel.checkindate = [NSString isEqualToNull:_txf_text2.text]?_txf_text2.text:@"";
            _model_hotel.checkincity = [NSString isEqualToNull:_txf_text1.text]?_txf_text1.text:@"";
            _model_hotel.checkincitycode = _str_id2;
            _model_hotel.citytype = _str_fromcityType;
            _model_hotel.checkoutdate = [NSString isEqualToNull:_txf_text3.text]?_txf_text3.text:@"";
            _model_hotel.numberofrooms = [NSString isEqualToNull:_txf_text4.text]?_txf_text4.text:@"";
            _model_hotel.remark = [NSString isEqualToNull:_txv_textView.text]?_txv_textView.text:@"";
            _model_hotel.isInternational = [NSString isEqualToNull:_str_IsInternational]?_str_IsInternational:@"";
            if (_model_Show_hotel != nil) {
                _model_hotel.indexid = _model_Show_hotel.indexid;
            }
            [self.delegate NewBusinessPlanViewController_btnClick_Delegate:@[_model_hotel] Type:_Type];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (_Type == 3) {
            _model_train = [[TravelTrainDetailModel alloc]init];
            _model_train.departuredate = [NSString isEqualToNull:_txf_text1.text]?_txf_text1.text:@"";
            _model_train.fromcity = [NSString isEqualToNull:_txf_text2.text]?_txf_text2.text:@"";
            _model_train.fromcitycode = _str_id2;
            _model_train.fromcitytype = _str_fromcityType;
            _model_train.tocity = [NSString isEqualToNull:_txf_text3.text]?_txf_text3.text:@"";
            _model_train.tocitycode = _str_id3;
            _model_train.tocitytype = _str_tocityType;
            _model_train.passenger = [NSString isEqualToNull:_txf_text4.text]?_txf_text4.text:@"";
            _model_train.remark = [NSString isEqualToNull:_txv_textView.text]?_txv_textView.text:@"";
            if (_model_Show_train != nil) {
                _model_train.indexid = _model_Show_train.indexid;
            }
            [self.delegate NewBusinessPlanViewController_btnClick_Delegate:@[_model_train] Type:_Type];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}

#pragma mark - delegate
-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start{
    NSInteger int_state = [start integerValue];
    NSDictionary *dic = array[0];
    if (int_state>10&&int_state<20) {
        if (int_state == 12) {
            _arr_city2 = array;
            _txf_text2.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            _str_id2 = dic[@"cityCode"];
            _str_fromcityType = [NSString isEqualToNullAndZero:dic[@"cityType"]] ? [NSString stringWithFormat:@"%@",dic[@"cityType"]]:@"1";
        }else if (int_state == 13) {
            _arr_city3 = array;
            _txf_text3.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            _str_id3 = dic[@"cityCode"];
            _str_tocityType = [NSString isEqualToNullAndZero:dic[@"cityType"]] ? [NSString stringWithFormat:@"%@",dic[@"cityType"]]:@"1";
        }
    }else if (int_state>20&&int_state<30) {
        if (int_state == 21) {
            _arr_city2 = array;
            _txf_text1.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            _str_id2 = dic[@"cityCode"];
            _str_fromcityType = [NSString isEqualToNullAndZero:dic[@"cityType"]] ? [NSString stringWithFormat:@"%@",dic[@"cityType"]]:@"1";
        }
    }else if (int_state>30) {
        if (int_state == 32) {
            _arr_city2 = array;
            _txf_text2.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            _str_id2 = dic[@"cityCode"];
            _str_fromcityType = [NSString isEqualToNullAndZero:dic[@"cityType"]] ? [NSString stringWithFormat:@"%@",dic[@"cityType"]]:@"1";

        }else if (int_state == 33) {
            _arr_city3 = array;
            _txf_text3.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            _str_id3 = dic[@"cityCode"];
            _str_tocityType = [NSString isEqualToNullAndZero:dic[@"cityType"]] ? [NSString stringWithFormat:@"%@",dic[@"cityType"]]:@"1";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
