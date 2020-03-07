//
//  ReservedView.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReservedView.h"
#import "ChooseCateFreshController.h"

@interface ReservedView ()<UITextFieldDelegate>

@property (nonatomic , copy) SelectListViewBlock block;
@property (nonatomic , copy) SelectListViewHeightBlock heightBlock;
@property (nonatomic, assign) NSInteger isBlock;
@end
@implementation ReservedView

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model block:(SelectListViewHeightBlock)block{
    ReservedView *view = [self init:txf model:model titleWidth:XBHelper_Title_Width block:^(MyProcurementModel *model, UITextField *contextFiled) {
        
    }];
    self.heightBlock = block;
    if (self.heightBlock) {
        self.heightBlock(self.int_height);
    }
    return view;
}

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model Y:(NSInteger)Y block:(SelectListViewHeightBlock)block txfblock:(SelectListViewBlock)txfblock{
    if (self.block) {
        self.block = txfblock;
    }
    __block SelectListViewBlock sb = txfblock;
    ReservedView *view = [self init:txf model:model titleWidth:XBHelper_Title_Width block:^(MyProcurementModel *model, UITextField *contextFiled) {
        sb(model,contextFiled);
    }];
    self.isBlock = 1;
    self.heightBlock = block;
    if (self.heightBlock) {
        self.heightBlock(self.int_height);
    }
    view.frame = CGRectMake(X(view), Y, WIDTH(view), HEIGHT(view));
    return view;
}

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidth:(float)width block:(SelectListViewBlock)block{
    if (self) {
        self = [[ReservedView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, _int_height)];
    }
    _int_height = 50;
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@",model.Description] font:Font_Important_15_20 maxSize:CGSizeMake(XBHelper_Title_Width, MAXFLOAT)];
    if (size.height>_int_height) {
        _int_height = size.height;
        _int_height = _int_height +10;
    }
    self.frame = CGRectMake(X(self), Y(self), WIDTH(self), _int_height);
    _lab_title=[GPUtils createLable:CGRectMake(12,0,width, _int_height) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self addSubview:_lab_title];
    _lab_title.numberOfLines = 0;
    txf.font = Font_Important_15_20;
    txf.textColor = Color_form_TextField_20;
    txf.delegate = self;
    
    if ([model.ctrlTyp isEqualToString:@"text"]) {
        txf.frame=CGRectMake(width+27,0,Main_Screen_Width-width-39, 50);
        if ([model.isRequired intValue]==1) {
            if ([NSString isEqualToNull:model.tips]) {
                txf.placeholder = [NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)",nil)];
            }else{
                txf.placeholder = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),Custing(@"(必填)",nil)];
            }
        }else{
            txf.placeholder = [NSString isEqualToNull:model.tips]?model.tips:Custing(@"请输入", nil);
        }
        [self addSubview:txf];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text=model.fieldValue;
        }
    }else if ([model.ctrlTyp isEqualToString:@"date"]){
        txf.frame=CGRectMake(width+27,0,Main_Screen_Width-width-65, 50);
        if ([model.isRequired intValue]==1) {
            if ([NSString isEqualToNull:model.tips]) {
                txf.placeholder = [NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)",nil)];
            }else{
                txf.placeholder = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),Custing(@"(必选)",nil)];
            }
        }else{
            txf.placeholder = [NSString isEqualToNull:model.tips]?model.tips:Custing(@"请选择", nil);
        }
        txf.userInteractionEnabled = NO;
        txf.textAlignment=NSTextAlignmentLeft;
        [self addSubview:txf];
        
        UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 15, 20, 20) imageName:@"skipImage"];
        [self addSubview:image];
        
        UIButton *btn = [GPUtils createButton:CGRectMake(width+27, 0, Main_Screen_Width-width-10, 50) action:@selector(btn_View_Click:) delegate:self];
        if (txf.tag == 1) {
            btn.tag = 3;
        }else if (txf.tag == 2){
            btn.tag = 4;
        }else{
            btn.tag = 1;
        }
        [self addSubview:btn];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text = model.fieldValue;
        }
    }else if ([model.ctrlTyp isEqualToString:@"dialog"]){
        txf.frame=CGRectMake(width+27,0,Main_Screen_Width-width-65, 50);
        txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必选)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请选择",nil);
        txf.userInteractionEnabled = NO;
        txf.textAlignment=NSTextAlignmentLeft;
        [self addSubview:txf];
        
        UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 15, 20, 20) imageName:@"skipImage"];
        [self addSubview:image];
        
        UIButton *btn = [GPUtils createButton:CGRectMake(width+27, 0, Main_Screen_Width-width-10, 50) action:@selector(btn_View_Click:) delegate:self];
        btn.tag = 2;
        [self addSubview:btn];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text = model.fieldValue;
        }
    }else if ([model.ctrlTyp isEqualToString:@"multi"]){
        txf.frame=CGRectMake(width+27,0,Main_Screen_Width-width-65, 50);
        txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必选)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请选择",nil);
        txf.userInteractionEnabled = NO;
        txf.textAlignment=NSTextAlignmentLeft;
        [self addSubview:txf];
        
        UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 15, 20, 20) imageName:@"skipImage"];
        [self addSubview:image];
        
        UIButton *btn = [GPUtils createButton:CGRectMake(width+27, 0, Main_Screen_Width-width-10, 50) action:@selector(btn_View_Click:) delegate:self];
        btn.tag = 5;
        [self addSubview:btn];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text = model.fieldValue;
        }
    }
    
    if ([[NSString stringWithFormat:@"%@",model.isOnlyRead]isEqualToString:@"1"]) {
        self.userInteractionEnabled = NO;
        txf.placeholder =nil;
    }
    
    _block=block;
    _txf_content = txf;
    _model = model;
    return self;
}

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidth:(float)width Y:(NSInteger)Y block:(SelectListViewBlock)block{
    _isBlock = 1;
    ReservedView *view = [[ReservedView alloc] init:txf model:model titleWidth:width block:block];
    view.isBlock = 1;
    view.frame = CGRectMake(X(view), Y, WIDTH(view), HEIGHT(view));
    return view;
}

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidth:(float)width Y:(NSInteger)Y MAXLength:(NSInteger)lenght block:(SelectListViewBlock)block{
    ReservedView *view = [[ReservedView alloc] init:txf model:model titleWidth:width Y:Y block:block];
    if (lenght>0) {
        txf.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^BOOL(UITextField *txf, NSRange range, NSString *str) {
            NSString *newString = [txf.text stringByReplacingCharactersInRange:range withString:str];
            newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if (newString.length>=lenght) {
                txf.text = [newString substringToIndex:lenght];
                return NO;
            }
            return YES;
        };
    }
    return view;
}

