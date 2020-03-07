//
//  IndustryOnController.h
//  galaxy
//
//  Created by 赵碚 on 15/12/23.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "RootViewController.h"
@protocol companyIndustryDelegate <NSObject>
@optional
- (void)companyIndustryClickedLoadBtn:(NSDictionary *)dic type:(NSString *)type;
@end

@interface IndustryOnController : RootViewController
@property(nonatomic,strong)NSDictionary * cuanDic;
@property(nonatomic,strong)NSString * dataStr;
-(id)initWithType:(NSString *)type;

@property (nonatomic, weak) id<companyIndustryDelegate> delegate;
@end
