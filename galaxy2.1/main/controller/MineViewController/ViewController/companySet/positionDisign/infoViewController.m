//
//  infoViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/3/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "infoViewController.h"

@interface infoViewController ()
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)UIScrollView * scrview;
@end

@implementation infoViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"使用说明", nil) backButton:YES];
    
    self.scrview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.scrview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:247/255.0f alpha:1.0f];
    [self.view addSubview:self.scrview];
    if ([self.status isEqualToString:@"costCenterInfo"]) {//成本中心
        [self createCostCenter:@"costCenterInfo"];
    }else if ([self.status isEqualToString:@"currency"]){//币种
        [self createProjectManagement:@"currency"];
    }else if ([self.status isEqualToString:@"costClass"]){//费用类别
        [self createCostClass:@"costClass"];
    }else if ([self.status isEqualToString:@"powerSet"]){//设置权限
        [self createPowerSet:@"powerSet"];
    }else if ([self.status isEqualToString:@"ProjectManagement"]){//项目
        [self createProjectManagement:@"ProjectManagement"];
    }else if ([self.status isEqualToString:@"editLeavelInfo"]){//设置级别
        [self createEditLeavel:@"editLeavelInfo"];
    }else if ([self.status isEqualToString:@"HRStandard"]){//住宿标准
        [self createHstandard:@"HRStandard"];
    }else if ([self.status isEqualToString:@"editPositionInfo"]){//设置职位
        [self createProjectManagement:@"editPositionInfo"];
    }else if ([self.status isEqualToString:@"borrowRecord"]){//员工借款
        [self createForHstandardView:@"borrowRecord"];
    }else if ([self.status isEqualToString:@"ForStand"]){//补贴标准
        [self createForHstandardView:@"ForStand"];
    }else if ([self.status isEqualToString:@"agent"]){//代理人设置
        [self createProjectManagement:@"agent"];
    }else if ([self.status isEqualToString:@"procurrementInfo"]){//采购类型
        [self createForHstandardView:@"procurrementInfo"];
    }else if ([self.status isEqualToString:@"payoffWayInfo"]){//支付方式
        [self createForHstandardView:@"payoffWayInfo"];
    }
//    else if ([self.status isEqualToString:@"travelType"]){
//        [self createForHstandardView:@"travelType"];
//    }
    // Do any additional setup after loading the view.
}


