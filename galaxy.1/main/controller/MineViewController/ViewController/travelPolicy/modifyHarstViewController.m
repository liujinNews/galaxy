//
//  modifyHarstViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
#import "modifyHarstViewController.h"

@interface modifyHarstViewController ()<UITextFieldDelegate,GPClientDelegate>
@property (nonatomic,strong)UISwitch * currerySw;
@property (nonatomic,strong)NSString * paramValue;
@property (nonatomic,strong)NSString * cityValue;
@property (nonatomic,strong)UILabel * isNoBal;

@property (nonatomic,strong)UIView * allView;

@property (nonatomic,strong)UIButton * allBtn;
@property (nonatomic,strong)UIButton * singleBtn;

@property (nonatomic,strong)GkTextField * allCityTF;
@property (nonatomic,strong)GkTextField * oneCityTF;
@property (nonatomic,strong)GkTextField * twoCityTF;
@property (nonatomic,strong)GkTextField * thirdlyCityTF;
@property (nonatomic,strong)GkTextField * fourthCityTF;
@property (nonatomic,strong)GkTextField * fifthlyCityTF;


@property (nonatomic,copy)NSString * housePrice0;
@property (nonatomic,copy)NSString * housePrice1;
@property (nonatomic,copy)NSString * housePrice2;
@property (nonatomic,copy)NSString * housePrice3;
@property (nonatomic,copy)NSString * housePrice4;
@property (nonatomic,copy)NSString * housePrice5;

@property (nonatomic,strong)UIButton * submitBtn;


@end

@implementation modifyHarstViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"住宿标准", nil) backButton:YES];
    self.paramValue = [NSString stringWithFormat:@"%@",self.data.isLimit];
    self.cityValue = [NSString stringWithFormat:@"%@",self.data.standard];
    self.housePrice0 = [NSString stringWithFormat:@"%@",self.data.housePrice0];
    self.housePrice1 = [NSString stringWithFormat:@"%@",self.data.housePrice1];
    self.housePrice2 = [NSString stringWithFormat:@"%@",self.data.housePrice2];
    self.housePrice3 = [NSString stringWithFormat:@"%@",self.data.housePrice3];
    self.housePrice4 = [NSString stringWithFormat:@"%@",self.data.housePrice4];
    self.housePrice5 = [NSString stringWithFormat:@"%@",self.data.housePrice5];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createAllPerhapsSingleView];
    [self createHeaderView];
    // Do any additional setup after loading the view.
}

//MARK:限制选择按钮
-(void)createHeaderView{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    headView.backgroundColor = Color_form_TextFieldBackgroundColor;
    UILabel * curreryA = [GPUtils createLable:CGRectMake(15, 0, WIDTH(headView)-137, 60) text:[NSString stringWithFormat:@"%@%@",Custing(@"员工级别：", nil),self.data.userLevel] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [headView  addSubview:curreryA];
    NSString * xianStr;
    if ([self.paramValue isEqualToString:@"0"]) {
        xianStr = Custing(@"不限制", nil);
        self.allView.hidden = YES;
    }else{
        xianStr = Custing(@"限制", nil);
        self.allView.hidden = NO;
    }
    self.isNoBal = [GPUtils createLable:CGRectMake(WIDTH(headView)-132, 0,60, 60) text:xianStr font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
    self.isNoBal.backgroundColor = [UIColor clearColor];
    [headView  addSubview:self.isNoBal];
    
    self.currerySw = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(headView)-62, 15, 0, 0)];
    self.currerySw.backgroundColor = [UIColor clearColor];
    if ([self.paramValue isEqualToString:@"0"]) {
        [self.currerySw setOn:[self.paramValue boolValue] animated:NO];
    }else{
        [self.currerySw setOn:[self.paramValue boolValue] animated:NO];
    }
    self.currerySw.tag = 101;
    [self.currerySw addTarget:self action:@selector(openModifyExchangeRateBtn:) forControlEvents:UIControlEventValueChanged];
    self.currerySw.onTintColor = Color_Blue_Important_20;
    
    [headView addSubview:self.currerySw];
    [self.view addSubview:headView];
}

