//
//  AttendanceAddViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/17.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceAddViewController.h"
#import "ComPeopleViewController.h"
#import "AttendanceAddressListViewController.h"
#import "AttendanceSelectWeekViewController.h"
#import "AttendanceRangeViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface AttendanceAddViewController ()<GPClientDelegate,UIScrollViewDelegate,ComPeopleViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scr_RootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *view_ContentView; //滚动视图contentView
@property (nonatomic, strong) WorkFormFieldsModel *model_Name;//考勤名称
@property (nonatomic, strong) WorkFormFieldsModel *model_SelectScope;//选择范围
@property (nonatomic, strong) WorkFormFieldsModel *model_AttendanceObject;//考勤部门
@property (nonatomic, strong) WorkFormFieldsModel *model_Role;//考勤角色
@property (nonatomic, strong) WorkFormFieldsModel *model_SignDate;//考勤日期
@property (nonatomic, strong) NSMutableArray *muarr_SignDate;
@property (nonatomic, strong) WorkFormFieldsModel *model_FromTime;//考勤时间
@property (nonatomic, strong) WorkFormFieldsModel *model_Type;//考勤周期
@property (nonatomic, strong) WorkFormFieldsModel *model_AttendanceAddrss;//考勤地点
@property (nonatomic, strong) WorkFormFieldsModel *model_SignScope;//考勤范围
@property (nonatomic, strong) UITextView *txv_AttendanceAddrss;
@property (nonatomic, strong) NSMutableArray *muarr_AttendanceAddrss;
@property (nonatomic, strong) NSMutableArray *arr_Type;
@property (nonatomic, strong) NSMutableArray *arr_TypeDate;
@property (nonatomic, strong) NSString *str_Submit;
@property (nonatomic, strong) DoneBtnView *dockView;//下部按钮底层视图

@property (nonatomic, strong) NSMutableArray *arr_Role;

@end

@implementation AttendanceAddViewController

-(NSMutableArray *)arr_Role{
    if (_arr_Role == nil) {
        _arr_Role = [NSMutableArray array];
        NSArray *type = @[Custing(@"参与部门", nil),Custing(@"参与角色", nil)];
        NSArray *code = @[@"0",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_Role addObject:model];
        }
    }
    return _arr_Role;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"添加考勤", nil) backButton:YES];
    [self initializeData];
    [self creationRootView];
    [self creationMainView];
    [self updateMainView];
}

