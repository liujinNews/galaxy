//
//  PeopleIndexViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PeopleIndexViewController.h"
#import "ComPeopleViewController.h"
#import "RDVTabBarController.h"
#import "ContactsViewController.h"
#import "CommonPeopleTableViewCell.h"
#import "SearchResultsTableViewController.h"
#import "ComPeopleModel.h"
#import "IQKeyboardManager.h"
#import <Contacts/Contacts.h>
#import "UIImage+Common.h"
#import "PeopleInfoViewController.h"
#import "ComPeopleModel.h"
//#import <AddressBook/AddressBook.h>

@interface PeopleIndexViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UIView *view_xibao;

@property (weak, nonatomic) IBOutlet UIView *view_Srarch;//搜索框
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) SearchResultsTableViewController *searchTableview;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSString *searchtext;

@property (weak, nonatomic) IBOutlet UIView *view_Company;//部门view，用来改变contentsize

@property (weak, nonatomic) IBOutlet UILabel *lab_ConpanyName;//设置公司名称

@property (weak, nonatomic) IBOutlet UILabel *lab_DeparmentName;//设置部门名称

@property (weak, nonatomic) IBOutlet UIView *view_PeopleList;//常用联系人view

@property (nonatomic, strong) NSString * parentId;

@property (nonatomic, strong) NSArray * arr_people_request;

@property (nonatomic, strong) UITableView *tab_People;//常用联系人table

@property (nonatomic, strong) UIView *noDateView;//无数据视图
@property (nonatomic, strong) UILabel *promptLabel;//无数据提示信息

@property (nonatomic, strong) UIView *xibao_Frame;

@end

@implementation PeopleIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *string =[defaults objectForKey:@"dic"];
//    
//    NSDictionary *dic_people_request = [NSString dictionaryWithJsonString:string];
    
//    _arr_people_request = dic_people_request[@"dic"];
    _arr_people_request = [NSArray array];
    //多语言初始化
    _lab_FrequentContacts.text = Custing(@"常用联系人", nil);
    _lab_OrganizationStructure.text = Custing(@"组织架构", nil);
    _lab_EnterpriseContacts.text = Custing(@"企业通讯录", nil);
    _lab_MyDepartment.text = Custing(@"我的部门", nil);

    
//    UIImage *changeImage = [UIImage imageWithCGImage:_img_xibao.image.CGImage
//                                             scale:1.0
//                                       orientation:UIImageOrientationRight];
//    _img_xibao.image = changeImage;
    _img_xibao.tag = 1;
    
    self.searchResults = [[NSMutableArray alloc]init];
    _searchtext = @"";
    //添加通知
    self.view.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
    _view_Company.frame = CGRectMake(X(_view_Company), Y(_view_Company), Main_Screen_Width, 68);
    
    UIImageView *lineDown=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width,0.5)];
    lineDown.backgroundColor=Color_White_Same_20;
    
//    _view_xibao.frame = CGRectMake(X(_view_xibao), Y(_view_xibao), WIDTH(_view_xibao), 0);
    _view_PeopleList.frame = CGRectMake(X(_view_PeopleList), Y(_view_PeopleList)-68, WIDTH(_view_PeopleList), HEIGHT(_view_PeopleList));
//    _view_xibao.hidden = YES;
    
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType ==0) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    _scr_Scroll.contentSize = CGSizeMake(Main_Screen_Width, 640);
    
    [self.addressBtn setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [self.departBtn setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [self.friendBtn setBackgroundColor:Color_form_TextFieldBackgroundColor];
//    [self.organiBtn setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [self.view_Company setBackgroundColor:Color_form_TextFieldBackgroundColor];
    [self.lab_ConpanyName setTextColor:Color_form_TextField_20];
    [self.lab_DeparmentName setTextColor:Color_form_TextField_20];
    [self.view_adFriBg setBackgroundColor:[XBColorSupport customBackgroundColor]];
    [self.view_CustBg setBackgroundColor:[XBColorSupport customBackgroundColor]];
    [self.imgView1 setBackgroundColor: [XBColorSupport supportimgLine]];
    [self.imgView2 setBackgroundColor: [XBColorSupport supportimgLine]];
    [self.imgView3 setBackgroundColor: [XBColorSupport supportimgLine]];
    [self.imgView4 setBackgroundColor: [XBColorSupport supportimgLine]];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setPeopleView];
    [self requestUserInfo];
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType ==0) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    _scr_Scroll.contentSize = CGSizeMake(Main_Screen_Width, 640);
}

