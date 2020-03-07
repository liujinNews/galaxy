//
//  BorrowingFormChooseController.m
//  galaxy
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BorrowingFormChooseController.h"
@interface BorrowingFormChooseController ()

@property(strong,nonatomic)NSDictionary *resultDict;//下载成功字典

@property(strong,nonatomic) UIView *View_ReversalType;
@property(strong,nonatomic) UITextField *txf_ReversalType;

@property(strong,nonatomic) NSMutableArray *arr_ReversalType;

@property (nonatomic, assign) NSInteger paramValue;//（0本位币，1原币）

@property (nonatomic, strong) UISearchBar * searchbar;

@property (nonatomic, strong)NSString *searchAim;



@end

@implementation BorrowingFormChooseController

-(NSMutableArray *)arr_ReversalType{
    if (_arr_ReversalType == nil) {
        _arr_ReversalType = [NSMutableArray array];
        NSArray *type = @[Custing(@"本位币", nil),Custing(@"原币", nil)];
        NSArray *code = @[@"0",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_ReversalType addObject:model];
        }
    }
    return _arr_ReversalType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"选择借款单", nil) backButton:YES ];
    self.view.backgroundColor = Color_White_Same_20;
    _ChoosedIdArray = [NSMutableArray arrayWithArray:[NSString isEqualToNullAndZero:_ChooseCategoryId]?[[NSString stringWithFormat:@"%@",_ChooseCategoryId] componentsSeparatedByString:@","]:@[]];
    self.str_ReversalType = [self.str_ReversalType isEqualToString:@"1"] ? @"1":@"0";
    _paramValue = 0;
    [self createViews];
}

-(void)createViews{
    
    _View_ReversalType = [[UIView alloc]init];
    _View_ReversalType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:_View_ReversalType];
    [_View_ReversalType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    _txf_ReversalType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReversalType WithContent:_txf_ReversalType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"冲销币种", nil) WithTips:nil WithInfodict:@{@"value1":[self.str_ReversalType isEqualToString:@"1"] ? Custing(@"原币", nil):Custing(@"本位币", nil)}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_ReversalType = Model.Id;
            weakSelf.txf_ReversalType.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"冲销币种", nil);
        picker.DateSourceArray = weakSelf.arr_ReversalType;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.str_ReversalType;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_ReversalType addSubview:view];

    _searchAim=@"";
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectZero];
//    [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    //    判断iOS的版本是否大于13.0
    if (@available(iOS 13.0, *)) {
        UIView *backGroundView = [[[self.searchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0];
        backGroundView.alpha = 0;
        self.searchbar.searchTextField.backgroundColor = Color_form_TextFieldBackgroundColor;
        self.searchbar.searchTextField.textColor = Color_Unsel_TitleColor;
        self.searchbar.searchTextField.placeholder = Custing(@"借款单", nil);
        UIImage *searchIcon = [UIImage imageNamed:@"searchIcon"];
        
        [self.searchbar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        [[[[ self.searchbar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        self.searchbar.placeholder = Custing(@"借款单", nil);
    }
    self.searchbar.delegate = self;
    self.searchbar.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.searchbar.keyboardType = UIKeyboardTypeDefault;
    self.searchbar.returnKeyType = UIReturnKeySearch;
//    self.searchbar.placeholder = Custing(@"借款单", nil);
    [self.view addSubview:self.searchbar];

    [self.searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReversalType.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchbar.mas_bottom).offset(0.5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"确定", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(sureSelect:)];
}
//借款单
-(void)requestBorrowForm{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary * dic =@{@"TaskId":@"",
                          @"PageIndex":[NSString stringWithFormat:@"%ld",self.currPage],
                          @"PageSize":@"20",
                          @"Name":_searchAim,
                          @"UserId":self.dict_otherPars ? self.dict_otherPars[@"UserId"]:@"0",
                          @"FlowCode":self.dict_otherPars ? self.dict_otherPars[@"FlowCode"]:@"",
                          @"FlowGuid":self.dict_otherPars ? self.dict_otherPars[@"FlowGuid"]:@""
                          };
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GETBORROWFORM] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    _totalPages = [result[@"totalPages"] integerValue];
    _paramValue = [result[@"paramValue"] integerValue];
    if (self.totalPages >= self.currPage) {
        [ChooseCateFreModel GetBorrowFormListDictionary:_resultDict Array:self.resultArray];
    }
    
}

-(void)updateViews{
    NSInteger height = 0;
    if (_paramValue == 1) {
        self.str_ReversalType = @"1";
        height = 60;
    }else{
        self.str_ReversalType = @"0";
    }
    [_View_ReversalType mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}



//MARK:tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell创建
    _cell=[tableView dequeueReusableCellWithIdentifier:@"BorrowFormCell"];
    if (_cell==nil) {
        _cell=[[BorrowFormCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BorrowFormCell"];
    }
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    [_cell configViewWithModel:model withIdArray:_ChoosedIdArray hideLine:(indexPath.section == self.resultArray.count - 1)];
    return _cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCateFreModel *model=(ChooseCateFreModel *)self.resultArray[indexPath.section];
    NSString *MarkId=[NSString stringWithFormat:@"%@",model.taskId];
    if ([_ChoosedIdArray containsObject:MarkId]) {
        [_ChoosedIdArray removeObject:MarkId];
    }else{
        [_ChoosedIdArray addObject:MarkId];
    }
    [self.tableView reloadData];
}
-(void)loadData{
    [self requestBorrowForm];
}
//MARK:确认选择
-(void)sureSelect:(id)obj{
    NSMutableArray *arr=[NSMutableArray array];
    for (ChooseCateFreModel *model in self.resultArray) {
        NSString *MarkId=[NSString stringWithFormat:@"%@",model.taskId];
        if ([_ChoosedIdArray containsObject:MarkId]) {
            [arr addObject:model];
        }
    }
    if ([self.str_ReversalType isEqualToString:@"1"] && arr.count > 1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"原币冲销只能选择一条", nil) duration:2.0];
        return;
    }
    if (self.ChooseBorrowFormBlock) {
        self.ChooseBorrowFormBlock(arr, self.str_ReversalType);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  - UISearchBarDelegate 协议方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        _searchAim=@"";
        self.currPage=1;
        [self loadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _searchAim=searchBar.text;
    self.currPage=1;
    [self loadData];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self.view configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有借款单哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