#pragma mark - function
#pragma mark 数据处理
//初始化数据
-(void)initializeData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroup:) name:@"edit_group" object:nil];
    _model_Name = [[WorkFormFieldsModel alloc]initialize];
    _model_SelectScope = [[WorkFormFieldsModel alloc]initialize];
    _model_Role = [[WorkFormFieldsModel alloc]initialize];
    _model_AttendanceObject = [[WorkFormFieldsModel alloc]initialize];
    _model_SignDate = [[WorkFormFieldsModel alloc]initialize];
    _model_FromTime = [[WorkFormFieldsModel alloc]initialize];
    _model_Type = [[WorkFormFieldsModel alloc]initialize];
    _model_AttendanceAddrss = [[WorkFormFieldsModel alloc]initialize];
    _model_SignScope = [[WorkFormFieldsModel alloc]initialize];

    _muarr_SignDate = [NSMutableArray array];
    _muarr_AttendanceAddrss = [NSMutableArray array];
    _str_Submit = @"";
    NSArray *arrs = @[Custing(@"自然月", nil),Custing(@"自定义", nil)];
    _arr_Type = [NSMutableArray array];
    for (int i = 0; i<arrs.count; i++) {
        STOnePickModel *model = [[STOnePickModel alloc]init];
        model.Id = [NSString stringWithFormat:@"%d",i];
        model.Type = arrs[i];
        [_arr_Type addObject:model];
    }
    NSMutableArray *arrdate = [NSMutableArray array];
    for (int i = 0; i<31; i++) {
        [arrdate addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    _arr_TypeDate = [NSMutableArray array];
    for (int i = 0; i<arrdate.count; i++) {
        STOnePickModel *model = [[STOnePickModel alloc]init];
        model.Id = [NSString stringWithFormat:@"%d",i+1];
        model.Type = arrdate[i];
        [_arr_TypeDate addObject:model];
    }
    
    _model_SelectScope.Id = @"0";
    _model_SelectScope.Value = Custing(@"参与部门", nil);
    if (_dic!=nil) {
        _model_Name.Value = _dic[@"name"];
        NSDictionary *dic = _dic[@"attendanceObject"][0];
        if ([_dic[@"attendanceObject"][0] isKindOfClass:[NSDictionary class]]) {
            _model_SelectScope.Id = [[NSString stringWithFormat:@"%@",dic[@"objectType"]]isEqualToString:@"1"]?@"1":@"0";
            if ([_model_SelectScope.Id isEqualToString:@"1"]) {
                _model_SelectScope.Value = Custing(@"参与角色", nil);
                _model_Role.Value = [NSString stringWithIdOnNO:dic[@"objectName"]];
                _model_Role.Id = [NSString stringWithIdOnNO:dic[@"objectId"]];
                _model_AttendanceObject.Value = @"";
                _model_AttendanceObject.Id = @"";
            }else{
                _model_SelectScope.Value = Custing(@"参与部门", nil);
                _model_AttendanceObject.Value = [NSString stringWithIdOnNO:dic[@"objectName"]];
                _model_AttendanceObject.Id = [NSString stringWithIdOnNO:dic[@"objectId"]];
                _model_Role.Value = @"";
                _model_Role.Id = @"";
            }
        }
        _muarr_SignDate = [NSMutableArray arrayWithArray:[[NSString stringWithIdOnNO:_dic[@"signDate"]] componentsSeparatedByString:@","]];
        _model_SignDate.Value = [NSString setDateListReturnString:_muarr_SignDate];
        _model_FromTime.Id = _dic[@"fromTime"];
        _model_FromTime.Value = _dic[@"toTime"];
        if ([[NSString stringWithFormat:@"%@",_dic[@"type"]]isEqualToString:@"1"]) {
            _model_Type.Value = [NSString isEqualToNull:_dic[@"fromDate"]] ? [NSString stringWithFormat:@"%@",_dic[@"fromDate"]]:@"1";
            _model_Type.Id = @"1";
        }else{
            _model_Type.Value = @"1";
            _model_Type.Id = @"0";
        }
        NSMutableArray *address = _dic[@"attendanceAddrs"];
        for (NSDictionary *dicarr in address) {
            AMapAOI *ama = [[AMapAOI alloc]init];
            ama.name = dicarr[@"address"];
            AMapGeoPoint *point = [[AMapGeoPoint alloc]init];
            NSArray *arr_Add = [[NSString stringWithIdOnNO:dicarr[@"latitude"]]componentsSeparatedByString:@","];
            [point setLatitude:[arr_Add[0] floatValue]];
            [point setLongitude:[arr_Add[1] floatValue]];
            ama.location = point;
            [_muarr_AttendanceAddrss addObject:ama];
            if (![NSString isEqualToNull:_model_AttendanceAddrss.Value]) {
                _model_AttendanceAddrss.Value = ama.name;
            }else{
                _model_AttendanceAddrss.Value = [NSString stringWithFormat:@"%@\n%@",_model_AttendanceAddrss.Value,ama.name];
            }
        }
        _model_SignScope.Value = _dic[@"signScope"];
    }else{
        _model_Type.Value = @"1";
        _model_Type.Id = @"0";
    }
}

-(void)jointResponse{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addString:_model_Name.txf_TexfField.text forKey:@"Name"];
    [dic addString:_model_SignScope.Value forKey:@"SignScope"];
    NSString *str = @"";
    for (NSString *date in _muarr_SignDate) {
        if ([NSString isEqualToNull:str]) {
            str = [NSString stringWithFormat:@"%@,%ld",str,[date integerValue]];
        }else{
            str = [NSString stringWithId:date];
        }
    }
    [dic addString:str forKey:@"SignDate"];
    [dic addString:_model_Type.Value forKey:@"FromDate"];
    [dic addString:_model_Type.Id forKey:@"Type"];
    [dic addString:_model_FromTime.Id forKey:@"FromTime"];
    [dic addString:_model_FromTime.Value forKey:@"ToTime"];
    [dic addArray:@[@{@"ObjectType":self.model_SelectScope.Id,@"ObjectId":[self.model_SelectScope.Id isEqualToString:@"1"] ? self.model_Role.Id:self.model_AttendanceObject.Id,@"ObjectName":[self.model_SelectScope.Id isEqualToString:@"1"] ? self.model_Role.Value:_model_AttendanceObject.txf_TexfField.text}] forKey:@"AttendanceObject"];
    NSMutableArray *addrs = [NSMutableArray array];
    for (AMapPOI *amap in _muarr_AttendanceAddrss) {
        [addrs addObject:@{@"Address":amap.name,@"Latitude":[NSString stringWithFormat:@"%f,%f",amap.location.latitude,amap.location.longitude]}];
    }
    [dic addArray:addrs forKey:@"AttendanceAddrs"];
    if (_dic != nil) {
        [dic addString:_dic[@"id"] forKey:@"Id"];
    }
    _str_Submit = [NSString transformToJson:dic];
}

