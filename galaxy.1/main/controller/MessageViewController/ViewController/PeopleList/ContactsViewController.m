//
//  ContactsViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/5/4.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ContactsViewController.h"
#import "PeopleNoInfoViewController.h"
#import "ComPeopleModel.h"
#import "PeopleInfoViewController.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *arr_show;
@property (nonatomic, strong) NSArray *arr_color;

@property(nonatomic,strong)UISearchBar * searchbar;
@property(nonatomic,strong)UIView *noDateView;//无数据视图

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"手机通讯录", nil) backButton:YES];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(49);
        make.left.right.bottom.equalTo(self.view);
        
    }];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    _searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 49)];
    _searchbar.placeholder = Custing(@"搜索", nil);
    _searchbar.delegate = self;
    _searchbar.keyboardType = UIKeyboardTypeDefault;
    _searchbar.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_searchbar];
    
    _arr_color = @[[GPUtils colorHString:@"#7ecef4"],[GPUtils colorHString:@"#6ad3a1"],[GPUtils colorHString:@"#ffa83a"],[GPUtils colorHString:@"#02adfc"],[GPUtils colorHString:@"#b37fad"]];
    
    if (self.userdatas.arr_noused_people) {
        _arr_show = [NSMutableArray arrayWithArray:self.userdatas.arr_noused_people];
        if (_arr_show.count>0) {
            [self changeData];
        }
    }else{
        _arr_show = [NSMutableArray array];
    }
    
    [self createNOdataView];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

-(void)changeData{
    //显示数据排序
    [_arr_show sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSMutableDictionary *dic1 = obj1;
        NSMutableDictionary *dic2 = obj2;
        NSString *str1=dic1[@"pinyin"];
        NSString *str2=dic2[@"pinyin"];
        return [str1 compare:str2];
    }];
    //转化数据
    NSMutableArray *Temporary = [[NSMutableArray alloc]init];
    NSMutableArray *ma_show = [[NSMutableArray alloc]init];
    NSMutableDictionary *md = [[NSMutableDictionary alloc]init];
    NSString *oneguihua = @"";
    //常规用户 中文
    for (int i = 0; i<_arr_show.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_arr_show[i]];
        if ([[NSString stringWithFormat:@"%@",dic[@"pinyin"]] isEqualToString:@""]) {
            [ma_show addObject:dic];
        }else if ([oneguihua isEqualToString:[[NSString stringWithFormat:@"%@",dic[@"pinyin"]] substringToIndex:1]]) {
            [ma_show addObject:dic];
        }
        else
        {
            if (i>0) {
                [md setObject:ma_show forKey:@"array"];
                [Temporary addObject:md];
            }
            oneguihua = [[NSString stringWithFormat:@"%@",dic[@"pinyin"]] substringToIndex:1];
            ma_show =[[NSMutableArray alloc]init];
            md =[[NSMutableDictionary alloc]init];
            [ma_show addObject:dic];
            [md setObject:[[NSString stringWithFormat:@"%@",dic[@"pinyin"]] substringToIndex:1] forKey:@"title"];
        }
        if (i==_arr_show.count-1) {
            [md setObject:ma_show forKey:@"array"];
            [Temporary addObject:md];
        }
    }
    [Temporary sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
        NSString *str1=(NSString *)[obj1 objectForKey:@"title"];
        NSString *str2=(NSString *)[obj2 objectForKey:@"title"];
        return [str1 compare:str2];
    }];
    _arr_show = Temporary;
}

////MARK:创建无数据视图
-(void)createNOdataView{
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有添加通讯录哦", nil) hasData:(_arr_show.count!=0) hasError:NO reloadButtonBlock:nil];

}

////MARK:移除筛选无数据视图
-(void)removeNodateViews{
    if (_noDateView&&_noDateView!=nil) {
        [_noDateView removeFromSuperview];
        _noDateView=nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 25)];
    view.backgroundColor = Color_White_Same_20;
    UILabel *titleLabel= [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width-15, 25) text:@"" font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    NSDictionary *travel;
    travel = _arr_show[section];
    titleLabel.text = travel[@"title"];
    [view addSubview:titleLabel];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 25)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [view addSubview:ImgView];
    return view;
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arr_show.count;
}

//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = _arr_show[section];
    NSArray *arr = dic[@"array"];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

//快捷检索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [_arr_show valueForKeyPath:@"title"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *citySection = _arr_show[indexPath.section][@"array"];
    NSDictionary *dic = citySection[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    UILabel *name = [GPUtils createLable:CGRectMake(70, 10, Main_Screen_Width-100, 20) text:dic[@"name"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:name];
    
    UILabel *mobile = [GPUtils createLable:CGRectMake(70, 30, Main_Screen_Width-100, 24) text:dic[@"mobile"] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [cell addSubview:mobile];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *str = dic[@"name"];
    str = str.length>1?[str substringWithRange:NSMakeRange(str.length-2, 2)]:str;
    
    UIButton *btn = [GPUtils createButton:CGRectMake(15, 10, 40, 40) action:nil delegate:self title:str font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn.titleLabel   setFont :[ UIFont   fontWithName : @"Helvetica-Bold"  size : 15 ]];
    btn.layer.cornerRadius = 20.0;
    int i = indexPath.row % (5);
    [btn setBackgroundColor:_arr_color[i]];
    
    [cell addSubview:btn];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 58.5, Main_Screen_Width, 0.5)];
    image.backgroundColor = Color_GrayLight_Same_20;
    [cell addSubview:image];
    
    return cell;
}
//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *citySection = _arr_show[indexPath.section][@"array"];
    NSDictionary *dic = citySection[indexPath.row];
    if (![[NSString stringWithFormat:@"%@",dic[@"companyId"]] isEqualToString:@"0"]) {
        ComPeopleModel *model = [[ComPeopleModel alloc]init];
        model.userId = dic[@"userId"];
        model.companyId = dic[@"companyId"];
        PeopleInfoViewController *peopleinfo = [[PeopleInfoViewController alloc]init];
        peopleinfo.model = model;
        [self.navigationController pushViewController:peopleinfo animated:YES];
    }else{
        PeopleNoInfoViewController *peo = [[PeopleNoInfoViewController alloc]init];
        peo.dic_userId = dic;
        int i = indexPath.row % (5);
        peo.color = _arr_color[i];
        [self.navigationController pushViewController:peo animated:YES];
    }
}


//搜索代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (self.userdatas.arr_noused_people) {
        _arr_show = [NSMutableArray arrayWithArray:self.userdatas.arr_noused_people];
    }else{
        _arr_show = [NSMutableArray array];
    }
    [self createNOdataView];

    if (_arr_show.count>0&&[NSString isEqualToNull:searchText]) {
        NSMutableArray *ma = [NSMutableArray array];
        for (int i = 0; i<_arr_show.count; i++) {
            NSMutableDictionary *mtdic = [NSMutableDictionary dictionaryWithDictionary:_arr_show[i]];
            if ([mtdic[@"name"] rangeOfString:searchText].location != NSNotFound)
            {
                [ma addObject: mtdic];
            }
        }
        _arr_show = ma;
    }
    if (_arr_show.count>0) {
        [self changeData];
    }
    [_tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self keyClose];
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
