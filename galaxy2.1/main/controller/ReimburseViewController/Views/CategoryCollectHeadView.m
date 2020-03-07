//
//  CategoryCollectHeadView.m
//  galaxy
//
//  Created by hfk on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CategoryCollectHeadView.h"

@implementation CategoryCollectHeadView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor=Color_White_Same_20;
        _travelBtn=[GPUtils createButton:CGRectMake(0, 0, 60, 22) action:nil delegate:nil];
        _travelBtn.center=CGPointMake(Main_Screen_Width/4, 22);
        
        [_travelBtn setImage:[UIImage imageNamed:Custing(@"Add_TravelUnSelect",nil)] forState:UIControlStateNormal];
//        _travelBtn.backgroundColor=[UIColor redColor];
        [self addSubview:_travelBtn];
        
        _dailyBtn=[GPUtils createButton:CGRectMake(0,0, 60, 22) action:nil delegate:nil];
        _dailyBtn.center=CGPointMake(Main_Screen_Width/4*3, 22);
        [_dailyBtn setImage:[UIImage imageNamed:Custing(@"Add_DailySelect",nil)] forState:UIControlStateNormal];
//        _dailyBtn.backgroundColor=[UIColor redColor];
        [self addSubview:_dailyBtn];
    }
    return self;
}
- (void)configHeadViewWith:(NSString *)selectStr{
    if ([selectStr isEqualToString:@"1"]) {
        [_travelBtn setImage:[UIImage imageNamed:Custing(@"Add_TravelSelect",nil)] forState:UIControlStateNormal];
        [_dailyBtn setImage:[UIImage imageNamed:Custing(@"Add_DailyUnSelect",nil)] forState:UIControlStateNormal];
    }else if ([selectStr isEqualToString:@"2"]){
        [_travelBtn setImage:[UIImage imageNamed:Custing(@"Add_TravelUnSelect",nil)] forState:UIControlStateNormal];
        [_dailyBtn setImage:[UIImage imageNamed:Custing(@"Add_DailySelect",nil)] forState:UIControlStateNormal];
    }

}
@end
