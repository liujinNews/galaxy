//
//  PowerMembersViewController.m
//  galaxy
//
//  Created by hfk on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PowerMembersViewController.h"
#import "PowerMembersCell.h"
#import "contactsVController.h"
#import "buildCellInfo.h"


@interface PowerMembersViewController ()<GPClientDelegate,ByvalDelegate>
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)PowerMembersCell *cell;
@property (nonatomic, strong) UIView *dockView;//底部视图
@property(nonatomic,strong)UIButton *addBtn;//添加按钮
@property(nonatomic,strong)NSMutableArray *choosePeopleArray;
@property(nonatomic,strong)NSString *requestType;//请求类型
@property (assign, nonatomic)NSInteger totalPage;//系统分页数


@end

@implementation PowerMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_memebrModel.roleName backButton:YES ];
    [self createAddBtn];
     _requestType=@"0";
    self.tableView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(@-50);
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if ([_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requestPowerMember];
    }
    _requestType=@"1";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建添加按钮
-(void)createAddBtn{
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    _addBtn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width, 50)action:@selector(addPowerMember) delegate:self];
    _addBtn.backgroundColor =Color_Blue_Important_20;
    [_addBtn setTitle:Custing(@"添加成员", nil) forState:UIControlStateNormal];
    _addBtn.titleLabel.font=Font_filterTitle_17 ;
    [_addBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:_addBtn];
}
//MARK:添加成员
-(void)addPowerMember{
    
    
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.arrClickPeople =_choosePeopleArray;
    contactVC.status = @"5";
    contactVC.menutype=3;
    contactVC.Radio = @"2";
    contactVC.isclean = @"1";
    contactVC.universalDelegate = self;
    contactVC.itemType = 99;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        if (array.count>0) {
            NSMutableArray *roleNames=[NSMutableArray array];
            NSMutableArray *userNames=[NSMutableArray array];
            for (buildCellInfo *info in array) {
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]]) {
                    [roleNames addObject:[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]];
                }
                if ([NSString isEqualToNull:info.requestor]) {
                    [userNames addObject:[NSString stringWithFormat:@"%@",info.requestor]];
                }
            }
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSString *url=[NSString stringWithFormat:@"%@",PowerMemberInsert];
            NSDictionary *parameters =@{@"RoleId":weakSelf.memebrModel.roleId,@"RoleName":[GPUtils getSelectResultWithArray:roleNames WithCompare:@","],@"UserName":[GPUtils getSelectResultWithArray:userNames WithCompare:@","],@"Description":weakSelf.memebrModel.roleName};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:weakSelf SerialNum:2 IfUserCache:NO];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//MARK:请求数据
-(void)requestPowerMember{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",PowerMemberNew];
     NSDictionary *parameters =@{@"roleId":_memebrModel.roleId,@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@10,@"OrderBy":@"UserDspName",@"IsAsc":@"asc"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        [self.tableView.mj_header  endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    switch (serialNum) {
        case 0:
            [self dealWithDownloadData];
            [self.tableView reloadData];
            
            [self createNOdataView];

            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header  endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            break;
        case 1:
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:1.0];
            self.currPage=1;
            [self requestPowerMember];
            break;
        case 2:
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"添加成功", nil) duration:1.0];
            self.currPage=1;
            [self requestPowerMember];
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
-(void)dealWithDownloadData{
    NSDictionary *result=_resultDict[@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        _totalPage=[result[@"totalPages"] integerValue] ;
        NSArray *array=result[@"items"];
        if (![array isKindOfClass:[NSNull class]]&&array.count!=0) {
            self.resultArray=[NSMutableArray arrayWithArray:array];
            _choosePeopleArray=[NSMutableArray array];
            if (self.currPage<=_totalPage) {
                NSArray *array=result[@"items"];
                for (NSDictionary *dict in array) {
                  NSDictionary *chooseDict=@{@"requestor":dict[@"userName"],@"requestorUserId":dict[@"userId"]};
                  [_choosePeopleArray addObject:chooseDict];
                }
            }else{
                NSArray *array=nil;
                for (NSDictionary *dict in array) {
                    NSDictionary *chooseDict=@{@"requestor":dict[@"userName"],@"requestorUserId":dict[@"userId"]};
                    [_choosePeopleArray addObject:chooseDict];
                }
            }
        }else {
            self.resultArray = [NSMutableArray arrayWithArray:@[]];
            _choosePeopleArray = [NSMutableArray arrayWithArray:@[]];
        }
    }
}
#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"PowerMembersCell"];
    if (_cell==nil) {
        _cell=[[PowerMembersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PowerMembersCell"];
    }
    [_cell configWithDict:self.resultArray[indexPath.row]];
    
    return _cell;
}
//是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
   
}
//删除模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=self.resultArray[indexPath.row];
    NSString *name=dict[@"userName"];
    if ([[NSString stringWithFormat:@"%@",_memebrModel.roleId] isEqualToString:@"2"]&&[name isEqualToString:self.userdatas.userDspName]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"系统管理员不允许删除自己", nil) duration:2.0];
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }

}
//处理删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSDictionary *dict=self.resultArray[indexPath.row];
        NSString *url=[NSString stringWithFormat:@"%@",PowerMemberDelete];
        NSDictionary *parameters =@{@"RoleId":_memebrModel.roleId,@"RoleName":dict[@"userId"],@"UserName":dict[@"userName"],@"Description":_memebrModel.roleName};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }
}

-(void)loadData{
    [self requestPowerMember];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有添加成员哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
