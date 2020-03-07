//
//  FilterCustomController.m
//  galaxy
//
//  Created by hfk on 16/4/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FilterCustomController.h"

@interface FilterCustomController ()

@end

@implementation FilterCustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"筛选", nil)  backButton:YES];
    _meItemArray=[NSMutableArray array];
    _mainArray=[NSMutableArray array];
    _chooseArray=[NSMutableArray array];
    _firstArray=[NSMutableArray array];
    _secArray=[NSMutableArray array];
    [self createTableView];
    [self setNavigationBar];
    _sureBtn.userInteractionEnabled=NO;
    [self requestDatas];
    
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
//MARK:创建tableView
-(void)createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height-(isiOS7?64:44))];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
//MARK:确定按钮
-(void)setNavigationBar{
    _sureBtn = [[UIButton alloc]init];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:_sureBtn title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(searchBtnClick:)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//MARK:-请求数据
-(void)requestDatas
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",addAddCostCategry];
    [[GPClient shareGPClient]RequestByGetWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    
}


//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    _sureBtn.userInteractionEnabled=YES;
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0://获取抢单列表
        {
            [userData savelocalFile:responceDic type:1];
            [CostCateNewModel getTypeByDictionary:responceDic Array:self.meItemArray];
            [self dealwithDatas];
            [self.tableView reloadData];
        }
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
    _sureBtn.userInteractionEnabled=YES;
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//MARK:数据请求处理
-(void)dealwithDatas
{
    NSArray *firstArr=@[Custing(@"全部", nil),Custing(@"差旅费", nil),Custing(@"日常费", nil),Custing(@"专项费", nil)];
    _firstArray=[NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];
    NSMutableArray *secArr=[NSMutableArray arrayWithObject:Custing(@"全部", nil)];
    _secArray=[NSMutableArray arrayWithObject:@"0"];
    NSArray *array=_resultDict[@"result"];
    for (NSDictionary *dict in array) {
        [secArr addObject:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]];
        [_secArray addObject:@"0"];
    }
    if ([_FilterType isEqualToString:@"0"]) {
        [_firstArray replaceObjectAtIndex:0 withObject:@"1"];
    }else if ([_FilterType isEqualToString:@"1"]){
        [_firstArray replaceObjectAtIndex:1 withObject:@"1"];
    }else if ([_FilterType isEqualToString:@"2"]){
        [_firstArray replaceObjectAtIndex:2 withObject:@"1"];
    }else if ([_FilterType isEqualToString:@"3"]){
        [_firstArray replaceObjectAtIndex:3 withObject:@"1"];
    }
    
    
    
    if ([_FilterCode isEqualToString:@"0"]) {
        [_secArray replaceObjectAtIndex:0 withObject:@"1"];
    }else{
        NSInteger cnt=1;
        for (CostCateNewModel *data in _meItemArray) {
            if ([_FilterCode isEqualToString:data.expenseCode]) {
                [_secArray replaceObjectAtIndex:cnt withObject:@"1"];
            }
            cnt++;
        }
    }
    [_mainArray addObject:firstArr];
    [_mainArray addObject:secArr];
    [_chooseArray addObject:_firstArray];
    [_chooseArray addObject:_secArray];
    
}

//MARK:-tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mainArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.mainArray[section];
    return itemArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    headView.backgroundColor=Color_White_Same_20;
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [headView addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+86, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [headView addSubview:titleLabel];
    
    if (section == 0) {
        titleLabel.text =Custing(@"类型", nil) ;
        
        
    }else if (section == 1){
        titleLabel.text =Custing(@"类别", nil) ;
    }
    [headView addSubview: titleLabel];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (_cell==nil) {
        _cell=[[FilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *string=self.mainArray[indexPath.section][indexPath.row];
    NSString *chooseString=self.chooseArray[indexPath.section][indexPath.row];
    [_cell configViewWithString:string withChoose:chooseString];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSInteger firstCount=_firstArray.count;
        [_firstArray removeAllObjects];
        for (NSInteger i=0; i<firstCount; i++) {
            [_firstArray addObject:@"0"];
        }
        [_firstArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else if (indexPath.section==1){
        NSInteger secondCount=_secArray.count;
        [_secArray removeAllObjects];
        for (NSInteger i=0; i<secondCount; i++) {
            [_secArray addObject:@"0"];
        }
        [_secArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    
    [_chooseArray removeAllObjects];
    [_chooseArray addObject:_firstArray];
    [_chooseArray addObject:_secArray];
    //    NSLog(@"%@",_chooseArray);
    
    [self.tableView reloadData];
}

//MARK:-确定按钮被点击
-(void)searchBtnClick:(UIButton *)btn
{
    
    _sureBtn.userInteractionEnabled=NO;
    if (_firstArray.count!=0&&_secArray.count>=2) {
        
        
        NSString *type=@"";
        if ([_firstArray[0] isEqualToString:@"1"]) {
            type=@"";
        }else{
            if ([_firstArray[1]isEqualToString:@"1"]) {
                type=@"1";
            }else if ([_firstArray[2]isEqualToString:@"1"]){
                type=@"2";
            }else if ([_firstArray[3]isEqualToString:@"1"]){
                type=@"3";
            }
        }
        NSMutableString *code= [NSMutableString stringWithString:@""];
        if ([_secArray[0] isEqualToString:@"1"]) {
            code=[NSMutableString stringWithFormat:@"%@",@""];
        }else{
            NSMutableArray *secondArray=[NSMutableArray array];
            for (NSString *str in _secArray) {
                [secondArray addObject:str];
            }
            [secondArray removeObjectAtIndex:0];
            NSInteger cnt=0;
            for (NSString *str in secondArray) {
                if ([str isEqualToString:@"1"]) {
                    CostCateNewModel *data=_meItemArray[cnt];
                    if (code==nil) {
                        code=[NSMutableString stringWithFormat:@"%@",data.expenseCode];
                    }else{
                        code=[NSMutableString stringWithFormat:@"%@,%@",code,data.expenseCode];
                    }
                }
                cnt++;
            }
        }
        if (![code isEqualToString:@""]) {
            [code deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        //    NSLog(@"%@%@",type,code);
        if (self.delegate) {
            [self.delegate didFilterData:type expenseCode:code];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