#pragma mark View
-(void)creationRootView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [_scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@50);
    }];
    
    self.view_ContentView =[[BottomView alloc]init];
    self.view_ContentView.userInteractionEnabled=YES;
    self.view_ContentView.backgroundColor=Color_White_Same_20;
    [_scr_RootScrollView addSubview:self.view_ContentView];
    
    [self.view_ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_RootScrollView);
        make.width.equalTo(self.scr_RootScrollView);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"保存", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf btn_click];
        }
    };
}

-(void)creationMainView{
    _model_Name.view_View = [[UIView alloc]init];
    _model_Name.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Name.view_View];
    [_model_Name.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_SelectScope.view_View = [[UIView alloc]init];
    _model_SelectScope.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_SelectScope.view_View];
    [_model_SelectScope.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Name.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_AttendanceObject.view_View = [[UIView alloc]init];
    _model_AttendanceObject.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_AttendanceObject.view_View];
    [_model_AttendanceObject.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_SelectScope.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Role.view_View = [[UIView alloc]init];
    _model_Role.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Role.view_View];
    [_model_Role.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_AttendanceObject.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
   
    _model_SignDate.view_View = [[UIView alloc]init];
    _model_SignDate.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_SignDate.view_View];
    [_model_SignDate.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Role.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_FromTime.view_View = [[UIView alloc]init];
    _model_FromTime.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_FromTime.view_View];
    [_model_FromTime.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_SignDate.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Type.view_View = [[UIView alloc]init];
    _model_Type.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Type.view_View];
    [_model_Type.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_FromTime.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_AttendanceAddrss.view_View = [[UIView alloc]init];
    _model_AttendanceAddrss.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_AttendanceAddrss.view_View];
    [_model_AttendanceAddrss.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Type.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_SignScope.view_View = [[UIView alloc]init];
    _model_SignScope.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_SignScope.view_View];
    [_model_SignScope.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_AttendanceAddrss.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
}

-(void)updateMainView{
    [self updateName];
    [self updateSelectScope];
    [self updateAttendanceObject];
    [self updateRole];
    [self updateSignDate];
    [self updateFromTime];
    [self updateType];
    [self updateAttendanceAddress];
    [self updateSignScope];
    [self updateContentView];
    [self updateEndDeptOrRole];
}

-(void)updateName{
    _model_Name.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Name.view_View WithContent:_model_Name.txf_TexfField WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"考勤组名称", nil) WithInfodict:nil WithTips:Custing(@"请输入考勤组名称", nil) WithNumLimit:200];
    [_model_Name.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_Name.Value]) {
        _model_Name.txf_TexfField.text = _model_Name.Value;
    }
}
-(void)updateSelectScope{
    _model_SelectScope.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_SelectScope.view_View WithContent:_model_SelectScope.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"选择范围", nil) WithInfodict:nil WithTips:Custing(@"请选择范围", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.model_SelectScope.Id = Model.Id;
            weakSelf.model_SelectScope.Value = Model.Type;
            weakSelf.model_SelectScope.txf_TexfField.text = Model.Type;
            [weakSelf updateEndDeptOrRole];
        }];
        picker.typeTitle=Custing(@"选择范围", nil);
        picker.DateSourceArray=weakSelf.arr_Role;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id = weakSelf.model_SelectScope.Id;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_model_SelectScope.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_SelectScope.Value]) {
        _model_SelectScope.txf_TexfField.text = _model_SelectScope.Value;
    }
}
//部门
-(void)updateAttendanceObject{
    _model_AttendanceObject.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_AttendanceObject.view_View WithContent:_model_AttendanceObject.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"参与部门", nil) WithInfodict:nil WithTips:Custing(@"请选择参与部门", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf getGroupId];
    }];
    [_model_AttendanceObject.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_FromTime.Id]) {
        _model_AttendanceObject.txf_TexfField.text = _model_AttendanceObject.Value;
    }
}
//角色
-(void)updateRole{
    _model_Role.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Role.view_View WithContent:_model_Role.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"参与角色", nil) WithInfodict:nil WithTips:Custing(@"请选择参与角色", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf selectRole];
    }];
    [_model_Role.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_Role.Id]) {
        _model_Role.txf_TexfField.text = _model_Role.Value;
    }
}