#pragma mark - 方法
//获取个人信息
-(void)requestUserInfo
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:XB_PersonalInfo Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
}

//请求基本数据
-(void)requestCredentials
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getcosummary] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}

//请求基本数据
-(void)requestGetMobContacts:(NSArray *)arr{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"MobContacts":jsonStr};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetMobContacts] Parameters:dic Delegate:self SerialNum:4 IfUserCache:NO];
}


-(void)analyzeContacts{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactImageDataKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSMutableArray *muarr = [NSMutableArray array];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@  ", givenName, familyName);
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *newP = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
            newP = [newP stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            // 去除+86
            if ([newP containsString:@"+86"]) {
                newP = [newP stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            }
            // 去除+
            if ([newP containsString:@"+"]) {
                newP = [newP stringByReplacingOccurrencesOfString:@"+" withString:@""];
            }
            if ([[newP substringToIndex:1]isEqualToString:@"1"]&&newP.length==11) {
                NSString *str = [NSString stringWithFormat:@"%@%@",familyName,givenName];
                if ([str isEqualToString:@""]) {
                    str = @"#";
                }
                NSDictionary *dic = @{@"companyId":@0,@"mobile":newP,@"name":str,@"used":@0,@"userId":@0};
                [muarr addObject:dic];
            }
        }
    }];
    [self requestGetMobContacts:muarr];
}

//设置显示页面
-(void)setViewInfo
{
    _lab_ConpanyName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.userdatas.company]]?self.userdatas.company:@"";
    _lab_DeparmentName.text =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.userdatas.groupname]]?self.userdatas.groupname:@"";
}

-(void)setPeopleView
{
    if (_arr_people_request) {
        if (_tab_People==nil) {
            _tab_People = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-430) style:UITableViewStylePlain];
        }
        _tab_People.delegate = self;
        _tab_People.dataSource = self;
        _tab_People.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tab_People.rowHeight = 69;
        _tab_People.backgroundColor = Color_White_Same_20;
        [self.view_PeopleList addSubview:_tab_People];
    }
    
    if (_searchTableview == nil) {
        _searchTableview =[[SearchResultsTableViewController alloc]init];
    }
    if (self.searchController == nil) {
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:_searchTableview];
    }
    self.searchController.searchBar.frame = CGRectMake(self.view_Srarch.frame.origin.x,
                                                       self.view_Srarch.frame.origin.y,
                                                       Main_Screen_Width, 44.0);
    self.searchController.searchBar.barStyle = UIBarStyleDefault;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.translucent = YES;
    [self.searchController.searchBar setBackgroundImage:[UIImage new]];
    self.searchController.searchBar.placeholder = Custing(@"搜索姓名", nil);
    self.searchController.searchBar.userInteractionEnabled = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.backgroundColor = Color_White_Same_20;
    self.searchController.searchBar.barTintColor = Color_White_Same_20;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar searchFieldBackgroundImageForState:UIControlStateNormal];
    [self.view_Srarch addSubview:self.searchController.searchBar];
    self.view_Srarch.userInteractionEnabled = YES;
    //圣诞样式
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType ==0) {
        UITextField *searchField = nil;
        UIView *ser_subview = (UIView *)_searchController.searchBar.subviews[0];
        for (UIView *subview in ser_subview.subviews) {
            if ([subview isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)subview;
                break;
            }
        }
        if (searchField) {
            UIImage *image = [UIImage imageNamed: @"Year_Search"];
            UIImageView *iView = [[UIImageView alloc] initWithImage:image];
            searchField.leftView = iView;
        }
        self.searchController.searchBar.backgroundImage = [UIImage imageNamed:@"Year_SearchBack"];
    }
    
    if (_arr_people_request.count==0) {
        [self createNOdataView];
    }
}