//设置级别
-(void)createEditLeavel:(NSString *)string {
    
    NSString * str1 = Custing(@"为什么要设置员工级别？", nil);
    NSString * str11 = Custing(@"因为费用报销中住宿标准是根据员工级别进行控制的。", nil);
    NSString * str2 = Custing(@"员工级别有区分大小吗？", nil);
    NSString * str21 = Custing(@"员工级别本身不区分大小，在设置住宿标准的时候，由用户自决定不同员工级别住宿费用多少。", nil);
    NSString * str3 = Custing(@"可以不设置员工级别么？", nil);
    NSString * str31 = Custing(@"可以，如果不需要控制住宿标准。", nil);
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size11 = [str11 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];

    CGSize size2 = [str2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size21 = [str21 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];

    CGSize size3 = [str3 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size31 = [str31 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    UIImage *editLeavel1 = [UIImage imageNamed:(lan)?@"editLeavelInfo1":@"enEditLeavelInfo1"];
    UIImage *editLeavel2 = [UIImage imageNamed:(lan)?@"editLeavelInfo2":@"enEditLeavelInfo2"];
    
    
    self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size11.height+size2.height+size21.height+size3.height+size31.height+((Main_Screen_Width-30)/editLeavel1.size.width * editLeavel1.size.height)+((Main_Screen_Width-30)/editLeavel2.size.width * editLeavel2.size.height)+3*50);
    
    //1
    UIView * agentOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 20+size1.height+size11.height+((Main_Screen_Width-30)/editLeavel1.size.width * editLeavel1.size.height))];
    agentOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:oneImage];
    
    UILabel * laOne = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laOne.numberOfLines = 0;
    laOne.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:laOne];
    
    UILabel * laOneOne = [GPUtils createLable:CGRectMake(50, 20+size1.height, WIDTH(agentOne)-65, size11.height) text:str11 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laOneOne.numberOfLines = 0;
    laOneOne.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:laOneOne];
    
    UIImageView * editLeavelInfo1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size1.height+size11.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/editLeavel1.size.width * editLeavel1.size.height))];
    editLeavelInfo1.image = GPImage((lan)?@"editLeavelInfo1":@"enEditLeavelInfo1");
    editLeavelInfo1.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:editLeavelInfo1];
    
    
    //2
    UIView * agentTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+size1.height+size11.height+((Main_Screen_Width-30)/editLeavel1.size.width * editLeavel1.size.height), Main_Screen_Width, 20+size2.height+size21.height+((Main_Screen_Width-30)/editLeavel2.size.width * editLeavel2.size.height))];
    agentTwo.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentTwo];
    
    
    UIImageView * twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    twoImage.image = GPImage(@"employTwo");
    twoImage.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoImage];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentTwo)-65, 20+size2.height) text:str2 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoLa];
    
    UILabel * twoOneLa = [GPUtils createLable:CGRectMake(50, 20+size2.height, WIDTH(agentTwo)-65, size21.height) text:str21 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    twoOneLa.numberOfLines = 0;
    twoOneLa.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoOneLa];
    
    UIImageView * editLeavelInfo2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size2.height+size21.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/editLeavel2.size.width * editLeavel2.size.height))];
    editLeavelInfo2.image = GPImage((lan)?@"editLeavelInfo2":@"enEditLeavelInfo2");
    editLeavelInfo2.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:editLeavelInfo2];
    
    //3
    UIView * agentThree = [[UIView alloc]initWithFrame:CGRectMake(0, 70+size1.height+size2.height+size11.height+size21.height+((Main_Screen_Width-30)/editLeavel1.size.width * editLeavel1.size.height)+((Main_Screen_Width-30)/editLeavel2.size.width * editLeavel2.size.height), Main_Screen_Width, 30+size3.height+size31.height)];
    agentThree.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str3]) {
        [self.scrview addSubview:agentThree];
    }
    
    UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    threeImage.image = GPImage(@"employThree");
    threeImage.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeImage];
    
    UILabel * threeLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentThree)-65, 20+size3.height) text:str3 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    threeLa.numberOfLines = 0;
    threeLa.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeLa];
    
    UILabel * laThreeOne = [GPUtils createLable:CGRectMake(50, 20+size3.height, WIDTH(agentThree)-65,size31.height) text:str31 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laThreeOne.numberOfLines = 0;
    laThreeOne.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:laThreeOne];
    
    
}


//权限管理
-(void)createPowerSet:(NSString *)string {
    
    NSString * str1 = Custing(@"如果系统管理员张三离职了，张三如何退出系统管理员角色？", nil);
    NSString * str11 = Custing(@"张三设置新的管理员李四，李四登录系统后台把张三从系统管理员角色中删除即可。", nil);
    
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size11 = [str11 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    UIImage *powerSet1 = [UIImage imageNamed:(lan)?@"powerSetInfo1":@"enPowerSet11"];
    
    self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size11.height+((Main_Screen_Width-30)/powerSet1.size.width * powerSet1.size.height)+50);
    
    //1
    UIView * agentOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 20+size1.height+size11.height+((Main_Screen_Width-30)/powerSet1.size.width * powerSet1.size.height))];
    agentOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:oneImage];
    
    UILabel * laOne = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laOne.numberOfLines = 0;
    laOne.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:laOne];
    
    UILabel * laOneOne = [GPUtils createLable:CGRectMake(50, 20+size1.height, WIDTH(agentOne)-65, size11.height) text:str11 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laOneOne.numberOfLines = 0;
    laOneOne.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:laOneOne];
    
    
    UIImageView * CostCenterInfo1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size1.height+size11.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/powerSet1.size.width * powerSet1.size.height))];
    CostCenterInfo1.image = GPImage((lan)?@"powerSetInfo1":@"enPowerSet11");
    CostCenterInfo1.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:CostCenterInfo1];
    
    
}

