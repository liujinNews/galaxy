//
//  AddtravelRouteViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "AddtravelRouteViewController.h"

@interface AddtravelRouteViewController ()<UITextViewDelegate,UITextFieldDelegate,chooseTravelDateViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UITextField *txf_TravelDate;//行程日期
@property (nonatomic, strong) UITextField *txf_TravelTime;//行程时间

@property (nonatomic, strong) UIDatePicker *datePicker;//弹出的时间图
@property (nonatomic, strong) chooseTravelDateView *datelView;//采购日期选择弹出框

@property (nonatomic, strong) UIPickerView *pic_date;//时间选择
@property (nonatomic, strong) NSArray *arr_date;//时间选择
@property (nonatomic, strong) NSDictionary *dic_time;

@property (nonatomic, strong) UIView *View_Time;
@property (nonatomic, strong) UIView *View_Content;

@end

@implementation AddtravelRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    [self setTitle:Custing(@"添加行程", nil) backButton:YES];
    if (_dic_load!=nil) {
        _dic_time = @{@"key":_dic_load[@"travelTime"],@"value":[_dic_load[@"travelTime"] isEqualToString:@"0"]?Custing(@"全天", nil):[_dic_load[@"travelTime"] isEqualToString:@"1"]?Custing(@"上午", nil):Custing(@"下午", nil)};
    }
    [self createMainView];
    [self updateBottonView];
}

#pragma mark - function
-(void)createMainView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?[UIColor whiteColor]:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right_click:)];
    
    _View_Time = [[UIView alloc]init];
    _View_Time.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_View_Time];
    [_View_Time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    
    _View_Content = [[UIView alloc]init];
    _View_Content.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_View_Content];
    [_View_Content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Time.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
}

-(void)updateBottonView{
    if (_arr_ShowArray.count>0) {
        for (int i = 0; i<_arr_ShowArray.count; i++) {
            MyProcurementModel *model = _arr_ShowArray[i];
            if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
                if ([model.fieldName isEqualToString:@"TravelDate"]) {
                    [_View_Time mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@120);
                    }];
                    [self updateTimeView];
                }
                if ([model.fieldName isEqualToString:@"TravelContent"]) {
                    [_View_Content mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@110);
                    }];
                    [self updateContentView];
                }
            }
        }
    }
}

