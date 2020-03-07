//
//  FormDetailBaseCell.m
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//


typedef NS_ENUM(NSUInteger, dateType) {
    dateSelectTime,//选择时间
    dateSelectDate,//选择日期
    dateSelectDateTime//选择日期时间
};
#import "FormDetailBaseCell.h"

@interface FormDetailBaseCell ()<UITextFieldDelegate,chooseTravelDateViewDelegate>

@property (nonatomic ,strong) UILabel  *lab_Title;
@property (nonatomic, strong) UIButton *btn_Contet;
@property (nonatomic, strong) UIImageView *img_Btn;
//@property (nonatomic, strong) UIImageView *img_ExpType;
@property (nonatomic, strong) UIView *view_Line;
@property (nonatomic, strong) MyProcurementModel *model;
@property (nonatomic, strong) id dModel;
//选择日期
@property (nonatomic, assign) dateType curDateType;
@property (nonatomic, strong) NSString *formatter_SelectTime;
@property (nonatomic, assign) UIDatePickerMode model_DatePick;
@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) chooseTravelDateView *DateChooseView;
@property (nonatomic, strong) NSString *selectDataString;
@property (nonatomic, assign) NSInteger int_Type;
@property (nonatomic, assign) NSInteger int_EnterLimit;

@end

@implementation FormDetailBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self createViews];
    }
    return self;
}
-(void)createViews{
    
    if (!_lab_Title) {
        _lab_Title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width, 50) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Title.numberOfLines=0;
        [self.contentView addSubview:_lab_Title];
    }
    [_lab_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.width.equalTo(XBHelper_Title_Width);
    }];
    
    if (!_img_Btn) {
        _img_Btn=[[UIImageView alloc]initWithFrame:CGRectZero];
        _img_Btn.image=[UIImage imageNamed:@"skipImage"];
        [self.contentView addSubview:_img_Btn];
    }
    [_img_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    if (!_txf_Contet) {
        _txf_Contet = [GPUtils createTextField:CGRectZero placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        [_txf_Contet addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_txf_Contet];
    }
    
    [_txf_Contet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.lab_Title.right).offset(15);
        make.right.equalTo(self.img_Btn.left);
    }];

    if (!_btn_Contet) {
        _btn_Contet=[GPUtils createButton:CGRectZero action:@selector(ClickBtn:) delegate:self];
        [self.contentView addSubview:_btn_Contet];
    }
    
    if (!_view_Line) {
        _view_Line = [[UIView alloc]initWithFrame:CGRectZero];
        _view_Line.backgroundColor = Color_White_Same_20;
        [self.contentView addSubview:_view_Line];
    }

}

//type 1输入 2选择
-(void)updateViewWithModel:(MyProcurementModel *)model type:(NSInteger)type{
    _int_Type = 0;
    _int_EnterLimit = 0;
    _btn_Contet.tag = 0;
    _txf_Contet.text = nil;
    _btn_Contet.frame=CGRectZero;
    _txf_Contet.userInteractionEnabled=YES;
    _txf_Contet.keyboardType = UIKeyboardTypeDefault;
    [_img_Btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    if (type==1) {
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _txf_Contet .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
            }else{
                _txf_Contet .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _txf_Contet .placeholder=Custing(@"请输入(必填)", nil);
            }else{
                _txf_Contet .placeholder=Custing(@"请输入", nil);
            }
        }
    }else if (type==2){
        _txf_Contet.userInteractionEnabled=NO;
        _View_PurchaseForm.userInteractionEnabled = NO;
        [_img_Btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(20, 20));
        }];
        _btn_Contet.frame=CGRectMake(40, 0, Main_Screen_Width-40, 50);
        if ([NSString isEqualToNull:model.tips]){
            if ([model.isRequired floatValue]==1) {
                _txf_Contet .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
            }else{
                _txf_Contet .placeholder=model.tips;
            }
        }else{
            if ([model.isRequired floatValue]==1) {
                _txf_Contet .placeholder=Custing(@"请选择(必选)", nil);
            }else{
                _txf_Contet .placeholder=Custing(@"请选择(必选)", nil);
                
            }
        }
    }
}

