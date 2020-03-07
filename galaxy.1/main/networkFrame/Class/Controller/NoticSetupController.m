//
//  NoticSetupController.m
//  MyDemo
//
//  Created by wilderliao on 15/12/2.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "NoticSetupController.h"

#import "MyTitleDescirbeCell.h"
#import "MyTitleSwitchCell.h"
    
#import "ConfigItem.h"

#import "ImSDk/TIMManager.h"

#import "MBProgressHUD.h"

@interface NoticSetupController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation NoticSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息通知设置";
    
    [self addOwnViews];
    
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD show:YES];
        HUD.hidden = YES;
        [HUD showText:@"正在获取APNS配置" atMode:MBProgressHUDModeIndeterminate];
    }
    
    __weak MBProgressHUD *wHUD = HUD;
    [[TIMManager sharedInstance] getAPNSConfig:^(TIMAPNSConfig *config){
        [self configState:config];
        [self configOwnViews];
        [self setupSubviewEnable:_configState.openPush];
        [wHUD hide:YES];
    } fail:^(int code, NSString *err){
        NSLog(@"%d%@",code,err);
        [wHUD hideText:@"获取APNS配置失败" atMode:MBProgressHUDModeIndeterminate andDelay:1.0 andCompletion:nil];
        [self configState:nil];
        [self configOwnViews];
        [self setupSubviewEnable:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)addOwnViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:_tableView];
    
    _datas = [NSMutableDictionary dictionary];
    _sectionTitle = [[NSMutableArray alloc] init];
}

- (void)configOwnViews
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    ConfigItem *item = nil;

    __weak NoticSetupController *ws = self;
    //开启通知section
    NSMutableArray *sec0 = [NSMutableArray array];
    [sec0 addObject:[self configItem:item switchOn:_configState.openPush title:@"开启通知" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
        NSLog(@"kNoticeSwitch");
        _configState.openPush = configItem.switchOn;
        uint32_t openPush = configItem.switchOn ? 1 : 2;
        [ws setApns:openPush type:nil soundName:nil];
        [ws setupSubviewEnable:configItem.switchOn];
    }]];
    [_sectionTitle addObject:@"开启通知"];
    [_datas setObject:sec0 forKey:@"开启通知"];
    _isEnableSwitch = ((ConfigItem *)sec0[0]).switchOn;
    item = nil;
    
    //C2C消息设置
    NSMutableArray *sec1 = [NSMutableArray array];
    [sec1 addObject:[self configItem:item switchOn:_configState.c2cOpenSound title:@"开启声音" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
        NSLog(@"kC2CSoundSwitch");
        _configState.c2cOpenSound = configItem.switchOn;
        NSString *fileName = [self selectFileName:_configState.c2cOpenSound shakeSwitchOn:_configState.c2cOpenShake];
        [ws setApns:0 type:@"c2cSound" soundName:fileName];
    }]];
    [sec1 addObject:[self configItem:item switchOn:_configState.c2cOpenShake title:@"开启震动" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
        NSLog(@"kC2CShakeSwitch");
        _configState.c2cOpenShake = configItem.switchOn;
        NSString *fileName = [self selectFileName:_configState.c2cOpenSound shakeSwitchOn:_configState.c2cOpenShake];
        [ws setApns:0 type:@"c2cSound" soundName:fileName];
    }]];
    [_sectionTitle addObject:@"C2C消息设置"];
    [_datas setObject:sec1 forKey:@"C2C消息设置"];
    
    //Group消息设置
    NSMutableArray *sec2 = [NSMutableArray array];
    [sec2 addObject:[self configItem:item switchOn:_configState.groupOpenSound title:@"开启声音" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
        NSLog(@"kGroupSoundSwitch");
        _configState.groupOpenSound = configItem.switchOn;
        NSString *fileName = [self selectFileName:_configState.groupOpenSound shakeSwitchOn:_configState.groupOpenShake];
        [ws setApns:0 type:@"groupSound" soundName:fileName];
    }]];
    [sec2 addObject:[self configItem:item switchOn:_configState.groupOpenShake title:@"开启震动" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
        NSLog(@"kGroupShakeSwitch");
        _configState.groupOpenShake = configItem.switchOn;
        NSString *fileName = [self selectFileName:_configState.groupOpenSound shakeSwitchOn:_configState.groupOpenShake];
        [ws setApns:0 type:@"groupSound" soundName:fileName];
    }]];
    [_sectionTitle addObject:@"Group消息设置"];
    [_datas setObject:sec2 forKey:@"Group消息设置"];
    
    //来电消息设置
//    NSMutableArray *sec3 = [NSMutableArray array];
//    [sec3 addObject:[self configItem:item switchOn:_configState.videoOpenSound title:@"开启声音" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
//        NSLog(@"kLyncSoundSwitch");
//        _configState.videoOpenSound = configItem.switchOn;
//        NSString *fileName = [self selectFileName:_configState.videoOpenSound shakeSwitchOn:_configState.videoOpenShake];
//        [ws setApns:0 type:@"videoSound" soundName:fileName];
//    }]];
//    [sec3 addObject:[self configItem:item switchOn:_configState.videoOpenShake title:@"开启震动" type:ITEM_TITLE_SWITCH describe:nil action:^(id<ConfigItemProtocol> configItem){
//        NSLog(@"kLyncShakeSwitch");
//        _configState.videoOpenShake = configItem.switchOn;
//        NSString *fileName = [self selectFileName:_configState.videoOpenSound shakeSwitchOn:_configState.videoOpenShake];
//        [ws setApns:0 type:@"videoSound" soundName:fileName];
//    }]];
//    [_sectionTitle addObject:@"来电消息设置"];
//    [_datas setObject:sec3 forKey:@"来电消息设置"];
}

