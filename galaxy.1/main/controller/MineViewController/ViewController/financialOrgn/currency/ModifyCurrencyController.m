//
//  ModifyCurrencyController.m
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
#import "ModifyCurrencyController.h"
#import "SelectExschangeViewController.h"

@interface ModifyCurrencyController ()<UITextFieldDelegate,GPClientDelegate,SelectExschangeViewControllerDelegate>
@property (nonatomic,strong)UITextField * currencyShortTF;
@property (nonatomic,strong)UITextField * currencyCodeTF;
@property (nonatomic,strong)UITextField * currencyTF;

@property(nonatomic,copy)NSString * currency;
@property(nonatomic,copy)NSString * currencyCode;
@property(nonatomic,copy)NSString * idd;
@property(nonatomic,copy)NSString * ExchangeRate;
@property(nonatomic,copy)NSString * no;
@property (nonatomic,strong)NSString * status;

@end

@implementation ModifyCurrencyController
-(id)initWithType:(NSDictionary *)type Name:(NSString *)str{
    self = [super init];
    if (self) {
        if (![type isKindOfClass:[NSNull class]] && type != nil && type.count != 0){
            if ([str isEqualToString:@"ModifyCurrency"]) {
                self.status = str;
                self.no = [NSString stringWithFormat:@"%@",[type objectForKey:@"no"]];
                self.idd = [NSString stringWithFormat:@"%@",[type objectForKey:@"idd"]];
                self.currency = [NSString stringWithFormat:@"%@",[type objectForKey:@"currency"]];
                self.currencyCode = [NSString stringWithFormat:@"%@",[type objectForKey:@"currencyCode"]];
                self.ExchangeRate = [NSString stringWithFormat:@"%@",[type objectForKey:@"ExchangeRate"]];
            }
        }
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [self.currencyCodeTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.status isEqualToString:@"ModifyCurrency"]) {
        [self setTitle:Custing(@"修改币种", nil) backButton:YES ];
        [self createCostCenterTextField];
    }else{
        [self setTitle:Custing(@"新增币种", nil) backButton:YES ];
        [self createCostCenterTextField];
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(currencySave:)];

    // Do any additional setup after loading the view.
}


-(void)currencySave:(UIButton *)btn{
    [self.currencyShortTF  resignFirstResponder];
    [self.currencyCodeTF  resignFirstResponder];
    [self.currencyTF  resignFirstResponder];
    
    if (self.currencyCodeTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入编号", nil)];
        return;
    }
    if (self.currencyCodeTF.text.length >10) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"编号不超过10位", nil)];
        return;
    }
    
    if (self.currencyTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入名称", nil)];
        return;
    }
    if (self.currencyTF.text.length >10) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"名称不超过10位", nil)];
        return;
    }
    
    if (self.currencyShortTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入汇率", nil)];
        return;
    }
    if (self.currencyShortTF.text.length >9) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"汇率不超过9位", nil)];
        return;
    }
    
    [self requestModifyCurrencyData];
    
}


-(void)requestModifyCurrencyData{
    if ([self.status isEqualToString:@"ModifyCurrency"]) {//修改币种
        NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",self.idd],@"currency":[NSString stringWithFormat:@"%@",self.currencyTF.text],@"currencyCode":[NSString stringWithFormat:@"%@",self.currencyCodeTF.text],@"currencyShort":@"",@"ExchangeRate":[NSString stringWithFormat:@"%@",self.currencyShortTF.text],@"no":[NSString stringWithFormat:@"%@",self.no]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",updatecurrency] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
        
    }else{//增加币种currencyShort
        NSDictionary *dic = @{@"id":@"",@"currency":[NSString stringWithFormat:@"%@",self.currencyTF.text],@"currencyCode":[NSString stringWithFormat:@"%@",self.currencyCodeTF.text],@"currencyShort":@"",@"ExchangeRate":[NSString stringWithFormat:@"%@",self.currencyShortTF.text],@"no":@""};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",insertcurrency] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    }
}

#pragma mark - action
-(void)btn_Click:(UIButton *)btn{
    NSLog(@"22");
    SelectExschangeViewController *select = [SelectExschangeViewController new];
    select.delegate = self;
    select.ids = _currencyCodeTF.text;
    [self.navigationController pushViewController:select animated:YES];
}

#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
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
        case 0:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"币种修改成功", nil) duration:2.0];
            
            break;
        case 1:
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"币种添加成功", nil) duration:2.0];
           
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
}

-(void)SelectExschangeViewControllerCellClick:(NSDictionary *)dic{
    _currencyTF.text = dic[@"currency"];
    _currencyCodeTF.text = dic[@"currencyCode"];
}

-(void)backBorrowRecord{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currencyShortTF  resignFirstResponder];
    [self.currencyCodeTF  resignFirstResponder];
    [self.currencyTF  resignFirstResponder];
}