-(void)openModifyExchangeRateBtn:(UISwitch *)btn{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"当前网络不可用，请检查您的网络设置" delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
        return;
    }
    switch (btn.tag) {
        case 101:
            if ([self.paramValue isEqualToString:@"0"]) {
                self.paramValue = @"1";
                self.isNoBal.text = Custing(@"限制", nil);
                self.allView.hidden = NO;
                [self.currerySw setOn:[self.paramValue boolValue] animated:YES];
                self.submitBtn.hidden = NO;
            }
            else
            {
                self.paramValue = @"0";
                self.isNoBal.text = Custing(@"不限制", nil);
                self.allView.hidden = YES;
                [self.currerySw setOn:[self.paramValue boolValue] animated:YES];
                self.submitBtn.hidden = YES;
                [self requestOpenTo];

            }
            break;
            
        default:
            break;
    }
}
//MARK:限制视图
-(void)createAllPerhapsSingleView{
    self.allView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 342)];
    self.allView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.allView];
    
    NSArray * setArr = @[
                         @{@"name":Custing(@"所有城市 ≤", nil)},
                         @{@"name":Custing(@"一线城市 ≤", nil)},
                         @{@"name":Custing(@"二线城市 ≤", nil)},
                         @{@"name":Custing(@"三线城市 ≤", nil)},
                         @{@"name":Custing(@"港澳台 ≤", nil)},
                         @{@"name":Custing(@"国际城市 ≤", nil)}];
    
    
    for (int j = 0 ; j <setArr.count ; j ++ ) {
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, j*57, WIDTH(self.allView), 57)];
        whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.allView  addSubview:whiteView];
        
        UILabel * cityLbl = [GPUtils createLable:CGRectMake(50, 0,120, 57) text:[[setArr objectAtIndex:j]objectForKey:@"name"] font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        cityLbl.backgroundColor = [UIColor clearColor];
        [whiteView  addSubview:cityLbl];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 56.5, WIDTH(self.allView)-30, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [whiteView  addSubview:lineView];
    }
    
    self.allBtn = [GPUtils createButton:CGRectMake(15, 20, 20, 20) action:@selector(isEnabledCity:) delegate:self title:@"" font:nil titleColor:nil];
    self.allBtn.tag =101;
    [self.allView addSubview:self.allBtn];
    
    
    self.singleBtn = [GPUtils createButton:CGRectMake(15, 77, 20, 20) action:@selector(isEnabledCity:) delegate:self title:@"" font:nil titleColor:nil];
    self.singleBtn.tag = 102;
    if ([self.cityValue isEqualToString:@"1"]) {
        [self.singleBtn setBackgroundImage:GPImage(@"MyApprove_Select") forState:UIControlStateNormal];
        [self.allBtn setBackgroundImage:GPImage(@"MyApprove_UnSelect") forState:UIControlStateNormal];
    }else{
        [self.allBtn setBackgroundImage:GPImage(@"MyApprove_Select") forState:UIControlStateNormal];
        [self.singleBtn setBackgroundImage:GPImage(@"MyApprove_UnSelect") forState:UIControlStateNormal];
    }
    
    [self.allView addSubview:self.singleBtn];
    
    
    self.allCityTF =[[GkTextField alloc]initWithFrame:CGRectMake(170, 15, ScreenRect.size.width-185, 27)];
    self.allCityTF.placeholder = Custing(@"请输入限制金额", nil);
    self.allCityTF.font = Font_Important_15_20;
    self.allCityTF.textColor = Color_form_TextField_20;
    self.allCityTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.allCityTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.allCityTF.adjustsFontSizeToFitWidth = YES;
    self.allCityTF.delegate=self;
    self.allCityTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.allView addSubview:self.allCityTF];
    
    self.oneCityTF =[[GkTextField alloc]initWithFrame:CGRectMake(170, 72, ScreenRect.size.width-185, 27)];
    self.oneCityTF.placeholder = Custing(@"请输入限制金额", nil);
    self.oneCityTF.font = Font_Important_15_20;
    self.oneCityTF.textColor = Color_form_TextField_20;
    self.oneCityTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.oneCityTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.oneCityTF.adjustsFontSizeToFitWidth = YES;
    self.oneCityTF.delegate=self;
    self.oneCityTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.allView addSubview:self.oneCityTF];
    
    self.twoCityTF =[[GkTextField alloc]initWithFrame:CGRectMake(170, 129, ScreenRect.size.width-185, 27)];
    self.twoCityTF.placeholder = Custing(@"请输入限制金额", nil);
    self.twoCityTF.font = Font_Important_15_20;
    self.twoCityTF.textColor = Color_form_TextField_20;
    self.twoCityTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.twoCityTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.twoCityTF.adjustsFontSizeToFitWidth = YES;
    self.twoCityTF.delegate=self;
    self.twoCityTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.allView addSubview:self.twoCityTF];
    
    self.thirdlyCityTF =[[GkTextField alloc]initWithFrame:CGRectMake(170, 186, ScreenRect.size.width-185, 27)];
    self.thirdlyCityTF.placeholder = Custing(@"请输入限制金额", nil);
    self.thirdlyCityTF.font = Font_Important_15_20;
    self.thirdlyCityTF.textColor = Color_form_TextField_20;
    self.thirdlyCityTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.thirdlyCityTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.thirdlyCityTF.adjustsFontSizeToFitWidth = YES;
    self.thirdlyCityTF.delegate=self;
    self.thirdlyCityTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.allView addSubview:self.thirdlyCityTF];
    
    self.fourthCityTF =[[GkTextField alloc]initWithFrame:CGRectMake(170, 243, ScreenRect.size.width-185, 27)];
    self.fourthCityTF.placeholder = Custing(@"请输入限制金额", nil);
    self.fourthCityTF.font = Font_Important_15_20;
    self.fourthCityTF.textColor = Color_form_TextField_20;
    self.fourthCityTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.fourthCityTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.fourthCityTF.adjustsFontSizeToFitWidth = YES;
    self.fourthCityTF.delegate=self;
    self.fourthCityTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.allView addSubview:self.fourthCityTF];
    
    self.fifthlyCityTF =[[GkTextField alloc]initWithFrame:CGRectMake(170, 300, ScreenRect.size.width-185, 27)];
    self.fifthlyCityTF.placeholder = Custing(@"请输入限制金额", nil);
    self.fifthlyCityTF.font = Font_Important_15_20;
    self.fifthlyCityTF.textColor = Color_form_TextField_20;
    self.fifthlyCityTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.fifthlyCityTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.fifthlyCityTF.adjustsFontSizeToFitWidth = YES;
    self.fifthlyCityTF.delegate=self;
    self.fifthlyCityTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.allView addSubview:self.fifthlyCityTF];
    
    if ([self.cityValue isEqualToString:@"0"]) {
        if (![self.housePrice0 isEqualToString:@"0"]) {
            self.allCityTF.text = self.housePrice0;
        }
        self.oneCityTF.text = @"";
        self.twoCityTF.text = @"";
        self.thirdlyCityTF.text = @"";
        self.fourthCityTF.text = @"";
        self.fifthlyCityTF.text = @"";
        self.oneCityTF.userInteractionEnabled = NO;
        self.twoCityTF.userInteractionEnabled = NO;
        self.thirdlyCityTF.userInteractionEnabled = NO;
        self.fourthCityTF.userInteractionEnabled = NO;
        self.fifthlyCityTF.userInteractionEnabled = NO;
        
    }else{
        self.allCityTF.text = @"";
        self.allCityTF.userInteractionEnabled = NO;
        if (![self.housePrice1 isEqualToString:@"0"]) {
            self.oneCityTF.text = self.housePrice1;
        }
        if (![self.housePrice2 isEqualToString:@"0"]) {
            self.twoCityTF.text = self.housePrice2;
        }
        if (![self.housePrice3 isEqualToString:@"0"]) {
            self.thirdlyCityTF.text = self.housePrice3;
        }
        if (![self.housePrice4 isEqualToString:@"0"]) {
            self.fourthCityTF.text = self.housePrice4;
        }
        if (![self.housePrice5 isEqualToString:@"0"]) {
            self.fifthlyCityTF.text = self.housePrice5;
        }
    }
    
    self.submitBtn = [GPUtils createButton:CGRectMake(15,Y(self.allView)+HEIGHT(self.allView)+16, WIDTH(self.allView)-30,49) action:@selector(saveModifyHarstData:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"保存", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [self.submitBtn setBackgroundColor:Color_Blue_Important_20];
    self.submitBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview: self.submitBtn];
    if ([self.paramValue isEqualToString:@"0"]) {
        self.submitBtn.hidden = YES;
    }
    
    
}