-(void)setCurDateType:(dateType)curDateType{
    _curDateType = curDateType;
    if (curDateType == dateSelectDate) {
        _formatter_SelectTime=@"yyyy/MM/dd";
        _model_DatePick=UIDatePickerModeDate;
    }else if (curDateType == dateSelectDateTime){
        _formatter_SelectTime=@"yyyy/MM/dd HH:mm";
        _model_DatePick=UIDatePickerModeDateAndTime;//UIDatePickerModeDateAndTime
    }else if (curDateType == dateSelectTime){
        _formatter_SelectTime=@"HH:mm";
        _model_DatePick=UIDatePickerModeTime;
    }
}
-(void)ClickBtn:(UIButton *)btn{
    if (btn.tag == 99) {
        UIViewController *vc=[GPUtils getCurrentVC];
        [vc.view endEditing:YES];
        _datePicker = [[UIDatePicker alloc]init];
        NSString *dateStr;
        if ([NSString isEqualToNull:_txf_Contet.text]) {
            dateStr=_txf_Contet.text;
            _selectDataString=_txf_Contet.text;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:_formatter_SelectTime];
            NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
            dateStr=currStr;
            _selectDataString=currStr;
        }
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:_formatter_SelectTime];
        NSDate *fromdate=[format dateFromString:dateStr];
        _datePicker.date=fromdate;
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
        
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(ClickBtn:) delegate:self title:Custing(@"确定", nil)  font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag=12;
        [view addSubview:sureDataBtn];
        
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(ClickBtn:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        cancelDataBtn.tag = 14;
        [view addSubview:cancelDataBtn];
        
        if (!_DateChooseView) {
            _DateChooseView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
            _DateChooseView.delegate = self;
        }
        
        [_DateChooseView showUpView:_datePicker];
        [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
    }else if (btn.tag == 12){
        if (_selectDataString) {
            _txf_Contet.text =_selectDataString;
            if (self.CellBackDataBlock) {
                self.CellBackDataBlock(self.IndexPath, self.txf_Contet, self.model, self.dModel);
            }
        }
        [_DateChooseView remove];

    }else if (btn.tag == 14){
        [_DateChooseView remove];
        _DateChooseView = nil;
        _datePicker = nil;
    }else{
        if (self.CellBackDataBlock) {
            self.CellBackDataBlock(self.IndexPath, self.txf_Contet, self.model, self.dModel);
        }
    }
}

-(void)DateChanged:(UIDatePicker *)sender{
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:_formatter_SelectTime];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    _selectDataString=str;
}

- (void)textValueChanged:(id)sender {
    if (self.CellBackDataBlock) {
        self.CellBackDataBlock(self.IndexPath, self.txf_Contet, self.model, self.dModel);
    }
}
#pragma mark - delegate
-(void)dimsissPDActionView{
    _DateChooseView = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_int_Type == 1) {
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (_int_Type == 2){
        NSString *pattern;
        pattern = @"^([1-9][0-9]{0,8})?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (_int_Type == 3){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,3})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (_int_Type == 4){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,1})(\\.[0-9]{0,2})?|100)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else{
        if (_int_EnterLimit > 0) {
            if (textField.text.length >= _int_EnterLimit) {
                return NO;
            }
        }else if (textField.text.length>=255) {
            return NO;
        }
    }
    return YES;
}

-(void)configOverTimeCellWithModel:(MyProcurementModel *)model withDetailsModel:(OverTimeDeatil *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    self.curDateType = dateSelectDateTime;
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    
    if ([model.fieldName isEqualToString:@"FromDate"]) {
        [self updateViewWithModel:model type:2];
        _btn_Contet.tag = 99;
        if ([NSString isEqualToNull:deModel.FromDate]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.FromDate];
        }
    }else  if ([model.fieldName isEqualToString:@"ToDate"]) {
        [self updateViewWithModel:model type:2];
        _btn_Contet.tag = 99;
        if ([NSString isEqualToNull:deModel.ToDate]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.ToDate];
        }
    }else  if ([model.fieldName isEqualToString:@"OverTime"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.OverTime]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.OverTime];
        }
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else  if ([model.fieldName isEqualToString:@"Type"]) {
        [self updateViewWithModel:model type:2];
        if ([NSString isEqualToNull:deModel.Type]) {
            switch ([deModel.Type integerValue]) {
                case 1:
                    _txf_Contet.text = Custing(@"工作日", );
                    break;
                case 2:
                    _txf_Contet.text = Custing(@"双休日", );
                    break;
                case 3:
                    _txf_Contet.text = Custing(@"法定节假日", );
                    break;
                case 4:
                    _txf_Contet.text = Custing(@"公司节假日", );
                    break;
                default:
                    break;
            }
        }
    } else if ([model.fieldName isEqualToString:@"AccountingModeId"]){
        [self updateViewWithModel:model type:2];
        if ([NSString isEqualToNull:deModel.AccountingMode]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.AccountingMode];
        }
    }else if ([model.fieldName isEqualToString:@"ExchangeHoliday"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.ExchangeHoliday]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.ExchangeHoliday];
        }
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Reason"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Reason]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.Reason];
        }
    }
    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
}
+ (CGFloat)cellOverTimeDetailHeightWithWithModel:(MyProcurementModel *)model withDetailsModel:(OverTimeDeatil *)deModel{
    CGFloat cellHeight = 50;
    if ([model.fieldName isEqualToString:@"ExchangeHoliday"]&&![deModel.AccountingModeId isEqualToString:@"2"]) {
        cellHeight = 0;
    }
    return cellHeight;
}