//费用类别
-(void)createCostClass:(NSString *)string {
    
    NSString * str1 = Custing(@"系统提供的默认费用类别，只能禁用和启用；", nil);
    NSString * str2 = Custing(@"自定义费用类别，可以修改和删除；", nil);
    NSString * str3 = Custing(@"一级费用类别必须包含二级费用类别，否则费用类别无法显示", nil);
    
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size2 = [str2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size3 = [str3 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    UIImage *CostClass1 = [UIImage imageNamed:(lan)?@"CostClassInfo1":@"enCostClassInfo1"];
    UIImage *CostClass2 = [UIImage imageNamed:(lan)?@"CostClassInfo2":@"enCostClassInfo2"];
    UIImage *CostClass21 = [UIImage imageNamed:(lan)?@"CostClassInfo3":@"enCostClassInfo3"];
    
    self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size3.height+((Main_Screen_Width-30)/CostClass1.size.width * CostClass1.size.height)+((Main_Screen_Width-30)/CostClass2.size.width * CostClass2.size.height)+((Main_Screen_Width-30)/CostClass21.size.width * CostClass21.size.height)+3*50);
    
    //1
    UIView * agentOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 20+size1.height+((Main_Screen_Width-30)/CostClass1.size.width * CostClass1.size.height))];
    agentOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:oneImage];
    
    UILabel * lookLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lookLa.numberOfLines = 0;
    lookLa.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:lookLa];
    
    UIImageView * CostCenterInfo1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size1.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/CostClass1.size.width * CostClass1.size.height))];
    CostCenterInfo1.image = GPImage((lan)?@"CostClassInfo1":@"enCostClassInfo1");
    CostCenterInfo1.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:CostCenterInfo1];
    
    //2
    UIView * agentTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+size1.height+((Main_Screen_Width-30)/CostClass1.size.width * CostClass1.size.height), Main_Screen_Width, 20+size2.height+((Main_Screen_Width-30)/CostClass2.size.width * CostClass2.size.height)+((Main_Screen_Width-30)/CostClass21.size.width * CostClass21.size.height))];
    agentTwo.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentTwo];
    
    
    UIImageView * twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    twoImage.image = GPImage(@"employTwo");
    twoImage.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoImage];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size2.height) text:str2 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoLa];
    
    UIImageView * CostCenterInfo2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size2.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/CostClass2.size.width * CostClass2.size.height))];
    CostCenterInfo2.image = GPImage((lan)?@"CostClassInfo2":@"enCostClassInfo2");
    CostCenterInfo2.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:CostCenterInfo2];
    
    UIImageView * CostCenterInfo21 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size2.height+((Main_Screen_Width-30)/CostClass2.size.width * CostClass2.size.height), Main_Screen_Width-30, ((Main_Screen_Width-30)/CostClass2.size.width * CostClass2.size.height))];
    CostCenterInfo21.image = GPImage((lan)?@"CostClassInfo3":@"enCostClassInfo3");
    CostCenterInfo21.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:CostCenterInfo21];
    
    //3
    
    UIView * agentThree = [[UIView alloc]initWithFrame:CGRectMake(0, 70+size1.height+size2.height+((Main_Screen_Width-30)/CostClass1.size.width * CostClass1.size.height)+((Main_Screen_Width-30)/CostClass2.size.width * CostClass2.size.height)+((Main_Screen_Width-30)/CostClass21.size.width * CostClass21.size.height), Main_Screen_Width, 20+size3.height)];
    agentThree.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str3]) {
        [self.scrview addSubview:agentThree];
    }
    
    UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    threeImage.image = GPImage(@"employThree");
    threeImage.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeImage];
    
    UILabel * threeLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentThree)-65, 20+size3.height) text:str3 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    threeLa.numberOfLines = 0;
    threeLa.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeLa];
    
}