//MARK:保存限制
-(void)saveModifyHarstData:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.allCityTF resignFirstResponder];
    [self.oneCityTF resignFirstResponder];
    [self.twoCityTF resignFirstResponder];
    [self.thirdlyCityTF resignFirstResponder];
    [self.fourthCityTF resignFirstResponder];
    [self.fifthlyCityTF resignFirstResponder];

    
    if ([self.paramValue isEqualToString:@"0"]) {
        
    }else{
        if ([self.cityValue isEqualToString:@"0"]) {
            if (self.allCityTF.text.length <=0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"限制所有城市的房价最高不能为空", nil) duration:1.5];
                return;
            }
        }else{
            if (self.oneCityTF.text.length <=0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"限制一级城市的房价最高不能为空", nil) duration:1.5];
                return;
            }
            if (self.twoCityTF.text.length <=0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"限制二级城市的房价最高不能为空", nil) duration:1.5];
                return;
            }
            if (self.thirdlyCityTF.text.length <=0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"限制三级城市的房价最高不能为空", nil) duration:1.5];
                return;
            }
            if (self.fourthCityTF.text.length <=0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"限制港澳台房价最高不能为空", nil) duration:1.5];
                return;
            }
            if (self.fifthlyCityTF.text.length <=0) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"限制国际房价最高不能为空", nil) duration:1.5];
                return;
            }
        }
    }
    
    
    [self requestParameter];
    
    
}