-(void)configItemCellWithModel:(MyProcurementModel *)model withDetailsModel:(ItemRequestDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];

    if ([model.fieldName isEqualToString:@"Name"]) {
        if ([model.ctrlTyp isEqualToString:@"dialog"]||[model.ctrlTyp isEqualToString:@"inventory"]) {
            [self updateViewWithModel:model type:2];
        }else{
            [self updateViewWithModel:model type:1];
        }
        if ([NSString isEqualToNull:deModel.Name]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Name];
        }
    }else  if ([model.fieldName isEqualToString:@"Brand"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Brand]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Brand];
        }
    }else  if ([model.fieldName isEqualToString:@"Spec"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Spec]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Spec];
        }
    }else  if ([model.fieldName isEqualToString:@"Unit"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Unit]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Unit];
        }
    }else  if ([model.fieldName isEqualToString:@"Qty"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Qty]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Qty];
        }
        _txf_Contet.keyboardType = UIKeyboardTypeNumberPad;
        _int_Type = 2;
    }else if ([model.fieldName isEqualToString:@"Price"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Price];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Amount];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else  if ([model.fieldName isEqualToString:@"UsedPart"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.UsedPart]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.UsedPart];
        }
    }else  if ([model.fieldName isEqualToString:@"UsedNode"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.UsedNode]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.UsedNode];
        }
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Remark]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Remark];
        }
    }
    
    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
}
//费用明细
-(void)configAddReimShareCellWithFormModel:(MyProcurementModel *)model withDataModel:(AddReimShareModel *)deModel{
    self.curDateType = dateSelectDate;
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    if ([model.fieldName isEqualToString:@"BranchId"]) {
        [self updateViewWithModel:model type:2];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Branch];
    }else if ([model.fieldName isEqualToString:@"RequestorDeptId"]){
        [self updateViewWithModel:model type:2];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.RequestorDept];
    }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]){
        [self updateViewWithModel:model type:2];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.RequestorBusDept];
    }else if ([model.fieldName isEqualToString:@"CostCenterId"]){
        [self updateViewWithModel:model type:2];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.CostCenter];
    }else if ([model.fieldName isEqualToString:@"ProjId"]){
        [self updateViewWithModel:model type:2];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.ProjName];
    }else if ([model.fieldName isEqualToString:@"Reserved1"]||[model.fieldName isEqualToString:@"Reserved2"]||[model.fieldName isEqualToString:@"Reserved3"]||[model.fieldName isEqualToString:@"Reserved4"]||[model.fieldName isEqualToString:@"Reserved5"]){
        if ([model.ctrlTyp isEqualToString:@"date"]||[model.ctrlTyp isEqualToString:@"dialog"]||[model.ctrlTyp isEqualToString:@"multi"]) {
            [self updateViewWithModel:model type:2];
            if ([model.ctrlTyp isEqualToString:@"date"]) {
                _btn_Contet.tag = 99;
            }
        }else{
            [self updateViewWithModel:model type:1];
        }
        _txf_Contet.text = [NSString stringWithIdOnNO:[deModel valueForKey:model.fieldName]];
    }else if ([model.fieldName isEqualToString:@"ShareRatio"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.ShareRatio];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 4;
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Amount];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Remark];
    }
    _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
}