-(void)updateTimeView{
    //日期
    UIView *view_TravelDate =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 60)];
    view_TravelDate.backgroundColor=Color_WhiteWeak_Same_20;
    [_View_Time addSubview:view_TravelDate];
    [view_TravelDate addSubview:[self createUpLineView]];
    
    UILabel *lab_TravelDate_title=[GPUtils createLable:CGRectMake(15,27,90, 16) text:Custing(@"日期", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view_TravelDate addSubview:lab_TravelDate_title];
    
    _txf_TravelDate = [GPUtils createTextField:CGRectMake(120, 14, ScreenRect.size.width-155,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_TravelDate.placeholder=Custing(@"请选择日期",nil);
    _txf_TravelDate.textAlignment = NSTextAlignmentRight;
    _txf_TravelDate.keyboardType = UIKeyboardTypeNumberPad;
    _txf_TravelDate.returnKeyType = UIReturnKeyDefault;
    _txf_TravelDate.tag = 1;
    [view_TravelDate addSubview:_txf_TravelDate];
    
    UIButton *btn_TravelDate=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2, 60) action:@selector(btn_Click:) delegate:self];
    btn_TravelDate.tag = 100;
    [view_TravelDate addSubview:btn_TravelDate];
    
    UIImageView * iconImage_TravelDate = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    iconImage_TravelDate.frame = CGRectMake(Main_Screen_Width-32, 26, 20, 20);
    [view_TravelDate addSubview:iconImage_TravelDate];
    
    //时间
    UIView *view_TravelTime =[[UIView alloc]initWithFrame:CGRectMake(0, 60, Main_Screen_Width, 60)];
    view_TravelTime.backgroundColor=Color_WhiteWeak_Same_20;
    [_View_Time addSubview:view_TravelTime];
    [view_TravelTime addSubview:[self createUpLineView]];
    
    UILabel *lab_TravelTime_title=[GPUtils createLable:CGRectMake(15,27,90, 16) text:Custing(@"时间", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [view_TravelTime addSubview:lab_TravelTime_title];
    
    _txf_TravelTime = [GPUtils createTextField:CGRectMake(120, 14, ScreenRect.size.width-155,42) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txf_TravelTime.placeholder=Custing(@"请选择时间",nil);
    _txf_TravelTime.textAlignment = NSTextAlignmentRight;
    _txf_TravelTime.keyboardType = UIKeyboardTypeNumberPad;
    _txf_TravelTime.returnKeyType = UIReturnKeyDefault;
    _txf_TravelTime.tag = 1;
    [view_TravelTime addSubview:_txf_TravelTime];
    
    UIButton *btn_TravelTime=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2, 60) action:@selector(btn_Click:) delegate:self];
    btn_TravelTime.tag = 101;
    [view_TravelTime addSubview:btn_TravelTime];
    
    UIImageView * iconImage_TravelTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
    iconImage_TravelTime.frame = CGRectMake(Main_Screen_Width-32, 26, 20, 20);
    [view_TravelTime addSubview:iconImage_TravelTime];
    
    if (![_dic_load isKindOfClass:[NSNull class]]) {
        _txf_TravelDate.text = _dic_load[@"travelDate"];
        _txf_TravelTime.text = [[NSString stringWithFormat:@"%@",_dic_load[@"travelTime"]] isEqualToString:@"2"]?Custing(@"下午", nil):[[NSString stringWithFormat:@"%@",_dic_load[@"travelTime"]] isEqualToString:@"1"]?Custing(@"上午", nil):Custing(@"全天", nil);
    }else{
        _dic_time = @{@"key":@"0",@"value":Custing(@"全天", nil)};
        _txf_TravelTime.text = Custing(@"全天", nil);
    }
}

-(void)updateContentView{
    
    _txv_Content=[[UITextView alloc]init];
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=Custing(@"内容", nil);
    model.tips=Custing(@"请输入行程内容", nil);
    if (![_dic_load isKindOfClass:[NSNull class]]) {
        model.fieldValue = _dic_load[@"travelContent"];
    }
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Content WithContent:_txv_Content WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Content addSubview:view];
    
    
//    //内容
//    UIView *view_two = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 110)];
//    view_two.backgroundColor = [UIColor whiteColor];
//    [_View_Content addSubview:view_two];
//    
//    
//    
//    
//    
//    UILabel *title=[GPUtils createLable:CGRectMake(15,14,75, 20) text:Custing(@"内容", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//    [view_two addSubview:title];
//    _remarksTextView=[[UITextView alloc]initWithFrame:CGRectMake(100, 10, Main_Screen_Width-115, 68)];
//    _remarksTextView.delegate=self;
//    _remarksTextView.font=Font_Important_15_20;
//    _remarksTextView.textColor=Color_form_TextField_20;
//    [_remarksTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [view_two addSubview:_remarksTextView];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRemarkTextViewEditChanged:) name:@"UITextViewTextDidChangeNotification"
//                                              object:_remarksTextView];
//    
//    _remarkTipField=[[UITextField alloc]initWithFrame:CGRectMake(4,8,Main_Screen_Width-120, 14)];
//    _remarkTipField.font=Font_Important_15_20;
//    _remarkTipField.enabled=NO;
//    _remarkTipField.placeholder = Custing(@"请输入行程内容", nil);
//    [_remarksTextView addSubview:_remarkTipField];
//    _remarkVoiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-40, Y(_remarksTextView)+HEIGHT(_remarksTextView)-5, 25, 25)];
//    [_remarkVoiceBtn setImage:[UIImage imageNamed:@"share_voice"] forState:UIControlStateNormal];
//    [_remarkVoiceBtn addTarget:self action:@selector(VoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [view_two addSubview:_remarkVoiceBtn];
//    UIView *linedowns=[[UIView alloc]initWithFrame:CGRectMake(0,109.5, Main_Screen_Width,0.5)];
//    linedowns.backgroundColor=Color_GrayLight_Same_20;
//    [view_two addSubview:linedowns];
//    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0.1, Main_Screen_Width,0.5)];
//    lineUp.backgroundColor=Color_GrayLight_Same_20;
//    [view_two addSubview:lineUp];
//    
//    if (![_dic_load isKindOfClass:[NSNull class]]) {
//        _remarksTextView.text = _dic_load[@"travelContent"];
//        _remarkTipField.hidden = YES;
//    }
}