//MARK:限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqual:@" "]) {
        return NO;
    }
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.allCityTF == textField||self.oneCityTF == textField||self.twoCityTF == textField||self.thirdlyCityTF == textField||self.fourthCityTF == textField||self.fifthlyCityTF == textField)  //判断是否时我们想要限定的那个输入框
    {
        NSCharacterSet *cs;
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        if (NSNotFound == nDotLoc && 0!= range.location) {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
        }
        else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
            
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            //只能输入数字和小数点"
            return NO;
        }
        if (NSNotFound != nDotLoc && range.location > nDotLoc +2) {//小数点后面2位
            return NO;
        }
        
        if (toBeString.length>=2) {
            if ([[toBeString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"]&&![[toBeString substringWithRange:NSMakeRange(1, 1)]isEqualToString:@"."]) {
                return NO;
            }
        }
        NSRange range1 = [toBeString rangeOfString:@"."];
        if (range1.location == NSNotFound) {
            if ([toBeString length] >10) { //如果输入框内容大于9
                textField.text = [toBeString substringToIndex:10];
                return NO;
            }
        }else{
            if ([toBeString length] >10) { //如果输入框内容大于12
                textField.text = [toBeString substringToIndex:10];
                return NO;
            }
            
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.allCityTF == textField||self.oneCityTF == textField||self.twoCityTF == textField||self.thirdlyCityTF == textField||self.fourthCityTF == textField||self.fifthlyCityTF == textField){
        if (textField.text.length!=0) {
            NSString *subStr = [textField.text substringFromIndex:textField.text.length-1];
            if ([subStr isEqualToString:@"."]) {
                textField.text=[textField.text substringToIndex:textField.text.length-1];
            }
        }
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.allCityTF resignFirstResponder];
    [self.oneCityTF resignFirstResponder];
    [self.twoCityTF resignFirstResponder];
    [self.thirdlyCityTF resignFirstResponder];
    [self.fourthCityTF resignFirstResponder];
    [self.fifthlyCityTF resignFirstResponder];

}


//MARK:切换限制
-(void)isEnabledCity:(UIButton *)btn{
    
    switch (btn.tag) {
        case 101:
            self.cityValue = @"0";
            [self.allBtn setBackgroundImage:GPImage(@"MyApprove_Select") forState:UIControlStateNormal];
            [self.singleBtn setBackgroundImage:GPImage(@"MyApprove_UnSelect") forState:UIControlStateNormal];
            
            if (![self.housePrice0 isEqualToString:@"0"]) {
                self.allCityTF.text = self.housePrice0;
            }
            self.allCityTF.userInteractionEnabled = YES;
            self.oneCityTF.text = @"";
            self.twoCityTF.text = @"";
            self.thirdlyCityTF.text = @"";
            self.fourthCityTF.text = @"";
            self.fifthlyCityTF.text = @"";
            self.oneCityTF.userInteractionEnabled = NO;
            self.twoCityTF.userInteractionEnabled = NO;
            self.thirdlyCityTF.userInteractionEnabled = NO;
            self.fourthCityTF.userInteractionEnabled = NO;
            self.fifthlyCityTF.userInteractionEnabled = NO;
            break;
        case 102:
            self.cityValue = @"1";
            [self.allBtn setBackgroundImage:GPImage(@"MyApprove_UnSelect") forState:UIControlStateNormal];
            [self.singleBtn setBackgroundImage:GPImage(@"MyApprove_Select") forState:UIControlStateNormal];
            
            self.allCityTF.text = @"";
            self.allCityTF.userInteractionEnabled = NO;
            if (![self.housePrice1 isEqualToString:@"0"]) {
                self.oneCityTF.text = self.housePrice1;
            }
            if (![self.housePrice2 isEqualToString:@"0"]) {
                self.twoCityTF.text = self.housePrice2;
            }
            if (![self.housePrice3 isEqualToString:@"0"]) {
                self.thirdlyCityTF.text = self.housePrice3;
            }
            if (![self.housePrice4 isEqualToString:@"0"]) {
                self.fourthCityTF.text = self.housePrice4;
            }
            if (![self.housePrice5 isEqualToString:@"0"]) {
                self.fifthlyCityTF.text = self.housePrice5;
            }
            self.oneCityTF.userInteractionEnabled = YES;
            self.twoCityTF.userInteractionEnabled = YES;
            self.thirdlyCityTF.userInteractionEnabled = YES;
            self.fourthCityTF.userInteractionEnabled = YES;
            self.fifthlyCityTF.userInteractionEnabled = YES;
            break;
        default:
            break;
    }
}

//MARK:请求保存员工级别对应的住宿标准

-(void)requestOpenTo{
    NSDictionary * dic = @{@"UserLevelId":[NSString stringWithFormat:@"%@",self.data.userLevelId],@"UserLevel":[NSString stringWithFormat:@"%@",self.data.userLevel],@"IsLimit":self.paramValue,@"Standard":self.cityValue,@"HousePrice1":@"",@"HousePrice2":@"",@"HousePrice3":@"",@"HousePrice4":@"",@"HousePrice5":@""};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveHotelStandard] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

-(void)requestParameter{
    NSDictionary * dic;
    if ([self.paramValue isEqualToString:@"0"]) {
        dic = @{@"UserLevelId":[NSString stringWithFormat:@"%@",self.data.userLevelId],@"UserLevel":[NSString stringWithFormat:@"%@",self.data.userLevel],@"IsLimit":self.paramValue,@"Standard":self.cityValue,@"HousePrice1":@"",@"HousePrice2":@"",@"HousePrice3":@"",@"HousePrice4":@"",@"HousePrice5":@""};
    }else{
        if ([self.cityValue isEqualToString:@"0"]) {
            dic = @{@"UserLevelId":[NSString stringWithFormat:@"%@",self.data.userLevelId],@"UserLevel":[NSString stringWithFormat:@"%@",self.data.userLevel],@"IsLimit":self.paramValue,@"Standard":self.cityValue,@"HousePrice1":[NSString stringWithFormat:@"%@",self.allCityTF.text],@"HousePrice2":[NSString stringWithFormat:@"%@",self.twoCityTF.text],@"HousePrice3":[NSString stringWithFormat:@"%@",self.thirdlyCityTF.text],@"HousePrice4":[NSString stringWithFormat:@"%@",self.fourthCityTF.text],@"HousePrice5":[NSString stringWithFormat:@"%@",self.fifthlyCityTF.text]};
        }else{
            dic = @{@"UserLevelId":[NSString stringWithFormat:@"%@",self.data.userLevelId],@"UserLevel":[NSString stringWithFormat:@"%@",self.data.userLevel],@"IsLimit":self.paramValue,@"Standard":self.cityValue,@"HousePrice1":[NSString stringWithFormat:@"%@",self.oneCityTF.text],@"HousePrice2":[NSString stringWithFormat:@"%@",self.twoCityTF.text],@"HousePrice3":[NSString stringWithFormat:@"%@",self.thirdlyCityTF.text],@"HousePrice4":[NSString stringWithFormat:@"%@",self.fourthCityTF.text],@"HousePrice5":[NSString stringWithFormat:@"%@",self.fifthlyCityTF.text]};
        }
    }
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveHotelStandard] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self backBorrowRecord];
    });
    switch (serialNum) {
        case 0://
             [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"条件设置成功", nil) duration:2.0];
            break;
        case 1://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"条件设置成功", nil) duration:2.0];
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
}
-(void)backBorrowRecord{
    [self.navigationController popViewControllerAnimated:YES];
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
