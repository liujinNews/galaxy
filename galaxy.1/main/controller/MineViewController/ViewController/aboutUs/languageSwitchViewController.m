//
//  languageSwitchViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/8/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "languageSwitchViewController.h"

@interface languageSwitchViewController ()<GPClientDelegate>
@property (nonatomic,strong)UIImageView * chineseImage;
@property (nonatomic,strong)UIImageView * englishImage;
@property (nonatomic,strong)NSString * languageStr;

@property (nonatomic, assign) int isvalue;//0 ch 1 en

@end

@implementation languageSwitchViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"多语言",nil) backButton:YES ];
    
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage];
    
    self.languageStr = [language isEqualToString:@"zh-Hans"]?@"1":@"2";
    [self createSwicthLauguageView];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(projectSave:)];

    // Do any additional setup after loading the view.
}

-(void)projectSave:(UIButton *)btn{
    NSDictionary *dic = @{@"Language":_isvalue==0?@"ch":@"en"};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_ChangeLanguage Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)createSwicthLauguageView{
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView * lauguageView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 98)];
    lauguageView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:lauguageView];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    line1.backgroundColor = Color_GrayLight_Same_20;
    [lauguageView addSubview:line1];
    
    UIButton * chineseBtn = [GPUtils createButton:CGRectMake(15, 1, Main_Screen_Width-30, 47) action:@selector(sssss:) delegate:self title:@"简体中文" font:Font_Important_15_20 titleColor:Color_Black_Important_20];
    [chineseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    chineseBtn.tag = 101;
    chineseBtn.backgroundColor = [UIColor clearColor];
    [lauguageView addSubview:chineseBtn];
    
    self.chineseImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(chineseBtn)-15, 16, 15, 15)];
    self.chineseImage.image = GPImage(@"Language_sure");
    [chineseBtn addSubview:self.chineseImage];
    
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(15, 49, Main_Screen_Width - 30, 0.5)];
    line2.backgroundColor = Color_GrayLight_Same_20;
    [lauguageView addSubview:line2];
    
    
    UIButton * EnglishBtn = [GPUtils createButton:CGRectMake(15, 50, Main_Screen_Width-30, 47) action:@selector(sssss:) delegate:self title:@"English" font:Font_Important_15_20 titleColor:Color_Black_Important_20];
    EnglishBtn.tag = 102;
    [EnglishBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    EnglishBtn.backgroundColor = [UIColor clearColor];
    [lauguageView addSubview:EnglishBtn];
    
    self.englishImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(chineseBtn)-15, 16, 15, 15)];
    self.englishImage.image = GPImage(@"Language_sure");
    [EnglishBtn addSubview:self.englishImage];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 97.5, Main_Screen_Width, 0.5)];
    line3.backgroundColor = Color_GrayLight_Same_20;
    [lauguageView addSubview:line3];
    
    if ([self.languageStr isEqualToString:@"1"]) {
        self.chineseImage.hidden = NO;
        self.englishImage.hidden = YES;
    }else{
        self.chineseImage.hidden = YES;
        self.englishImage.hidden = NO;
    }
    
}

-(void)sssss:(UIButton *)btn {
    switch (btn.tag) {
        case 101:
            self.chineseImage.hidden = NO;
            self.englishImage.hidden = YES;
            _isvalue = 0;
            break;
        case 102:
            self.chineseImage.hidden = YES;
            self.englishImage.hidden = NO;
            _isvalue = 1;
            break;
            
        default:
            break;
    }
    
}

#pragma mark -delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    NSString *str = @"";
    if (_isvalue == 0) {
        str = @"zh-Hans";
    }else{
        str = @"en";
    }
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",str] forKey:AppLanguage];
        [NSUserDefaults standardUserDefaults];
        self.userdatas.language = _isvalue == 0?@"ch":@"en";
        self.userdatas.RefreshStr = @"YES";
        [self.userdatas storeUserInfo];
        [ApplicationDelegate setupTabViewController];
        
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
