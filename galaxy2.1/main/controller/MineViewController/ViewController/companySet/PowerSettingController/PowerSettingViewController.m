//
//  PowerSettingViewController.m
//  galaxy
//
//  Created by hfk on 16/5/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "infoViewController.h"

#import "PowerSettingViewController.h"
#import "PowerSettingModel.h"
#import "PowerSettingCell.h"
#import "PowerMembersViewController.h"
#import "InstructionsViewController.h"
#import "PowerAddRoleController.h"
@interface PowerSettingViewController ()<GPClientDelegate,UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)NSMutableArray *resultArray;//结果数据
@property(nonatomic,strong)PowerSettingCell *cell;
@property(nonatomic,assign)BOOL requestType;
@property (nonatomic,strong)DoneBtnView * dockView;


@end

@implementation PowerSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"权限管理", nil) backButton:YES WithTitleImg:@"my_positionQ"];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self createMainViwe];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    _requestType=NO;
    [self requestPowerRoles];
    
}
-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"powerSet"];
    [self.navigationController pushViewController:INFO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_requestType) {
        [self requestPowerRoles];
    }
    _requestType=YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView endEditing:NO];
}
//MARK:创建tableViw
-(void)createMainViwe{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(@-50);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"新增", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0) {
            PowerAddRoleController *vc=[[PowerAddRoleController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}
//MARK:权限获得
-(void)requestPowerRoles{
    NSString *url=[NSString stringWithFormat:@"%@",EditPower];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [NSString isEqualToNull:[responceDic objectForKey:@"msg"]]?[responceDic objectForKey:@"msg"]:@"";
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0:
            _resultArray=[NSMutableArray array];
            [self dealWithData];
            [_tableView reloadData];
            break;
        case 1:
        {
            if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]] isEqualToString:@"-1"]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"此角色下有成员无法删除", nil) duration:1.0];
                return;
            }
            [self requestPowerRoles];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil)];
        }
            break;
        default:
            break;
    }
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

}
//MARK:数据处理
-(void)dealWithData{
    NSArray *result=_resultDict[@"result"];
    for (NSDictionary *dict in result) {
        PowerSettingModel *model=[[PowerSettingModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        if (![[NSString stringWithFormat:@"%@",model.roleId] isEqualToString:@"8"]) {
            [_resultArray addObject:model];
        }
    }
}
#pragma mark - UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _resultArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PowerSettingModel *model=(PowerSettingModel *)_resultArray[indexPath.section];
    if ([NSString isEqualToNull:model.Description]) {
        NSString *str=model.Description;
        //        str=[str stringByReplacingOccurrencesOfString:@"\n" withString:@","];
        CGSize size = [str sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-180, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
        return 30+size.height;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"PowerSettingCell"];
    if (_cell==nil) {
        _cell=[[PowerSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PowerSettingCell"];
    }
    PowerSettingModel *model=(PowerSettingModel *)_resultArray[indexPath.section];
    [_cell configViewWithModel:model withIndex:indexPath.row];
    return _cell;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PowerMembersViewController *powerVC=[[PowerMembersViewController alloc]init];
    powerVC.memebrModel=_resultArray[indexPath.section];
    [self.navigationController pushViewController:powerVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    PowerSettingModel *model=(PowerSettingModel *)_resultArray[indexPath.section];
    return [model.companyId floatValue]>0;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    PowerSettingModel *model=(PowerSettingModel *)_resultArray[indexPath.section];
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"编辑", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        PowerAddRoleController *vc=[[PowerAddRoleController alloc]init];
        vc.model_Edit=model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){

        NSString *url=[NSString stringWithFormat:@"%@",DELETEROLE];
        NSDictionary *parameters=@{@"RoleId":[NSString isEqualToNull:model.roleId]?model.roleId:@"0",@"RoleName":[NSString isEqualToNull:model.roleName]?model.roleName:@""};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];

    }];
    editRowAction.backgroundColor = Color_Sideslip_TableView;
    return @[deleteRowAction,editRowAction];
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