//住宿标准
-(void)createHstandard:(NSString *)string {
    
    NSString * str1 = Custing(@"开启住宿标准限制，在添加消费记录时，如果员工的住宿费用超过标准，将不能添加消费", nil);
    NSString * str2 = Custing(@"住宿标准按照员工级别和城市等级控制", nil);
    
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size2 = [str2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    UIImage *HRStandard1 = [UIImage imageNamed:(lan)?@"HRStandardInfo1":@"enHRStandard11"];
    UIImage *HRStandard2 = [UIImage imageNamed:(lan)?@"HRStandardInfo2":@"enHRStandard12"];
    
    self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+((Main_Screen_Width-30)/HRStandard1.size.width * HRStandard1.size.height)+((Main_Screen_Width-30)/HRStandard2.size.width * HRStandard2.size.height)+2*50);
    
    //1
    UIView * agentOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 20+size1.height+((Main_Screen_Width-30)/HRStandard1.size.width * HRStandard1.size.height))];
    agentOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:oneImage];
    
    UILabel * lookLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lookLa.numberOfLines = 0;
    lookLa.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:lookLa];
    
    UIImageView * CostCenterInfo1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size1.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/HRStandard1.size.width * HRStandard1.size.height))];
    CostCenterInfo1.image = GPImage((lan)?@"HRStandardInfo1":@"enHRStandard11");
    CostCenterInfo1.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:CostCenterInfo1];
    
    //2
    UIView * agentTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+size1.height+((Main_Screen_Width-30)/HRStandard1.size.width * HRStandard1.size.height), Main_Screen_Width, 20+size2.height+((Main_Screen_Width-30)/HRStandard2.size.width * HRStandard2.size.height))];
    agentTwo.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentTwo];
    
    
    UIImageView * twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    twoImage.image = GPImage(@"employTwo");
    twoImage.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoImage];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size2.height) text:str2 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoLa];
    
    UIImageView * CostCenterInfo2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size2.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/HRStandard2.size.width * HRStandard2.size.height))];
    CostCenterInfo2.image = GPImage((lan)?@"HRStandardInfo2":@"enHRStandard12");
    CostCenterInfo2.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:CostCenterInfo2];
    
}


