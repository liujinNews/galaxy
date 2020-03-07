//
//  SubmitFormView.m
//  galaxy
//
//  Created by hfk on 2017/7/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//
#import "SubmitFormView.h"

@implementation SubmitFormView

-(SubmitFormView *)initBaseView:(UIView *)baseView WithContent:(id)txf  WithFormType:(formViewType)formViewType WithSegmentType:(segmentType)segmentType Withmodel:(MyProcurementModel *)model WithInfodict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _baseView=baseView;
        _baseView.clipsToBounds=YES;
        _curFormViewType=formViewType;
        _curSegmentType=segmentType;
        _InfoDict=dict;
        _model=model;
        _baseView.backgroundColor = Color_form_TextFieldBackgroundColor;
        if (_curFormViewType==formViewSelectDate) {
            _formatter_SelectTime=@"yyyy/MM/dd";
            _model_DatePick=UIDatePickerModeDate;
        }else if (_curFormViewType==formViewSelectDateTime||_curFormViewType==formViewSelectYearDateTime){
            _formatter_SelectTime=@"yyyy/MM/dd HH:mm";
            _model_DatePick=UIDatePickerModeDateAndTime;//UIDatePickerModeDateAndTime
        }else if (_curFormViewType==formViewSelectTime){
            _formatter_SelectTime=@"HH:mm";
            _model_DatePick=UIDatePickerModeTime;
        }else if (_curFormViewType == formViewSelectMonthDateTime){
            _formatter_SelectTime = @"yyyy/MM";
            _model_DatePick=UIDatePickerModeDate;
        }
        
        if ([txf isKindOfClass:[UITextField class]]) {
            _txfield_content=txf;
            _txfield_content.userInteractionEnabled=NO;
            _txfield_content.font=Font_Important_15_20;
            _txfield_content.delegate=self;
            _txfield_content.textColor = Color_form_TextField_20;
            _txfield_content.backgroundColor = Color_form_TextFieldBackgroundColor;
            _txfield_content.textAlignment=NSTextAlignmentLeft;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:_txfield_content];
            [self addSubview:_txfield_content];
            
        }else if ([txf isKindOfClass:[UITextView class]]){
            _txview_content=txf;
            [_txview_content setAutocorrectionType:UITextAutocorrectionTypeNo];
            _txview_content.textColor = Color_form_TextField_20;
//            _txview_content.backgroundColor = Color_form_TextFieldBackgroundColor;
            _txview_content.font=Font_Important_15_20;
            _txview_content.textAlignment=NSTextAlignmentLeft;
            _txview_content.delegate=self;
            _txview_content.backgroundColor = Color_form_TextFieldBackgroundColor;
            [self addSubview:_txview_content];
            if (!_txv_subview) {
                _txv_subview=[[UITextField alloc]initWithFrame:CGRectMake(4,10,Main_Screen_Width-100, 14)];
                _txv_subview.font=Font_Important_15_20;
                _txv_subview.enabled=NO;
                _txv_subview.placeholder=Custing(@"请输入", nil);
//                _txv_subview.backgroundColor = Color_form_TextFieldBackgroundColor;
                [_txview_content addSubview:_txv_subview];
            }
        }
        if (!_lab_title) {
            _lab_title=[GPUtils createLable:CGRectMake(0, 0, XBHelper_Title_Width, 50) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//            _lab_title.backgroundColor = Color_form_TextFieldBackgroundColor;
            _lab_title.text=[NSString stringWithIdOnNO:_model.Description];
            _lab_title.numberOfLines=0;
            _lab_title.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_lab_title];
            
        }
        if (!_img_des) {
            _img_des=[GPUtils createImageViewFrame:CGRectZero imageName:nil];
            [self addSubview:_img_des];
        }
        if (!_img_cate) {
            _img_cate=[GPUtils createImageViewFrame:CGRectZero imageName:nil];
            [self addSubview:_img_cate];
        }
        if (!_SegmentLineView) {
            _SegmentLineView=[[UIView alloc]init];
            _SegmentLineView.backgroundColor=Color_White_Same_20;
            [self addSubview:_SegmentLineView];
        }
        if (!_selectBtn) {
            _selectBtn=[GPUtils createButton:CGRectZero action:@selector(btnClick:) delegate:self];
            [self addSubview:_selectBtn];
        }
        
        if ([[NSString stringWithFormat:@"%@",_model.isOnlyRead]isEqualToString:@"1"]) {
            if (_curFormViewType == formViewSelect || _curFormViewType == formViewSelectTime || _curFormViewType == formViewSelectDate || _curFormViewType == formViewSelectDateTime || _curFormViewType == formViewSelectYearDateTime||_curFormViewType == formViewSelectMonthDateTime) {
                _curFormViewType = formViewShowText;
            }else if (_curFormViewType == formViewSelectCate){
                _curFormViewType = formViewShowCate;
            }
        }
        
        [self dealWithSegmentHeightAndView];
        
        if (_curFormViewType != formViewShowAppover && [[NSString stringWithFormat:@"%@",_model.isOnlyRead]isEqualToString:@"1"]) {
            _selectBtn.userInteractionEnabled=NO;
            _txview_content.editable=NO;
            _txview_content.selectable=NO;
            _txfield_content.userInteractionEnabled=NO;
            _txfield_content.placeholder=nil;
            _txv_subview.placeholder=nil;
            _img_des.hidden = YES;
        }

    }
    return self;
}
//MARK:处理分割线
-(void)dealWithSegmentHeightAndView{
    _height=10;
    _SegmentLineView.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
    if (_curSegmentType==lineViewNone) {
        _height=0;
        _SegmentLineView.frame=CGRectMake(0, 0, Main_Screen_Width, 0);
    }else if (_curSegmentType==lineViewOnlyLine){
        _height=0.5;
        _SegmentLineView.frame=CGRectMake(12, 0, Main_Screen_Width-12, 0.5);
        _SegmentLineView.backgroundColor=Color_GrayLight_Same_20;
    }else if (_curSegmentType==lineViewLine){
        UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0.1, Main_Screen_Width,0.5)];
        lineUp.backgroundColor=Color_GrayLight_Same_20;
        [_SegmentLineView addSubview:lineUp];
        
        UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,9.5, Main_Screen_Width,0.5)];
        lineDown.backgroundColor=Color_GrayLight_Same_20;
        [_SegmentLineView addSubview:lineDown];
        
    }else if (_curSegmentType==lineViewDownLine){
        
        UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,9.5, Main_Screen_Width,0.5)];
        lineDown.backgroundColor=Color_GrayLight_Same_20;
        [_SegmentLineView addSubview:lineDown];
        
    }else if (_curSegmentType==lineViewUpLine){
        
        UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0.1, Main_Screen_Width,0.5)];
        lineUp.backgroundColor=Color_GrayLight_Same_20;
        [_SegmentLineView addSubview:lineUp];
    }
    _lab_title.center=CGPointMake(12+XBHelper_Title_Width/2, _height+25);
    [self dealWithFormViewType];
}
//MARK:处理格式
-(void)dealWithFormViewType{
    NSInteger mainHeight=50;
    if (_curFormViewType==formViewShowText) {
        [self showAndEnterTxfFrame];
        _txfield_content.text=_InfoDict?([NSString isEqualToNull:_InfoDict[@"value1"]]?_InfoDict[@"value1"]:@""):([NSString isEqualToNull:_model.fieldValue]?[NSString stringWithFormat:@"%@",_model.fieldValue]:@"");
        
    }else if (_curFormViewType==formViewShowAmount){
        [self showAndEnterTxfFrame];
        [self showAbountNumber];
        
    }else if (_curFormViewType==formViewSelect||_curFormViewType==formViewLookSelect||_curFormViewType==formViewSelectTime||_curFormViewType==formViewSelectDate||_curFormViewType==formViewSelectDateTime||_curFormViewType==formViewSelectCate||_curFormViewType==formViewShowCate||_curFormViewType==formViewSelectYearDateTime||_curFormViewType==formViewBankAccount||_curFormViewType == formViewSelectMonthDateTime){
        [self showSelectTxfFrame];
        [self checkInSelectInfo];
    }else if (_curFormViewType==formViewEnterText){
        [self showAndEnterTxfFrame];
        [self checkInWriteInfo];
        
    }else if (_curFormViewType==formViewEnterAmout||_curFormViewType==formViewEnterExchange||_curFormViewType==formViewEnterNum||_curFormViewType==formViewEnterDays||_curFormViewType==formViewEnterHalfNum||_curFormViewType==formViewEnterNegAmout){
        [self showAndEnterTxfFrame];
        [self checkInWriteInfo];
        if (_curFormViewType == formViewEnterNegAmout) {
            _txfield_content.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }else{
            _txfield_content.keyboardType =UIKeyboardTypeDecimalPad;
        }
    }else if (_curFormViewType==formViewEnterTextView||_curFormViewType==formViewVoiceTextView||_curFormViewType==formViewVoiceNoTitleTextView){
        [self checkInTextViewInfo];
        mainHeight=100;
    }else if (_curFormViewType==formViewLongTextView){
        [self checkInLongTextViewInfo];
        mainHeight=280;
    }else if (_curFormViewType==formViewShowAppover){
        [self checkInApproverInfo];
        _selectBtn.tag=3;
        mainHeight=100;
    }else if (_curFormViewType==formViewOnlySelect){
        [self showOnlySelect];
    }
    
    [_baseView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.height+mainHeight));
    }];
    self.frame=CGRectMake(0, 0, Main_Screen_Width, _height+mainHeight);
}
//显示输入样式的TextField Frame
-(void)showAndEnterTxfFrame{
    _txfield_content.frame=CGRectMake(12+15+XBHelper_Title_Width,_height,Main_Screen_Width-12-15-12-XBHelper_Title_Width, 50);
}
//选择样式的TextField Frame
-(void)showSelectTxfFrame{
    if (_curFormViewType==formViewSelectCate||_curFormViewType==formViewShowCate) {
        _selectBtn.tag=5;
        _txfield_content.frame=CGRectMake(12+15+XBHelper_Title_Width, _height, Main_Screen_Width-12-15-XBHelper_Title_Width-12-20-10-32, 50);
        _img_cate.frame=CGRectMake(Main_Screen_Width-12-20-32, _height+9, 32, 32);
    }else{
        if (_curFormViewType == formViewSelectDate||_curFormViewType == formViewSelectDateTime||_curFormViewType==formViewSelectTime||_curFormViewType == formViewSelectMonthDateTime) {
            _selectBtn.tag = 6;
        }else if (_curFormViewType == formViewSelectYearDateTime){
            _selectBtn.tag = 7;
        }else if (_curFormViewType == formViewBankAccount){
            _selectBtn.tag = 8;
        }else{
            _selectBtn.tag = 1;
        }
        _txfield_content.frame=CGRectMake(12+15+XBHelper_Title_Width, _height, Main_Screen_Width-12-15-XBHelper_Title_Width-12-20-10, 50);
    }
    if (_curFormViewType != formViewShowCate) {
        _img_des.image = [UIImage imageNamed:@"skipImage"];
    }else{
        _txfield_content.frame = CGRectMake(12+15+XBHelper_Title_Width, _height, Main_Screen_Width-12-15-XBHelper_Title_Width-12-10-32, 50);
        _img_cate.frame = CGRectMake(Main_Screen_Width-12-32, _height+9, 32, 32);
    }
    if (_curFormViewType == formViewLookSelect) {
        _img_des.image = nil;
        _txfield_content.textColor = Color_Blue_Important_20;
    }
    _img_des.frame = CGRectMake(Main_Screen_Width-12-20, _height+15, 20, 20);
    _selectBtn.frame = CGRectMake(12+15+XBHelper_Title_Width, _height, Main_Screen_Width-12-15-XBHelper_Title_Width, 50);
}
//输入框显示数字相关
-(void)showAbountNumber{
    
    NSString *str=_InfoDict?([NSString isEqualToNull:_InfoDict[@"value1"]]?_InfoDict[@"value1"]:@"0"):([NSString isEqualToNull:_model.fieldValue]?[NSString stringWithFormat:@"%@",_model.fieldValue]:@"0");
    if (_curFormViewType==formViewShowAmount) {
        _txfield_content.text=[GPUtils transformNsNumber:str];
    }
}
//选择框
-(void)checkInSelectInfo{
    if ([NSString isEqualToNull:_model.tips]){
        if ([_model.isRequired floatValue] == 1) {
            _txfield_content.placeholder = [NSString stringWithFormat:@"%@%@",_model.tips,Custing(@"(必选)", nil)] ;
        }else{
            _txfield_content.placeholder=_model.tips;
        }
    }else{
        if ([_model.isRequired floatValue]==1) {
            _txfield_content.placeholder=Custing(@"请选择(必选)", nil);
        }else{
            _txfield_content.placeholder=Custing(@"请选择", nil);
        }
    }
    if (self.curFormViewType == formViewBankAccount) {
        _txfield_content.text = _InfoDict ? ([NSString isEqualToNull:_InfoDict[@"value1"]] ? [NSString getSecretBankAccount:_InfoDict[@"value1"]]:@""):([NSString isEqualToNull:_model.fieldValue] ? [NSString getSecretBankAccount:_model.fieldValue]:@"");
    }else{
        _txfield_content.text = _InfoDict?([NSString isEqualToNull:_InfoDict[@"value1"]]?_InfoDict[@"value1"]:@""):([NSString isEqualToNull:_model.fieldValue]?[NSString stringWithIdOnNO:_model.fieldValue]:@"");
    }
}
//输入框
-(void)checkInWriteInfo{
    if ([NSString isEqualToNull:_model.tips]){
        if ([_model.isRequired floatValue]==1) {
            _txfield_content.placeholder=[NSString stringWithFormat:@"%@%@",_model.tips,Custing(@"(必填)", nil)] ;
        }else{
            _txfield_content.placeholder=_model.tips;
        }
    }else{
        if ([_model.isRequired floatValue]==1) {
            _txfield_content.placeholder=Custing(@"请输入(必填)", nil);
        }else{
            _txfield_content.placeholder=Custing(@"请输入", nil);
        }
    }
    _txfield_content.userInteractionEnabled=YES;
    
    NSString *str=_InfoDict?([NSString isEqualToNull:_InfoDict[@"value1"]]?_InfoDict[@"value1"]:@""):([NSString isEqualToNull:_model.fieldValue]?[NSString stringWithFormat:@"%@",_model.fieldValue]:@"");
    if (_curFormViewType==formViewEnterText||_curFormViewType==formViewEnterNum||_curFormViewType==formViewEnterDays||_curFormViewType==formViewEnterHalfNum||_curFormViewType==formViewEnterAmout||_curFormViewType==formViewEnterNegAmout||_curFormViewType==formViewEnterExchange) {
        _txfield_content.text=[NSString isEqualToNull:str]?[NSString stringWithFormat:@"%@",str]:@"";
    }
}

