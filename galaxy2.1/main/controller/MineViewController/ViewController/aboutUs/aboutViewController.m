
//
//  aboutViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "languageSwitchViewController.h"
#import "newMessageDVController.h"
#import "aboutUsViewController.h"
#import "aboutViewController.h"
#import "MainLoginViewController.h"
#import "switchCompanyViewController.h"
#import "accountAndSafeViewController.h"

@interface aboutViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * settingArray;

@end

@implementation aboutViewController

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
    self.settingArray = @[
  @[@{@"image":@"My_Account",@"companyType":Custing(@"账号与安全", nil),@"tag":@"accountSafe"}],
  @[@{@"image":@"set_message",@"companyType":Custing(@"新消息通知", nil),@"tag":@"newMessage"}],
  @[@{@"image":@"set_language",@"companyType":Custing(@"多语言",nil),@"tag":@"lunage"}],
  @[@{@"image":@"set_info",@"companyType":Custing(@"版本信息", nil),@"tag":@"Version"},@{@"image":@"set_about",@"companyType":Custing(@"关于喜报", nil),@"tag":@"aboutXB"}],
  @[@{@"image":@"Setting_SwitchCompay",@"companyType":Custing(@"切换公司",nil),@"tag":@"changeCom"}]];
    [self setTitle:Custing(@"设置", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}

-(void)btn_Quit{
    if (self.userdatas.SystemType == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:Custing(@"退出代理模式？", nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:Custing(@"退出登录？", nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
    }
}

//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:Custing(@"确定", nil)]) {
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
        
        [UMessage removeAlias:self.userdatas.userId type:@"GalaxyPoint" response:^(id responseObject, NSError *error) {
            
        }];
        if (self.userdatas.SystemType==1) {
            self.userdatas.SystemType=0;
            self.userdatas.SystemUserId=@"";
            self.userdatas.SystemToken=@"";
            self.userdatas.SystemRequestor = @"";
            self.userdatas.SystemRequestorDept = @"";
            [self.userdatas storeUserInfo];
            self.userdatas.RefreshStr = @"YES";
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[self.userdatas.language isEqualToString:@"ch"]?@"zh-Hans":@"en"] forKey:AppLanguage];
            [NSUserDefaults standardUserDefaults];
            
            [ApplicationDelegate setupTabViewController];
        }else{
//            self.userdatas.sig = @"";
            self.userdatas.password = @"";
            [self.userdatas storeUserInfo];
            if (![self.userdatas.experience isEqualToString:@"YES"]) {
                MainLoginViewController * login = [[MainLoginViewController alloc]init];
                login.isGoLoginView = 1;
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }else{
                MainLoginViewController *firs = [[MainLoginViewController alloc]init];
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:firs];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }
        }
    }
}

-(void)clearCacheSuccess{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.settingArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *itemArray = self.settingArray[section];
    return [itemArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    footView.backgroundColor=[UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.settingArray.count-1) {
        return 55;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==self.settingArray.count-1) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
        view.backgroundColor=Color_White_Same_20;
        
        UIButton * chooseBtn = [GPUtils createButton:CGRectMake(0, 10, Main_Screen_Width, 45) action:@selector(btn_Quit) delegate:self title:Custing(@"退出登录", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
        if (self.userdatas.SystemType == 1) {
            [chooseBtn setTitleColor:Color_Orange_Weak_20 forState:UIControlStateNormal];
            [chooseBtn setTitle:Custing(@"退出代理模式", nil) forState:UIControlStateNormal];
        }
        chooseBtn.backgroundColor = Color_form_TextFieldBackgroundColor;
        [view addSubview:chooseBtn];
        return view;
    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor =Color_WhiteWeak_Same_20;
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-90, 46) text:[self.settingArray[indexPath.section][indexPath.row] objectForKey:@"companyType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        
        UIImageView * helpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 22, 22)];
        helpImage.image = GPImage([self.settingArray[indexPath.section][indexPath.row] objectForKey:@"image"]);
        [cell.contentView addSubview:helpImage];
        
        NSString * tag = [self.settingArray[indexPath.section][indexPath.row] objectForKey:@"tag"];
       
        if ([tag isEqualToString:@"changeCom"]){
            UILabel *lab = [GPUtils createLable:CGRectMake(160, 0, Main_Screen_Width-200, 45) text:self.userdatas.company font:Font_Important_15_20 textColor:Color_cellTitle textAlignment:NSTextAlignmentRight];
            [cell addSubview:lab];
        }
        NSArray *array = self.settingArray[indexPath.section];
        if (array.count > 1 && indexPath.row != array.count - 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(54, 45.5, Main_Screen_Width - 54, 0.5)];
            line.backgroundColor = Color_GrayLight_Same_20;
            [cell.contentView addSubview:line];
        }
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.settingArray[indexPath.section][indexPath.row][@"tag"];
    if ([name isEqualToString:@"accountSafe"]) {
        if ([self.userdatas.experience isEqualToString:@"yes"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"当前为体验账号，无法进行操作。" duration:1.0];
            return;
        }
        accountAndSafeViewController * account = [[accountAndSafeViewController alloc]init];
        [self.navigationController pushViewController:account animated:YES];
    }else if ([name isEqualToString:@"newMessage"]) {
        newMessageDVController * message = [[newMessageDVController alloc]init];
        [self.navigationController pushViewController:message animated:YES];
    }else if ([name isEqualToString:@"lunage"]){
        languageSwitchViewController * languae = [[languageSwitchViewController alloc]init];
        [self.navigationController pushViewController:languae animated:YES];
    }else if ([name isEqualToString:@"Version"]){
        aboutUsViewController * aboutUs = [[aboutUsViewController alloc]initWithType:@"banben"];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }else if ([name isEqualToString:@"aboutXB"]){
        aboutUsViewController * aboutUs = [[aboutUsViewController alloc]initWithType:@"about"];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }else if ([name isEqualToString:@"changeCom"]){
        if ([self.userdatas.mySystemStr isEqualToString:@"12"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"代理模式不可进入", nil) duration:1.5];
            return;
        }
        switchCompanyViewController * switchDic = [[switchCompanyViewController alloc]init];
        [self.navigationController pushViewController:switchDic animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