//成本中心
-(void)createCostCenter:(NSString *)string {
    
    NSString * str1 = Custing(@"在员工管理中，每个员工都可以设置一个默认成本中心；", nil);
    NSString * str2 = Custing(@"按照成本中心可以设置预算，或者按照成本中心和费用类别组合设置预算；", nil);
    NSString * str3 = Custing(@"成本中心可以按照部门设置，也可以按照项目来设置，根据企业的需要自行设置。", nil);
    NSString * str31 = Custing(@"按照部门设置如下：", nil);
    NSString * str32 = Custing(@"按照项目设置如下：", nil);
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size2 = [str2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size3 = [str3 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size31 = [str31 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size32 = [str32 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    UIImage *costCenter1 = [UIImage imageNamed:(lan)?@"CostCenterInfo1":@"enCostCenterInfo1"];
    UIImage *costCenter2 = [UIImage imageNamed:(lan)?@"CostCenterInfo2":@"enCostCenterInfo2"];
    
    
    self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size3.height+size31.height+size32.height+((Main_Screen_Width-30)/costCenter1.size.width * costCenter1.size.height)+((Main_Screen_Width-30)/costCenter2.size.width * costCenter2.size.height)+3*50);
    
    //1
    UIView * agentOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 20+size1.height)];
    agentOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:oneImage];
    
    UILabel * lookLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lookLa.numberOfLines = 0;
    lookLa.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:lookLa];
    
    //2
    UIView * agentTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+size1.height, Main_Screen_Width, 20+size2.height)];
    agentTwo.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentTwo];
    
    
    UIImageView * twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    twoImage.image = GPImage(@"employTwo");
    twoImage.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoImage];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size2.height) text:str2 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoLa];
    
    //3
    
    UIView * agentThree = [[UIView alloc]initWithFrame:CGRectMake(0, 70+size1.height+size2.height, Main_Screen_Width, 20+size3.height+size31.height+size32.height+((Main_Screen_Width-30)/costCenter1.size.width * costCenter1.size.height)+((Main_Screen_Width-30)/costCenter2.size.width * costCenter2.size.height))];
    agentThree.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str3]) {
        [self.scrview addSubview:agentThree];
    }
    
    UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    threeImage.image = GPImage(@"employThree");
    threeImage.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeImage];
    
    UILabel * threeLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentThree)-65, 20+size3.height) text:str3 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    threeLa.numberOfLines = 0;
    threeLa.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeLa];
    
    UILabel * laTwoOne = [GPUtils createLable:CGRectMake(50, 20+size3.height, WIDTH(agentThree)-65,size31.height) text:str31 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laTwoOne.numberOfLines = 0;
    laTwoOne.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:laTwoOne];
    
    UIImageView * CostCenterInfo1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size3.height+size31.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/costCenter1.size.width * costCenter1.size.height))];
    CostCenterInfo1.image = GPImage((lan)?@"CostCenterInfo1":@"enCostCenterInfo1");
    CostCenterInfo1.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:CostCenterInfo1];
    
    UILabel * laTwoTwe = [GPUtils createLable:CGRectMake(50, 20+size3.height+size31.height+((Main_Screen_Width-30)/costCenter1.size.width * costCenter1.size.height), WIDTH(agentThree)-65,size32.height) text:str32 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laTwoTwe.numberOfLines = 0;
    laTwoTwe.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:laTwoTwe];
    
    UIImageView * CostCenterInfo2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20+size3.height+size31.height+((Main_Screen_Width-30)/costCenter1.size.width * costCenter1.size.height)+size32.height, Main_Screen_Width-30, ((Main_Screen_Width-30)/costCenter2.size.width * costCenter2.size.height))];
    CostCenterInfo2.image = GPImage((lan)?@"CostCenterInfo2":@"enCostCenterInfo2");
    CostCenterInfo2.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:CostCenterInfo2];
    
}