//textView框
-(void)checkInTextViewInfo{
    if ([NSString isEqualToNull:_model.tips]){
        if ([_model.isRequired floatValue]==1) {
            _txv_subview.placeholder=[NSString stringWithFormat:@"%@%@",_model.tips,Custing(@"(必填)", nil)] ;
        }else{
            _txv_subview.placeholder=_model.tips;
        }
    }else{
        if ([_model.isRequired floatValue]==1) {
            _txv_subview.placeholder=Custing(@"请输入(必填)", nil);
        }else{
            _txv_subview.placeholder=Custing(@"请输入", nil);
            
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemarkTextViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_txview_content];
    BOOL isCh=[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    if ((_lab_title.text.length>=11)||(isCh&&_lab_title.text.length>=5)) {
        _lab_title.frame=CGRectMake(0, 0, XBHelper_Title_Width, 60);
        _lab_title.center=CGPointMake(12+XBHelper_Title_Width/2, _height+30);
    }
    
    _txview_content.frame=CGRectMake(12+XBHelper_Title_Width+10, _height+8, Main_Screen_Width-12-XBHelper_Title_Width-10-12, 68);

    if (_curFormViewType==formViewVoiceNoTitleTextView) {
        _lab_title.hidden=YES;
        _txview_content.frame=CGRectMake(12, _height+8, Main_Screen_Width-12-12, 68);
    }

    _txview_content.text=_InfoDict?([NSString isEqualToNull:_InfoDict[@"value1"]]?_InfoDict[@"value1"]:@""):([NSString isEqualToNull:_model.fieldValue]?_model.fieldValue:@"");
    
    if (_txview_content.text.length>0) {
        _txv_subview.hidden=YES;
    }
    
    if (_curFormViewType==formViewVoiceTextView||_curFormViewType==formViewVoiceNoTitleTextView) {
        _selectBtn.frame=CGRectMake(Main_Screen_Width/2, Y(_txview_content)+HEIGHT(_txview_content)-5, Main_Screen_Width/2, 25);
        _selectBtn.tag=4;
        _img_des.frame=CGRectMake(Main_Screen_Width-40, Y(_txview_content)+HEIGHT(_txview_content)-5, 10, 15);
        _img_des.image=[UIImage imageNamed:@"share_voice_gray"];
    }
}
-(void)checkInLongTextViewInfo{

    if ([NSString isEqualToNull:_model.tips]){
        if ([_model.isRequired floatValue]==1) {
            _txv_subview.placeholder=[NSString stringWithFormat:@"%@%@",_model.tips,Custing(@"(必填)", nil)] ;
        }else{
            _txv_subview.placeholder=_model.tips;
        }
    }else{
        if ([_model.isRequired floatValue]==1) {
            _txv_subview.placeholder=Custing(@"请输入(必填)", nil);
        }else{
            _txv_subview.placeholder=Custing(@"请输入", nil);
            
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemarkTextViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:_txview_content];
    _lab_title.hidden=YES;
    _txview_content.frame=CGRectMake(12, _height+8, Main_Screen_Width-12-12, 247);
    _txview_content.text=_InfoDict?([NSString isEqualToNull:_InfoDict[@"value1"]]?_InfoDict[@"value1"]:@""):([NSString isEqualToNull:_model.fieldValue]?_model.fieldValue:@"");
    if (_txview_content.text.length>0) {
        _txv_subview.hidden=YES;
    }
    
    _selectBtn.frame=CGRectMake(Main_Screen_Width/2, Y(_txview_content)+HEIGHT(_txview_content)-5, Main_Screen_Width/2, 25);
    _selectBtn.tag=4;
    _img_des.frame=CGRectMake(Main_Screen_Width-40, Y(_txview_content)+HEIGHT(_txview_content)-5, 10, 15);
    _img_des.image=[UIImage imageNamed:@"share_voice_gray"];
}
//审批人框
-(void)checkInApproverInfo{
    _lab_title.center=CGPointMake(12+XBHelper_Title_Width/2, _height+50);
    _img_des.image=[UIImage imageNamed:@"share_AddAproval"];
    _img_des.frame=CGRectMake(0, 0, 60, 60);
    _img_des.center=CGPointMake(12+XBHelper_Title_Width+15+30, 50+_height);
    _img_des.layer.masksToBounds = YES;
    _img_des.layer.cornerRadius = 30.0f;
    
    _txfield_content.frame=CGRectMake(170, _height, Main_Screen_Width-170-15, 100);
    _selectBtn.frame=CGRectMake(100, _height, 60, 100);
    
    
    if ([NSString isEqualToNull:_model.fieldValue]) {
        if ([NSString isEqualToNull:_InfoDict[@"value1"]]) {
            [_img_des sd_setImageWithURL:[NSURL URLWithString:_InfoDict[@"value1"]]];
        }else{
            if (![NSString isEqualToNull:_InfoDict[@"value2"]]||[[NSString stringWithFormat:@"%@",_InfoDict[@"value2"]] isEqualToString:@"0"]) {
                _img_des.image=[UIImage imageNamed:@"Message_Man"];
            }else{
                _img_des.image=[UIImage imageNamed:@"Message_Woman"];
            }
        }
        _txfield_content.text=_model.fieldValue;
    }
}
//单纯选择
-(void)showOnlySelect{
    _selectBtn.tag=1;
    _lab_title.frame=CGRectMake(12, _height, Main_Screen_Width-12-12-20, 50);
    _img_des.image=[UIImage imageNamed:@"skipImage"];
    _img_des.frame = CGRectMake(Main_Screen_Width-12-20, _height+15, 20, 20);
    _selectBtn.frame=CGRectMake(12, _height, Main_Screen_Width-12-12-20, 50);
}
-(void)btnClick:(UIButton *)btn{
    UIViewController *vc = [GPUtils getCurrentVC];
    [vc.view endEditing:YES];
    
    if (btn.tag==1) {//选择样式点击事件
        if (self.FormClickedBlock) {
            self.FormClickedBlock(_model);
        }
    }else if (btn.tag==3){//选择审批人
        if (self.ApproverClickedBlock) {
            self.ApproverClickedBlock(_model,_img_des);
        }
    }else if (btn.tag==4){
        [self startVoice];
    }else if (btn.tag==5){
        if (self.CateClickedBlock) {
            self.CateClickedBlock(_model,_img_cate);
        }
    }else if (btn.tag == 6){
        _datePicker = [[UIDatePicker alloc]init];
        NSString *dateStr;
        if ([NSString isEqualToNull:_txfield_content.text]) {
            dateStr=_txfield_content.text;
            _selectDataString=_txfield_content.text;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:_formatter_SelectTime];
            NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
            dateStr=currStr;
            _selectDataString=currStr;
        }
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:_formatter_SelectTime];
        NSDate *fromdate = [format dateFromString:dateStr];
        _datePicker.date = fromdate;
        
        userData *userdatas=[userData shareUserData];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
        _datePicker.datePickerMode = _model_DatePick;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"日期", nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btnClick:) delegate:self title:Custing(@"确定", nil)  font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag=12;
        [view addSubview:sureDataBtn];
        
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btnClick:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        cancelDataBtn.tag = 14;
        [view addSubview:cancelDataBtn];
        
        if (!_DateChooseView) {
            _DateChooseView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
            _DateChooseView.delegate = self;
        }
        
        [_DateChooseView showUpView:_datePicker];
        [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
    }else if (btn.tag == 7){
        UIViewController *vc=[GPUtils getCurrentVC];
        [vc.view endEditing:YES];
        _DuringDatePicker = [[HKDatePickView alloc]initWithType:btn.tag WithTimeFormart:_formatter_SelectTime];
        _DuringDatePicker.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 200);
        _DuringDatePicker.delegate = self;
        NSString *dateStr;
        if ([NSString isEqualToNull:_txfield_content.text]) {
            dateStr=_txfield_content.text;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:_formatter_SelectTime];
            NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
            dateStr=currStr;
        }
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:_formatter_SelectTime];
        NSDate *fromdate=[format dateFromString:dateStr];
        _DuringDatePicker.curDate=fromdate;
        __weak typeof(self) weakSelf = self;
        [_DuringDatePicker setBlock:^(NSString *date, NSInteger type) {
            if (date) {
                weakSelf.txfield_content.text =date;
                if (weakSelf.TimeClickedBlock) {
                    weakSelf.TimeClickedBlock(weakSelf.model, date);
                }
            }
        }];
        [vc.view addSubview:_DuringDatePicker];
        [_DuringDatePicker showInView:vc.view];
        
    }else if (btn.tag == 8){
        
        ChangePhoneNumController *change = [[ChangePhoneNumController alloc]init];
        change.type = 2;
        __weak typeof(self) weakSelf = self;
        change.numDataChangeBlock = ^(NSString *numData, NSInteger type) {
            weakSelf.txfield_content.text = [NSString getSecretBankAccount:numData];
            if (weakSelf.viewClickedBackBlock) {
                weakSelf.viewClickedBackBlock(numData);
            }
        };
        [[AppDelegate appDelegate].topViewController.navigationController pushViewController:change animated:YES];
    }else if (btn.tag==12){//确定选择日期
        if (_selectDataString) {
            _txfield_content.text =_selectDataString;
            if (self.TimeClickedBlock) {
                self.TimeClickedBlock(_model, _selectDataString);
            }
        }
        [_DateChooseView remove];
    }else if (btn.tag==13){//增加明细等按钮
        btn.selected = !btn.selected;
        if (self.FormClickedBlock) {
            self.FormClickedBlock(nil);
        }
    }else if (btn.tag == 14){
        [_DateChooseView remove];
        _DateChooseView = nil;
        _datePicker = nil;
    }
}

