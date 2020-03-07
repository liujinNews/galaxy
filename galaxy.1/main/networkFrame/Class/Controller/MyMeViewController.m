//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyMeViewController.h"
#import "AppDelegate.h"
#import "GlobalData.h"
#import "AccountHelper.h"
#import "UIResponder+addtion.h"
#import "MyCommOperation.h"
#import "UIViewAdditions.h"
#import "MyBlackListViewController.h"
#import "MyUtilty.h"
#import "MyChatCell.h"

#import "MyTitleSwitchCell.h"
#import "MyTitleDescirbeCell.h"
#import "ConfigItem.h"
#import "MyAlertView.h"
#import "NoticSetupController.h"

#import "ConstDefine.h"

#import "TLSSDK/TLSHelper.h"
#import "QALSDK/QalSDKProxy.h"

@interface MyMeViewController ()
@property (nonatomic, strong) NSString * changeFrontNick;
@end

@implementation MyMeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self initTable];
    [self configOwnViews];
}

- (void)initTable{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    _tableView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
    _tableView.separatorColor = RGBACOLOR(0xd7, 0xd7, 0xcf, 1.f);
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _tableView.sectionIndexColor = RGBACOLOR(0xa4, 0xa4, 0xa4, 1.0f);
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    if (_tableView.tableFooterView == nil) {
        [self initExitButton];
    }
    [self.view addSubview:_tableView];
}

- (void)initExitButton{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    _tableView.tableFooterView = footView;
    
    UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [exitBtn setFrame:CGRectMake(footView.bounds.size.width/2-100, 20, 200, 40)];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    exitBtn.backgroundColor = [UIColor grayColor];
    
    [exitBtn addTarget:self action:@selector(onExitDownClick:) forControlEvents:UIControlEventTouchDown];
    [exitBtn addTarget:self action:@selector(onExitUpInClick:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn addTarget:self action:@selector(onExitUpOutClick:) forControlEvents:UIControlEventTouchUpOutside];
    
    [_tableView.tableFooterView addSubview:exitBtn];
}

- (void)configOwnViews{
     _cellsConfig = [NSMutableDictionary dictionary];
    NSMutableArray *sec0 = [NSMutableArray array];
    
    ConfigItem *item = nil;
    
    [sec0 addObject:[self configID:item]];
    item = nil;

    [sec0 addObject:[self configNick:item]];
    item = nil;
    
    [sec0 addObject:[self configNotic:item]];
    item = nil;
    
    [sec0 addObject:[self configEnvironment:item]];
    item = nil;
    
    [sec0 addObject:[self configConsoleLog:item]];
    item = nil;
    
    [sec0 addObject:[self configLogLevel:item]];
    item = nil;
    
    [sec0 addObject:[self configBlackList:item]];
    item = nil;
    
    [sec0 addObject:[self configAllowType:item]];
    item = nil;
    
    [sec0 addObject:[self configVersion:item]];
    item = nil;
    
    [_cellsConfig setObject:sec0 forKey:@(0)];
}

- (ConfigItem *)configID:(ConfigItem *)item{
    item = [[ConfigItem alloc] initWithTitle:@"ID" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:[GlobalData shareInstance].me action:^(id<ConfigItemProtocol> configItem){}];
    return item;
}

- (ConfigItem *)configNick:(ConfigItem *)item{
    _changeFrontNick = [GlobalData shareInstance].nickName ? [GlobalData shareInstance].nickName:@"";
    __weak MyMeViewController *weakSelf = self;
    __weak UITableView *weakTableView = _tableView;
    item = [[ConfigItem alloc] initWithTitle:@"设置昵称" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:([GlobalData shareInstance].nickName ? [GlobalData shareInstance].nickName:@"") action:^(id<ConfigItemProtocol> configItem){
        __weak ConfigItem *wci = configItem;
        MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"请输入昵称" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
            if (buttonIndex == 1) {
                NSString *text = [myAlertView textFieldAtIndex:0].text;
                [[MyCommOperation shareInstance] setNickName:text succ:^{
                    [wci setDescribe:text];
                    [weakTableView reloadData];
                    [weakSelf showPrompt:@"修改昵称成功"];
                } fail:^(int code, NSString *err){
                    [weakSelf showPrompt:@"修改昵称失败"];
                }];
            }
        }];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.text = [GlobalData shareInstance].nickName;
        tf.delegate = self;
        [tf addTarget:weakSelf action:@selector(onValueChange:) forControlEvents:UIControlEventEditingChanged];
        [alert becomeFirstResponder];
        [alert show];
    }];
    return item;
}

