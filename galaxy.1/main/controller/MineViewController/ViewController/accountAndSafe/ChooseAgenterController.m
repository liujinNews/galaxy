//
//  ChooseAgenterController.m
//  galaxy
//
//  Created by hfk on 2018/8/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ChooseAgenterController.h"
#import "InstructionsViewController.h"
#import "DelegateOtherCell.h"
#import "DelegateSelfCell.h"
#import "AddAndEditDelegateController.h"

@interface ChooseAgenterController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>

@property (nonatomic, strong) NSMutableArray *arr_delegateSelf;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)BOOL requestType;

@end

@implementation ChooseAgenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"代理人设置", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    self.arr_delegateSelf = [NSMutableArray array];
    [self createTableView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"增加代理人", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_right_click)];
    [self getdelegated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        [self getdelegated];
    }
    _requestType = YES;
}

-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"agent"];
    [self.navigationController pushViewController:INFO animated:YES];
}

-(void)btn_right_click{
    AddAndEditDelegateController *vc = [[AddAndEditDelegateController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView .delegate = self;
    _tableView .dataSource = self;
    _tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//MARK:代理信息获取
-(void)getdelegated{
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",delegated_get] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
//MARK:获取代理人详情
-(void)delegatedLogin{
    NSDictionary *dic = @{@"Account":self.userdatas.SystemAccount,@"AgentUserId":self.userdatas.userId,@"UserId":self.userdatas.SystemUserId};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",delegated_login] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
        case 0:
        {
            if ([responceDic[@"result"]isKindOfClass:[NSArray class]]) {
                [self.arr_delegateSelf removeAllObjects];
                [self.arr_delegateSelf addObjectsFromArray:responceDic[@"result"]];
                [_tableView reloadData];
            }
        }
            break;
        case 1:
        {
            NSDictionary *dic = responceDic[@"result"];
            self.userdatas.SystemToken = dic[@"token"];
            self.userdatas.SystemphotoGraph = dic[@"photoGraph"];
            //设置语言
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[NSString stringWithFormat:@"%@",dic[@"language"]] isEqualToString:@"ch"]?@"zh-Hans":@"en"] forKey:AppLanguage];
            [NSUserDefaults standardUserDefaults];
            [self.userdatas storeUserInfo];
            [ApplicationDelegate setupTabViewController];
        }
            break;
        case 2:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
            [self getdelegated];
        }
            break;
        default:
            break;
    }
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
#pragma mark - UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.arr_delegateSelf.count;
    }else{
        return self.arr_delegateOther.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DelegateSelfCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DelegateSelfCell"];
        if (cell==nil) {
            cell=[[DelegateSelfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DelegateSelfCell"];
        }
        NSDictionary *dict = self.arr_delegateSelf[indexPath.row];
        cell.dict = dict;
        return cell;
    }else{
         DelegateOtherCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DelegateOtherCell"];
        if (cell==nil) {
            cell=[[DelegateOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DelegateOtherCell"];
        }
        NSString * nameStr = [self.arr_delegateOther[indexPath.row] objectForKey:@"requestor"];
        cell.title = nameStr;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 40;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
        view.backgroundColor = Color_White_Same_20;
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
        view.backgroundColor = Color_White_Same_20;
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    view.backgroundColor = Color_White_Same_20;
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dict = self.arr_delegateSelf[indexPath.row];
        AddAndEditDelegateController *vc = [[AddAndEditDelegateController alloc]init];
        vc.dict = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *dict = self.arr_delegateOther[indexPath.row];
        self.userdatas.SystemUserId = [NSString stringWithIdOnNO:dict[@"requestorUserId"]];
        self.userdatas.SystemAccount = [NSString stringWithIdOnNO:dict[@"requestorAccount"]];
        self.userdatas.SystemRequestor = [NSString stringWithIdOnNO:dict[@"requestor"]];
        self.userdatas.SystemRequestorDept = [NSString stringWithIdOnNO:dict[@"requestorDept"]];
        self.userdatas.bool_AgentHasApprove = [[NSString stringWithFormat:@"%@",dict[@"taskApproval"]] isEqualToString:@"1"] ? YES:NO;
        [self.userdatas storeUserInfo];
        self.userdatas.RefreshStr = @"YES";
        self.userdatas.SystemType = 1;
        [self.userdatas storeUserInfo];
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        // 请求代理数据
        [self delegatedLogin];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        NSDictionary *dict = self.arr_delegateSelf[indexPath.row];
        NSDictionary *parameters = @{@"Id":[NSString stringWithIdOnNO:dict[@"id"]]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",delegated_delete] Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    }];
    return @[deleteRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
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