-(void)DateChanged:(UIDatePicker *)sender{
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:_formatter_SelectTime];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    _selectDataString=str;
}
#pragma mark - delegate
-(void)dimsissPDActionView{
    _DateChooseView = nil;
}
//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_curFormViewType==formViewEnterAmout) {
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        //        if ((match == 1||[string isEqualToString:@""])&&self.AmountChangedBlock) {
        //            self.AmountChangedBlock(toBeString);
        //        }
        return match!= 0;
    }else if (_curFormViewType==formViewEnterNegAmout) {
        NSString *pattern;
        pattern = @"^-?((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        //        if ((match == 1||[string isEqualToString:@""])&&self.AmountChangedBlock) {
        //            self.AmountChangedBlock(toBeString);
        //        }
        return match!= 0;
    }else if (_curFormViewType==formViewEnterExchange){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,3})(\\.[0-9]{0,5})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        //        if ((match == 1||[string isEqualToString:@""])&&self.ExchangeChangedBlock) {
        //            self.ExchangeChangedBlock(toBeString);
        //        }
        return match!= 0;
    }else if (_curFormViewType==formViewEnterNum){
        NSString *pattern;
        pattern = @"^([1-9][0-9]{0,4})?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (_curFormViewType==formViewEnterDays){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,3})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (_curFormViewType==formViewEnterHalfNum){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,3})(\\.[0,5]{0,1})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else{
        if (_model.enterLimit) {
            if (textField.text.length>=_model.enterLimit) {
                return NO;
            }
        }else if (textField.text.length>=255) {
            return NO;
        }
    }
    return YES;
}
-(void)textFieldChanged{
    if (_curFormViewType==formViewEnterExchange) {
        if (self.ExchangeChangedBlock) {
            self.ExchangeChangedBlock(self.txfield_content.text);
        }
    }else if (_curFormViewType == formViewEnterAmout || _curFormViewType == formViewEnterNegAmout){
        if (self.AmountChangedBlock) {
            self.AmountChangedBlock(self.txfield_content.text);
        }
    }else if (_curFormViewType == formViewEnterDays || _curFormViewType == formViewEnterHalfNum){
        if (self.AmountChangedBlock) {
            self.AmountChangedBlock(self.txfield_content.text);
        }
    }else if (_curFormViewType == formViewEnterText){
        if (self.TextChangedBlock) {
            self.TextChangedBlock(self.txfield_content.text);
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_model.enterLimit) {
        if (textField.text.length>=_model.enterLimit) {
            textField.text = [textField.text substringToIndex:_model.enterLimit];
        }
    }else if (textField.text.length>=255) {
        textField.text = [textField.text substringToIndex:255];
    }
}
//MARK:-textView代理事件
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView==_txview_content) {
        _txview_content.text = textView.text;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==_txview_content) {
        if (_txview_content.text.length == 0) {
            _txv_subview.hidden = NO;
        }else{
            _txv_subview.hidden = YES;
        }
    }
    if (self.TextChangedBlock) {
        self.TextChangedBlock(textView.text);
    }
}
-(void)RemarkTextViewEditChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length == 0) {
        _txv_subview.hidden = NO;
    }else{
        _txv_subview.hidden = YES;
    }
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (_model.enterLimit) {
                if (toBeString.length>=_model.enterLimit) {
                    textField.text = [toBeString substringToIndex:_model.enterLimit];
                }
            }else if (toBeString.length>=255) {
                textField.text = [toBeString substringToIndex:255];
            }
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (_model.enterLimit) {
            if (toBeString.length>=_model.enterLimit) {
                textField.text = [toBeString substringToIndex:_model.enterLimit];
            }
        }else if (toBeString.length>=255) {
            textField.text = [toBeString substringToIndex:255];
        }
    }
}
//MARK:通知释放
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)startVoice{
    _selectBtn.userInteractionEnabled=NO;
    
    if(_iflyRecognizerView == nil)
    {
        [self initRecognizer];
    }
    [_txview_content resignFirstResponder];
    
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iflyRecognizerView start];
}
/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    //有界面
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示剧中
        UIViewController *vc=[GPUtils getCurrentVC];
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:vc.view.center];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iflyRecognizerView.delegate = self;
    
    if (_iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 140, 10)];
        view.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2+90);
        view.backgroundColor=[GPUtils colorHString:@"#35383a"];
        [_iflyRecognizerView addSubview:view];
    }
    
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"errorCode:%d",[error errorCode]);
    _selectBtn.userInteractionEnabled=YES;
}
/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _txv_subview.hidden = YES;
    _txview_content.text = [NSString stringWithFormat:@"%@%@",_txview_content.text,result];
    
}
/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void)setOtherHeight:(NSInteger)OtherHeight{
    [_baseView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo((self.height+OtherHeight));
    }];
    
    self.frame=CGRectMake(0, 0, Main_Screen_Width, _height+OtherHeight);
    
    _txfield_content.frame=CGRectMake(12+XBHelper_Title_Width+15,_height,Main_Screen_Width-12-15-XBHelper_Title_Width-12, OtherHeight);
    
    _lab_title.frame=CGRectMake(0, 0, XBHelper_Title_Width, OtherHeight);
    _lab_title.center=CGPointMake(12+XBHelper_Title_Width/2, _height+OtherHeight/2);
    
}
-(void)setCateImg:(NSString *)cateImg{
    if (_curFormViewType==formViewSelectCate||_curFormViewType==formViewShowCate) {
        _img_cate.image =[UIImage imageNamed:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",cateImg]]?[NSString stringWithFormat:@"%@",cateImg]:@"15"];
    }
}

-(SubmitFormView *)initBaseView:(UIView *)baseView WithContent:(id)txf  WithFormType:(formViewType)formViewType WithSegmentType:(segmentType)segmentType WithString:(NSString *)string WithTips:(NSString *)tips WithInfodict:(NSDictionary *)dict{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=string;
    model.tips=tips;
    return [self initBaseView:baseView WithContent:txf WithFormType:formViewType WithSegmentType:segmentType Withmodel:model WithInfodict:dict];
}

-(SubmitFormView *)initBaseView:(UIView *)baseView WithContent:(id)txf  WithFormType:(formViewType)formViewType WithSegmentType:(segmentType)segmentType WithString:(NSString *)string WithInfodict:(NSDictionary *)dict WithTips:(NSString *)tips WithNumLimit:(NSInteger)enterLimit{
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    model.Description=string;
    model.tips=tips;
    if (enterLimit>0) {
        model.enterLimit=enterLimit;
    }
    return [self initBaseView:baseView WithContent:txf WithFormType:formViewType WithSegmentType:segmentType Withmodel:model WithInfodict:dict];
    
}
-(SubmitFormView *)initAddBtbWithBaseView:(UIView *)baseView withTitle:(NSString *)title withTitleAlignment:(NSInteger)alignment withImageArray:(NSArray *)imgArray withBtnLocation:(NSInteger)location withlineStyle:(NSInteger)lineStyle{
    
    self = [super init];
    if (self) {
        _baseView=baseView;
        
        _baseView.backgroundColor=Color_form_TextFieldBackgroundColor;
        
        float height=0;
        if (lineStyle==1) {
            height=10;
            _SegmentLineView=[[UIView alloc]init];
            _SegmentLineView.frame=CGRectMake(0, 0, Main_Screen_Width, 10);
            _SegmentLineView.backgroundColor=Color_White_Same_20;
            [self addSubview:_SegmentLineView];
        }else{
            height=0.5;
            _SegmentLineView=[[UIView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
            _SegmentLineView.backgroundColor=Color_GrayLight_Same_20;
            [self addSubview:_SegmentLineView];
        }
        
        UIButton *btns=[GPUtils createButton:CGRectZero action:@selector(btnClick:) delegate:self title:nil font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
        btns.tag=13;
        [btns setImage:[UIImage imageNamed:imgArray[0]] forState:UIControlStateNormal];
        [btns setImage:[UIImage imageNamed:imgArray[0]] forState:UIControlStateSelected];
        if (imgArray.count>1) {
            [btns setImage:[UIImage imageNamed:imgArray[1]] forState:UIControlStateSelected];
        }
        [self addSubview:btns];

//        @param alignment 文字所居位置(0左边 1右边)
//        @param location 按钮位置(0居中1居右)
        CGSize size = [[NSString stringWithFormat:@" %@",title] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 50) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 15;
        CGFloat btnWidth = titleWidth + imageWidth + 20;
        if (location==0) {
            if (alignment==0) {
                btns.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
                btns.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
                [btns setTitle:[NSString stringWithFormat:@"%@ ",title] forState:UIControlStateNormal];
                [btns setTitle:[NSString stringWithFormat:@"%@ ",title] forState:UIControlStateSelected];
                [btns makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(height);
                    make.centerX.equalTo(self);
                    make.size.equalTo(CGSizeMake(btnWidth, 50));
                }];
            }else{
                [btns setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
                [btns setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateSelected];
                [btns makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(height);
                    make.centerX.equalTo(self);
                    make.size.equalTo(CGSizeMake(btnWidth, 50));
                }];
            }
        }else{
            if (alignment==0) {
                btns.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth+9, 0, imageWidth-9);
                btns.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+9, 0, -titleWidth-9);
                [btns setTitle:[NSString stringWithFormat:@"%@ ",title] forState:UIControlStateNormal];
                [btns setTitle:[NSString stringWithFormat:@"%@ ",title] forState:UIControlStateSelected];
                [btns makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(height);
                    make.right.equalTo(self.right).offset(@-12);
                    make.size.equalTo(CGSizeMake(btnWidth, 50));
                }];
            }else{
                [btns setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
                [btns setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateSelected];
                btns.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [btns makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(height);
                    make.right.equalTo(self.right).offset(@-12);
                    make.size.equalTo(CGSizeMake(btnWidth, 50));
                }];
            }
        }
        
        [_baseView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(50+height);
        }];
        self.frame=CGRectMake(0, 0, Main_Screen_Width, 50+height);
    }
    return self;
}

