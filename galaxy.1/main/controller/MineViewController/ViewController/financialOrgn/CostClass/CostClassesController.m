//
//  CostClassesController.m
//  galaxy
//
//  Created by hfk on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "moreCostClassViewController.h"
#import "infoViewController.h"

#import "CostClassesController.h"
#import "CostClassesModel.h"
#import "CostClassesCell.h"
#import "SecCostClassesController.h"
#import "AddCostClassesController.h"
#import "FirCostClassesController.h"
#import "InstructionsViewController.h"
#define pageNum (Main_Screen_Height-NavigationbarHeight-50)/34
@interface CostClassesController ()<GPClientDelegate>
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property (nonatomic, strong) UIView *dockView;//底部视图
@property(nonatomic,strong)UIButton *editBtn;//编辑按钮
@property(nonatomic,strong)UIButton *addBtn;//添加按钮
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(nonatomic,strong)CostClassesCell *cell;
@property(nonatomic,strong)NSString *requestType;//请求类型

@end

@implementation CostClassesController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"" backButton:NO ];
    [self createEditAndAdd];
    _requestType=@"0";
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(@-50);
    }];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self setTitle:Custing(@"费用类别", nil) backButton:YES WithTitleImg:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"更多", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(pushMoreSetting:)];
    
}


-(void)ImageClicked:(id)obj{
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"costClass"];
    [self.navigationController pushViewController:INFO animated:YES];
}

-(void)pushMoreSetting:(UIButton *)btn {
    moreCostClassViewController * more = [[moreCostClassViewController alloc]init];
    [self.navigationController pushViewController:more animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([_requestType isEqualToString:@"1"]) {
        self.currPage=1;
        [self requsetCostClasses];
    }
    _requestType=@"1";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建编辑添加按钮
-(void)createEditAndAdd{
    
    self.dockView = [[UIView alloc]init];
    self.dockView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    
    _editBtn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width/2, 50)action:@selector(editInfo) delegate:self];
    _editBtn.backgroundColor =Color_Blue_Important_20;
    [_editBtn setTitle:Custing(@"编辑", nil) forState:UIControlStateNormal];
    _editBtn.titleLabel.font=Font_filterTitle_17 ;
    [_editBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:_editBtn];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenRect.size.width/2-1, 0, 1, 50)];
    imageView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_editBtn addSubview:imageView];
    
    _addBtn=[GPUtils createButton:CGRectMake(ScreenRect.size.width/2, 0, ScreenRect.size.width/2, 50)action:@selector(addInfo) delegate:self];
    _addBtn.backgroundColor = Color_Blue_Important_20;
    [_addBtn setTitle:Custing(@"添加", nil) forState:UIControlStateNormal];
    _addBtn.titleLabel.font=Font_filterTitle_17 ;
    [_addBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:_addBtn];
}


//MARK:费用类别
-(void)requsetCostClasses{
    self.isLoading = YES;
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",COSTClasses];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": [NSString stringWithFormat:@"%d",(int)pageNum],@"OrderBy":@"Status desc,No",@"IsAsc":@"",@"parentid":@"0"};
      [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    
}
//MARK:编辑费用类别
-(void)editInfo{
    FirCostClassesController *firstVC=[[FirCostClassesController alloc]initWithType:@"1"];
    [self.navigationController pushViewController:firstVC animated:YES];
}

//MARK:添加费用类别
-(void)addInfo{
    AddCostClassesController *addCostVC=[[AddCostClassesController alloc]initWithType:@"1"];
//    addCostVC
    [self.navigationController pushViewController:addCostVC animated:YES];

}

//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    }
    _resultDict=responceDic;
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
            [self dealWithData];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            break;
        case 1:
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
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            CostClassesModel *model=[[CostClassesModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            CostClassesModel *model=[[CostClassesModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}


#pragma mark - UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width,0.01)];
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
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"CostClassesCell"];
    if (_cell==nil) {
        _cell=[[CostClassesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CostClassesCell"];
    }
    CostClassesModel *model=(CostClassesModel  *)self.resultArray[indexPath.row];
     NSInteger sta = [model.status integerValue];
    [_cell configViewWithModel:model withType:@"1"withStatus:sta];
    if (indexPath.row==self.resultArray.count-1) {
        _cell.lineView.hidden=YES;
    }
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecCostClassesController *secCostVC=[[SecCostClassesController alloc]initWithType:@"1"];
    secCostVC.costModel=self.resultArray[indexPath.row];
    [self.navigationController pushViewController:secCostVC animated:YES];
}
-(void)loadData{
 [self requsetCostClasses];
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
