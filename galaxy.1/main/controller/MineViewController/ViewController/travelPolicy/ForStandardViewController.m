//
//  ForStandardViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/9/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "infoViewController.h"

#import "HRStandardData.h"
#import "HRStandardTableViewCell.h"
#import "ForStandardViewController.h"
#import "InstructionsViewController.h"
@interface ForStandardViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * hrstArray;
@property (nonatomic,strong)NSMutableArray * hstandardArray;
@property (nonatomic,strong)NSMutableArray * subsidyArray;

@end

@implementation ForStandardViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"" backButton:NO];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    self.hrstArray = [NSMutableArray array];
    self.hstandardArray = [NSMutableArray array];
    self.subsidyArray = [NSMutableArray array];
    [self requestGetUserLevelData];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, NavigationbarHeight-20)];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:(CGRectMake(0,0, 40, 40))];
    [backButton setImage:[UIImage imageNamed:@"NavBarImg_GoBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(ReturnLayerOf:) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0,-15, 0, 0);
    [titleView addSubview:backButton];
    
    CGSize size = [NSString sizeWithText:Custing(@"报销标准", nil) font:Font_Important_18_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(45, 0, Main_Screen_Width - 102, HEIGHT(titleView)) text:Custing(@"报销标准", nil) font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    titleLa.backgroundColor = [UIColor clearColor];
    [titleView addSubview:titleLa];
    
    UIButton * rightSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(titleView)/2+size.width/2-8, HEIGHT(titleView)/2-16.5, 33, 33)];
    [rightSearchBtn addTarget:self action:@selector(aboutEditPosition:) forControlEvents:UIControlEventTouchUpInside];
    [rightSearchBtn setImage:GPImage(@"my_positionQ") forState:UIControlStateNormal];
    rightSearchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [titleView addSubview:rightSearchBtn];
    
    
    if ([FestivalStyle isEqualToString:@"1"]||self.userdatas.SystemType==1) {
        [backButton setImage:[UIImage imageNamed:@"Share_AgentGoBack"] forState:UIControlStateNormal];
        titleLa.textColor = Color_White_Same_20;
        [rightSearchBtn setImage:GPImage(@"my_positionsWhite") forState:UIControlStateNormal];
        
    }
    // Do any additional setup after loading the view.
}

-(void)ReturnLayerOf:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)aboutEditPosition:(UIButton *)btn{
    
    InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"ForStand"];
    [self.navigationController pushViewController:INFO animated:YES];
}

//表单加载
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hrstArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.hrstArray[section];
    return [itemArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 70)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *head1View=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    head1View.backgroundColor = [UIColor whiteColor];
    [headView addSubview:head1View];
    
    UILabel * curreryA = [GPUtils createLable:CGRectMake(15, 0, WIDTH(headView)-80, 60) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    curreryA.backgroundColor = [UIColor clearColor];
    [head1View addSubview:curreryA];
    curreryA.numberOfLines = 0;
    
    
    if (section == 0) {
        curreryA.text = Custing(@"住宿标准", nil);
    }else{
        curreryA.text = Custing(@"补贴标准setting", nil);
    }
    
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRStandardData *cellInfo = self.hrstArray[indexPath.section][indexPath.row];
    return [cellInfo.cellHeight floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRStandardTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HRStandardTableViewCell"];
    if (cell==nil) {
        cell=[[HRStandardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRStandardTableViewCell"];
    }
    HRStandardData *cellInfo = self.hrstArray[indexPath.section][indexPath.row];
    [cell configLookHRSTandardCellInfo:cellInfo];
    
    return cell;
}


//获取员工级别
-(void)requestGetUserLevelData {
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetUserLevels] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//获取员工补贴标准列表------2
-(void)requestGetStdAllowancesData {
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetStdAllowanceV2] Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}



- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    switch (serialNum) {
        case 1:
            [self.hstandardArray removeAllObjects];
            [HRStandardData GetUserLevelListDictionary:responceDic Array:self.hstandardArray];
            if (self.hstandardArray.count == 0) {
                self.hstandardArray = [NSMutableArray arrayWithArray:@[]];
                [self requestGetStdAllowancesData];

            }else {
                [self requestGetStdAllowancesData];

            }
            [self.hrstArray addObject:self.hstandardArray];
            break;
            
        case 3:
            [self.subsidyArray removeAllObjects];
            [HRStandardData GetUserForStandardListDictionary:responceDic Array:self.subsidyArray];
            if (self.subsidyArray.count == 0) {
                self.subsidyArray = [NSMutableArray arrayWithArray:@[]];
            }
            [self.hrstArray addObject:self.subsidyArray];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    if (self.hstandardArray.count == 0) {
        self.hstandardArray = [NSMutableArray arrayWithArray:@[]];
    }
    if (self.subsidyArray.count == 0) {
        self.subsidyArray = [NSMutableArray arrayWithArray:@[]];
    }
    
    [self.tableView reloadData];
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