#pragma mark - action
//确定按钮
-(void)btn_right_click:(UIButton *)btn{
    if (_arr_ShowArray.count>0) {
        for (int i = 0; i<_arr_ShowArray.count; i++) {
            MyProcurementModel *model = _arr_ShowArray[i];
            if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]&&[model.isRequired integerValue]==1) {
                if ([model.fieldName isEqualToString:@"TravelDate"]) {
                    if (![NSString isEqualToNull:_txf_TravelDate.text]) {
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择日期", nil) duration:1.0];
                        return;
                    }
                    if (![NSString isEqualToNull:_txf_TravelTime.text]) {
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入时间", nil) duration:1.0];
                        return;
                    }
                }
                if ([model.fieldName isEqualToString:@"TravelContent"]) {
                    if (![NSString isEqualToNull:_txv_Content.text]) {
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入内容", nil) duration:1.0];
                        return;
                    }
                }
            }
        }
    }
    
    if (_txf_TravelDate == nil) {
        _txf_TravelDate = [UITextField new];
    }
    if (_dic_time == nil) {
        _dic_time = @{@"key":@"0",@"value":Custing(@"全天", nil)};
    }
    if (_txv_Content == nil) {
        _txv_Content = [UITextView new];
    }
    
    [self.delegate AddtravelRouteViewController_save:@{@"travelDate":_txf_TravelDate.text,@"travelTime":_dic_time[@"key"],@"travelContent":_txv_Content.text}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btn_Click:(UIButton *)btn
{
    //选择日期
    if (btn.tag==100) {
        if (![NSString isEqualToNull:_txf_TravelDate.text]) {
            NSDate *date = [NSDate date];
            _txf_TravelDate.text = [NSString stringWithDate:date];
        }
        _txf_TravelDate.text = [_txf_TravelDate.text substringToIndex:10];
        _datePicker = [[UIDatePicker alloc]init];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd"];
        NSDate *fromdate=[format dateFromString:_txf_TravelDate.text];
        NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
        NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
        NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
        _datePicker.date=fromDate;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"日期",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = 1;
        [view addSubview:sureDataBtn];
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [view addSubview:cancelDataBtn];
        if (!_datelView) {
            _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
            _datelView.delegate = self;
        }
        
        [_datelView showUpView:_datePicker];
        [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
        [_datelView show];
    }
    if (btn.tag == 101) {
        if (_pic_date == nil) {
            _pic_date = [[UIPickerView alloc]init];
            _pic_date.dataSource = self;
            _pic_date.delegate = self;
        }
        if (_arr_date == nil) {
            _arr_date = @[@{@"key":@"0",@"value":Custing(@"全天", nil)},@{@"key":@"1",@"value":Custing(@"上午", nil)},@{@"key":@"2",@"value":Custing(@"下午", nil)}];
        }
        if (_datelView == nil) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"时间", nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            [view addSubview:sureDataBtn];
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            [view addSubview:cancelDataBtn];
            if (!_datelView) {
                _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _pic_date.frame.size.height+40) pickerView:_pic_date titleView:view];
                _datelView.delegate = self;
            }
            [_datelView showUpView:_pic_date];
            [_datelView show];
        }
        if (![NSString isEqualToNull:_txf_TravelTime.text]) {
            NSDictionary *dic = _arr_date[0];
            _dic_time = dic;
            _txf_TravelTime.text = dic[@"value"];
        }
        for (int i = 0; i<_arr_date.count; i++) {
            NSDictionary *dic =_arr_date[i];
            if ([_txf_TravelTime.text isEqualToString:dic[@"value"]]) {
                [_pic_date selectRow:i inComponent:0 animated:YES];
            }
        }
        [_datelView show];
    }
}

//#pragma mark - delegate
////备注语音输入6
//-(void)VoiceBtnClick:(UIButton *)btn{
//    [self keyClose];
//    [self startVoice];
//}
//
////备注限制字数
//-(void)AddRemarkTextViewEditChanged:(NSNotification *)obj{
//    UITextView *textField = (UITextView *)obj.object;
//    NSString *toBeString = textField.text;
//    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length >255) {
//                textField.text = [toBeString substringToIndex:255];
//            }
//        }
//    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        if (toBeString.length > 255) {
//            textField.text = [toBeString substringToIndex:255];
//        }
//    }
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if (textView.text.length>200) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
//        textView.text = [textView.text substringToIndex:199];
//    }
//}
//
//-(void)textViewDidChangeSelection:(UITextView *)textView
//{
//    if (textView.text.length>200) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
//        textView.text = [textView.text substringToIndex:199];
//    }
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    if (textView.text.length>200) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
//        textView.text = [textView.text substringToIndex:199];
//    }
//}
//
//-(void)textViewDidChange:(UITextView *)textView
//{
//    [self changeRemarkView];
//}
////备注分行显示处理
//-(void)changeRemarkView
//{
//    if (_remarksTextView.text.length == 0) {
//        _remarkTipField.hidden = NO;
//    }else{
//        _remarkTipField.hidden = YES;
//    }
//}

//日期选择底层视图代理
-(void)dimsissPDActionView{
    _datelView=nil;
}

//数值变化的时候代理
-(void)DateChanged:(UIDatePicker *)sender{
    [self keyClose];
}

//时间选择确定按钮
-(void)sureData:(UIButton *)btn{
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    _txf_TravelDate.text = str;
    [self.datelView remove];
}

-(void)btn_Cancel_Click{
    [_datelView remove];
    [self.datelView remove];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arr_date.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _arr_date[row][@"value"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _dic_time = _arr_date[row];
}

-(void)sureData{
    _txf_TravelTime.text = _dic_time[@"value"];
    [_datelView remove];
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
