//
//  ChooseTypeController.m
//  galaxy
//
//  Created by hfk on 2017/6/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ChooseTypeController.h"
#import "reimburProcurementViewController.h"
@interface ChooseTypeController ()
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
/**
 *  区分viewwillapper是否请求数据
 */
@property(nonatomic,strong)NSString *requestType;

@end

@implementation ChooseTypeController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.type=type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    self.ChoosedIdArray=[NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryId]?[[NSString stringWithFormat:@"%@",_ChooseCategoryId] componentsSeparatedByString:@","]:@[]];
    
    if ([_type isEqualToString:@"projectChooseType"]){
        [self setTitle:Custing(@"选择项目类型", nil) backButton:YES ];
        [self updateTable];
    }
    _requestType=@"1";
}
-(void)updateTable{
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(@-50);
    }];
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width, 50)action:@selector(AddProjectType:) delegate:self];
    btn.backgroundColor =Color_Blue_Important_20;
    [btn setTitle:Custing(@"新增", nil) forState:UIControlStateNormal];
    btn.titleLabel.font=Font_filterTitle_17 ;
    [btn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:btn];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self loadData];
    }
    _requestType=@"0";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:新建项目类型
-(void)AddProjectType:(UIButton *)btn{
    reimburProcurementViewController * reimburs = [[reimburProcurementViewController alloc]initWithType:nil Name:@"AddProjectType"];
    [self.navigationController pushViewController:reimburs animated:YES];

}
//项目
-(void)requestProjectTypeList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading=YES;
    NSDictionary * dic =@{@"ProjTyp":@"",@"PageIndex":[NSString stringWithFormat:@"%ld",self.currPage],@"PageSize":@"20"};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GETPROJTYPELIST] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    //下拉刷新
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    switch (serialNum) {
        case 0:
        {
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];

        }
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"删除成功", nil) duration:2.0];
            self.currPage=1;
            [self requestProjectTypeList];
        }
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
-(void)dealWithData{
    NSDictionary *result=_resultDict[@"result"];
    _totalPages=[result[@"totalPages"] integerValue] ;
    if (self.totalPages >= self.currPage) {
        if ([_type isEqualToString:@"projectChooseType"]){
            [ChooseCateFreModel GetProjTypeDictionary:_resultDict Array:self.resultArray];
        }
    }
}
//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else{
        return 0.5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width,10);
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        view.backgroundColor =Color_form_TextFieldBackgroundColor;
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(50, 0, Main_Screen_Width-50, 0.5)];
        lineview.backgroundColor =Color_GrayLight_Same_20;
        [view addSubview:lineview];
        return view;
    }
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell创建
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCategoryCell"];
    if (_cell==nil) {
        _cell=[[ChooseCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCategoryCell"];
    }
    
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    [_cell configFreViewWithModel:model withIdArray:_ChoosedIdArray withType:_type];
    return _cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.ChooseCateBlock) {
        weakSelf.ChooseCateBlock(self.resultArray[indexPath.section], _type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *copyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"修改", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){

        ChooseCateFreModel *cellInfo = self.resultArray[indexPath.section];
        NSDictionary *parameters = @{@"idd":[NSString stringWithFormat:@"%@",cellInfo.Id],@"type":[NSString stringWithFormat:@"%@",cellInfo.projTyp]};
        reimburProcurementViewController * reimburs = [[reimburProcurementViewController alloc]initWithType:parameters Name:@"EditProjectType"];
        [self.navigationController pushViewController:reimburs animated:YES];
    }];
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        ChooseCateFreModel *cellInfo = self.resultArray[indexPath.section];
        NSDictionary * dic =@{@"id":[NSString stringWithFormat:@"%@",cellInfo.Id]};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",DELEPROJTYPE] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    }];
    copyRowAction.backgroundColor = Color_Sideslip_TableView;
    
    return @[deleteRowAction,copyRowAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    return UITableViewCellEditingStyleDelete;//删除cell
    
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
    
}

-(void)loadData{
    if ([_type isEqualToString:@"projectChooseType"]){
        [self requestProjectTypeList];
    }
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.view configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有项目类型哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