#pragma mark - config item

- (ConfigItem *)configItem:(ConfigItem *)item switchOn:(BOOL )isOn title:(NSString *)itemTitle type:(int)itemType describe:(NSString *)des action:(ConfigCellAction)action
{
    item = [[ConfigItem alloc] initWithTitle:itemTitle itemType:itemType switchOn:isOn describe:des action:^(id<ConfigItemProtocol> configItem)
    {
        action(configItem);
    }];
    return item;
}

- (void)configState:(TIMAPNSConfig *)config
{
    _configState = [[ConfigState alloc] init];
    
    //设置默认值
    if (config == nil)
    {
        _configState.openPush = NO;
        _configState.c2cOpenSound = NO;
        _configState.c2cOpenShake = NO;
        _configState.groupOpenSound = NO;
        _configState.groupOpenShake = NO;
//        _configState.videoOpenSound = NO;
//        _configState.videoOpenShake = NO;
        return;
    }
    
    _configState.openPush = (config.openPush==1) ? YES : NO;
    
    if ([config.c2cSound isEqualToString:@"00.caf"] || config.c2cSound.length==0) {
        _configState.c2cOpenSound = NO;
        _configState.c2cOpenShake = NO;
    }
    else if ([config.c2cSound isEqualToString:@"01.caf"]) {
        _configState.c2cOpenSound = NO;
        _configState.c2cOpenShake = YES;
    }
    else if ([config.c2cSound isEqualToString:@"10.caf"]) {
        _configState.c2cOpenSound = YES;
        _configState.c2cOpenShake = NO;
    }
    else if ([config.c2cSound isEqualToString:@"11.caf"]) {
        _configState.c2cOpenSound = YES;
        _configState.c2cOpenShake = YES;
    }
    
    if ([config.groupSound isEqualToString:@"00.caf"] || config.groupSound.length==0) {
        _configState.groupOpenSound = NO;
        _configState.groupOpenShake = NO;
    }
    else if ([config.groupSound isEqualToString:@"01.caf"]) {
        _configState.groupOpenSound = NO;
        _configState.groupOpenShake = YES;
    }
    else if ([config.groupSound isEqualToString:@"10.caf"]) {
        _configState.groupOpenSound = YES;
        _configState.groupOpenShake = NO;
    }
    else if ([config.groupSound isEqualToString:@"11.caf"]) {
        _configState.groupOpenSound = YES;
        _configState.groupOpenShake = YES;
    }
    
//    if ([config.videoSound isEqualToString:@"00.caf"] || config.videoSound.length==0) {
//        _configState.videoOpenSound = NO;
//        _configState.videoOpenShake = NO;
//    }
//    else if ([config.videoSound isEqualToString:@"01.caf"]) {
//        _configState.videoOpenSound = NO;
//        _configState.videoOpenShake = YES;
//    }
//    else if ([config.videoSound isEqualToString:@"10.caf"]) {
//        _configState.videoOpenSound = YES;
//        _configState.videoOpenShake = NO;
//    }
//    else if ([config.videoSound isEqualToString:@"11.caf"]) {
//        _configState.videoOpenSound = YES;
//        _configState.videoOpenShake = YES;
//    }
    
}

- (NSString *)selectFileName:(BOOL)soundOn shakeSwitchOn:(BOOL)shakeOn
{
    if (!soundOn && !shakeOn) {
        return @"00.caf";
    }
    else if (!soundOn && shakeOn) {
        return @"01.caf";
    }
    else if (soundOn && !shakeOn) {
        return @"10.caf";
    }
    else if (soundOn && shakeOn) {
        return @"11.caf";
    }
    else{
        return nil;
    }
}

- (void)saveObject:(BOOL)obj key:(NSString*)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:obj] forKey:key];
}

//openPush:0-不进行设置 1-开启推送 2-关闭推送
- (void)setApns:(uint32_t)openPush type:(NSString *)type soundName:(NSString *)name
{
    TIMAPNSConfig * apnsConfig = [[TIMAPNSConfig alloc] init];
    apnsConfig.openPush = openPush;
    if ([type isEqualToString:@"c2cSound"]){
        apnsConfig.c2cSound = name;
    }
    if ([type isEqualToString:@"groupSound"]) {
        apnsConfig.groupSound = name;
    }
    if ([type isEqualToString:@"videoSound"]) {
        apnsConfig.videoSound = name;
    }
    
    [[TIMManager sharedInstance] setAPNS:apnsConfig succ:^()
     {
         NSLog(@"succ");
     } fail:^(int code, NSString *err)
     {
         NSLog(@"fail");
     }];
}

- (void)setupSubviewEnable:(BOOL)isEnable
{
    NSLog(@"setupSubviewEnable");
    for(NSString *key in _datas)
    {
        NSArray *items = (NSArray *)[_datas objectForKey:key];
        for (ConfigItem *item in items)
        {
            if ([item.title isEqualToString:@"开启通知"]){
                continue;
            }
            item.isEnable = isEnable;
        }
    }
    [_tableView reloadData];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id title = _sectionTitle[section];
    return ((NSArray *)[_datas objectForKey:title]).count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitle.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitle[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reusedId = @"NoticConfig";
    
    id title = _sectionTitle[indexPath.section];
    ConfigItem *item = ((NSArray *)[_datas objectForKey:title])[indexPath.row];
    
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

@end

@implementation ConfigState

@end