- (ConfigItem *)configNotic:(ConfigItem *)item{
    __weak MyMeViewController *ws = self;
    item = [[ConfigItem alloc] initWithTitle:@"消息通知设置" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:nil action:^(id<ConfigItemProtocol> configItem) {
        NoticSetupController  *noticSetupVC = [[NoticSetupController alloc] init];
        [ws.navigationController pushViewController:noticSetupVC animated:YES];
    }];
    return item;
}


- (ConfigItem *)configEnvironment:(ConfigItem *)item{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    BOOL bSwitchOn = YES;
    NSNumber* value = nil;
    value=[defaults objectForKey:kEnvironmentSwitch];
    if (value) { bSwitchOn = [value boolValue]; }
    __weak UITableView *weakTableView = _tableView;
    item = [[ConfigItem alloc] initWithTitle:@"测试环境" itemType:ITEM_TITLE_SWITCH switchOn:bSwitchOn describe:nil action:^(id<ConfigItemProtocol> configItem){
        __weak ConfigItem *wci = configItem;
        MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"警告" message:@"切换环境需要退出应用" cancelButtonTitle:@"退出应用" otherButtonTitles:@[@"暂不退出"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
            if (buttonIndex == 0){
                NSString* key = kEnvironmentSwitch;
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSNumber numberWithBool:wci.switchOn] forKey:key];
                [defaults synchronize];
                exit(0);
            }
            else{
                wci.switchOn = !wci.switchOn;
                [weakTableView reloadData];
            }
        }];
        [alert show];
    }];
    return item;
}

- (ConfigItem *)configConsoleLog:(ConfigItem *)item{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    BOOL bSwitchOn = YES;
    NSNumber* value = nil;
    value=[defaults objectForKey:kConsoleLogSwitch];
    if (value) { bSwitchOn = [value boolValue]; }
    __weak UITableView *weakTableView = _tableView;
    item = [[ConfigItem alloc] initWithTitle:@"打印控制台日志" itemType:ITEM_TITLE_SWITCH switchOn:bSwitchOn describe:nil action:^(id<ConfigItemProtocol> configItem){
        __weak ConfigItem *wci = configItem;
        MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"警告" message:@"切换打印控制台日志需要退出应用" cancelButtonTitle:@"退出应用" otherButtonTitles:@[@"暂不退出"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
            if (buttonIndex == 0){
                NSString* key = kConsoleLogSwitch;
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSNumber numberWithBool:wci.switchOn] forKey:key];
                [defaults synchronize];
                exit(0);
            }
            else{
                wci.switchOn = !wci.switchOn;
                [weakTableView reloadData];
            }
        }];
        [alert show];
    }];
    return item;
}

- (ConfigItem *)configLogLevel:(ConfigItem *)item{
    item = [[ConfigItem alloc] initWithTitle:@"日志等级" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:[self getLogLevelDescription] action:^(id<ConfigItemProtocol> configItem){
        
        MyAlertView *logLevelMenu = [[MyAlertView alloc]initWithTitle:@"" message:nil cancelButtonTitle:@"返回" otherButtonTitles:@[@"NONE", @"ERROR", @"WARN",@"INFO",@"DEBUG"]  block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
            [GlobalData shareInstance].logLevel = TIM_LOG_NONE;
            switch (buttonIndex) {
                case 0:
                    return;
                case 1:
                    [GlobalData shareInstance].logLevel = TIM_LOG_NONE;
                    break;
                case 2:
                    [GlobalData shareInstance].logLevel = TIM_LOG_ERROR;
                    break;
                case 3:
                    [GlobalData shareInstance].logLevel = TIM_LOG_WARN;
                    break;
                case 4:
                    [GlobalData shareInstance].logLevel = TIM_LOG_INFO;
                    break;
                case 5:
                    [GlobalData shareInstance].logLevel = TIM_LOG_DEBUG;
                    break;
                default:
                    break;
            }
            MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"警告" message:@"切换日志等级需要退出应用" cancelButtonTitle:@"退出应用" otherButtonTitles:@[@"暂不退出"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
                if (buttonIndex == 0)
                {
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    [defaults setObject:[NSNumber numberWithInt:(int)[GlobalData shareInstance].logLevel] forKey:kLogLevel];
                    [defaults synchronize];
                    exit(0);
                }
            }];
            [alert show];
        }];
        [logLevelMenu show];
    }];
    return item;
}

