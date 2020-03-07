//
//  ImportElInController.m
//  galaxy
//
//  Created by hfk on 2017/1/12.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ImportElInController.h"

@interface ImportElInController ()<UIPickerViewDataSource,UIPickerViewDelegate,GPClientDelegate,chooseTravelDateViewDelegate>
@property (nonatomic,strong)UIPickerView * pickerView;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * typelView;//报销类型选择弹出框
//@property (nonatomic,strong)NSMutableArray * typeArray;
@property (nonatomic,strong)NSString * typeStr;
@property (nonatomic,strong)NSString * tagStr;

@property (nonatomic,strong)NSDictionary * importDic;


@end

@implementation ImportElInController

-(id)initWithType:(NSDictionary *)type{
    self = [super init];
    if (self) {
        self.importDic = type;
    }
    
    return self;
}

-(NSMutableArray *)AddCostTotalCateArray{
    if (_AddCostTotalCateArray==nil) {
        _AddCostTotalCateArray=[NSMutableArray array];
        NSArray *type=@[Custing(@"差旅Add", nil),Custing(@"日常Add", nil),Custing(@"专项费", nil)];
        NSArray *code=@[@"1",@"2",@"3"];
        for (int i=0; i<type.count; i++) {
            ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
            model.addCostType=type[i];
            model.addCostCode=code[i];
            [_AddCostTotalCateArray addObject:model];
        }
    }
    return _AddCostTotalCateArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"导入电子发票", nil)  backButton:YES];
    [self createScrollView];
    [self createMainViews];
    _isOpenGener=YES;
    self.tagStr = @"2";
    _categoryArr=[NSMutableArray array];
    [self updateGenreView];
    [self updateCateView];
    [self updateCateGoryView];
    [self updateLoadView];
    [self updateContentView];
}

//MARK:创建滚动视图
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

//MARK:创建主视图
-(void)createMainViews{
    self.GenreView=[[UIView alloc]init];
    self.GenreView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:self.GenreView];
    [self.GenreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    self.CateView=[[UIView alloc]init];
    self.CateView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:self.CateView];
    [self.CateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.GenreView.bottom);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    self.CategoryView=[[UIView alloc]init];
    self.CategoryView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:self.CategoryView];
    [self.CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CateView.bottom);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    _CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _CategoryLayOut.minimumInteritemSpacing =1;
    _CategoryLayOut.minimumLineSpacing =1;
    _CategoryCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_CategoryLayOut];
    _CategoryCollectView.delegate = self;
    _CategoryCollectView.dataSource = self;
    _CategoryCollectView.backgroundColor =Color_White_Same_20;
    _CategoryCollectView.scrollEnabled=NO;
    [_CategoryCollectView registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [self.CategoryView addSubview:_CategoryCollectView];
    
    [_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.top);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
    
    _LoadView=[[UIView alloc]init];
    _LoadView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_LoadView];
    [_LoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.bottom);
        make.left.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView.width);
    }];
}
//MARK:再次获取类别选择中的类别
-(void)chooseAgainCostCategry{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":self.tagStr};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}


//个人发票导入
-(void)importElectInvoice:(UIButton *)btn {
    
    if ([self.genreLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:2.0];
        return;
    }
    
    if ([self.CateLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择费用类别", nil) duration:2.0];
        return;
    }
    if ([self.importDic[@"list"] isEqualToString:@"person"]) {
        NSDictionary * dict = @{@"AccountType":self.importDic[@"result"][@"accountType"],@"AccountNo":self.importDic[@"result"][@"accountNo"],@"Type":self.tagStr,@"ExpenseCode":self.expenseCode,@"ExpenseType":_categoryString,@"ExpenseIcon":self.expenseIcon,@"InvItems":self.importDic[@"InvItems"],@"ExpenseCat":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_expenseCat]]?_expenseCat:@"",@"ExpenseCatCode":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_expenseCatCode]]?_expenseCatCode:@""};
        //        NSDictionary *parameters = @{@"Invoices":arrays};
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
        
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/AddInv"] Parameters:@{@"Invoices":stri} Delegate:self SerialNum:1 IfUserCache:NO];
    }else {
        NSDictionary * dict = @{@"ClientId":self.importDic[@"result"][@"clientId"],@"AccessToken":self.importDic[@"result"][@"accessToken"],@"SQM":self.importDic[@"result"][@"spsqm"],@"Type":self.tagStr,@"ExpenseCode":self.expenseCode,@"ExpenseType":self.CateLab.text,@"ExpenseIcon":self.expenseIcon,@"ThirdItems":self.importDic[@"ThirdItems"],@"ExpenseCat":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_expenseCat]]?_expenseCat:@"",@"ExpenseCatCode":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_expenseCatCode]]?_expenseCatCode:@""};
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
        
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/AddInvEnt"] Parameters:@{@"Invoices":stri} Delegate:self SerialNum:2 IfUserCache:NO];
    }
    
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}


