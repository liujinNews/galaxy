//
//  XibaoFriendViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/6/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "XibaoFriendViewController.h"
#import <Contacts/Contacts.h>
#import "PeopleInfoViewController.h"
#import <AddressBook/AddressBook.h>

@interface XibaoFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,GPClientDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray * arr_people_request;

@end

@implementation XibaoFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"喜报好友", nil) backButton:YES];
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 69;
    [self.view addSubview:_tableView];
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.bottom);
        
    }];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    _arr_people_request = [NSArray array];
    if (!self.userdatas.arr_used_people) {
        [self getContacts];
    }else{
        _arr_people_request = self.userdatas.arr_used_people;
        [self createNOdataView];
        [_tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

-(void)getContacts{
   
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
        switch (ABstatus) {
            case kABAuthorizationStatusAuthorized:
            {
                [self analyzeOldContacts];
            }
                break;
            case kABAuthorizationStatusNotDetermined:
            {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (granted){
                        CFRelease(addressBook);
                        [self analyzeOldContacts];
                    }else{
                        [self createAddBookAlert];
                    }});
            }
                break;
            case kABAuthorizationStatusDenied:
                [self createAddBookAlert];
                break;
                
            case kABAuthorizationStatusRestricted:
                [self createAddBookAlert];
                break;
            default:
                break;
        }
    }else{
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
            {
                [self analyzeContacts];
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        [self analyzeContacts];
                    }else {
                        [self createAddBookAlert];
                    }
                }];
            }
                break;
            case CNAuthorizationStatusDenied:
                [self createAddBookAlert];
                break;
            case CNAuthorizationStatusRestricted:
                [self createAddBookAlert];
                break;
            default:
                break;
        }
    }
}

-(void)createAddBookAlert{
    [UIAlertView bk_showAlertViewWithTitle:Custing(@"请在iPhone的“设置-隐私-通讯录”选项中，允许喜报访问你的通讯录", nil) message:@"" cancelButtonTitle:Custing(@"好的", nil) otherButtonTitles:@[Custing(@"设置", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    return;
}
-(void)analyzeOldContacts{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //数组数量
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    if (peopleCount>0) {
        NSMutableArray *muarr = [NSMutableArray array];
        for (int i = 0; i < peopleCount; i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
            //姓
            NSString *lastNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            //名
            NSString *firstNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *name=[NSString stringWithFormat:@"%@%@",lastNameValue,firstNameValue];
            //拿到多值电话
            ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFIndex phoneCount = ABMultiValueGetCount(phones);
            for (int j = 0; j < phoneCount ; j++) {
                NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
                phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
                if ([phoneValue containsString:@"+86"]) {
                    phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                }
                // 去除+
                if ([phoneValue containsString:@"+"]) {
                    phoneValue = [phoneValue stringByReplacingOccurrencesOfString:@"+" withString:@""];
                }
                if ([[phoneValue substringToIndex:1]isEqualToString:@"1"]&&phoneValue.length==11) {
                    if ([name isEqualToString:@""]) {
                        name = @"#";
                    }
                    NSDictionary *dic = @{@"companyId":@0,@"mobile":phoneValue,@"name":name,@"used":@0,@"userId":@0};
                    [muarr addObject:dic];
                }
            }
            CFRelease(phones);
        }
        [self requestGetMobContacts:muarr];

    }
    CFRelease(addressBook);
    CFRelease(peopleArray);
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

//请求基本数据
-(void)requestGetMobContacts:(NSArray *)arr
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"MobContacts":jsonStr};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetMobContacts] Parameters:dic Delegate:self SerialNum:4 IfUserCache:NO];
}

////MARK:创建无数据视图
-(void)createNOdataView{
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有添加通讯录哦", nil) hasData:(_arr_people_request.count!=0) hasError:NO reloadButtonBlock:nil];
}

#pragma mark - 代理
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    if ([responceDic[@"success"]intValue]==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:2.0];
        return;
    }
    if (serialNum == 4) {
        NSArray *arr = responceDic[@"result"];
        if (arr.count>0) {
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
            _arr_people_request = [NSArray arrayWithArray:used];
            [_tableView reloadData];
            self.userdatas.arr_used_people = used;
            self.userdatas.arr_noused_people = noused;
        }
        [self createNOdataView];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

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