-(void)updateSignDate{
    _model_SignDate.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_SignDate.view_View WithContent:_model_SignDate.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"打卡日期", nil) WithInfodict:nil WithTips:Custing(@"请选择打卡日期", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        AttendanceSelectWeekViewController *att = [[AttendanceSelectWeekViewController alloc]init];
        att.muarr_return = weakSelf.muarr_SignDate;
        [att setBlock:^(NSMutableArray *arr, NSString *week) {
            weakSelf.model_SignDate.txf_TexfField.text = week;
            weakSelf.muarr_SignDate = arr;
        }];
        [weakSelf.navigationController pushViewController:att animated:YES];
    }];
    [_model_SignDate.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_SignDate.Value]) {
        _model_SignDate.txf_TexfField.text = _model_SignDate.Value;
    }else{
        _muarr_SignDate = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5"]];
        _model_SignDate.txf_TexfField.text = [NSString setDateListReturnString:_muarr_SignDate];
    }
}
//打卡时间
-(void)updateFromTime{
    _model_FromTime.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_FromTime.view_View WithContent:_model_FromTime.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"打卡时间", nil) WithInfodict:nil WithTips:Custing(@"请选择打卡时间", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    __block NSString *str_date = @"";
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"开始时间", nil) Type:3 Date:weakSelf.model_FromTime.Id];
        [view setSTblock:^(NSString *date) {
            str_date = date;
            STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"结束时间", nil) Type:3 Date:weakSelf.model_FromTime.Value];
            [view setSTblock:^(NSString *date) {
                NSTimeInterval secs = [[NSDate TimeFromString:str_date] timeIntervalSinceDate:[NSDate TimeFromString:date]];
                if (secs>0) {
                    [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"结束时间不能小于开始时间", nil) duration:1.5];
                }else{
                    weakSelf.model_FromTime.txf_TexfField.text = [NSString stringWithFormat:@"%@-%@",str_date,date];
                    weakSelf.model_FromTime.Id = str_date;
                    weakSelf.model_FromTime.Value = date;
                }
            }];
            [view show];
        }];
        [view show];
    }];
    [_model_FromTime.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_FromTime.Id]) {
        _model_FromTime.txf_TexfField.text = [NSString stringWithFormat:@"%@-%@",_model_FromTime.Id,_model_FromTime.Value];
    }else{
        _model_FromTime.Id = @"09:00";
        _model_FromTime.Value = @"18:00";
        _model_FromTime.txf_TexfField.text = [NSString stringWithFormat:@"%@-%@",_model_FromTime.Id,_model_FromTime.Value];
    }
}
//考勤周期
-(void)updateType{
    _model_Type.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Type.view_View WithContent:_model_Type.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"考勤周期", nil) WithInfodict:nil WithTips:Custing(@"请选择考勤周期", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.model_Type.txf_TexfField.text = Model.Type;
            weakSelf.model_Type.Id = Model.Id;
            weakSelf.model_Type.Value = @"1";
            if ([Model.Type isEqualToString:Custing(@"自定义", nil)]) {
                STOnePickView *picker = [[STOnePickView alloc]init];
                [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                    weakSelf.model_Type.txf_TexfField.text = [NSString stringWithFormat:@"%@%@%@",Custing(@"每月", nil),Model.Type,Custing(@"号", nil)];
                    weakSelf.model_Type.Value = Model.Type;
                }];
                picker.typeTitle = Custing(@"考勤周期", nil);
                picker.DateSourceArray = [NSMutableArray arrayWithArray:weakSelf.arr_TypeDate];
                STOnePickModel *stmodel = [[STOnePickModel alloc]init];
                stmodel.Id = [NSString isEqualToNull:weakSelf.model_Type.Value]?weakSelf.model_Type.Value:@"";
                picker.Model = stmodel;
                [picker UpdatePickUI];
                [picker setContentMode:STPickerContentModeBottom];
                [picker show];
            }
        }];
        picker.typeTitle = Custing(@"考勤周期", nil);
        picker.DateSourceArray = [NSMutableArray arrayWithArray:self.arr_Type];
        STOnePickModel *stmodel = [[STOnePickModel alloc]init];
        stmodel.Id = [NSString isEqualToNull:weakSelf.model_Type.Id]?weakSelf.model_Type.Id:@"";
        picker.Model = stmodel;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_model_Type.view_View addSubview:view];
    if ([_model_Type.Id floatValue] == 1) {
        _model_Type.txf_TexfField.text = [NSString stringWithFormat:@"%@%@%@",Custing(@"每月", nil),_model_Type.Value,Custing(@"号", nil)];
    }else{
        _model_Type.txf_TexfField.text = Custing(@"自然月", nil);
    }
}
//打卡地点
-(void)updateAttendanceAddress{
    _model_AttendanceAddrss.txf_TexfField = [[UITextField alloc]init];
    _txv_AttendanceAddrss = [[UITextView alloc]init];
    _txv_AttendanceAddrss.editable = NO;
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_AttendanceAddrss.view_View WithContent:_txv_AttendanceAddrss WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine WithString:Custing(@"考勤地点", nil) WithInfodict:nil WithTips:Custing(@"请选择考勤地点", nil) WithNumLimit:200];
    for (UIView *view in [_txv_AttendanceAddrss subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *txf = (UITextField *)view;
            txf.enabled = NO;
        }
    }
    _txv_AttendanceAddrss.frame = CGRectMake(X(_txv_AttendanceAddrss), Y(_txv_AttendanceAddrss), WIDTH(_txv_AttendanceAddrss)-30, HEIGHT(_txv_AttendanceAddrss));
    [_model_AttendanceAddrss.view_View addSubview:view];
    UIImageView *imgview = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 25, 20, 20) imageName:@"skipImage"];
    [_model_AttendanceAddrss.view_View addSubview:imgview];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(92, 10, Main_Screen_Width -92, 100)];
    [_model_AttendanceAddrss.view_View addSubview:btn];
    
    __weak typeof(self) weakSelf = self;
    [btn bk_whenTapped:^{
        AttendanceAddressListViewController *att = [[AttendanceAddressListViewController alloc]init];
        att.muarr_return = weakSelf.muarr_AttendanceAddrss;
        [att setBlock:^(NSMutableArray *arr) {
            weakSelf.muarr_AttendanceAddrss = arr;
            weakSelf.txv_AttendanceAddrss.text = @"";
            for (AMapPOI *amp in arr) {
                if (![NSString isEqualToNull:weakSelf.txv_AttendanceAddrss.text]) {
                    weakSelf.txv_AttendanceAddrss.text = amp.name;
                }else{
                    weakSelf.txv_AttendanceAddrss.text = [NSString stringWithFormat:@"%@\n%@",weakSelf.txv_AttendanceAddrss.text,amp.name];
                }
            }
            for (UIView *view in [weakSelf.txv_AttendanceAddrss subviews]) {
                if ([view isKindOfClass:[UITextField class]]) {
                    [view removeFromSuperview];
                }
            }
        }];
        [weakSelf.navigationController pushViewController:att animated:YES];
    }];
    
    if ([NSString isEqualToNull:_model_AttendanceAddrss.Value]) {
        _txv_AttendanceAddrss.text = _model_AttendanceAddrss.Value;
        for (UIView *view in [_txv_AttendanceAddrss subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

//打卡范围
-(void)updateSignScope{
    _model_SignScope.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_SignScope.view_View WithContent:_model_SignScope.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"打卡范围", nil) WithInfodict:nil WithTips:Custing(@"请选择打卡范围", nil) WithNumLimit:200];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        AttendanceRangeViewController *att = [[AttendanceRangeViewController alloc]init];
        att.str_return = weakSelf.model_SignScope.Value;
        [att setBlock:^(NSString *str_return) {
            weakSelf.model_SignScope.txf_TexfField.text = [NSString stringWithFormat:@"%@%@",str_return,Custing(@"米", nil)];
            weakSelf.model_SignScope.Value = str_return;
            ;
        }];
        [weakSelf.navigationController pushViewController:att animated:YES];
    }];
    [_model_SignScope.view_View addSubview:view];
    if ([NSString isEqualToNull:_model_SignScope.Value]) {
        _model_SignScope.txf_TexfField.text = [NSString stringWithFormat:@"%@%@",_model_SignScope.Value,Custing(@"米", nil)];
    }else{
        _model_SignScope.Value = @"300";
        _model_SignScope.txf_TexfField.text = [NSString stringWithFormat:@"%@%@",_model_SignScope.Value,Custing(@"米", nil)];
    }
}