- (ConfigItem *)configBlackList:(ConfigItem *)item{
    __weak MyMeViewController *weakSelf = self;
    item = [[ConfigItem alloc] initWithTitle:@"黑名单" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:nil action:^(id<ConfigItemProtocol> configItem){
        MyBlackListViewController* blackListCntlor = [[MyBlackListViewController alloc] init];
        [weakSelf.navigationController pushViewController:blackListCntlor animated:YES];
    }];
    return item;
}

- (ConfigItem *)configAllowType:(ConfigItem *)item{
    __weak UITableView *weakTableView = _tableView;
    item = [[ConfigItem alloc] initWithTitle:@"设置好友申请" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:[self getAllowTypeDescription] action:^(id<ConfigItemProtocol> configItem){
        
        __weak ConfigItem *wci = configItem;
        MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"" message:nil cancelButtonTitle:@"返回" otherButtonTitles:@[@"自动接受", @"需要验证", @"拒绝所有申请"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
            TIMFriendAllowType allowType = TIM_FRIEND_ALLOW_ANY;
            switch (buttonIndex) {
                case 0:
                    return;
                case 1:
                    allowType = TIM_FRIEND_ALLOW_ANY;
                    break;
                case 2:
                    allowType = TIM_FRIEND_NEED_CONFIRM;
                    break;
                case 3:
                    allowType = TIM_FRIEND_DENY_ANY;
                    break;
                default:
                    break;
            }
            [[MyCommOperation shareInstance] setAllowType:allowType succ:^(TIMFriendAllowType type){
                NSString *describe;
                switch (type) {
                    case TIM_FRIEND_ALLOW_ANY:
                        describe = @"自动接受";
                        break;
                    case TIM_FRIEND_NEED_CONFIRM:
                        describe = @"需要验证";
                        break;
                    case TIM_FRIEND_DENY_ANY:
                        describe = @"拒绝所有申请";
                }
                [wci setDescribe:describe];
                [weakTableView reloadData];
            } fail:nil];
        }];
        [alert show];
    }];
    return item;
}

- (ConfigItem *)configVersion:(ConfigItem *)item{
    item = [[ConfigItem alloc] initWithTitle:@"版本号" itemType:ITEM_TITLE_DESCRIBE switchOn:nil describe:nil action:^(id<ConfigItemProtocol> configItem){
        NSString *imVersion = [[TIMManager sharedInstance] GetVersion];
//        NSString *qalVersion = [[QalSDKProxy sharedInstance] getSDKVer];
        NSString *tlsVersion = [[TLSHelper getInstance] getSDKVersion];
        NSString *qalVersion = [[QalSDKProxy sharedInstance] getSDKVer];
        
//        NSString *myMessage = [NSString stringWithFormat:@"IMSDK Version:%@\r\nQal Verssion:%@\r\nTLSSDK Version:%@",imVersion, qalVersion, tlsVersion];
        NSString *myMessage = [NSString stringWithFormat:@"IMSDK Version:%@\r\nTLSSDK Version:%@\r\nQALSDK Version:%@",imVersion, tlsVersion,qalVersion];
        
        MyAlertView *alert = [[MyAlertView alloc] initWithTitle:@"版本信息" message:myMessage cancelButtonTitle:nil otherButtonTitles:@[@"确定"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
        }];
        [alert show];
    }];
    return item;
}

#pragma mark - Delegate<UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSMutableArray *)[_cellsConfig objectForKey:@(0)]).count;
}