//MARK:创建无数据视图
-(void)createNOdataView{
    [self removeNodateViews];
}

//MARK:移除筛选无数据视图
-(void)removeNodateViews{
    if (_noDateView&&_noDateView!=nil) {
        [_noDateView removeFromSuperview];
        _noDateView=nil;
    }
}

-(void)getsearchdata
{
    NSString *url=[NSString stringWithFormat:@"%@",getmbrs];
    NSDictionary *parameters = @{@"UserDspName":_searchtext};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:8 IfUserCache:NO];
}

#pragma mark - action
//公司点击事件
- (IBAction)btnClick_Company:(UIButton *)sender {
    ComPeopleViewController *people = [[ComPeopleViewController alloc]init];
    people.nowGroup = [NSString isEqualToNull:self.userdatas.companyId]?self.userdatas.companyId:self.userdatas.groupid;
    people.nowGroupname = self.userdatas.company;
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    RDVTabBarController *nav = (RDVTabBarController *)window.rootViewController;
    UINavigationController *navi = nav.viewControllers[0];
    
    [navi pushViewController:people animated:YES];
}

//部门点击事件
- (IBAction)btnClick_Department:(UIButton *)sender {
    ComPeopleViewController *people = [[ComPeopleViewController alloc]init];
    people.nowGroup = [NSString isEqualToNull:self.userdatas.groupid]?self.userdatas.groupid:self.userdatas.companyId;
    people.nowGroupname = [NSString isEqualToNull:self.userdatas.groupname]?self.userdatas.groupname:self.userdatas.company;
    people.parentId = _parentId;
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    RDVTabBarController *nav = (RDVTabBarController *)window.rootViewController;
    UINavigationController *navi = nav.viewControllers[0];
    [navi pushViewController:people animated:YES];
}

//-(void)createAddBookAlert{
//    [UIAlertView bk_showAlertViewWithTitle:Custing(@"请在iPhone的“设置-隐私-通讯录”选项中，允许喜报访问你的通讯录", nil) message:@"" cancelButtonTitle:Custing(@"好的", nil) otherButtonTitles:@[Custing(@"设置", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if([[UIApplication sharedApplication] canOpenURL:url]) {
//                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        }
//    }];
//    return;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    if ([responceDic[@"success"]intValue]==0) {
        
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:2.0];
        return;
    }
    if (serialNum == 3) {
        NSDictionary *userInfo = responceDic[@"result"];
        if (![userInfo isEqual:[NSNull null]]) {
            self.userdatas.company = userInfo[@"companyName"];
            self.userdatas.companyId = [NSString stringWithIdOnNO:userInfo[@"companyId"]];
            
            NSArray *usergroup_arr = userInfo[@"userGroup"];
            if (![usergroup_arr isEqual:[NSNull null]]) {
                if (usergroup_arr.count>0) {
                    NSDictionary *userGroup_Dic = usergroup_arr[0];
                    self.userdatas.groupname = userGroup_Dic[@"groupName"];
                    self.userdatas.groupid = userGroup_Dic[@"groupId"];
                    _parentId = userGroup_Dic[@"parentId"];
                    [self.userdatas storeUserInfo];
                }
            }
            [self requestCredentials];
        }
    }else if (serialNum == 4) {
        NSArray *arr = responceDic[@"result"];
        if (arr.count>0) {
            [self removeNodateViews];
            
            _view_xibao.frame = CGRectMake(X(_view_xibao), Y(_view_xibao), WIDTH(_view_xibao), 68);
            _view_PeopleList.frame = CGRectMake(X(_view_PeopleList), Y(_view_PeopleList), WIDTH(_view_PeopleList), HEIGHT(_view_PeopleList));
            _view_xibao.hidden = NO;
            
            NSMutableArray *used = [NSMutableArray array];
            NSMutableArray *noused = [NSMutableArray array];
            for (int i = 0; i<arr.count; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
                NSString *pinyin = [[NSString stringWithFormat:@"%@",dic[@"name"]] firstPinYin].uppercaseString;
                
                [dic addString:pinyin forKey:@"pinyin"];
                if ([dic[@"used"] integerValue]==1) {
                    [used addObject:dic];
                }
                [noused addObject:dic];
            }
            if (used.count==0) {
                _view_xibao.frame = CGRectMake(X(_view_xibao), Y(_view_xibao), WIDTH(_view_xibao), 0);
                _view_PeopleList.frame = CGRectMake(X(_view_PeopleList), Y(_view_PeopleList)-68, WIDTH(_view_PeopleList), HEIGHT(_view_PeopleList));
                _view_xibao.hidden = YES;
            }
            _arr_people_request = [NSArray arrayWithArray:used];
            [_tab_People reloadData];
            self.userdatas.arr_used_people = used;
            self.userdatas.arr_noused_people = noused;
        }
    }else if (serialNum == 0) {
        [YXSpritesLoadingView dismiss];
        
        NSDictionary * result = [responceDic objectForKey:@"result"];
        self.userdatas.companyId = [NSString stringWithIdOnNO:[result objectForKey:@"groupId"]];
        [self.userdatas storeUserInfo];
        [self setViewInfo];
    }else if (serialNum == 8) {
        NSArray *group = responceDic[@"result"];
        _searchResults = [[NSMutableArray alloc]init];
        ComPeopleModel *model ;
        if (![group isEqual:[NSNull null]]) {
            for (int i = 0 ; i<group.count; i++) {
                model = [[ComPeopleModel alloc]initWithBydic:group[i]];
                [_searchResults addObject:model];
            }
            // If searchResultsController
            if (self.searchController.searchResultsController) {
                
                _searchTableview.searchResults = self.searchResults;
                _searchTableview.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                // And reload the tableView with the new data
                [_searchTableview.tableView reloadData];
            }
        }
        
    }
    
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark 表格代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.userdatas.SystemType == 1) {
        return 0;
    }
    return _arr_people_request.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *check = @"cell";
