//
//  switchCompanyViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/8/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "createNeViewController.h"
#import "createJoinCViewController.h"
#import "switchCompanyViewController.h"
#import "costCenterCell.h"


@interface switchCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate,ByvalDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * companyArray;
@property (nonatomic,strong)NSDictionary * choseDic;
@property (nonatomic,strong)UIButton * submitBtn;

@end

@implementation switchCompanyViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
     [self RequestCompanyDocument];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"切换公司", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-49)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    self.companyArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"创建新公司SW", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(switchCreateCom:)];

    
    UIButton * submitBtn = [GPUtils createButton:CGRectMake(0,ScreenRect.size.height - 45 - NavigationbarHeight, Main_Screen_Width,45) action:@selector(pushJoinCompany:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"加入已有公司", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [submitBtn setBackgroundColor:Color_Blue_Important_20];
    [self.view addSubview: submitBtn];
    
    // Do any additional setup after loading the view.
}

-(void)switchCreateCom:(UIButton *)btn {
    //创建新公司
    createNeViewController * swC = [[createNeViewController alloc]init];
    [self.navigationController pushViewController:swC animated:YES];
    
   
}

-(void)pushJoinCompany:(UIButton *)btn {
    //加入现有公司
    createJoinCViewController * create = [[createJoinCViewController alloc]initWithType:@"jiaruXIAN"];
    [self.navigationController pushViewController:create animated:YES];
}

//获取我的企业表单数据
-(void)RequestCompanyDocument{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"user/GetUserCoList"] Parameters:@{@"CompanyId":[NSString stringWithFormat:@"%@",self.userdatas.companyId],@"CompanyName":[NSString stringWithFormat:@"%@",self.userdatas.company]} Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//
-(void)RequestSwitchCompany:(NSDictionary *)comDic {
    
    [[GPClient shareGPClient]REquestByPostWithPath:XB_SwitchCorp Parameters:comDic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.companyArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    costCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:@"costCenterCell"];
    if (cell==nil) {
        cell=[[costCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCenterCell"];
    }
     NSDictionary *name = self.companyArray[indexPath.row];
    [cell configCompanySwitchCellInfo:name];
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:[NSString stringWithFormat:@"%@",[self.companyArray[indexPath.row] objectForKey:@"companyId"]]]) {
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 16.5, 15, 15)];
        skipImage.image = GPImage(@"Language_sure");
        [cell.mainView addSubview:skipImage];
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choseDic = @{};
    self.choseDic = self.companyArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[NSString stringWithFormat:@"%@",self.userdatas.company] isEqualToString:[self.companyArray[indexPath.row] objectForKey:@"companyName"]]) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@？",Custing(@"切换公司", nil)] delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
    [alert show];
    
    
}

//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:Custing(@"确定", nil)]) {
        [self RequestSwitchCompany:@{@"UserId":[NSString stringWithFormat:@"%@",self.userdatas.userId],@"CompanyId":[NSString stringWithFormat:@"%@",self.choseDic[@"companyId"]]}];
    }else if ([btnTitle isEqualToString:Custing(@"取消", nil)] ) {
        NSLog(@"你点击了重新登录按钮");
    }
}


-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        }
        return;
    }
    if (serialNum == 0) {
        
        NSArray * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }else{
            self.companyArray = [NSMutableArray arrayWithArray:result];
        }
        
        [self.tableView reloadData];
    }else if (serialNum == 1) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            return;
        }
        self.userdatas.multCompanyId=@"0";
        self.userdatas.language = [NSString isEqualToNull:result[@"language"]] ? result[@"language"]:@"ch";
        [[NSUserDefaults standardUserDefaults] setObject:[self.userdatas.language isEqualToString:@"en"] ? @"en":@"zh-Hans" forKey:AppLanguage];
        [NSUserDefaults standardUserDefaults];
        self.userdatas.companyLogo = result[@"companyLogo"];
        self.userdatas.checkExpiryDic = result[@"checkExpiry"];
        self.userdatas.source = [result[@"source"] integerValue];
        self.userdatas.companyId = [NSString stringWithIdOnNO:result[@"companyId"]];
        self.userdatas.company = [NSString stringWithIdOnNO:result[@"coName"]];
        self.userdatas.department = [NSString stringWithIdOnNO:result[@"department"]];
        self.userdatas.coCode = [NSString stringWithIdOnNO:result[@"coCode"]];
        self.userdatas.userDspName = [NSString stringWithIdOnNO:result[@"userDspName"]];
        self.userdatas.token = [NSString stringWithFormat:@"%@",result[@"token"]];
        self.userdatas.userId = [NSString stringWithFormat:@"%@",result[@"userId"]];
        self.userdatas.isOnlinePay = [NSString stringWithFormat:@"%@",result[@"isOnlinePay"]];
        self.userdatas.CorpActTyp = [NSString stringWithFormat:@"%@",result[@"corpActTyp"]];
        self.userdatas.multiCyPayment = [[NSString stringWithFormat:@"%@",result[@"multiCyPayment"]] isEqualToString:@"1"] ? @"1":@"0";
        self.userdatas.isOpenChanPay = [[NSString stringWithFormat:@"%@",result[@"isOpenChanPay"]] isEqualToString:@"1"] ? @"1":@"0";

        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",result[@"photoGraph"]]];
        if ([dic isKindOfClass:[NSDictionary class]]){
            self.userdatas.photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        }else{
            self.userdatas.photoGraph = nil;
        }
        self.userdatas.gender = [NSString stringWithIdOnNO:result[@"gender"]];
        self.userdatas.groupid = @"0";

        self.userdatas.cacheItems = [NSMutableDictionary dictionary];

        if ([result[@"cacheItems"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"cacheItems"]) {
                NSString *name = dict[@"name"];
                if (!self.userdatas.cacheItems[name]) {
                    NSDictionary *item = @{@"updateTime":[NSString stringWithIdOnNO:dict[@"updateTime"]],
                                           @"update":@"1"
                                           };
                    [self.userdatas.cacheItems setObject:item forKey:name];
                }else{
                    NSDictionary *item;
                    if ([self.userdatas.cacheItems[name][@"updateTime"] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"updateTime"]]]) {
                        item = @{@"updateTime":[NSString stringWithIdOnNO:dict[@"updateTime"]],
                                 @"update":@"0"
                                 };
                        
                    }else{
                        item = @{@"updateTime":[NSString stringWithIdOnNO:dict[@"updateTime"]],
                                 @"update":@"1"
                                 };
                    }
                    [self.userdatas.cacheItems setObject:item forKey:name];
                }
            }
        }
        self.userdatas.isSystem = [[NSString stringWithFormat:@"%@",result[@"isManager"]] isEqualToString:@"1"] ? @"1":@"0";
        self.userdatas.RefreshStr = @"YES";
        [self.userdatas storeUserInfo];
        __weak typeof(self) weakSelf = self;
        [[VoiceDataManger sharedManager]getBaseShowDataWithBlock:^(BOOL successed) {
            if (successed) {
                [ApplicationDelegate setupTabViewController];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"数据有误", nil) duration:1.0];
                return;
            }
        }];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
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