//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    if (serialNum ==1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"导入成功" duration:2.0];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    if (serialNum ==2) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"导入成功" duration:2.0];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    switch (serialNum) {
        case 10:
            [self dealWithType];
            [self dealAgainChooseType];
            [self updateAgainCateGoryView];
            break;
        default:
            break;
    }
    
}
//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:费用类型数据处理
-(void)dealWithType{
    _categoryArr=[NSMutableArray array];
    NSDictionary *parDict= [CostCateNewModel getCostCateByDict:_resultDict array:_categoryArr withType:1];
    _CateLevel=parDict[@"CateLevel"];
    _categoryRows=[parDict[@"categoryRows"]integerValue];
}
//MARK:改变报销类型后报销类别重置
-(void)dealAgainChooseType{
    
    _CateLab.center=CGPointMake(Main_Screen_Width/2+38, 35);
    _CateLab.textColor=Color_LabelPlaceHolder_Same_20;
    _CateLab.text=Custing(@"请选择", nil);
    
    _categoryImage.center=CGPointMake(Main_Screen_Width-56, 35);
    _categoryImage.image=nil;
    _categoryString=@"";
    _expenseCode=@"";
    _expenseIcon=@"";
}
//MARK:更新类型视图
-(void)updateGenreView{
    [self.GenreView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    [self.GenreView addSubview:[self createDownLineView]];
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(0,0,70, 16) text:Custing(@"报销类型", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.center=CGPointMake(50, 35);
    [self.GenreView addSubview:titleLbl];
    
    _genreLab=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-160, 18) text:Custing(@"请选择", nil) font:Font_Important_15_20 textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentRight];
    _genreLab.center=CGPointMake(Main_Screen_Width/2+38, 35);
    [self.GenreView addSubview:_genreLab];
    
    UIImageView *genreImage=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    genreImage.center=CGPointMake(Main_Screen_Width-25, 35);
    [self.GenreView addSubview:genreImage];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 10, Main_Screen_Width/2, 50) action:@selector(selectedTypeOrCateary:) delegate:self];
    [self.GenreView addSubview:btn];
    
}