//合同条款明细
-(void)configContractTermCellWithModel:(MyProcurementModel *)model withDetailsModel:(ContractTermDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    if ([model.fieldName isEqualToString:@"No"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.No]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.No];
        }
        _txf_Contet.keyboardType = UIKeyboardTypeNumberPad;
        _int_Type = 2;
    }else if ([model.fieldName isEqualToString:@"Terms"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Terms]) {
            _txf_Contet.text= [NSString stringWithFormat:@"%@",deModel.Terms];
        }
    }
    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
}
//付款方式用明细
-(void)configContractPayMethodCellWithModel:(MyProcurementModel *)model withDetailsModel:(ContractPayMethodDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    self.curDateType = dateSelectDate;
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    
    if ([model.fieldName isEqualToString:@"No"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.No]) {
            _txf_Contet.text = deModel.No;
        }
        _txf_Contet.keyboardType = UIKeyboardTypeNumberPad;
        _int_Type = 2;
    }else if ([model.fieldName isEqualToString:@"PayRatio"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.PayRatio];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Amount];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else  if ([model.fieldName isEqualToString:@"PayDate"]) {
        [self updateViewWithModel:model type:2];
        _btn_Contet.tag = 99;
        if ([NSString isEqualToNull:deModel.PayDate]) {
            _txf_Contet.text=deModel.PayDate;
        }
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Remark]) {
            _txf_Contet.text=deModel.Remark;
        }
    }else if ([model.fieldName isEqualToString:@"PaymentClause"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.PaymentClause]) {
            _txf_Contet.text=deModel.PaymentClause;
        }
    }
    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
}
//费用类别明细
-(void)configContractExpTypeCellWithModel:(MyProcurementModel *)model withDetailsModel:(ExpTypeDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    self.curDateType = dateSelectDate;
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    
    if ([model.fieldName isEqualToString:@"LocalCyAmount"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.LocalCyAmount]) {
            _txf_Contet.text = deModel.LocalCyAmount;
        }
        _txf_Contet.keyboardType = UIKeyboardTypeNumberPad;
        _int_Type = 1;
    }else if([model.fieldName isEqualToString:@"ExpenseCode"]){
        [self updateViewWithModel:model type:2];
        
        _img_ExpType = [GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-12-20-32, 5, 32, 32) imageName:nil];
        [self.contentView addSubview:_img_ExpType];
        [_txf_Contet makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.img_ExpType.right);
        }];
        if ([NSString isEqualToNullAndZero:deModel.ExpenseCode]) {
            _txf_Contet.text = [GPUtils getSelectResultWithArray:@[deModel.ExpenseCat,deModel.ExpenseType]];
            _img_ExpType.image = [UIImage imageNamed:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",deModel.ExpenseIcon]]?[NSString stringWithFormat:@"%@", deModel.ExpenseIcon]:@"15"];
        }
    }
    else if ([model.fieldName isEqualToString:@"Amount"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Amount];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]) {
        [self updateViewWithModel:model type:2];
        if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",deModel.PurchaseInfo]]) {
            _txf_Contet.text=[NSString stringWithFormat:@"%@",deModel.PurchaseInfo];
        }
    }else if([model.fieldName isEqualToString:@"No"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.No]) {
            _txf_Contet.text = deModel.No;
        }
        _txf_Contet.keyboardType = UIKeyboardTypeNumberPad;
        _int_Type = 1;
    }

    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
}


-(void)configWareHouseEntryCellWithModel:(MyProcurementModel *)model withDetailsModel:(WareHouseEntryDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    
    if ([model.fieldName isEqualToString:@"Name"]) {
        if ([model.ctrlTyp isEqualToString:@"dialog"]) {
            [self updateViewWithModel:model type:2];
        }else{
            [self updateViewWithModel:model type:1];
        }
        if ([NSString isEqualToNull:deModel.Name]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Name];
        }
    }else  if ([model.fieldName isEqualToString:@"Brand"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Brand]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Brand];
        }
    }else  if ([model.fieldName isEqualToString:@"Spec"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Spec]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Spec];
        }
    }else  if ([model.fieldName isEqualToString:@"Unit"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Unit]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Unit];
        }
    }else  if ([model.fieldName isEqualToString:@"Qty"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Qty]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Qty];
        }
        _txf_Contet.keyboardType = UIKeyboardTypeNumberPad;
        _int_Type = 2;
    }else if ([model.fieldName isEqualToString:@"Price"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Price];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Amount"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Amount];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Remark"]) {
        [self updateViewWithModel:model type:1];
        if ([NSString isEqualToNull:deModel.Remark]) {
            _txf_Contet.text = [NSString stringWithFormat:@"%@",deModel.Remark];
        }
    }
    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
}


//合同审批新增年度费用明细
-(void)configContractYearExpCellWithModel:(MyProcurementModel *)model withDetailsModel:(ContractYearExpDetail *)deModel WithCount:(NSInteger)count WithIndex:(NSInteger)index{
    _model = model;
    _dModel = deModel;
    _lab_Title.text=[NSString stringWithFormat:@"%@",model.Description];
    
    if ([model.fieldName isEqualToString:@"Year"]) {
        [self updateViewWithModel:model type:2];
        if ([NSString isEqualToNull:deModel.Year]) {
            _txf_Contet.text = deModel.Year;
        }
    }else if ([model.fieldName isEqualToString:@"TotalAmount"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.TotalAmount];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else if ([model.fieldName isEqualToString:@"Tax"]){
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.Tax];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
    }else  if ([model.fieldName isEqualToString:@"ExclTax"]) {
        [self updateViewWithModel:model type:1];
        _txf_Contet.text = [NSString stringWithIdOnNO:deModel.ExclTax];
        _txf_Contet.keyboardType = UIKeyboardTypeDecimalPad;
        _int_Type = 1;
//        _txf_Contet.userInteractionEnabled=NO;
    }
    if (index!=count-1) {
        _view_Line.frame=CGRectMake(X(_lab_Title), 49, Main_Screen_Width-X(_lab_Title), 1);
    }else{
        _view_Line.frame=CGRectZero;
    }
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