-(ReservedView *)init:(UITextField *)txf model:(MyProcurementModel *)model  titleWidthNoChangeContent:(float)width block:(SelectListViewBlock)block{
    if (self) {
        self = [[ReservedView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 50)];
    }
    _lab_title=[GPUtils createLable:CGRectMake(12,0,width, 50) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [self addSubview:_lab_title];
    _lab_title.numberOfLines = 0;
    txf.font = Font_Important_15_20;
    txf.textColor = Color_form_TextField_20;
    txf.delegate = self;
    
    if ([model.ctrlTyp isEqualToString:@"text"]) {
        txf.frame=CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-39, 50);
        txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请输入",nil);
        [self addSubview:txf];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text=model.fieldValue;
        }
    }else if ([model.ctrlTyp isEqualToString:@"date"]){
        txf.frame=CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-65, 50);
        txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必选)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请选择",nil);
        txf.userInteractionEnabled = NO;
        txf.textAlignment=NSTextAlignmentLeft;
        [self addSubview:txf];
        
        UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 15, 20, 20) imageName:@"skipImage"];
        [self addSubview:image];
        
        UIButton *btn = [GPUtils createButton:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-10, 50) action:@selector(btn_View_Click:) delegate:self];
        if (txf.tag == 1) {
            btn.tag = 3;
        }else if (txf.tag == 2){
            btn.tag = 4;
        }else{
            btn.tag = 1;
        }
        [self addSubview:btn];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text = model.fieldValue;
        }
    }else if ([model.ctrlTyp isEqualToString:@"dialog"]){
        txf.frame=CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-65, 50);
        txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必选)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请选择",nil);
        txf.userInteractionEnabled = NO;
        txf.textAlignment=NSTextAlignmentLeft;
        [self addSubview:txf];
        
        UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 15, 20, 20) imageName:@"skipImage"];
        [self addSubview:image];
        
        UIButton *btn = [GPUtils createButton:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-10, 50) action:@selector(btn_View_Click:) delegate:self];
        btn.tag = 2;
        [self addSubview:btn];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text = model.fieldValue;
        }
    }else if ([model.ctrlTyp isEqualToString:@"multi"]){
        txf.frame=CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-65, 50);
        txf.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必选)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:Custing(@"请选择",nil);
        txf.userInteractionEnabled = NO;
        txf.textAlignment=NSTextAlignmentLeft;
        [self addSubview:txf];
        
        UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-32, 15, 20, 20) imageName:@"skipImage"];
        [self addSubview:image];
        
        UIButton *btn = [GPUtils createButton:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-10, 50) action:@selector(btn_View_Click:) delegate:self];
        btn.tag = 5;
        [self addSubview:btn];
        
        if ([NSString isEqualToNull:model.fieldValue]) {
            txf.text = model.fieldValue;
        }
    }
    
    _block=block;
    _txf_content = txf;
    _model = model;
    return self;
}

