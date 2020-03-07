//
//  createSuccessViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/11/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "MainLoginViewController.h"
#import "JoinInvitationViewController.h"
#import "LoginViewController.h"
#import "createSuccessViewController.h"

@interface createSuccessViewController ()
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSDictionary * succDic;
@property(nonatomic,strong)UIImageView * coRect;

@end

@implementation createSuccessViewController

-(id)initWithType:(NSString *)type can:(NSDictionary *)canDic{
    self = [super init];
    if (self) {
        self.status = type;
        self.succDic = canDic;
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    self.navigationController.navigationBar.hidden = YES;
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIImage *icon = [UIImage imageNamed:@"login_createScuss"];
    self.coRect = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width/icon.size.width * icon.size.height)];
    self.coRect.image = icon;
    [self.view addSubview:self.coRect];
    
    UIImageView * successImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.coRect)/2-30, HEIGHT(self.coRect)*0.42-30, 60, 60)];
    successImage.image = GPImage(@"login_scuess");
    successImage.backgroundColor = [UIColor clearColor];
    [self.coRect addSubview:successImage];
    
    UILabel * successLbl = [GPUtils createLable:CGRectMake(0, Y(successImage)+HEIGHT(successImage)+10, Main_Screen_Width, 25) text:@"" font:Font_Important_18_20 textColor:Color_White_Same_20 textAlignment:NSTextAlignmentCenter];
    successLbl.backgroundColor = [UIColor clearColor];
    [self.coRect  addSubview:successLbl];
    
    UILabel * coNameLbl = [GPUtils createLable:CGRectMake(0, Y(successLbl)+HEIGHT(successLbl)+10, Main_Screen_Width, 25) text:@"" font:Font_Same_14_20 textColor:Color_White_Same_20 textAlignment:NSTextAlignmentCenter];
    coNameLbl.backgroundColor = [UIColor clearColor];
    [self.coRect  addSubview:coNameLbl];
    
    if ([self.status isEqualToString:@"jiaruNEW"]) {
        if ([[self.succDic objectForKey:@"Source"] isEqualToString:@"1"]) {
            successLbl.text = [NSString stringWithFormat:@"%@%@", Custing(@"您已申请加入", nil),[self.succDic objectForKey:@"companyName"]];
            coNameLbl.text = [NSString stringWithFormat:@"%@%@%@", Custing(@"公司管理员", nil),[self.succDic objectForKey:@"companyContact"],Custing(@"授权同意后才可以登录", nil)];
        }else {
            successLbl.text = Custing(@"注册成功", nil);
            coNameLbl.text = [NSString stringWithFormat:@"%@",[self.succDic objectForKey:@"companyName"]];
        }
        
    }else {//zhuceNEW
        successLbl.text = Custing(@"企业创建成功", nil);
        coNameLbl.text = [NSString stringWithFormat:@"%@",[self.succDic objectForKey:@"companyName"]];
    }
    
    [self invitationAndJoinView];
    // Do any additional setup after loading the view.
}

-(void)invitationAndJoinView {
    

    CGSize logla1_height = [NSString sizeWithText:Custing(@"登录喜报PC端，可以批量导入员工和设置报销策略.", nil) font:Font_Same_14_20 maxSize:CGSizeMake(Main_Screen_Width-30, MAXFLOAT)];
    
    UILabel * logLa1 = [GPUtils createLable:CGRectMake(15, Y(self.coRect)+HEIGHT(self.coRect)+129, WIDTH(self.view)-30, logla1_height.height) text:Custing(@"登录喜报PC端，可以批量导入员工和设置报销策略.", nil) font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    logLa1.backgroundColor = [UIColor clearColor];
    logLa1.numberOfLines = 0;
    [self.view addSubview:logLa1];
    
    UILabel * logLa2 = [GPUtils createLable:CGRectMake(15, Y(logLa1)+HEIGHT(logLa1)-5, WIDTH(self.view)-30, 30) text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    logLa2.backgroundColor = [UIColor clearColor];//@"web.xibaoxiao.com"
    [self.view addSubview:logLa2];
    
    UIButton * enterBtn = [GPUtils createButton:CGRectMake(15, Y(logLa2)+HEIGHT(logLa2)+10, Main_Screen_Width-30, 45) action:@selector(enterWorker:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"进入喜报", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [enterBtn setBackgroundColor:Color_Blue_Important_20];
    enterBtn.layer.cornerRadius = 14.0f;
    [self.view addSubview:enterBtn];
    
    [enterBtn setTitle:Custing(@"进入喜报", nil) forState:UIControlStateHighlighted];
    if ([self.status isEqualToString:@"jiaruNEW"]) {
        enterBtn.frame = CGRectMake(15, Y(self.coRect)+HEIGHT(self.coRect)+50, Main_Screen_Width-30, 45);
        
        logLa1.frame = CGRectMake(15, Y(self.coRect)+HEIGHT(self.coRect)+120, Main_Screen_Width-30, logla1_height.height);
        logLa2.frame = CGRectMake(15, Y(logLa1)+HEIGHT(logLa1)-5, WIDTH(self.view)-30, 30);
        if ([[self.succDic objectForKey:@"Source"] isEqualToString:@"1"]) {
            [enterBtn setTitle:Custing(@"立即登录", nil) forState:UIControlStateNormal];
            [enterBtn setTitle:Custing(@"立即登录", nil) forState:UIControlStateHighlighted];
        }
        
    }else {//zhuceNEW
        UILabel * systemLbl = [GPUtils createLable:CGRectMake(0, Y(self.coRect)+HEIGHT(self.coRect)+15, Main_Screen_Width, 45) text:Custing(@"您是系统管理员，邀请同事一起加入吧", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
        systemLbl.backgroundColor = [UIColor clearColor];
        systemLbl.numberOfLines = 0;
        [self.view  addSubview:systemLbl];
        
        UIButton * invitationBtn = [GPUtils createButton:CGRectMake(15, Y(self.coRect)+HEIGHT(self.coRect)+70, Main_Screen_Width-30, 45) action:@selector(invitationWorker:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"邀请同事", nil) font:Font_Important_15_20 color:Color_Orange_Weak_20];
        [invitationBtn setBackgroundColor:[UIColor clearColor]];
        invitationBtn.layer.cornerRadius = 14.0f;
        invitationBtn.layer.borderWidth = 1.0f;
        invitationBtn.layer.borderColor = Color_Orange_Weak_20.CGColor;
        [self.view addSubview:invitationBtn];
    }
    
}

-(void)invitationWorker:(UIButton *)btn{
    JoinInvitationViewController * invitation = [[JoinInvitationViewController alloc]init];
    invitation.corpId = [self.succDic objectForKey:@"corpId"];
    if (![self.status isEqualToString:@"login"]) {
        invitation.accountInvite = @"createCom";
    }
    
    [self.navigationController pushViewController:invitation animated:YES];
    
}

-(void)enterWorker:(UIButton *)btn{
    
    if ([NSString isEqualToNull:[self.succDic objectForKey:@"Password"]]) {
        MainLoginViewController * main = [[MainLoginViewController alloc]init];
        [self.navigationController pushViewController:main animated:YES];
    }else {
        LoginViewController * login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        
    }
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
