//
//  ReimPolicyView.m
//  galaxy
//
//  Created by hfk on 2017/10/24.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReimPolicyView.h"

@implementation ReimPolicyView
- (instancetype)initWithFlowCode:(NSString *)flowcode withBodydict:(NSDictionary *)bodydict withBaseViewHeight:(BaseView_Height_Block)block{
    self = [super init];
    if (self) {
        _bodydict = bodydict;
        _flowCode = flowcode;
        [self setupWithHeightBlock:block];
    }
    return self;
}

-(void)setupWithHeightBlock:(BaseView_Height_Block)block{
    
    if ([self.bodydict[@"mode"]floatValue]==0) {
        if ([NSString isEqualToNull:self.bodydict[@"body"]]) {
            CGSize size = [[NSString stringWithFormat:@"%@",self.bodydict[@"body"]] sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-24, 10000) lineBreakMode:NSLineBreakByCharWrapping];
            
            self.frame=CGRectMake(0, 0, Main_Screen_Width, size.height+25);
            
            UILabel *label=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, size.height+25) text:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.bodydict[@"body"]]]?[NSString stringWithFormat:@"%@",self.bodydict[@"body"]]:@"" font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            NSAttributedString * att1 = [[NSAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: label.font,NSBaselineOffsetAttributeName:@(-3)}];
            [label setAttributedText:att1];
            
            label.numberOfLines=0;
            [self addSubview:label];
            
            if (block) {
                block((size.height+25), self.bodydict);
            }
        }else{
            if (block) {
                block((0), nil);
            }
        }
    }else if ([self.bodydict[@"mode"]floatValue]==1){
        self.frame=CGRectMake(0, 0, Main_Screen_Width, 40);
        UILabel *label=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, 40) text:nil font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",self.bodydict[@"body"]]];
        if (array.count>0) {
            NSDictionary * dict = array[0];
            if (![dict[@"displayname"] isKindOfClass:[NSNull class]]) {
                NSString *title = dict[@"displayname"];
                label.text = title;
                NSAttributedString * att1 = [[NSAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: label.font,NSBaselineOffsetAttributeName:@(-3)}];
                [label setAttributedText:att1];
            }
        }
        [self addSubview:label];
        UIButton *btn=[GPUtils createButton:CGRectMake(0, 0, Main_Screen_Width, 40) action:@selector(click:) delegate:self];
        [self addSubview:btn];
        if (block) {
            block(40, self.bodydict);
        }
    }
}
-(void)click:(UIButton *)btn{
    if (self.clickBlock) {
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",self.bodydict[@"body"]]];
        if (array.count>0) {
            NSDictionary * dict=array[0];
            self.clickBlock([NSString stringWithFormat:@"%@",[dict objectForKey:@"filepath"]]);
        }

    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
