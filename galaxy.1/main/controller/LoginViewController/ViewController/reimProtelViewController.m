
//
//  reimProtelViewController.m
//  galaxy
//
//  Created by 赵碚 on 15/12/4.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "reimProtelViewController.h"

@interface reimProtelViewController ()<UITextViewDelegate,GPClientDelegate>
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    [self setTitle:Custing(@"报销协议", nil) backButton:YES];
    [self requestSend];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
-(void)sideslipBar:(id)btn
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createAboutView{
    self.idd = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"id"]];
    self.descriptio = [NSString stringWithFormat:@"%@",[_resultDict objectForKey:@"contents"]];
    
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    mainView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:mainView];
    self.aboutUSTV = [[UITextView alloc]initWithFrame:CGRectMake(WIDTH(mainView)*0.05, 0, WIDTH(mainView)*0.9, HEIGHT(mainView)-NavigationbarHeight)];
    self.aboutUSTV.font = Font_cellContent_16;
    self.aboutUSTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.descriptio stringByReplacingOccurrencesOfString:@"\\\\r" withString:@"/"];
    self.aboutUSTV.text = self.descriptio;
    self.aboutUSTV.textColor = [UIColor grayColor];
    [self.aboutUSTV becomeFirstResponder];
    self.aboutUSTV.editable = NO;
    self.aboutUSTV.scrollEnabled=YES;
    self.aboutUSTV.delegate = self;
    self.aboutUSTV.backgroundColor = Color_form_TextFieldBackgroundColor;
    [mainView addSubview:self.aboutUSTV];
}


//
-(void)requestSend{
    
    [[GPClient shareGPClient]RequestByGetWithPath:XB_ReimSer Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
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
//            if (!self.userdatas.cache07) {
//                self.userdatas.cache07 = [NSString GetstringFromDate];
//            }
//            self.userdatas.local07 = self.userdatas.cache07;
//            self.userdatas.localFile07 = responceDic;
            _resultDict = responceDic;
            [userData savelocalFile:responceDic type:7];
            [self createAboutView];
            break;
            
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

    
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