-(SubmitFormView *)initDuringTimeViewWithBaseView:(UIView *)baseView Withmodel:(MyProcurementModel *)model WithType:(NSInteger)DuringType WithTimeFormart:(NSString *)DuringFormat WithFormType:(formViewType)formViewType{
    self = [super init];
    if (self) {
        _baseView=baseView;
        _model=model;
        _DuringType=DuringType;
        _DuringFormat=DuringFormat;
        _curFormViewType=formViewType;
        [self updateDuringTimeWithType:DuringType];
        
    }
    return self;
}
-(void)updateDuringTimeWithType:(NSInteger)type{
    if (_curFormViewType==formViewSelect) {
        [_baseView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@90);
        }];
        
        if (type==1) {
            [_baseView addSubview:[self createLineView]];
            self.frame=CGRectMake(0, 0, Main_Screen_Width/2, 90);
            
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2, 10, 1, 80)];
            image.backgroundColor = Color_GrayLight_Same_20;
            [self addSubview:image];
            
            UILabel *title=[GPUtils createLable:CGRectMake(0,0,70, 16) text:[NSString stringWithFormat:@"%@",_model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            title.center=CGPointMake(47, 35);
            [self addSubview:title];
            
            _DuringMonthDayLabel=[GPUtils createLable:CGRectMake(0, 0, 150, 20)];
            _DuringMonthDayLabel.center=CGPointMake(Main_Screen_Width/2-90, 36);
            _DuringMonthDayLabel.textAlignment=2;
            [self addSubview:_DuringMonthDayLabel];
            
            _DuringTimeLabel=[GPUtils createLable:CGRectMake(0, 0, 100, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:2];
            _DuringTimeLabel.center=CGPointMake(Main_Screen_Width/2-65, 66);
            [self addSubview:_DuringTimeLabel];
            
            UIButton *statebtn=[GPUtils createButton:CGRectMake(60, 10, Main_Screen_Width/2, 80) action:@selector(btn_Click:) delegate:self];
            statebtn.tag = 102;
            [self addSubview:statebtn];
            
            _DuringTime=_model.fieldValue;
            
            NSMutableArray *array=[GPUtils transformTimeString:_DuringTime WithTimeFormat:_DuringFormat];
            _DuringMonthDayLabel.attributedText=array[0];
            _DuringTimeLabel.text=array[1];
            
        }else if (type==2){
            self.frame=CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2, 80);
            
            UILabel *endtitle=[GPUtils createLable:CGRectMake(0,0,70, 16) text:[NSString stringWithFormat:@"%@",_model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            endtitle.center=CGPointMake(47, 35);
            [self addSubview:endtitle];
            
            _DuringMonthDayLabel=[GPUtils createLable:CGRectMake(0, 0, 150, 20)];
            _DuringMonthDayLabel.center=CGPointMake(Main_Screen_Width/2-90, 36);
            _DuringMonthDayLabel.textAlignment=2;
            [self addSubview:_DuringMonthDayLabel];
            
            _DuringTimeLabel=[GPUtils createLable:CGRectMake(0, 0, 100, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:2];
            _DuringTimeLabel.center=CGPointMake(Main_Screen_Width/2-65, 66);
            [self addSubview:_DuringTimeLabel];
            
            UIButton *endbtn=[GPUtils createButton:CGRectMake(60, 10, Main_Screen_Width/2, 80) action:@selector(btn_Click:) delegate:self];
            endbtn.tag = 103;
            [self addSubview:endbtn];
            
            _DuringTime=_model.fieldValue;
            
            NSMutableArray *array=[GPUtils transformTimeString:_DuringTime WithTimeFormat:_DuringFormat];
            _DuringMonthDayLabel.attributedText=array[0];
            _DuringTimeLabel.text=array[1];
        }
    }else{
        [_baseView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@75);
        }];
        if (type==1) {
            [_baseView addSubview:[self createLine1View]];
            self.frame=CGRectMake(0, 0, Main_Screen_Width/2, 75);
            
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2, 0, 1, 75)];
            image.backgroundColor = Color_GrayLight_Same_20;
            [self addSubview:image];
            
            UILabel *title=[GPUtils createLable:CGRectMake(0,0,40, 16) text:[NSString stringWithFormat:@"%@",_model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            title.center=CGPointMake(32, 20);
            [self addSubview:title];
            
            UILabel *startMonLab=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width/2-65, 20)];
            startMonLab.center=CGPointMake(Main_Screen_Width/4+10, 25);
            startMonLab.textAlignment=2;
            [self addSubview:startMonLab];
            
            UILabel *startTimeLab=[GPUtils createLable:CGRectMake(0, 0, 100, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:2];
            startTimeLab.center=CGPointMake(Main_Screen_Width/2-75, 54);
            [self addSubview:startTimeLab];
            
            if ([NSString isEqualToNull:_model.fieldValue]) {
                NSString *str=_model.fieldValue;
                NSMutableArray *array=[GPUtils transformTimeString:str];
                startMonLab.attributedText=array[0];
                startTimeLab.text=array[1];
            }
        }else{
            self.frame=CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2, 75);
            
            UILabel *endtitle=[GPUtils createLable:CGRectMake(0,0,40, 16) text:[NSString stringWithFormat:@"%@",_model.Description] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            endtitle.center=CGPointMake(32, 20);
            [self addSubview:endtitle];
            
            UILabel *endMonLab=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width/2-65, 20)];
            endMonLab.center=CGPointMake(Main_Screen_Width/4+10, 25);
            endMonLab.textAlignment=2;
            [self addSubview:endMonLab];
            
            UILabel *endTimeLab=[GPUtils createLable:CGRectMake(0, 0, 100, 20) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:2];
            endTimeLab.center=CGPointMake(Main_Screen_Width/2-75, 54);
            [self addSubview:endTimeLab];
            
            if ([NSString isEqualToNull:_model.fieldValue]) {
                NSString *str=_model.fieldValue;
                NSMutableArray *array=[GPUtils transformTimeString:str];
                endMonLab.attributedText=array[0];
                endTimeLab.text=array[1];
            }
        }
    }
}

