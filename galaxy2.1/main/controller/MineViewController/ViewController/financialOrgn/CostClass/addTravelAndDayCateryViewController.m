//
//  addTravelAndDayCateryViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "addTravelAndDayCollectionCell.h"

#import "addTravelAndDayCateryData.h"
#import "addTravelAndDayCateryCell.h"
#import "addTravelAndDayCateryViewController.h"

@interface addTravelAndDayCateryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSDictionary * paramValue;
@property (weak,nonatomic)UICollectionView *collectionView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)UIView * dockView;
/**
 是否全选
 */
@property (nonatomic,assign)BOOL IsSelectAll;
/**
 全选按钮
 */
@property (nonatomic,strong)UIButton * SelectAllBtn;

@property (nonatomic,strong)NSMutableArray * resultArray;
@property (nonatomic,strong)NSMutableArray *collArray;
@property (nonatomic,assign)NSInteger selectRow;
@end

@implementation addTravelAndDayCateryViewController
-(id)initWithType:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
        self.paramValue = dict;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing([self.paramValue objectForKey:@"title"], nil) backButton:YES];
    self.view.backgroundColor = Color_form_TextFieldBackgroundColor;
    _IsSelectAll = NO;
    _resultArray = [NSMutableArray array];
    self.collArray = [NSMutableArray array];
    [self createMainView];
    [self requestIsTravelOrDayData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
//MARK:创建视图
-(void)createMainView{
    //tableView
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(98);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    //collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(floor((Main_Screen_Width-150)/2), 33);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 22;
    flowLayout.minimumLineSpacing = 12;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(Main_Screen_Width, 23);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[addTravelAndDayCollectionCell class] forCellWithReuseIdentifier:@"addTravelAndDayCollectionCell"];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.tableView.right).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    
    self.dockView=[[UIView alloc]init];
    self.dockView.backgroundColor=Color_White_Same_20;
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    UIButton *moreBtn=[GPUtils createButton:CGRectMake(0, 0, ScreenRect.size.width, 50)action:@selector(saveData:) delegate:self];
    moreBtn.backgroundColor =Color_Blue_Important_20;
    moreBtn.tag=1;
    [moreBtn setTitle:Custing(@"保存", nil) forState:UIControlStateNormal];
    moreBtn.titleLabel.font=Font_filterTitle_17 ;
    [moreBtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [self.dockView addSubview:moreBtn];
    
    _SelectAllBtn=[[UIButton alloc]init];
    _SelectAllBtn.tag=2;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:_SelectAllBtn title:Custing(@"全选Cate", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(saveData:)];

}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    addTravelAndDayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addTravelAndDayCollectionCell" forIndexPath:indexPath];
    addTravelAndDayCateryData * data = self.collArray[indexPath.row];
    [cell sizeToFit];
    
    if ([NSString isEqualToNull:data.coExpenseType]) {
        cell.expenseLa.text = data.coExpenseType;
        if (([data.isTravelApp isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"出差申请"]) || ([data.isTravel isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"差旅费"]) || ([data.isDaily isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"日常费"])|| ([data.isApproval isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"专项费"])|| ([data.isPayment isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"付款"])|| ([data.isContract isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"合同"])|| ([data.tax isEqualToString:@"1"] && [[self.paramValue objectForKey:@"title"] isEqualToString:@"税额Add"])) {
            cell.mainView.backgroundColor = [UIColor clearColor];
            cell.mainView.layer.borderColor = Color_Blue_Important_20.CGColor;
            cell.mainView.layer.borderWidth = 1.0;
            cell.triangleView.hidden = NO;
            cell.expenseLa.textColor = Color_Blue_Important_20;
        }else {
            cell.mainView.image = nil;
            cell.triangleView.hidden = YES;
            cell.mainView.layer.borderColor = [UIColor clearColor].CGColor;
            cell.mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.expenseLa.textColor = Color_Black_Important_20;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    addTravelAndDayCateryData * Maindata=self.resultArray[_selectRow];
    NSMutableArray *array=Maindata.GetExpTypeList;
    NSMutableDictionary *dict=array[indexPath.row];
    addTravelAndDayCateryData * data = self.collArray[indexPath.row];
    if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"出差申请"]) {
        if ([data.isTravelApp isEqualToString:@"1"]) {
            data.isTravelApp = @"0";
            [dict setValue:@"0" forKey:@"isTravelApp"];
        }else{
            data.isTravelApp = @"1";
            [dict setValue:@"1" forKey:@"isTravelApp"];
        }
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"差旅费"]) {
        if ([data.isTravel isEqualToString:@"1"]) {
            data.isTravel=@"0";
            [dict setValue:@"0" forKey:@"isTravel"];
        }else{
            data.isTravel=@"1";
            [dict setValue:@"1" forKey:@"isTravel"];
        }
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"日常费"]){
        if ([data.isDaily isEqualToString:@"1"]) {
            data.isDaily=@"0";
            [dict setValue:@"0" forKey:@"isDaily"];
        }else{
            data.isDaily=@"1";
            [dict setValue:@"1" forKey:@"isDaily"];
        }
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"专项费"]){
        if ([data.isApproval isEqualToString:@"1"]) {
            data.isApproval=@"0";
            [dict setValue:@"0" forKey:@"isApproval"];
        }else{
            data.isApproval=@"1";
            [dict setValue:@"1" forKey:@"isApproval"];
        }
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"付款"]){
        if ([data.isPayment isEqualToString:@"1"]) {
            data.isPayment=@"0";
            [dict setValue:@"0" forKey:@"isPayment"];
        }else{
            data.isPayment=@"1";
            [dict setValue:@"1" forKey:@"isPayment"];
        }
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"合同"]){
        if ([data.isContract isEqualToString:@"1"]) {
            data.isContract = @"0";
            [dict setValue:@"0" forKey:@"isContract"];
        }else{
            data.isContract = @"1";
            [dict setValue:@"1" forKey:@"isContract"];
        }
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"税额Add"]){
        if ([data.tax isEqualToString:@"1"]) {
            data.tax=@"0";
            [dict setValue:@"0" forKey:@"tax"];
        }else{
            data.tax=@"1";
            [dict setValue:@"1" forKey:@"tax"];
        }
    }
    [_collectionView reloadData];
}