-(void)createCostCenterTextField{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView * numberView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 49)];
    numberView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:numberView];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    //编号
    UILabel * CodeLa = [GPUtils createLable:CGRectMake(15, 0, ((lan)?35:60), 49) text:Custing(@"编号", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    CodeLa.backgroundColor = [UIColor clearColor];
    [numberView addSubview:CodeLa];
    
    self.currencyCodeTF = [GPUtils createTextField:CGRectMake(((lan)?65:75), 0, Main_Screen_Width-((lan)?80:90), 49) placeholder:Custing(@"请选择编号", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.currencyCodeTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.currencyCodeTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.currencyCodeTF.adjustsFontSizeToFitWidth = YES;
    self.currencyCodeTF.delegate=self;
    self.currencyCodeTF.tag = 0;
    self.currencyCodeTF.keyboardType = UIKeyboardTypeEmailAddress;
//    [self.currencyCodeTF becomeFirstResponder];
    if (self.currencyCode !=nil&&![self.currencyCode isEqualToString:@"<null>"]&&![self.currencyCode isEqualToString:@"(null)"]) {
        self.currencyCodeTF.text = self.currencyCode;
    }
    _currencyCodeTF.userInteractionEnabled = NO;
    [numberView addSubview:self.currencyCodeTF];
    if (![self.status isEqualToString:@"ModifyCurrency"]) {
        UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
        iconImage.frame = CGRectMake(Main_Screen_Width-32, 15, 20, 20);
        [numberView addSubview:iconImage];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:numberView.frame];
        btn.tag = 1;
        [btn addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
     //名称
    UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, Main_Screen_Width, 49)];
    nameView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:nameView];
    
    UILabel * currenyLa = [GPUtils createLable:CGRectMake(15, 0, ((lan)?35:50), 49) text:Custing(@"名称", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    currenyLa.backgroundColor = [UIColor clearColor];
    [nameView addSubview:currenyLa];
    
    self.currencyTF = [GPUtils createTextField:CGRectMake(((lan)?65:65), 0, Main_Screen_Width-((lan)?80:80), 49) placeholder:Custing(@"请输入名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.currencyTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.currencyTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.currencyTF.adjustsFontSizeToFitWidth = YES;
    self.currencyTF.delegate=self;
    self.currencyTF.tag = 1;
    self.currencyTF.keyboardType = UIKeyboardTypeDefault;
    if (self.currency !=nil&&![self.currency isEqualToString:@"<null>"]&&![self.currency isEqualToString:@"(null)"]) {
        self.currencyTF.text = self.currency;
    }
    _currencyTF.userInteractionEnabled = NO;
    [nameView addSubview:self.currencyTF];
    
    //汇率
    UIView * ShortView = [[UIView alloc]initWithFrame:CGRectMake(0, 128, Main_Screen_Width, 49)];
    ShortView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:ShortView];
    UILabel * ShortLa = [GPUtils createLable:CGRectMake(15, 0, ((lan)?35:100), 49) text:Custing(@"汇率", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    ShortLa.backgroundColor = [UIColor clearColor];
    [ShortView addSubview:ShortLa];
    
    self.currencyShortTF = [GPUtils createTextField:CGRectMake(((lan)?65:120), 0, Main_Screen_Width-((lan)?80:135), 49) placeholder:Custing(@"请输入汇率", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.currencyShortTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.currencyShortTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.currencyShortTF.adjustsFontSizeToFitWidth = YES;
    self.currencyShortTF.delegate=self;
    self.currencyShortTF.tag = 2;
    self.currencyShortTF.keyboardType = UIKeyboardTypeDecimalPad;
    if (self.ExchangeRate !=nil&&![self.ExchangeRate isEqualToString:@"<null>"]&&![self.ExchangeRate isEqualToString:@"(null)"]) {
        self.currencyShortTF.text = self.ExchangeRate;
    }
    [ShortView addSubview:self.currencyShortTF];
    if ([self.currency isEqualToString:Custing(@"人民币(本位币)", nil)]) {
        self.currencyCodeTF.userInteractionEnabled = NO;
        self.currencyCodeTF.textColor = [UIColor grayColor];
        self.currencyTF.userInteractionEnabled = NO;
        self.currencyTF.textColor = [UIColor grayColor];
        self.currencyShortTF.userInteractionEnabled = NO;
        self.currencyShortTF.textColor = [UIColor grayColor];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
        case 0:
        {
            if (textField.text.length >= 10 && string.length>0){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"编号不超过10位", nil)];
                return NO;
            }
           
        }
            break;
        case 1:
        {
            if (textField.text.length >= 10 && string.length>0){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"名称不超过10位", nil)];
                return NO;
            }
            
        }
            break;
        case 2:
        {
            //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
            if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
                return YES;
            }
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
            if (self.currencyShortTF == textField)  //判断是否时我们想要限定的那个输入框
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
                if (NSNotFound != nDotLoc && range.location > nDotLoc +4) {//小数点后面2位
                    return NO;
                }
                
                if (toBeString.length>=4) {
                    if ([[toBeString substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"]&&![[toBeString substringWithRange:NSMakeRange(1, 1)]isEqualToString:@"."]) {
                        return NO;
                    }
                }
                NSRange range1 = [toBeString rangeOfString:@"."];
                if (range1.location == NSNotFound) {
                    if ([toBeString length] >4) { //如果输入框内容大于10
                        textField.text = [toBeString substringToIndex:4];
                        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"汇率不超过4位"];
                        return NO;
                    }
                }else{
                    if ([toBeString length] >9) { //如果输入框内容大于10
                        textField.text = [toBeString substringToIndex:9];
                        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"汇率不超过9位", nil)];
                        return NO;
                    }
                    
                }
            }
            return YES;
//            if (textField.text.length >= 10 && string.length>0){
//                [[GPAlertView sharedAlertView] showAlertText:self WithText:@"汇率不超过10位"];
//                return NO;
//            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
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
