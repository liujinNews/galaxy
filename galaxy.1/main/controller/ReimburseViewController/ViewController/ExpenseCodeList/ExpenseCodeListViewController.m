//
//  ExpenseCodeListViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/10/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ExpenseCodeListViewController.h"
#import "ExpenseCodeListTableViewCell.h"
#import "CostCateNewModel.h"
#import "ExpenseListCollectCell.h"
#import "ExpenseListHeadView.h"

static NSString *const CellIdentifier = @"ExpenseListCollectCell";
static NSString *const HeadViewIdentifier = @"ExpenseListHeadView";

@interface ExpenseCodeListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,GPClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *arr_oftenDataList;
@property (nonatomic, strong) NSMutableArray *arr_ofen;
@property (nonatomic, strong) NSMutableArray *arr_show;
/**
 * 常用费用类别选择视图
 */
@property (nonatomic,strong)UIView *View_Collect;
@property(nonatomic,strong)UICollectionView *collView;
@property(nonatomic,strong)ExpenseListCollectCell *cell;
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;

@property (nonatomic, strong) UITableView *tbv_tableview;
@property (nonatomic, strong) UISearchBar *scr_Search;

#define ExpenseCodeCell @"ExpenseCodeCell"

@end

@implementation ExpenseCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"选择费用类别", nil) backButton:YES];
    [self createViews];
    self.arr_oftenDataList=[NSMutableArray array];
    if (self.str_flowCode) {
        [self requestOftenCate];
    }else{
        self.arr_ofen=[NSMutableArray array];
        [self analysisData];
        [self.tbv_tableview reloadData];
    }
}
-(void)createViews{
    _scr_Search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    _scr_Search.placeholder = Custing(@"搜索费用类别", nil);
    _scr_Search.delegate = self;
    [self.view addSubview:_scr_Search];
    
    _tbv_tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tbv_tableview.backgroundColor = Color_form_TextFieldBackgroundColor;
    _tbv_tableview.delegate = self;
    _tbv_tableview.dataSource = self;
    _tbv_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbv_tableview];
    [_tbv_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scr_Search.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}
//MARK:获取费用类别
-(void)requestOftenCate{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETOFTENCATELIST];
    NSDictionary *parameters = @{@"FlowCode":self.str_flowCode};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
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
            [CostCateNewModel getCostCateByDict:responceDic array:self.arr_oftenDataList withType:2];
            self.arr_ofen=[NSMutableArray arrayWithArray:self.arr_oftenDataList];
            [self analysisData];
            [self.tbv_tableview reloadData];
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

-(void)analysisData{
    _arr_show = [NSMutableArray array];
    if ([_str_CateLevel integerValue]==2||[_str_CateLevel integerValue]==3) {
        for (int i = 0; i<_arr_DataList.count; i++) {
            CostCateNewModel *cost = _arr_DataList[i];
            [_arr_show addObjectsFromArray:cost.getExpTypeList];
        }
    }else{
        _arr_show = [NSMutableArray arrayWithArray:_arr_DataList];
    }
}

#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr_show.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.arr_ofen&&self.arr_ofen.count>0) {
        return 32+(ceilf((float)(self.arr_ofen.count)/3))*42 + 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.arr_ofen&&self.arr_ofen.count>0) {
        return [self createHeadView];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpenseCodeListTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpenseCodeListTableViewCell" owner:self options:nil] lastObject];
    CostCateNewSubModel *model = _arr_show[indexPath.row];
    cell.lab_Title.text = [NSString stringWithFormat:@"%@",model.expenseType];
    cell.lab_ExpenseCat.text = [NSString stringWithFormat:@"%@",model.expenseCat];
    cell.img_Icon.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
    [cell addSubview:[self createLineViewOfHeight:69.5 X:75]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CostCateNewSubModel *model=_arr_show[indexPath.row];
    
    if (self.CellClick) {
        self.CellClick(model);
        [self returnBack];
    }else if (self.ChooseCateBlock) {
        self.ChooseCateBlock(nil, model);
        [self returnBack];
    }
}
-(UIView *)createHeadView{
    NSInteger height = 32+(ceilf((float)(self.arr_ofen.count)/3))*42 + 10;
    if (!_View_Collect) {
        _View_Collect=[[UIView alloc]init];
    }
    _View_Collect.frame=CGRectMake(0, 0, Main_Screen_Width, height);
    _View_Collect.backgroundColor=Color_form_TextFieldBackgroundColor;

    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
    }
    _layOut.minimumInteritemSpacing =0;
    _layOut.minimumLineSpacing =0;
    
    if (!_collView) {
        _collView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layOut];
    }
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.backgroundColor =Color_form_TextFieldBackgroundColor;
    [_collView registerClass:[ExpenseListCollectCell class] forCellWithReuseIdentifier:CellIdentifier];
    [_collView registerClass:[ExpenseListHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier];
    [_View_Collect addSubview:_collView];
    [_collView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Collect);
        make.left.equalTo(self.View_Collect).offset(@12);
        make.right.equalTo(self.View_Collect).offset(@-12);
        make.bottom.equalTo(self.View_Collect.bottom).offset(@-10);
    }];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor=Color_White_Same_20;
    [self.View_Collect  addSubview:view];;

    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collView.bottom);
        make.left.right.equalTo(self.View_Collect);
        make.height.equalTo(@10);
    }];
    [_collView reloadData];
    
    return self.View_Collect;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((Main_Screen_Width-48)/3, 42);;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

#pragma mark 设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Main_Screen_Width, 32);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        ExpenseListHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadViewIdentifier forIndexPath:indexPath];
        [headView configHeadView];
        return  headView;
    }else{
        return  [[UICollectionReusableView alloc]init];
    }
}


#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr_ofen.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [_cell configCollectCellWithData:self.arr_ofen withIndex:indexPath];
    return _cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CostCateNewSubModel *model=_arr_ofen[indexPath.row];
    if (self.CellClick) {
        self.CellClick(model);
        [self returnBack];
    }else if (self.ChooseCateBlock) {
        self.ChooseCateBlock(nil, model);
        [self returnBack];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self getSearchData:searchText];
    [self.tbv_tableview reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self keyClose];
    [self getSearchData:searchBar.text];
    [self.tbv_tableview reloadData];
}

-(void)getSearchData:(NSString *)string{
    if ([string isEqualToString:@""]) {
        self.arr_ofen=[NSMutableArray arrayWithArray:self.arr_oftenDataList];
        [self analysisData];
    }else{
        NSMutableArray *arr1=[NSMutableArray array];
        self.arr_ofen=[NSMutableArray arrayWithArray:self.arr_oftenDataList];
        for (CostCateNewSubModel *model in _arr_ofen) {
            if ([NSString isEqualToNull:model.expenseType]) {
                if ([model.expenseType rangeOfString:string].location != NSNotFound){
                    [arr1 addObject:model];
                }
            }
        }
        self.arr_ofen=arr1;
        
        NSMutableArray *arr2=[NSMutableArray array];
        [self analysisData];
        for (CostCateNewSubModel *model in _arr_show) {
            if ([NSString isEqualToNull:model.expenseType]) {
                if ([model.expenseType rangeOfString:string].location != NSNotFound){
                    [arr2 addObject:model];
                }
            }
        }
        self.arr_show=arr2;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