#pragma mark - <UItableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    addTravelAndDayCateryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"addTravelAndDayCateryCell"];
    if (cell==nil) {
        cell=[[addTravelAndDayCateryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addTravelAndDayCateryCell"];
    }
    addTravelAndDayCateryData * data = self.resultArray[indexPath.row];
    BOOL select = NO;
    if (_selectRow == indexPath.row) {
        select = YES;
    }
    [cell configAddTravelAndDayCateryCellInfo:data withSelect:select];
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    addTravelAndDayCateryData * data = self.resultArray[indexPath.row];
    _selectRow=indexPath.row;
    [self.collArray removeAllObjects];
    [addTravelAndDayCateryData GetCollectionAddTravelAndDayCateryDictionary:@{@"result":data.GetExpTypeList} Array:self.collArray];
    [tableView reloadData];
    [self.collectionView reloadData];
}

-(void)requestIsTravelOrDayData {
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GETCATEList] Parameters:@{@"Type":@"0"} Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

//MARK:全选处理//请求保存费用类别对应的差旅or日常
-(void)saveData:(UIButton *)btn {
    switch (btn.tag) {
        case 1:
            [self saveCategorySetting];
            break;
        case 2:
            [self changeSelectAll];
            break;
        default:
            break;
    }
}

-(void)saveCategorySetting{
    
    NSMutableArray *sumbitArray=[NSMutableArray array];
    [addTravelAndDayCateryData getSubmitData:_resultArray WithResultArr:sumbitArray];
    
    NSDictionary *parameters;
    if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"出差申请"]) {
        parameters= @{@"Type":@"7",@"ExpTyps":sumbitArray};
        
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"差旅费"]) {
        parameters= @{@"Type":@"1",@"ExpTyps":sumbitArray};
        
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"日常费"]){
        parameters= @{@"Type":@"2",@"ExpTyps":sumbitArray};
        
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"专项费"]){
        parameters= @{@"Type":@"3",@"ExpTyps":sumbitArray};
        
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"付款"]){
        parameters= @{@"Type":@"4",@"ExpTyps":sumbitArray};
        
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"合同"]){
        parameters= @{@"Type":@"6",@"ExpTyps":sumbitArray};
        
    }else if ([[self.paramValue objectForKey:@"title"] isEqualToString:@"税额Add"]){
        parameters= @{@"Type":@"5",@"ExpTyps":sumbitArray};
        
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:stri forKey:@"ExpTypeList"];
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SAVECATELIST] Parameters:dict Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
-(void)changeSelectAll{
    _IsSelectAll=!_IsSelectAll;
    if (_IsSelectAll) {
        [_SelectAllBtn setTitle:Custing(@"取消", nil) forState:UIControlStateNormal];
        [_SelectAllBtn setTitleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Noraml_NavBar_TitleGray_20 forState:UIControlStateNormal];
    }else{
        [_SelectAllBtn setTitle:Custing(@"全选", nil) forState:UIControlStateNormal];
        [_SelectAllBtn setTitleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 forState:UIControlStateNormal];
    }
    
    for (addTravelAndDayCateryData * data in self.resultArray) {
        NSMutableArray *array=[NSMutableArray arrayWithArray:data.GetExpTypeList];
        [self dealWithArray:array];
    }
    addTravelAndDayCateryData *data=self.resultArray[_selectRow];
    [self.collArray removeAllObjects];
    [addTravelAndDayCateryData GetCollectionAddTravelAndDayCateryDictionary:@{@"result":data.GetExpTypeList} Array:self.collArray];
    [self.collectionView reloadData];
}