-(UIView *)createLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}
//MARK:表单头视图(高度1)
-(UIView *)createLine1View{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
    view.backgroundColor=Color_GrayLight_Same_20;
    return view;
}
-(void)btn_Click:(UIButton *)btn{
    NSLog(@"期间选择");
    UIViewController *vc=[GPUtils getCurrentVC];
    [vc.view endEditing:YES];
    _DuringDatePicker = [[HKDatePickView alloc]initWithType:btn.tag WithTimeFormart:_DuringFormat];
    _DuringDatePicker.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 200);
    _DuringDatePicker.delegate = self;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:_DuringFormat];
    NSDate *fromdate=[format dateFromString:_DuringTime];
    _DuringDatePicker.curDate=fromdate;
    [vc.view addSubview:_DuringDatePicker];
    [_DuringDatePicker showInView:vc.view];
}
//MARK:日期选择代理
-(void)didFinishPickView:(NSString *)date withType:(NSInteger)type
{
    if (type==102) {
        _DuringTime=date;
        NSMutableArray *array=[GPUtils transformTimeString:date WithTimeFormat:_DuringFormat];
        _DuringMonthDayLabel.attributedText=array[0];
        _DuringTimeLabel.text=array[1];
        if (self.ChooseTimeBlock) {
            self.ChooseTimeBlock(date, type-101);
        }
        
    }else if (type==103){
        _DuringTime=date;
        NSMutableArray *array=[GPUtils transformTimeString:date WithTimeFormat:_DuringFormat];
        _DuringMonthDayLabel.attributedText=array[0];
        _DuringTimeLabel.text=array[1];
        if (self.ChooseTimeBlock) {
            self.ChooseTimeBlock(date, type-101);
        }
    }
}


