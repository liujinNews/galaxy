//
//  createJoinCViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/11/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "createNewCoListViewController.h"
#import "createJoinNuViewController.h"
#import "createJoinCViewController.h"

@interface createJoinCViewController ()<UITextFieldDelegate,GPClientDelegate>
@property(nonatomic,strong)UIView * mainView;
@property(nonatomic,strong)UITextField * companyIdTF;
@property(nonatomic,strong)NSString * status;
//@property(nonatomic,strong)NSDictionary * switchDic;

@end

@implementation createJoinCViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
//        self.switchDic = canDic;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //jiaruHave
    if ([self.status isEqualToString:@"jiaruHave"]) {
        [self setTitle:Custing(@"加入已有企业", nil) backButton:YES];
    }else if ([self.status isEqualToString:@"jiaruXIAN"]) {
        [self setTitle:Custing(@"加入已有公司", nil) backButton:YES];
    }
    
    [self createJoinCompanyView];
    // Do any additional setup after loading the view.
}

-(void)createJoinCompanyView{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 85)];
    self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.mainView ];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH(self.mainView), 45)];
    whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.mainView  addSubview:whiteView];
    
     if ([self.status isEqualToString:@"jiaruXIAN"]) {
         UILabel * comNaLa = [GPUtils createLable:CGRectMake(15, 0, 60, 45) text:Custing(@"企业号id", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
         comNaLa.backgroundColor = [UIColor clearColor];
         [whiteView addSubview:comNaLa];
     }
    self.companyIdTF = [GPUtils createTextField:CGRectMake(15, 0, WIDTH(self.mainView)-30, 45) placeholder:Custing(@"请输入企业号", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.companyIdTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.companyIdTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.companyIdTF.keyboardType = UIKeyboardTypeNumberPad;
    self.companyIdTF.tag = 0;
    self.companyIdTF.delegate = self;
    [whiteView addSubview:self.companyIdTF];
    
    if ([self.status isEqualToString:@"jiaruXIAN"]) {
        self.companyIdTF.frame = CGRectMake(85, 0, WIDTH(self.mainView)-100, 45);
    }
    
    UILabel * joinCoLa = [GPUtils createLable:CGRectMake(15, 55, Main_Screen_Width - 30, 30) text:Custing(@"向公司管理员或同事索要企业号", nil) font:Font_Same_11_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    joinCoLa.backgroundColor = [UIColor clearColor];
    joinCoLa.numberOfLines = 0;
    [self.mainView addSubview:joinCoLa];
    
    
    UIButton * registerBtn = [GPUtils createButton:CGRectMake(15, 95, Main_Screen_Width-30, 45) action:@selector(nextJoinCompany:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"下一步", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [registerBtn setBackgroundColor:Color_Blue_Important_20];
    registerBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:registerBtn];
    
    if ([self.status isEqualToString:@"jiaruXIAN"]) {
        self.companyIdTF.frame = CGRectMake(85, 0, WIDTH(self.mainView)-100, 45);
        joinCoLa.hidden = YES;
        registerBtn.frame = CGRectMake(15, 80, Main_Screen_Width-30, 45);
    }

        
    
    
}

-(void)nextJoinCompany:(UIButton *)btn {
    
    [self.companyIdTF resignFirstResponder];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    if (self.companyIdTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入企业号", nil) duration:1.5];
        [self.companyIdTF becomeFirstResponder];
        return;
    }

     [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"account/GetCorpInfo"] Parameters:@{@"CorpCode":[NSString stringWithFormat:@"%@",self.companyIdTF.text]} Delegate:self SerialNum:0 IfUserCache:NO];
    
   
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    if (serialNum ==0) {
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]] isEqualToString:@"0"]) {
//            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"该公司不存在", nil) duration:2.0];
            return;
        }
        
    }
    
   
    if (serialNum==0) {
        NSString * companyName=@"";
        NSString * companyContact=@"";
        
        if ([self.status isEqualToString:@"jiaruXIAN"]) {//公司管理加入公司
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                
            }else{
                companyName = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyName"]];
//                companyContact = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyContact"]];
            }
            createNewCoListViewController * create = [[createNewCoListViewController alloc]initWithType:@"jiaruXIANtwo" can:@{@"CorpCode":[NSString stringWithFormat:@"%@",self.companyIdTF.text],@"CompanyName":[NSString isEqualToNull:companyName] ? companyName : @""}];
            [self.navigationController pushViewController:create animated:YES];
        }else if ([self.status isEqualToString:@"jiaruHave"]) {//注册流程加入已有企业
            NSDictionary * result = [responceDic objectForKey:@"result"];
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                
            }else{
                companyName = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyName"]];
                companyContact = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyContact"]];
            }
            createJoinNuViewController * crea = [[createJoinNuViewController alloc]initWithType:@"jiaruNEW" can:@{@"CoCode":[NSString stringWithFormat:@"%@",self.companyIdTF.text],@"companyName":[NSString isEqualToNull:companyName] ? companyName : @"",@"companyContact":[NSString isEqualToNull:companyContact] ? companyContact : @""}];
            [self.navigationController pushViewController:crea animated:YES];
        }
        
        
    
    }
    
    switch (serialNum) {
        case 0://
            
            break;
        
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //不允许输入空格
    if ([string isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
        case 0:
        {
            if (textField.text.length >= 20 && string.length>0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司企业号不超过20位", nil)];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.companyIdTF resignFirstResponder];
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