-(void)dealWithArray:(NSMutableArray *)arr{
    NSString * changeStr=_IsSelectAll?@"1":@"0";
    for (NSMutableDictionary *dict in arr) {
        if ([self.paramValue[@"title"] isEqualToString:@"出差申请"]){
            [dict setValue:changeStr forKey:@"isTravelApp"];
        }else if ([self.paramValue[@"title"] isEqualToString:@"差旅费"]){
            [dict setValue:changeStr forKey:@"isTravel"];
        }else if ([self.paramValue[@"title"] isEqualToString:@"日常费"]){
            [dict setValue:changeStr forKey:@"isDaily"];
        }else if ([self.paramValue[@"title"] isEqualToString:@"专项费"]){
            [dict setValue:changeStr forKey:@"isApproval"];
        }else if ([self.paramValue[@"title"] isEqualToString:@"付款"]){
            [dict setValue:changeStr forKey:@"isPayment"];
        }else if ([self.paramValue[@"title"] isEqualToString:@"合同"]){
            [dict setValue:changeStr forKey:@"isContract"];
        }else if ([self.paramValue[@"title"] isEqualToString:@"税额Add"]){
            [dict setValue:changeStr forKey:@"tax"];
        }
    }
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [addTravelAndDayCateryData getResultDate:responceDic WithArray:self.resultArray];
            _selectRow=0;
            addTravelAndDayCateryData *data=self.resultArray[_selectRow];
            [addTravelAndDayCateryData GetCollectionAddTravelAndDayCateryDictionary:@{@"result":data.GetExpTypeList} Array:self.collArray];
            [_tableView reloadData];
            [_collectionView reloadData];
        }
            break;
            
        case 1://
        {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil) duration:2.0];
        }
            break;
        default:
            break;
    }
    
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
