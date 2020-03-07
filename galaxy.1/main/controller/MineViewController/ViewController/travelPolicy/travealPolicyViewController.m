//
//  travealPolicyViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "infoViewController.h"
#import "HStandardViewController.h"
#import "travealPolicyViewController.h"
#import "InstructionsViewController.h"
@interface travealPolicyViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * finanicalArray;
@property(nonatomic,strong)NSString * paramValue;
@property (nonatomic,strong)NSString * forStandStr;
@property (nonatomic,strong)NSString * releaseStr;

@end

@implementation travealPolicyViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if ([self.releaseStr isEqualToString:@"0"]) {
        [self requestParameterSettings];
        [self requestStdParamsGetParameterSettings];
    }else if ([self.releaseStr isEqualToString:@"1"]) {
        [self requestParameterSettings];
    }else if ([self.releaseStr isEqualToString:@"2"]) {
        [self requestStdParamsGetParameterSettings];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.releaseStr = @"0";
    self.finanicalArray = @[@[@{@"financialType":Custing(@"住宿标准", nil)}],@[@{@"financialType":Custing(@"补贴标准setting",nil)}]];
    [self setTitle:@"" backButton:NO];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.finanicalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.finanicalArray[section];
    return [itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    headView.backgroundColor = [UIColor clearColor];
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = Color_form_TextFieldBackgroundColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-35, 18, 20, 20)];
        skipImage.image = GPImage(@"skipImage");
        [cell.contentView addSubview:skipImage];
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 55.5, Main_Screen_Width-30, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [cell.contentView addSubview:lineView];
        
        UILabel * geneLbl = [GPUtils createLable:CGRectMake(15, 1, Main_Screen_Width-30, 54) text:[self.finanicalArray[indexPath.section][indexPath.row] objectForKey:@"financialType"] font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        geneLbl.backgroundColor = [UIColor clearColor];
        geneLbl.numberOfLines = 0;
        [cell.contentView addSubview:geneLbl];
        
    }
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = self.finanicalArray[indexPath.section][indexPath.row][@"financialType"];
    if ([name isEqualToString:Custing(@"住宿标准", nil)]) {
        self.releaseStr = @"1";
        HStandardViewController * hrs = [[HStandardViewController alloc]initWithType:self.paramValue forStand:@"hstandard"];
        [self.navigationController pushViewController:hrs animated:YES];
    }else if ([name isEqualToString:Custing(@"补贴标准setting", nil)]) {
        self.releaseStr = @"2";
        HStandardViewController * hrs = [[HStandardViewController alloc]initWithType:self.forStandStr forStand:@"forstand"];
        [self.navigationController pushViewController:hrs animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




//请求参数
-(void)requestParameterSettings{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetParam] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//请求参数
-(void)requestStdParamsGetParameterSettings{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StdParams/GetParamValue"] Parameters:@{@"ParamName":@"StdAllowance"} Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    
    if (serialNum ==0) {
        NSString * result = [responceDic objectForKey:@"result"];
        if (![NSString isEqualToNull:result]) {
            return;
        }else{
            self.paramValue = [NSString stringWithFormat:@"%@",result];
        }
        
    }
    
    
    if (serialNum ==1) {
        NSString * result = [responceDic objectForKey:@"result"];
        if (![NSString isEqualToNull:result]) {
            return;
        }else{
            self.forStandStr = [NSString stringWithFormat:@"%@",result];
        }
        
    }
    switch (serialNum) {
        case 0://
            break;
        default:
            break;
    }
    [self.tableView reloadData];
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
