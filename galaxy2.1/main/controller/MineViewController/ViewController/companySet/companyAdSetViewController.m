//
//  companyAdSetViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "ticketSpecificationViewController.h"

#import "BudgetSettingViewController.h"
#import "editCompanyDcoController.h"
#import "InvitationJoinViewController.h"
#import "positionDisignViewController.h"
#import "JoinInvitationViewController.h"
//编辑通讯录
#import "ComPeopleEditViewController.h"

#import "companyAdSetViewController.h"
#import "PowerSettingViewController.h"
#import "BillInfoViewController.h"
#import "costCenterViewController.h"
#import "BillInfoListController.h"
@interface companyAdSetViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * companyArray;
@property (nonatomic,strong)UIView * footView;
@property (nonatomic,strong)UILabel * nameLbl;
@property (nonatomic,strong)UILabel * numberLbl;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
@end

@implementation companyAdSetViewController
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
    
    self.companyArray = @[
                        @[@{@"companyImage":@"enterpriseSet",@"companyType":Custing(@"企业设置", nil),@"tag":@"name"}],
  
                        @[@{@"companyImage":@"My_InvitationWorker",@"companyType":Custing(@"邀请同事加入", nil),@"tag":@"join"}],
       
                        @[@{@"companyImage":@"administration",@"companyType":Custing(@"员工管理", nil),@"tag":@"set"},@{@"companyImage":@"positionDisign",@"companyType":Custing(@"员工职位", nil),@"tag":@"set"},@{@"companyImage":@"GetLevel",@"companyType":Custing(@"员工级别", nil),@"tag":@"set"},@{@"companyImage":@"costCenter",@"companyType":Custing(@"成本中心", nil),@"tag":@"join"}],
                          
                       @[@{@"companyImage":@"CHMOD",@"companyType":Custing(@"权限管理", nil),@"tag":@"set"},@{@"companyImage":@"approvalAdmin",@"companyType":Custing(@"审批管理", nil),@"tag":@"join"}],
                          
                        @[@{@"companyImage":@"NormalInvoiceInfo",@"companyType":Custing(@"发票抬头", nil),@"tag":@"set"},@{@"companyImage":@"NormalTicketSpecification",@"companyType":Custing(@"报销规范", nil),@"tag":@"join"}]
                        ];
    [self setTitle:Custing(@"公司管理", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    // Do any additional setup after loading the view.
}

#pragma mark - function
//获取个人信息
-(void)requestUserInfo
{
    [[GPClient shareGPClient]REquestByPostWithPath:XB_PersonalInfo Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
}

//请求基本数据
-(void)requestCredentials
{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcosummary] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.companyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.companyArray[section];
    return [itemArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==self.companyArray.count-1) {
        return 0.0;
    }else{
        return 10.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.companyArray.count-1) {
        return nil;
    }else{
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        self.footView.backgroundColor=[UIColor clearColor];
        return self.footView;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 65;
    }else{
        return 46;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
//        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView * helpImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 24, 24)];
        helpImage.image = GPImage([self.companyArray[indexPath.section][indexPath.row] objectForKey:@"companyImage"]);
        [cell.contentView addSubview:helpImage];
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 14, 18, 18)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width-90, 46) text:[self.companyArray[indexPath.section][indexPath.row] objectForKey:@"companyType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:geneLbl];
        
        NSString * tag = [self.companyArray[indexPath.section][indexPath.row] objectForKey:@"tag"];
        if ([tag isEqualToString:@"name"]) {
            geneLbl.hidden = YES;
            self.nameLbl = [GPUtils createLable:CGRectMake(54, 10, Main_Screen_Width-90, 26) text:Custing(@"企业设置", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            self.nameLbl.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:self.nameLbl];
            if ([NSString isEqualToNull:self.userdatas.company]) {
                self.nameLbl.text = [NSString stringWithFormat:@"%@",self.userdatas.company];
            }
            
            self.numberLbl = [GPUtils createLable:CGRectMake(54, 36, Main_Screen_Width-90, 20) text:Custing(@"企业号：", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            self.numberLbl.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:self.numberLbl];
            
            if ([NSString isEqualToNull:self.userdatas.coCode]) {
                self.numberLbl.text = [NSString stringWithFormat:@"%@%@",Custing(@"企业号：", nil),self.userdatas.coCode];
            }
            
        }else if ([tag isEqualToString:@"set"]){
            UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(54, 45.5, Main_Screen_Width-69, 0.5)];
            lineView.backgroundColor = Color_GrayLight_Same_20;
            [cell.contentView addSubview:lineView];
        }
        
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.companyArray[indexPath.section][indexPath.row][@"companyType"];
    if ([name isEqualToString:Custing(@"企业设置", nil)]) {
        editCompanyDcoController * editCom = [[editCompanyDcoController alloc]initWithType:@"companyEdit"];
        [self.navigationController pushViewController:editCom animated:YES];
    }else if ([name isEqualToString:Custing(@"邀请同事加入", nil)]){
        JoinInvitationViewController * invitation = [[JoinInvitationViewController alloc]init];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.userdatas.coCode]]) {
            invitation.corpId = [NSString stringWithFormat:@"%@",self.userdatas.coCode];
        }
        [self.navigationController pushViewController:invitation animated:YES];
    }else if ([name isEqualToString:Custing(@"员工管理", nil)]){
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        //请求跳转参数
        [self requestUserInfo];
    }else if ([name isEqualToString:Custing(@"员工职位", nil)]){
        positionDisignViewController * position = [[positionDisignViewController alloc]initWithType:@"position"];
        [self.navigationController pushViewController:position animated:YES];
    }else if ([name isEqualToString:Custing(@"员工级别", nil)]){
        positionDisignViewController * position = [[positionDisignViewController alloc]initWithType:@"level"];
        [self.navigationController pushViewController:position animated:YES];
    }else if ([name isEqualToString:Custing(@"权限管理", nil)]){
        PowerSettingViewController * powerEdit = [[PowerSettingViewController alloc]init];
        [self.navigationController pushViewController:powerEdit animated:YES];
    }else if ([name isEqualToString:Custing(@"审批管理", nil)]){
        BudgetSettingViewController *exp = [[BudgetSettingViewController alloc]init];
        exp.statusStr = @"approvalAdmin";
        [self.navigationController pushViewController:exp animated:YES];
    }else if ([name isEqualToString:Custing(@"发票抬头", nil)]){
        BillInfoListController *vc=[[BillInfoListController alloc]init];
        vc.CanDeal=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:Custing(@"报销规范", nil)]) {
        ticketSpecificationViewController * ticket = [[ticketSpecificationViewController alloc]initWithType:@{@"ticket":@"manager"}];
        [self.navigationController pushViewController:ticket animated:YES];
    }else if ([name isEqualToString:Custing(@"成本中心", nil)]) {
        costCenterViewController * cost = [[costCenterViewController alloc]init];
        [self.navigationController pushViewController:cost animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 3:
        {
            NSDictionary *userInfo = responceDic[@"result"];
            self.userdatas.company = userInfo[@"companyName"];
            self.userdatas.companyId = [NSString stringWithIdOnNO:userInfo[@"companyId"]];
            
            NSArray *usergroup_arr = userInfo[@"userGroup"];
            if (usergroup_arr.count>0) {
                NSDictionary *userGroup_Dic = usergroup_arr[0];
                self.userdatas.groupname = userGroup_Dic[@"groupName"];
                self.userdatas.groupid = userGroup_Dic[@"groupId"];
            }
            
            [self.userdatas storeUserInfo];
            [self requestCredentials];
        }
            break;
        case 0:
        {
            NSDictionary * result = [responceDic objectForKey:@"result"];
            self.userdatas.companyId = [NSString stringWithIdOnNO:[result objectForKey:@"groupId"]];
            [self.userdatas storeUserInfo];
            
            ComPeopleEditViewController *comedit = [[ComPeopleEditViewController alloc]init];
            comedit.nowGroup = self.userdatas.companyId;
            [self.navigationController pushViewController:comedit animated:YES];
        }
            break;
        default:
            break;
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