//MARK:更新费用类别选择
-(void)updateCateView{
    [self.CateView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,59.48, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [self.CateView addSubview:lineUp];
    
    [self.CateView addSubview:[self createLineView]];
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(0,0,70, 16) text:Custing(@"费用类别Add", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.center=CGPointMake(50, 35);
    [self.CateView addSubview:titleLbl];
    _CateLab=[GPUtils createLable:CGRectMake(0, 0,Main_Screen_Width-160, 18) text:Custing(@"请选择", nil) font:Font_Important_15_20 textColor:Color_LabelPlaceHolder_Same_20 textAlignment:NSTextAlignmentRight];
    _CateLab.center=CGPointMake(Main_Screen_Width/2+38, 35);
    [self.CateView addSubview:_CateLab];
    
    _categoryImage=[GPUtils createImageViewFrame:CGRectMake(0, 0, 32, 32) imageName:nil];
    _categoryImage.center=CGPointMake(Main_Screen_Width-56, 35);
    [self.CateView addSubview:_categoryImage];
    
    _CateImage=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    _CateImage.center=CGPointMake(Main_Screen_Width-25, 35);
    [self.CateView addSubview:_CateImage];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 10, Main_Screen_Width/2, 50) action:@selector(CategoryClick:) delegate:self];
    [self.CateView addSubview:btn];
    if ([NSString isEqualToNull:_categoryString]) {
        _CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
        _CateLab.textColor=Color_form_TextField_20;
        _CateLab.text=[NSString stringWithFormat:@"%@",_categoryString];
        _categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:_expenseIcon]?_expenseIcon:@"15"];
    }
    
}

//MARK:更新费用类型选择
-(void)updateCateGoryView{
    
    _CateImage.image=[UIImage imageNamed:@"skipImage"];
    _isOpenGener=NO;
    [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}

//MARK:更改费用类型选择选择框弹出
-(void)updateAgainCateGoryView{
    NSLog(@"%@",_CateLevel);
    if ([_CateLevel isEqualToString:@"1"]) {
        _CateImage.image=[UIImage imageNamed:@"share_Open"];
        _isOpenGener=YES;
        if (_categoryRows==0) {
            [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@10);
            }];
        }else{
            [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.categoryRows)+20));
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*self.categoryRows)+20));
            }];
        }
        [_CategoryCollectView reloadData];
    }else{
        _CateImage.image=[UIImage imageNamed:@"skipImage"];
        [self.CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
//MARK:更ૢ新ૢ确ૢ认ૢ导ૢ入ૢ按ૢ钮ૢ
-(void)updateLoadView{
    [_LoadView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    UIButton * importBtn = [GPUtils createButton:CGRectMake(15, 15, Main_Screen_Width-30, 45) action:@selector(importElectInvoice:) delegate:self title:Custing(@"确认导入", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [importBtn setBackgroundColor:Color_Blue_Important_20];
    importBtn.layer.cornerRadius = 15.0f;
    [_LoadView addSubview:importBtn];
}

//MARK:更新根视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.LoadView.bottom);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:费用类型类别选择
-(void)selectedTypeOrCateary:(UIButton *)btn{
    NSLog(@"费用类型类别选择");
    [self AddCostTotalCateArray];
    
    [self createFootView];
}

-(void)createFootView {
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 139)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
//    self.pickerView.tag = btn.tag;
    
//    NSLog(@"%ld-----%ld",(long)btn.tag,(long)self.pickerView.tag);
    if ([self.genreLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [self.pickerView selectRow:1 inComponent:0 animated:NO];
    }else {
        [self.pickerView selectRow:[self.tagStr integerValue]-1 inComponent:0 animated:NO];
    }
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 50)];
    
    UILabel * xuanzhe = [GPUtils createLable:CGRectMake(0, 0,WIDTH(view), 50) text:Custing(@"请选择报销类型", nil) font:Font_cellContent_16 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    xuanzhe.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:xuanzhe];
    
    UIButton *sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH(view)-50, 0, 50, 50)];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn setImage:GPImage(@"Add_Save") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:sureBtn];
    
    if (!_typelView) {
        _typelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pickerView.frame.size.height+50) pickerView:self.pickerView titleView:view];
        _typelView.delegate = self;
    }
    [_typelView showUpView:self.pickerView];

}

-(void)selectedType:(UIButton *)btn {
    [self keyClose];
    [self.typelView remove];
    [self dimsissPDActionView];
    [self chooseAgainCostCategry];
    
    if ([NSString isEqualToNull:self.typeStr]) {
        self.genreLab.text = self.typeStr;
    }else {
        self.genreLab.text = Custing(@"日常费", nil);
    }
    
    self.genreLab.textColor = Color_Black_Important_20;
}