//项目//代理人设置//币种//职位
-(void)createProjectManagement:(NSString *)string {
    
    NSString * str1;
    NSString * str11;
    NSString * str2;
    NSString * str21;
    NSString * str22;
    NSString * str23;
    NSString * str25;
    NSString * str3;
    NSString * str31;
    NSString * str5;
    if ([string isEqualToString:@"ProjectManagement"]) {
        str1 = Custing(@"如何设置表单中显示项目？", nil);
        str11 = Custing(@"在PC端“系统管理”-“审批管理”-“出差申请、差旅报销、日常报销”表单设置，勾选“项目”。", nil);
        str2 = Custing(@"如何报销项目费用？", nil);
        str21 = Custing(@"在申请“差旅报销、日常报销”时，选择需要的项目", nil);
        str22 = @"";
        str23 = @"";
        str25 = @"";
        str3 = Custing(@"如何查看项目费用？", nil);
        str31 = Custing(@"“报销分析”-“项目统计”中查看项目费用合计。", nil);
        str5 = @"";
    }else if ([string isEqualToString:@"agent"]) {
        str1 = Custing(@"什么是代理人设置?", nil);
        str11 = Custing(@"我授权给代理人，代理人只有申请权限，没有审批权限。 ", nil);
        str2 = Custing(@"代理人可以做哪些申请?", nil);
        str21 = Custing(@"预订机票、酒店、火车票； ", nil);
        str22 = Custing(@"添加消费记录； ", nil);
        str23 = Custing(@"填写差旅报销、日常报销； ", nil);
        str25 = Custing(@"填写“工作--审批中的申请”。", nil);
        str3 = @"";
        str31 = @"";
        str5 = @"";
    }else if ([string isEqualToString:@"currency"]) {
        str1 = Custing(@"如何开启币种和汇率？", nil);
        str11 = Custing(@"系统默认币种为人民币，如果使用多币种和汇率，点击“开启币种和汇率”即可。", nil);
        str2 = Custing(@"差旅报销表单如何设置币种和汇率？", nil);
        str21 = Custing(@"点击“开启币种和汇率”后，差旅报销表单设置中，币种、汇率、本位币金额选项自动勾选。", nil);
        str22 = @"";
        str23 = @"";
        str25 = @"";
        str3 = Custing(@"在什么地方使用币种和汇率？", nil);
        str31 = Custing(@"开启币种和汇率后，在添加消费记录时可以选择币种；在填写报销单申请时，可以选择币种和汇率。", nil);
        str5 = Custing(@"系统“本位币”默认为“人民币”。", nil);
    }else if ([string isEqualToString:@"editPositionInfo"]) {
        str1 = Custing(@"员工职位的定义", nil);
        str11 = Custing(@"喜报中员工职位和公司通常的职位不一样，喜报中员工职位是配合审批管理中审批人关系而设置的。", nil);
        str2 = Custing(@"如何设置员工职位？", nil);
        str21 = Custing(@"公司通常对各部门经理称呼：销售经理、采购经理、产品经理；", nil);
        str22 = Custing(@"喜报中对各部门经理称呼为：部门经理。", nil);
        str23 = @"";
        str25 = @"";
        str3 = Custing(@"如何设置审批管理中的审批人？", nil);
        str31 = Custing(@"审批人只需要选择“申请人”的“部门经理”即可。", nil);
        str5 = @"";
    }
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size11 = [str11 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size2 = [str2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size21 = [str21 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size22 = [str22 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size23 = [str23 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size25 = [str25 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size3 = [str3 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize size31 = [str31 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size5 = [str5 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    
    if ([string isEqualToString:@"ProjectManagement"]) {
        self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size3.height+size11.height+size21.height+size31.height+3*50);
    }else if ([string isEqualToString:@"agent"]) {
        self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size11.height+size21.height+size22.height+size23.height+size25.height+2*50);
    }else if ([string isEqualToString:@"currency"]) {
        self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size11.height+size21.height+size3.height+size31.height+size5.height+4*50);
    }else if ([string isEqualToString:@"editPositionInfo"]) {
        self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size3.height+size11.height+size21.height+size22.height+size31.height+3*50);
    }
    
    //1
    UIView * viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 30+size1.height+size11.height)];
    viewOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:viewOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [viewOne addSubview:oneImage];
    
    UILabel * laOne = [GPUtils createLable:CGRectMake(50, 0, WIDTH(viewOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laOne.numberOfLines = 0;
    laOne.backgroundColor = [UIColor clearColor];
    [viewOne addSubview:laOne];
    
    UILabel * laOneOne = [GPUtils createLable:CGRectMake(50, 20+size1.height, WIDTH(viewOne)-65,size11.height) text:str11 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laOneOne.numberOfLines = 0;
    laOneOne.backgroundColor = [UIColor clearColor];
    [viewOne addSubview:laOneOne];
    
    
    //2
    NSInteger twoHeight = 0;
    if ([string isEqualToString:@"ProjectManagement"]) {
        twoHeight = 0;
    }else if ([string isEqualToString:@"agent"]) {
        twoHeight = size22.height+size23.height+size25.height;
    }else if ([string isEqualToString:@"currency"]) {
        twoHeight = 0;
    }else if ([string isEqualToString:@"editPositionInfo"]) {
        twoHeight = size22.height;
    }else{
        
    }
    
    UIView * viewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 50+size1.height+size11.height, Main_Screen_Width, 30+size2.height+size21.height+twoHeight)];
    viewTwo.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:viewTwo];
    
    UIImageView * twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    twoImage.image = GPImage(@"employTwo");
    
    twoImage.backgroundColor = [UIColor clearColor];
    [viewTwo addSubview:twoImage];
    
    UILabel * laTwo = [GPUtils createLable:CGRectMake(50, 0, WIDTH(viewTwo)-65, 20+size2.height) text:str2 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laTwo.numberOfLines = 0;
    laTwo.backgroundColor = [UIColor clearColor];
    [viewTwo addSubview:laTwo];
    
    UILabel * laTwoOne = [GPUtils createLable:CGRectMake(50, 20+size2.height, WIDTH(viewTwo)-65,size21.height) text:str21 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laTwoOne.numberOfLines = 0;
    laTwoOne.backgroundColor = [UIColor clearColor];
    [viewTwo addSubview:laTwoOne];
    
    UILabel * laTwoTwe = [GPUtils createLable:CGRectMake(50, 20+size2.height+size21.height, WIDTH(viewTwo)-65,size22.height) text:str22 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laTwoTwe.numberOfLines = 0;
    laTwoTwe.backgroundColor = [UIColor clearColor];
    [viewTwo addSubview:laTwoTwe];
    
    UILabel * laTwoThree = [GPUtils createLable:CGRectMake(50, 20+size2.height+size21.height+size22.height, WIDTH(viewTwo)-65,size23.height) text:str23 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laTwoThree.numberOfLines = 0;
    laTwoThree.backgroundColor = [UIColor clearColor];
    [viewTwo addSubview:laTwoThree];
    
    UILabel * laTwoFive = [GPUtils createLable:CGRectMake(50, 20+size2.height+size21.height+size22.height+size23.height, WIDTH(viewTwo)-65,size25.height) text:str25 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laTwoFive.numberOfLines = 0;
    laTwoFive.backgroundColor = [UIColor clearColor];
    [viewTwo addSubview:laTwoFive];
    
    
    
    //3
    UIView * viewThree = [[UIView alloc]initWithFrame:CGRectMake(0, 90+size1.height+size11.height+size2.height+size21.height+twoHeight, Main_Screen_Width, 30+size3.height+size31.height)];
    viewThree.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str3]) {
        [self.scrview addSubview:viewThree];
    }
    
    
    UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    threeImage.image = GPImage(@"employThree");
    
    threeImage.backgroundColor = [UIColor clearColor];
    [viewThree addSubview:threeImage];
    
    UILabel * laThree = [GPUtils createLable:CGRectMake(50, 0, WIDTH(viewThree)-65, 20+size3.height) text:str3 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laThree.numberOfLines = 0;
    laThree.backgroundColor = [UIColor clearColor];
    [viewThree addSubview:laThree];
    
    UILabel * laThreeOne = [GPUtils createLable:CGRectMake(50, 20+size3.height, WIDTH(viewThree)-65,size31.height) text:str31 font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    laThreeOne.numberOfLines = 0;
    laThreeOne.backgroundColor = [UIColor clearColor];
    [viewThree addSubview:laThreeOne];
    
    //5
    UIView * viewFive = [[UIView alloc]initWithFrame:CGRectMake(0, 130+size1.height+size11.height+size2.height+size21.height+size3.height+size31.height, Main_Screen_Width, 20+size5.height)];
    viewFive.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str5]) {
        [self.scrview addSubview:viewFive];
    }
    
    
    UIImageView * fiveImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    fiveImage.image = GPImage(@"employFour");
    fiveImage.backgroundColor = [UIColor clearColor];
    [viewFive addSubview:fiveImage];
    
    UILabel * laFive = [GPUtils createLable:CGRectMake(50, 0, WIDTH(viewFive)-65, 20+size5.height) text:str5 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    laFive.numberOfLines = 0;
    laFive.backgroundColor = [UIColor clearColor];
    [viewFive addSubview:laFive];
}



//报销标准//员工借款//采购类型//支付方式
-(void)createForHstandardView:(NSString *)string {
    NSString * str1;
    NSString * str2;
    NSString * str3;
    NSString * str5;
    if ([string isEqualToString:@"borrowRecord"]) {
        str1 = Custing(@"员工借款记录来自“出差申请中的预支金额”；", nil);
        str2 = Custing(@"员工借款记录来自“差旅报销时冲销的金额”；", nil);
        str3 = Custing(@"员工借款记录来自“预支审批的借款金额”；", nil);
        str5 = Custing(@"财务经理或出纳有权限手工输入员工本次还款金额。", nil);
    }else if ([string isEqualToString:@"ForStand"]) {
        str1 = Custing(@"住宿标准按照员工级别和城市等级进行设置。", nil);
        str2 = Custing(@"补贴标准按照员工级别和补贴类型进行设置，补贴类型在“费用类别—补贴”下维护。", nil);
        str3 = Custing(@"住宿标准控制，在添加消费记录时，控制住宿费不能超标。", nil);
        str5 = Custing(@"补贴标准控制，在添加消费记录时，自动带出补贴金额。", nil);
    }else if ([string isEqualToString:@"procurrementInfo"]) {
        str1 = Custing(@"填写采购申请单时，需要选择“采购类型”。", nil);
        str2 = Custing(@"“报表--采购统计”中，根据采购类型汇总金额。", nil);
        str3 = @"";
        str5 = @"";
    }else if ([string isEqualToString:@"payoffWayInfo"]) {
        str1 = Custing(@"填写采购申请单时，需要选择“支付方式”。", nil);
        str2 = Custing(@"“报表--采购统计“中，根据支付方式汇总金额。", nil);
        str3 = @"";
        str5 = @"";
    }
    
    CGSize size1 = [str1 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size2 = [str2 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size3 = [str3 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size5 = [str5 sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-65, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSLog(@"1--%f,2--%f",self.view.frame.size.height,size1.height+size2.height+size3.height+size5.height+4*10);
    
    self.scrview.contentSize=CGSizeMake(self.view.frame.size.width, size1.height+size2.height+size3.height+size3.height+4*50);
    
    //1
    UIView * agentOne = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 20+size1.height)];
    agentOne.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentOne];
    
    UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    oneImage.image = GPImage(@"employOne");
    oneImage.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:oneImage];
    
    UILabel * lookLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size1.height) text:str1 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lookLa.numberOfLines = 0;
    lookLa.backgroundColor = [UIColor clearColor];
    [agentOne addSubview:lookLa];
    
    //2
    UIView * agentTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+size1.height, Main_Screen_Width, 20+size2.height)];
    agentTwo.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrview addSubview:agentTwo];
    
    
    UIImageView * twoImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    twoImage.image = GPImage(@"employTwo");
    twoImage.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoImage];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentOne)-65, 20+size2.height) text:str2 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [agentTwo addSubview:twoLa];
    
    //3
    UIView * agentThree = [[UIView alloc]initWithFrame:CGRectMake(0, 70+size1.height+size2.height, Main_Screen_Width, 20+size3.height)];
    agentThree.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str3]) {
        [self.scrview addSubview:agentThree];
    }
    
    UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    threeImage.image = GPImage(@"employThree");
    threeImage.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeImage];
    
    UILabel * threeLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentThree)-65, 20+size3.height) text:str3 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    threeLa.numberOfLines = 0;
    threeLa.backgroundColor = [UIColor clearColor];
    [agentThree addSubview:threeLa];
    
    //5
    UIView * agentFour = [[UIView alloc]initWithFrame:CGRectMake(0, 100+size1.height+size2.height+size3.height, Main_Screen_Width, 20+size5.height)];
    agentFour.backgroundColor = Color_form_TextFieldBackgroundColor;
    if ([NSString isEqualToNull:str3]) {
        [self.scrview addSubview:agentFour];
    }
    
    UIImageView * fourImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    fourImage.image = GPImage(@"employFour");
    fourImage.backgroundColor = [UIColor clearColor];
    [agentFour addSubview:fourImage];
    
    UILabel * fourLa = [GPUtils createLable:CGRectMake(50, 0, WIDTH(agentFour)-65, 20+size5.height) text:str5 font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    fourLa.numberOfLines = 0;
    fourLa.backgroundColor = [UIColor clearColor];
    [agentFour addSubview:fourLa];
    
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