-(SubmitFormView *)initWithBaseView:(UIView *)baseView WithSwitch:(UISwitch *)swh WithString:(NSString *)string WithInfo:(BOOL)isOpen WithTips:(NSString *)tips{
    self = [super init];
    if (self) {
        _baseView=baseView;
        
        _SegmentLineView=[[UIView alloc]init];
        _SegmentLineView.backgroundColor=Color_White_Same_20;
        [self addSubview:_SegmentLineView];
        [_SegmentLineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.width.equalTo(self);
            make.height.equalTo(@10);
        }];
        
        _lab_title=[GPUtils createLable:CGRectZero text:string font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_title.text=[NSString stringWithIdOnNO:string];
        _lab_title.numberOfLines=0;
        [self addSubview:_lab_title];
        [_lab_title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.SegmentLineView.bottom);
            make.left.equalTo(self.left).offset(@12);
            make.width.equalTo(@(XBHelper_Title_Width));
            make.bottom.equalTo(self.bottom);
        }];
        
        UILabel *desLab=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentLeft];
        desLab.text=[NSString stringIsExist:tips];
        desLab.numberOfLines=0;
        [self addSubview:desLab];
        CGSize size1 = [tips sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-15-XBHelper_Title_Width-75, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        
        NSInteger height=(20+size1.height)>50?20+size1.height:50;
        
        [desLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.SegmentLineView.bottom);
            make.left.equalTo(self.left).offset(@(12+15+XBHelper_Title_Width));
            make.right.equalTo(self.right).offset(@-75);
            make.height.equalTo(@(height));
        }];
        
        swh.backgroundColor = [UIColor clearColor];
        [swh setOn: isOpen animated:YES];
        swh.onTintColor = Color_Blue_Important_20;
        [swh addTarget:self action:@selector(ClickSwitch:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:swh];
        [swh makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(@(10+height/2-15));
            make.right.equalTo(self.right).offset(@-12);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
            
        }];

        [_baseView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height+10));
        }];
        
        self.frame=CGRectMake(0, 0, Main_Screen_Width, height+10);
 
    }
    return  self;
    
}
-(void)ClickSwitch:(UISwitch *)obj{
    if (self.viewClickedBackBlock) {
        self.viewClickedBackBlock(obj.on ? @1:@0);
    }
}

@end
