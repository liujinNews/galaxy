//
//  HStandardViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "infoViewController.h"

#import "modifyHrandViewController.h"
#import "modifyHarstViewController.h"
#import "HRStandardData.h"
#import "HRStandardTableViewCell.h"
#import "HStandardViewController.h"
#import "InstructionsViewController.h"
#import "ChooseCategoryModel.h"
#import "ChooseCategoryController.h"
@interface HStandardViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * hrstArray;
@property (nonatomic,strong)NSString * paramValue;
@property (nonatomic,strong)UISwitch * currerySw;
@property (nonatomic,strong)NSString * returnStr;
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)NSString * statusStr;
/**
 *  tableView头视图
 */
@property(nonatomic,strong)UIView *headView;
/**
 超标准是否可以提交
 */
@property (nonatomic,strong)NSString * CanSubmit;
@property (nonatomic,strong)NSMutableArray *submitArray;
/**
 是否可以提交显示Label
 */
@property (nonatomic,strong)UILabel *CanSubmitLab;
@end

@implementation HStandardViewController
-(NSMutableArray *)submitArray{
    if (_submitArray==nil) {
        _submitArray=[NSMutableArray array];
        NSArray *type=@[Custing(@"可以", nil),Custing(@"不可以", nil)];
        NSArray *code=@[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
            model.addCostType=type[i];
            model.addCostCode=code[i];
            [_submitArray addObject:model];
        }
    }
    return _submitArray;
}
-(id)initWithType:(NSString *)type forStand:(NSString *)string{
    self = [super init];
    if (self) {
        self.paramValue = type;
        self.statusStr = string;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if ([self.returnStr isEqualToString:@"bouu"]) {
        if ([self.paramValue isEqualToString:@"0"]) {
            self.hrstArray = nil;
        }else{
            if ([self.statusStr isEqualToString:@"hstandard"]) {
                [self requestGetUserLevelData];
            }else {
                [self requestGetStdAllowancesData];
            }
            
        }
    }else{
        if ([self.paramValue isEqualToString:@"0"]) {
            self.hrstArray = nil;
        }else{
            if ([self.statusStr isEqualToString:@"hstandard"]) {
                [self requestGetUserLevelData];
            }else {
                [self requestGetStdAllowancesData];
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:nil backButton:NO];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self createHeaderView];
    self.tableView.tableHeaderView = self.headerView;
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
    
    CGSize size;// = [NSString sizeWithText:Custing(@"报销标准", nil) font:Font_Important_18_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if ([self.statusStr isEqualToString:@"hstandard"]) {
        size = [NSString sizeWithText:Custing(@"住宿标准", nil) font:Font_Important_18_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    }else {
        size = [NSString sizeWithText:Custing(@"补贴标准setting", nil) font:Font_Important_18_20 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    }
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(45, 0, Main_Screen_Width - 102, HEIGHT(titleView)) text:Custing(@"报销标准", nil) font:Font_Important_18_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    titleLa.backgroundColor = [UIColor clearColor];
    [titleView addSubview:titleLa];
    if ([self.statusStr isEqualToString:@"hstandard"]) {
        titleLa.text = Custing(@"住宿标准", nil);
    }else {
        titleLa.text = Custing(@"补贴标准setting", nil);
    }
    
    UIButton * rightSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(titleView)/2+size.width/2-8, HEIGHT(titleView)/2-16.5, 33, 33)];
    [rightSearchBtn addTarget:self action:@selector(aboutEditPosition:) forControlEvents:UIControlEventTouchUpInside];
    [rightSearchBtn setImage:GPImage(@"my_positionQ") forState:UIControlStateNormal];
    rightSearchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    if ([self.statusStr isEqualToString:@"hstandard"]) {
        rightSearchBtn.tag = 101;
    }else {
        rightSearchBtn.tag = 102;
    }
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
    switch (btn.tag) {
        case 101:
        {
            infoViewController * INFO = [[infoViewController alloc]initWithType:@"HRStandard"];
            [self.navigationController pushViewController:INFO animated:YES];
        }
            break;
        case 102:
        {
            InstructionsViewController * INFO = [[InstructionsViewController alloc]initWithType:@"ForStand"];
            [self.navigationController pushViewController:INFO animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)createHeaderView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
    self.headerView.backgroundColor = [UIColor clearColor];
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    headView.backgroundColor = Color_form_TextFieldBackgroundColor;
    UILabel * curreryA = [GPUtils createLable:CGRectMake(15, 0, WIDTH(headView)-80, 60) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [headView  addSubview:curreryA];
    curreryA.numberOfLines = 0;

    
    self.currerySw = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH(headView)-70, 15, 0, 0)];
    self.currerySw.backgroundColor = [UIColor clearColor];
    self.currerySw.transform= CGAffineTransformMakeScale(1.15,1.15);
    if ([self.paramValue isEqualToString:@"0"]) {
        [self.currerySw setOn:[self.paramValue boolValue] animated:NO];
    }else{
        [self.currerySw setOn:[self.paramValue boolValue] animated:NO];
    }
    self.currerySw.tag = 101;
    
    if ([self.statusStr isEqualToString:@"hstandard"]) {
        curreryA.text = Custing(@"住宿标准", nil);
    }else{
        curreryA.text = Custing(@"补贴标准setting", nil);
    }
    
    [self.currerySw addTarget:self action:@selector(openHRAndExchangeRateBtn:) forControlEvents:UIControlEventValueChanged];
    self.currerySw.onTintColor = Color_Blue_Important_20;
    
    [headView addSubview:self.currerySw];
    [self.headerView addSubview:headView];
    [self.tableView addSubview:self.headerView];
}

-(void)openHRAndExchangeRateBtn:(UISwitch *)btn{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:Custing(@"当前网络不可用，请检查您的网络设置",nil) delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"确定", nil), nil];
        [alert show];
        return;
    }
    switch (btn.tag) {
        case 101:
            if ([self.paramValue isEqualToString:@"0"]) {
                self.paramValue = @"1";
                if ([self.statusStr isEqualToString:@"hstandard"]) {
                    [self requestModifyTheParameters];
                }else {
                    [self requestModifyForStandParameters];
                }
                
                [self.currerySw setOn:[self.paramValue boolValue] animated:YES];
            }
            else
            {
                self.paramValue = @"0";
                if ([self.statusStr isEqualToString:@"hstandard"]) {
                    [self requestModifyTheParameters];
                }else {
                    [self requestModifyForStandParameters];
                }
                [self.currerySw setOn:[self.paramValue boolValue] animated:YES];
            }
            break;
            
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hrstArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.statusStr isEqualToString:@"hstandard"]&&self.hrstArray.count!=0) {
        return 70;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self createHeadView];
    return _headView;
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
    HRStandardData *cellInfo = self.hrstArray[indexPath.row];
    return [cellInfo.cellHeight integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRStandardTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HRStandardTableViewCell"];
    if (cell==nil) {
        cell=[[HRStandardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRStandardTableViewCell"];
    }
    HRStandardData *cellInfo = self.hrstArray[indexPath.row];
    if ([self.statusStr isEqualToString:@"hstandard"]) {
        [cell configHRSTandardCellInfo:cellInfo];
    }else {
        [cell configHRSTandardCellInfo:cellInfo];
    }
    
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.returnStr = @"bouu";
    HRStandardData *cellInfo = self.self.hrstArray[indexPath.row];
    if ([self.statusStr isEqualToString:@"hstandard"]) {
        modifyHarstViewController * hrs = [[modifyHarstViewController alloc]init];
        hrs.data = cellInfo;
        [self.navigationController pushViewController:hrs animated:YES];

    }else {
        modifyHrandViewController * hrs = [[modifyHrandViewController alloc]init];
        hrs.data = cellInfo;
        [self.navigationController pushViewController:hrs animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



//保存是否限制员工住宿标准
-(void)requestModifyTheParameters{
    
    NSDictionary *parameters = @{@"Paramvalue":[NSString stringWithFormat:@"%@",self.paramValue]};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveParam] Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//保存是否限制员工补贴标准-----2
-(void)requestModifyForStandParameters{

    NSDictionary *parameters = @{@"ParamName":@"StdAllowance",@"ParamValue":[NSString stringWithFormat:@"%@",self.paramValue]};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StdParams/Save"] Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//获取员工级别
-(void)requestGetUserLevelData {
    //HotelStandard/GetHotelStandardById
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetUserLevels_V2] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//获取员工补贴标准列表------2
-(void)requestGetStdAllowancesData {
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"StdAllowance/GetStdAllowances"] Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}



- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    switch (serialNum) {
        case 0:
            if ([self.paramValue isEqualToString:@"1"]) {
                self.hrstArray = [NSMutableArray array];
                [self requestGetUserLevelData];
            }else{
                self.hrstArray = nil;
            }
            break;
        case 1:
        {
            self.hrstArray = [NSMutableArray array];
            NSDictionary *dict=responceDic[@"result"];
            _CanSubmit=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"hotelLimitMode"]]]?[NSString stringWithFormat:@"%@",dict[@"hotelLimitMode"]]:@"";
            [HRStandardData GetUserLevelListDictionary:dict Array:self.hrstArray];
        }
            break;
        case 2:
            if ([self.paramValue isEqualToString:@"1"]) {
                self.hrstArray = [NSMutableArray array];
                [self requestGetStdAllowancesData];
            }else{
                self.hrstArray = [NSMutableArray arrayWithArray:@[]];
            }
            break;
        case 3:
            self.hrstArray = [NSMutableArray array];
            [HRStandardData GetUserForStandardListDictionary:responceDic Array:self.hrstArray];
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
-(void)createHeadView{
    if ([self.statusStr isEqualToString:@"hstandard"]&&self.hrstArray.count!=0) {
        _headView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 70)];
        _headView.backgroundColor = [UIColor clearColor];
        
        UIView *leadview=[[UIView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width, 60)];
        leadview.backgroundColor = Color_form_TextFieldBackgroundColor;
        [_headView addSubview:leadview];
        
        UIImageView * skipImage=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,21, 20, 20) imageName:@"skipImage"];
        [leadview addSubview:skipImage];
    
        UILabel * titleLab = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-150, 60) text:Custing(@"超标准是否可以提交", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [leadview  addSubview:titleLab];
        
        _CanSubmitLab= [GPUtils createLable:CGRectMake(Main_Screen_Width-135, 0, 100, 60) text:[_CanSubmit isEqualToString:@"0"]?Custing(@"不可以", nil):Custing(@"可以", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentRight];
        [leadview  addSubview:_CanSubmitLab];
        
        UIButton *selectBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2, 60) action:@selector(CanSubmit:) delegate:self];
        [leadview  addSubview:selectBtn];
    }else{
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    }
}

-(void)CanSubmit:(UIButton *)btn{
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"HotelStand"];
    choose.ChooseCategoryArray=self.submitArray;
    choose.ChooseCategoryId=_CanSubmit;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.CanSubmit=model.addCostCode;
        weakSelf.CanSubmitLab.text=model.addCostType;
    };
    [self.navigationController pushViewController:choose animated:YES];
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