//MARK:费用类型选择代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.AddCostTotalCateArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ChooseCategoryModel * data = [self.AddCostTotalCateArray objectAtIndex:row];
    return data.addCostType;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 49;
}

//弹窗代理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ChooseCategoryModel * data = [self.AddCostTotalCateArray objectAtIndex:row];
        self.tagStr=data.addCostCode;
        self.typeStr=data.addCostType;
}

//清除时间控制器
-(void)dimsissPDActionView{
    _typelView = nil;
}



//MARK:费用类别选择
-(void)CategoryClick:(UIButton *)btn{
    if ([self.genreLab.text isEqualToString:Custing(@"请选择", nil)]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择报销类型", nil) duration:1.0];
        return;
    }
    NSLog(@"费用类型类别选择");
    if (_categoryArr.count==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    if ([_CateLevel isEqualToString:@"1"]) {
        if (_isOpenGener ==YES) {
            [self updateCateGoryView];
        }else {
            [self updateAgainCateGoryView];
        }
        
    }else if ([_CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:_categoryArr];
        CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
        model.expenseCode=_expenseCode;
        pickerArea.CateModel=model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        if ([self.typeStr isEqualToString:@"1"]) {
            pickerArea.str_flowCode=@"F0002";
        }else if ([self.typeStr isEqualToString:@"2"]){
            pickerArea.str_flowCode=@"F0003";
        }else if ([self.typeStr isEqualToString:@"3"]){
            pickerArea.str_flowCode=@"F0010";
        }
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            if (![secondModel.expenseType isEqualToString:weakSelf.categoryString]) {
                weakSelf.categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.categoryString=[NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.expenseCode=secondModel.expenseCode;
                weakSelf.expenseIcon=secondModel.expenseIcon;
                weakSelf.expenseCat=secondModel.expenseCat;
                weakSelf.expenseCatCode=secondModel.expenseCatCode;
                weakSelf.CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
                weakSelf.CateLab.text=[GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
                weakSelf.CateLab.textColor=Color_form_TextField_20;
            }
        }];
        [pickerArea show];
    }else if([_CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = _categoryArr;
        ex.str_CateLevel = _CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseType isEqualToString:weakSelf.categoryString]) {
                weakSelf.categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.categoryString=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.expenseCode=model.expenseCode;
                weakSelf.expenseIcon=model.expenseIcon;
                weakSelf.expenseCat=model.expenseCat;
                weakSelf.expenseCatCode=model.expenseCatCode;
                weakSelf.CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
                weakSelf.CateLab.text=[GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                weakSelf.CateLab.textColor=Color_form_TextField_20;
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width/5, 65);
    }else{
        return CGSizeMake(70, 70);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView==_CategoryCollectView) {
        return 0;
    }else{
        if (Main_Screen_Width==320) {
            return 3;
        }else{
            return 5;
        }
    }
}
#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView==_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width, 20);
    }else{
        return CGSizeZero;
    }
}

#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _categoryArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
    [_cell configWithArray:_categoryArr withRow:indexPath.row];
    return _cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CostCateNewModel *model=_categoryArr[indexPath.row];
    if (![model.expenseType isEqualToString:_categoryString]) {
        _categoryImage.image =[UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];            _categoryString=[NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
        _expenseCode=model.expenseCode;
        _expenseIcon=model.expenseIcon;
        _expenseCat=model.expenseCat;
        _expenseCatCode=model.expenseCatCode;
        _CateLab.center=CGPointMake(Main_Screen_Width/2+3, 35);
        _CateLab.text=[NSString stringWithFormat:@"%@",_categoryString];
        _CateLab.textColor=Color_form_TextField_20;
        [self updateCateGoryView];
    }else{
        [self updateCateGoryView];
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
