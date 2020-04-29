//
//  ViewController.m
//  MSRocketGiftAnimation
//
//  Created by J on 2016/2/11.
//  Copyright © 2016年 J. All rights reserved.
//

#import "ViewController.h"
#import "MSCostlyGiftRocketAnimationView.h"
#import "MSCostlyGiftItemView.h"
@interface ViewController ()
@property(nonatomic,strong)MSCostlyGiftRocketAnimationView* gifView ;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.gifView performAnimationForGift:nil trayView:nil completion:^(MSCostlyGiftItemView *itemView) {
        
    }];
}


- (void)viewDidLoad{
    [self addImageView];
}




- (void)addImageView{
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"backGroud"];
}

#pragma mark --lazy
-(MSCostlyGiftRocketAnimationView *)gifView{
    if(!_gifView){
        CGSize size = [UIScreen mainScreen].bounds.size;
        MSCostlyGiftRocketAnimationView* view = [[MSCostlyGiftRocketAnimationView alloc] initWithFrame:CGRectMake((size.width-100)*0.5, size.height - 190 - 20, 100, 190)];
        self.gifView = view;
        [self.view addSubview:view];
    }
    return _gifView;
}

@end