//更新滚动视图 基本方法
-(void)updateContentView{
    [self.view_ContentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.model_SignScope.view_View.bottom);
    }];
}
-(void)updateEndDeptOrRole{
    
    if ([_model_SelectScope.Id isEqualToString:@"1"]) {
        _model_AttendanceObject.Value = @"";
        _model_AttendanceObject.Id = @"";
        self.model_AttendanceObject.txf_TexfField.text = @"";
        [_model_AttendanceObject.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_model_Role.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
    }else{
        _model_Role.Value = @"";
        _model_Role.Id = @"";
        self.model_Role.txf_TexfField.text = @"";
        [_model_Role.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_model_AttendanceObject.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
        }];
    }
}
//MARK:选择角色
-(void)selectRole{
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"AttendanceRole"];
    choose.ChooseCategoryId=self.model_Role.Id;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.model_Role.Id = model.roleId;
        weakSelf.model_Role.Value = model.roleName;
        weakSelf.model_Role.txf_TexfField.text = model.roleName;
    };
    [self.navigationController pushViewController:choose animated:YES];
}
#pragma mark 网络请求
-(void)requestAttendanceInsertAttendance{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceInsertAttendance];
    NSDictionary *parameters = @{@"AttendanceJson":_str_Submit};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

-(void)requestAttendanceUpdateAttendance{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",AttendanceUpdateAttendance];
    NSDictionary *parameters = @{@"AttendanceJson":_str_Submit};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

#pragma mark - action
-(void)btn_click{
    if (![NSString isEqualToNull:_model_Name.txf_TexfField.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入考勤组名称", nil) duration:1.5];
        return;
    }
    if ([_model_SelectScope.Id isEqualToString:@"1"]) {
        if (![NSString isEqualToNull:_model_Role.txf_TexfField.text]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择参与角色", nil) duration:1.5];
            return;
        }
    }else{
        if (![NSString isEqualToNull:_model_AttendanceObject.txf_TexfField.text]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择参与部门", nil) duration:1.5];
            return;
        }
    }
   
    if (![NSString isEqualToNull:_model_SignDate.txf_TexfField.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择打卡日期", nil) duration:1.5];
        return;
    }
    if (![NSString isEqualToNull:_model_FromTime.txf_TexfField.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择打卡时间", nil) duration:1.5];
        return;
    }
    if (![NSString isEqualToNull:_model_Type.txf_TexfField.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择考勤周期", nil) duration:1.5];
        return;
    }
    if (_muarr_AttendanceAddrss.count==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择考勤地点", nil) duration:1.5];
        return;
    }
    if (![NSString isEqualToNull:_model_SignScope.txf_TexfField.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择打卡范围", nil) duration:1.5];
        return;
    }
    [self jointResponse];
    if (_dic==nil) {
        [self requestAttendanceInsertAttendance];
    }else{
        [self requestAttendanceUpdateAttendance];
    }
}
-(void)getGroupId{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcosummary] Parameters:nil Delegate:self SerialNum:4 IfUserCache:NO];
}

#pragma mark - Delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:error]?error:Custing(@"网络请求失败", nil) duration:1.0];
        return;
    }
    if (serialNum == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }else if (serialNum == 1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改成功", nil) duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }else if (serialNum == 4) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        self.userdatas.groupid = [result objectForKey:@"groupId"];
        self.userdatas.PeoplePage = self.navigationController.viewControllers.count;
        [self.userdatas storeUserInfo];
        ComPeopleViewController *cp = [[ComPeopleViewController alloc]init];
        cp.nowGroupname = self.userdatas.company;
        cp.nowGroup = [NSString isEqualToNull:self.userdatas.groupid]?self.userdatas.groupid:self.userdatas.companyId;
        [self.navigationController pushViewController:cp animated:YES];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//- (void)ComPeopleViewController_BtnClick:(NSDictionary *)dic{
//    _model_AttendanceObject.Id = dic[@"id"];
//    _model_AttendanceObject.txf_TexfField.text = dic[@"name"];
//}

- (void)editGroup:(NSNotification *)note{
    NSDictionary *dic = note.userInfo;
    _model_AttendanceObject.Id = dic[@"id"];
    _model_AttendanceObject.txf_TexfField.text = dic[@"name"];
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
