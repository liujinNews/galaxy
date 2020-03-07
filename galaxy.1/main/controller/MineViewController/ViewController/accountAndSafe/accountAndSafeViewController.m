//
//  accountAndSafeViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "updatePVController.h"
#import "ModifyNameViewController.h"
#import "accountAndSafeViewController.h"
#import "SafeProtectionViewController.h"
#import "LoginHistoryController.h"
#import "ChooseAgenterController.h"
#import "MainLoginViewController.h"
#import "LogOutViewController.h"

@interface accountAndSafeViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * acsArray;
@property (nonatomic,strong)UIView * footView;
@property (nonatomic, strong) NSMutableArray *arr_delegateOther;

@end

@implementation accountAndSafeViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    [self getagentsdelegated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"账号与安全", nil) backButton:YES];
    if (self.userdatas.SystemType==1) {
        self.acsArray = @[
                          @[@{@"image":@"Safe_LogInHis",@"accountType":Custing(@"最近登录记录", nil),@"tag":@"LoginHis"}],
                          @[@{@"image":@"safe_phone",@"accountType":Custing(@"更换手机号", nil),@"tag":@"ChangePhone"},
                            @{@"image":@"safe_password",@"accountType":Custing(@"修改登录密码", nil),@"tag":@"ChangePaw"}],
                          @[@{@"image":@"safe_safe",@"accountType":Custing(@"安全保护", nil),@"tag":@"SafeSetting"}]
                          ];
    }else{
        self.acsArray = @[
                          @[@{@"image":@"Safe_LogInHis",@"accountType":Custing(@"最近登录记录", nil),@"tag":@"LoginHis"}],
                          @[@{@"image":@"safe_phone",@"accountType":Custing(@"更换手机号", nil),@"tag":@"ChangePhone"},
                            @{@"image":@"safe_password",@"accountType":Custing(@"修改登录密码", nil),@"tag":@"ChangePaw"}],
                          @[@{@"image":@"safe_safe",@"accountType":Custing(@"安全保护", nil),@"tag":@"SafeSetting"}],
                          @[@{@"image":@"safe_people",@"accountType":Custing(@"代理人设置", nil),@"tag":@"SetAgent"}],
                          ];
    }

//    if (self.userdatas.source >= 11) {//第三方登录
//        self.acsArray = @[@[@{@"image":@"safe_safe",@"accountType":Custing(@"安全保护", nil),@"tag":@"SafeSetting"}],
//                          @[@{@"image":@"safe_people",@"accountType":Custing(@"代理人设置", nil),@"tag":@"SetAgent"}]
//                          ];
//    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.tableFooterView = self.footView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.acsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *itemArray = self.acsArray[section];
    return [itemArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==self.acsArray.count-1) {
        return 100.0;
    }else{
        return 10.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.acsArray.count-1) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 100)];
        
        UIView *viewC = [[UIView alloc]initWithFrame:CGRectMake(0, 45, Main_Screen_Width, 45)];
        viewC.backgroundColor = Color_White_Same_20;
        [view addSubview:viewC];
        
        UIButton * chooseBtn = [GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 45) action:@selector(btn_Logout:) delegate:self title:Custing(@"注销账户", nil) font:Font_Important_15_20 titleColor:Color_Red_Weak_20];
        chooseBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
        [viewC addSubview:chooseBtn];
        return view;
    }else{
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        self.footView.backgroundColor=[UIColor clearColor];
        return self.footView;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45.5, Main_Screen_Width, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lineView];
        
        UIImageView * helpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 22, 22)];
        helpImage.image = GPImage([self.acsArray[indexPath.section][indexPath.row] objectForKey:@"image"]);
        [cell.contentView addSubview:helpImage];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-75, 46) text:[self.acsArray[indexPath.section][indexPath.row] objectForKey:@"accountType"] font:[UIFont systemFontOfSize:16.0f] textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        if ([geneLbl.text isEqualToString:Custing(@"更换手机号", nil)]) {
            lineView.frame = CGRectMake(54, Y(lineView), WIDTH(lineView), HEIGHT(lineView));
        }
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userData * data = [userData shareUserData];
    NSString *tag = [self.acsArray[indexPath.section][indexPath.row] objectForKey:@"tag"];
    if ([tag isEqualToString:@"ChangePhone"]) {
        ModifyNameViewController * phone = [[ModifyNameViewController alloc]initWithType:@"phone"];
        phone.personDic = @{@"mobile":data.logName};
        [self.navigationController pushViewController:phone animated:YES];
    }else if ([tag isEqualToString:@"ChangePaw"]) {
        [self pushRestPasswordController];
    }else if ([tag isEqualToString:@"SafeSetting"]) {
        SafeProtectionViewController * safe = [[SafeProtectionViewController alloc]init];
        [self.navigationController pushViewController:safe animated:YES];
    }else if ([tag isEqualToString:@"SetAgent"]) {
        ChooseAgenterController * agent = [[ChooseAgenterController alloc]init];
        agent.arr_delegateOther = self.arr_delegateOther ? self.arr_delegateOther:[NSMutableArray array];
        [self.navigationController pushViewController:agent animated:YES];
    }else if ([tag isEqualToString:@"LoginHis"]) {
        LoginHistoryController *vc=[[LoginHistoryController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//MARK:修改密码
-(void)pushRestPasswordController{
    if ([self.userdatas.experience isEqualToString:@"YES"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前账号为体验账号，请登录后进行修改。", nil) duration:2.0];
        return;
    }
    userData * data = [userData shareUserData];
    if ([data.experience isEqualToString:@"no"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"体验帐号不能修改密码" duration:2.0];
        return;
    }else{
        updatePVController * update = [[updatePVController alloc]init];
        [self.navigationController pushViewController:update animated:YES];
    }
    
}

- (void)btn_Logout:(UIButton *)sender{
    LogOutViewController *logOutVC = [[LogOutViewController alloc] init];
    [self.navigationController pushViewController:logOutVC animated:YES];
}

//获取代理人
-(void)getagentsdelegated
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",delegated_getagents] Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        //        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        //        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    if (serialNum == 3) {
        _arr_delegateOther = [NSMutableArray array];
        NSArray * items = [responceDic objectForKey:@"result"];
        if ([items isKindOfClass:[NSNull class]] || items == nil|| items.count == 0||!items){
            return;
        }
        for (NSDictionary * listDic in items) {
            if ([listDic isEqual:[NSNull null]]) {
                return;
            }
            if (listDic ==nil) {
                return;
            }
            if ([NSString isEqualToNull:listDic[@"requestorDeptId"]] && [NSString isEqualToNull:listDic[@"requestorAccount"]]) {
                [_arr_delegateOther addObject:listDic];
            }
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