-(void)btn_View_Click:(UIButton *)btn{
    UIViewController *view = [AppDelegate appDelegate].topViewController;
    [view.view endEditing:YES];
    NSLog(@"%ld", (long)btn.tag);
    [self endEditing:YES];
    switch (btn.tag) {
        case 1:
        {
            NSString *dateString;
            
            if (![NSString isEqualToNull:_txf_content.text]) {
                NSDate *date = [NSDate date];
                dateString= [NSString stringWithDate:date];
            }else{
                dateString=[_txf_content.text substringToIndex:10];
            }
            _dap_ExpenseDate = [[UIDatePicker alloc]init];
            NSDateFormatter *format=[[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy/MM/dd"];
            NSDate *fromdate=[format dateFromString:dateString];
            NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
            NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
            NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
            _dap_ExpenseDate.date=fromDate;
            userData *userdatas=[userData shareUserData];
            _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
            _dap_ExpenseDate.datePickerMode = UIDatePickerModeDate;
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"日期",nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_View_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            sureDataBtn.tag = 11;
            [view addSubview:sureDataBtn];
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_View_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            cancelDataBtn.tag = 14;
            [view addSubview:cancelDataBtn];
            if (!_cho_datelView) {
                _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
                _cho_datelView.delegate = self;
            }
            
            [_cho_datelView showUpView:_dap_ExpenseDate];
            [_cho_datelView show];
        }
            break;
        case 2:
        {
            if (self.isBlock != 1) {
                if (self.block) {
                    self.block(_model,_txf_content);
                }
            }else{
                MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
                vc.model=_model;
                vc.aimTextField=_txf_content;
                __weak typeof(self) weakSelf = self;
                [vc setBlock:^{
                    if (weakSelf.block) {
                        weakSelf.block(weakSelf.model,weakSelf.txf_content);
                    }
                }];
                [[AppDelegate appDelegate].topViewController.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        case 3:{
            NSString *dateString;
            
            if (![NSString isEqualToNull:_txf_content.text]) {
                dateString= [NSString GetstringFromDate];
            }else{
                dateString=[_txf_content.text substringToIndex:16];
            }
            _dap_ExpenseDate = [[UIDatePicker alloc]init];
            NSDateFormatter *format=[[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSDate *fromDate=[format dateFromString:dateString];
            _dap_ExpenseDate.date=fromDate;
            userData *userdatas=[userData shareUserData];
            _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
            _dap_ExpenseDate.datePickerMode = UIDatePickerModeDateAndTime;
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"时间",nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_View_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            sureDataBtn.tag = 12;
            [view addSubview:sureDataBtn];
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_View_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            cancelDataBtn.tag = 15;
            [view addSubview:cancelDataBtn];
            if (!_cho_datelView) {
                _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
                _cho_datelView.delegate = self;
            }
            
            [_cho_datelView showUpView:_dap_ExpenseDate];
            [_cho_datelView show];
        }
            break;
        case 4:
        {
            NSString *dateString;
            
            if (![NSString isEqualToNull:_txf_content.text]) {
                NSDate *date = [NSDate date];
                dateString= [NSString stringWithDate:date];
            }else{
                dateString=[_txf_content.text substringToIndex:10];
            }
            _dap_ExpenseDate = [[UIDatePicker alloc]init];
            NSDateFormatter *format=[[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy/MM/dd"];
            NSDate *fromdate=[format dateFromString:dateString];
            NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
            NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
            NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
            _dap_ExpenseDate.date=fromDate;
            userData *userdatas=[userData shareUserData];
            _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
            _dap_ExpenseDate.datePickerMode = UIDatePickerModeDate;
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"日期",nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_View_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            sureDataBtn.tag = 13;
            [view addSubview:sureDataBtn];
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_View_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            cancelDataBtn.tag = 16;
            [view addSubview:cancelDataBtn];
            if (!_cho_datelView) {
                _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
                _cho_datelView.delegate = self;
            }
            
            [_cho_datelView showUpView:_dap_ExpenseDate];
            [_cho_datelView show];
        }
            break;
        case 5:
        {
            if (self.isBlock != 1) {
                if (self.block) {
                    self.block(_model,self.txf_content);
                }
            }else{
                
                ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
                vc.ChooseModel=_model;
                vc.isMultiSelect=YES;
                __weak typeof(self) weakSelf = self;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    NSMutableArray *arr=[NSMutableArray array];
                    for (ChooseCateFreModel *model in array) {
                        [arr addObject:model.name];
                    }
                    weakSelf.txf_content.text=[GPUtils getSelectResultWithArray:arr WithCompare:@","];
            
                    if (weakSelf.block) {
                        weakSelf.block(weakSelf.model,weakSelf.txf_content);
                    }
                };
                [[AppDelegate appDelegate].topViewController.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 11:
        {
            NSDate * pickerDate = [_dap_ExpenseDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString * str = [pickerFormatter stringFromDate:pickerDate];
            
            _txf_content.text = str;
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
            
            if (self.block&&self.isBlock == 1) {
                self.block(_model,_txf_content);
            }
        }
            break;
        case 12:
        {
            NSDate * pickerDate = [_dap_ExpenseDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSString * str = [pickerFormatter stringFromDate:pickerDate];
            
            _txf_content.text = str;
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;

            if (self.block&&self.isBlock == 1) {
                self.block(_model,_txf_content);
            }
        }
            break;
        case 13:
        {
            NSDate * pickerDate = [_dap_ExpenseDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString * str = [pickerFormatter stringFromDate:pickerDate];
            
            _txf_content.text = str;
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
            if (self.block&&self.isBlock == 1) {
                self.block(_model,_txf_content);
            }
        }
            break;
        case 14:{
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
        }
            break;
        case 15:{
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
        }
            break;
        case 16:{
            _dap_ExpenseDate = nil;
            [_cho_datelView remove];
            _cho_datelView = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark - delegate
-(void)dimsissPDActionView{
    _cho_datelView = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