-(NSArray *)sectionIndexTitlesForTableView{
    NSArray* titles = [NSArray arrayWithObjects:@"设置", nil];
    return titles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* reusedId = @"Config";
    
    ConfigItem *item = ((NSArray *)_cellsConfig[@(indexPath.section)])[indexPath.row];
    if (item.type == ITEM_TITLE_DESCRIBE) {
        MyTitleDescirbeCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
        if (!cell) {
            cell = [[MyTitleDescirbeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusedId];
        }
        [cell config:item];
        return cell;
    }
    else if (item.type == ITEM_TITLE_SWITCH){
        MyTitleSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
        if (!cell) {
            cell = [[MyTitleSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
        }
        [cell config:item];
        return cell;
    }
    NSLog(@"item type no exist");
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfigItem *item = ((NSArray *)_cellsConfig[@(indexPath.section)])[indexPath.row];
    if (item.type == ITEM_TITLE_DESCRIBE){
        [item ConfigCellAction];
    }
}

#pragma mark - Event Response
- (void) onExitUpInClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    __weak MyMeViewController *weakSelf = self;
    MyAlertView *exitAlert = [[MyAlertView alloc] initWithTitle:@"" message:@"确认退出" cancelButtonTitle:@"返回" otherButtonTitles:@[@"确认"] block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
        if (buttonIndex == 1) {
            [weakSelf exit];
        }
    }];
    [exitAlert show];
}

- (void) onExitDownClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)onExitUpOutClick:(id)sender{
    UIButton *btn = (UIButton*)sender;
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)onValueChange:(id)sender{
    UITextField *textField = (UITextField*)sender;
    //记录待选文字记录
    UITextRange *markedTextRange = textField.markedTextRange;
    //如果存在待选文字记录，则暂不处理
    if (markedTextRange) {
        return;
    }
    NSString *changeText;
    //长度变短
    if (_changeFrontNick.length > textField.text.length) {
        changeText = [_changeFrontNick substringFromIndex:textField.text.length];
        //将超出最大限制字节的文本删除
        size_t length = strlen([textField.text UTF8String]);
        if ( length > kNickMaxBytesLength) {
            textField.text = [self cutBeyondText:textField.text];
        }
    }
    else{//长度变长
        changeText = [textField.text substringFromIndex:_changeFrontNick.length];
        if ([MyChatCell stringContainsEmoji:changeText]) {
            textField.text = _changeFrontNick;
        }
        else{
    //将超出最大限制字节的文本删除
    size_t length = strlen([textField.text UTF8String]);
    if ( length > kNickMaxBytesLength) {
        textField.text = [self cutBeyondText:textField.text];
    }
}
    }
    _changeFrontNick = textField.text;
}

//递归计算符合规定的文本长度
- (NSString *)cutBeyondText:(NSString *)fieldText{
    size_t length = strlen([fieldText UTF8String]);
    if (length > kNickMaxBytesLength) {
        fieldText = [fieldText substringToIndex:fieldText.length-1];
        return [self cutBeyondText:fieldText];
    }
    else{
        return fieldText;
    }
}

//确保没有表情输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length > 1 && [MyChatCell stringContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods
- (void) exit{
    NSLog(@"exit");
    
    // 删除登录sdk的缓存
    NSString *userIdentifier = [GlobalData shareInstance].me;
    
    [[GlobalData shareInstance].accountHelper clearUserInfo:userIdentifier];
    
    // 登出imsdk
    [[TIMManager sharedInstance] logout:^{
        TDDLogEvent(@"logout Succ");
        AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate switchToLoginView];
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Fail: %d->%@", code, err);
        AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate switchToLoginView];
    }];
    
    // 删除本地的登录信息，下一次不再自动登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kLoginParam];
    
    // 删除全局数据对象
    [GlobalData removeInstance];
}

- (NSString *)getAllowTypeDescription {
    switch ([GlobalData shareInstance].friendApplyOpt) {
        case TIM_FRIEND_ALLOW_ANY:
            return @"自动接受";
            break;
        case TIM_FRIEND_NEED_CONFIRM:
            return @"需要验证";
            break;
        case TIM_FRIEND_DENY_ANY:
            return @"拒绝所有申请";
            break;
        default:
            return @"当前设置错误";
            break;
    }
    return @"当前设置错误";
}

- (NSString *)getLogLevelDescription {
    switch ([GlobalData shareInstance].logLevel) {
        case TIM_LOG_NONE:
            return @"NONE";
            break;
        case TIM_LOG_ERROR:
            return @"ERROR";
            break;
        case TIM_LOG_WARN:
            return @"WARN";
            break;
        case TIM_LOG_INFO:
            return @"INFO";
            break;
        case TIM_LOG_DEBUG:
            return @"DEBUG";
            break;
        default:
            return @"当前设置错误";
            break;
    }
    return @"当前设置错误";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _tableView = nil;
    _noticeSwitch = nil;
    _soundSwitch = nil;
    _shakeSwitch = nil;
    _environmentSwitch = nil;
    [_cellsConfig removeAllObjects];
    _cellsConfig = nil;
}

@end
