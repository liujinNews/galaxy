
//
//  reimProtelViewController.m
//  galaxy
//
//  Created by 赵碚 on 15/12/4.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "reimProtelViewController.h"

@interface reimProtelViewController ()<UITextViewDelegate,GPClientDelegate,LanguageControllerDelegate>
@property (nonatomic,strong)UITextView * aboutUSTV;
@property (nonatomic,strong)NSString * descriptio;
@property (nonatomic,strong)NSString * idd;
@property (nonatomic,strong)NSString * status;
@property(nonatomic, strong)NSDictionary *resultDict;//缓存数据

@end

@implementation reimProtelViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * naview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, NavBarHeight)];
    naview.backgroundColor = [GPUtils colorHString:ColorPurple];
    [self.view addSubview:naview];
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, HEIGHT(self.view)*0.045, HEIGHT(self.view)*0.045)];
    [leftbtn addTarget:self action:@selector(sideslipBar:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    UIImageView * leftImage = [[UIImageView alloc]initWithImage:GPImage(@"pc_nav_btn_back_img")];
    leftImage.frame = CGRectMake(0, 0, 22, 22);
    leftImage.backgroundColor = [UIColor clearColor];
    [leftbtn addSubview:leftImage];
    [naview addSubview:leftbtn];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-50, 30, 100, 25) text:Custing(@"forget_hidAccountAgreement", nil) font:[UIFont systemFontOfSize:17.0f]textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    [naview addSubview:titleLa];
    
    if (self.userdatas.local07&&self.userdatas.cache07) {
        if (self.userdatas.local07!=self.userdatas.cache07)
        {
            [self requestSend];
        }
        else
        {
            _resultDict = self.userdatas.localFile07;
            if (!_resultDict) {
                [self requestSend];
            }
            else
            {
                [self createAboutView];
            }
        }
    }
    else
    {
        [self requestSend];
    }
    
    // Do any additional setup after loading the view.
}
-(void)sideslipBar:(id)btn
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createAboutView{
    self.idd = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"id"]];
    self.descriptio = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"contents"]];
    
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, Main_Screen_Width, Main_Screen_Height)];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    self.aboutUSTV = [[UITextView alloc]initWithFrame:CGRectMake(WIDTH(mainView)*0.05, 0, WIDTH(mainView)*0.9, HEIGHT(mainView)-NavBarHeight)];
    self.aboutUSTV.font = Font_cellContent_16;
    self.aboutUSTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.descriptio stringByReplacingOccurrencesOfString:@"\\\\r" withString:@"/"];
    self.aboutUSTV.text = self.descriptio;
    self.aboutUSTV.textColor = [UIColor grayColor];
    [self.aboutUSTV becomeFirstResponder];
    self.aboutUSTV.editable = NO;
    self.aboutUSTV.scrollEnabled=YES;
    self.aboutUSTV.delegate = self;
    self.aboutUSTV.backgroundColor = [UIColor clearColor];
    [mainView addSubview:self.aboutUSTV];
}


//
-(void)requestSend{
    
    [[GPClient shareGPClient]REquestByGetWithPath:[NSString stringWithFormat:@"%@%@",kServer,termsser] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
    //FDE55D29E567D879//
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    //description//id
    NSString * result = [responceDic objectForKey:@"contents"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| !result){
        return;
    }
    
    
    switch (serialNum) {
        case 0://
            if (!self.userdatas.cache07) {
                self.userdatas.cache07 = [NSString GetstringFromDate];
            }
            self.userdatas.local07 = self.userdatas.cache07;
            self.userdatas.localFile07 = responceDic;
            _resultDict = responceDic;
            [userData savrlocalFile:responceDic type:7];
            [self createAboutView];
            break;
            
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    if ([responceFail isEqualToString:@"The request timed out."]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"服务器请求超时" duration:2.0];
    }else{
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",responceFail] duration:2.0];
    }
    
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