//    CommonPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:check];
//    if (!cell) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonPeopleTableViewCell" owner:self options:nil];
//        cell = [nib lastObject];
//    }
    NSDictionary *dic = _arr_people_request[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = dic[@"name"];
    cell.imageView.image = [UIImage imageNamed:@"Message_Man"];
    
    //添加一个线
    UIImageView *image;
    if (indexPath.row == _arr_people_request.count-1) {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, Main_Screen_Width, 0.5)];
    }
    else
    {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(60, 68, Main_Screen_Width, 0.5)];
    }
    image.backgroundColor = Color_GrayLight_Same_20;
    [cell addSubview:image];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
    cell.contentView.backgroundColor = [XBColorSupport customBackgroundColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    RDVTabBarController *nav = (RDVTabBarController *)window.rootViewController;
    UINavigationController *navi = nav.viewControllers[0];
    
//    NSDictionary *dics = _arr_people_request[indexPath.row];
//    //跳转到AIO
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[NSString stringWithFormat:@"%@",dics[@"photoGraph"]] forKey:@"userHeader"];
//    [userDefaults synchronize];
//    
//    
//    IMAUser *user = [[IMAUser alloc]init];
//    
//    user.userId = [NSString stringWithFormat:@"%@_%@",dics[@"userId"],@"xibao"];
//    
//    NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",dics[@"photoGraph"]]];
//    if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
//        user.icon = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
//    }else{
//        user.icon = nil;
//    }
//    
//    user.nickName = dics[@"userDspName"];
//    user.remark = dics[@"userDspName"];
    ComPeopleModel *model = [[ComPeopleModel alloc]init];
    NSDictionary *dic = _arr_people_request[indexPath.row];
    model.userId = dic[@"userId"];
    model.companyId = dic[@"companyId"];
    PeopleInfoViewController *peopleinfo = [[PeopleInfoViewController alloc]init];
    peopleinfo.model = model;
    [navi pushViewController:peopleinfo animated:YES];
    
//    [[AppDelegate sharedAppDelegate] pushToChatViewControllerWith:user];
    
    
}

#pragma mark UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    
    _searchtext = searchString;
    
    [self getsearchdata];
    
    
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
