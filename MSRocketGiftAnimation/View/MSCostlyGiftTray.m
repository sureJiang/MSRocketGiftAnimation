//
//  MSCostlyGiftTray.m
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import "MSCostlyGiftTray.h"

#if !__has_feature(objc_arc)
#error MSCostlyGiftTray must be built with ARC.
#endif

@interface MSCostlyGiftTray ()

@property (strong, nonatomic) IBOutlet UIView *giftIconView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic, readwrite) UIButton *buttonAvatar;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *redBackgroundView;

@property (nonatomic,strong) UIImageView *highlightedBackgroundView;

@property (nonatomic) BOOL performingBreathingAnimation;

@property (nonatomic,strong) UILabel *comboLabel;

@end

@implementation MSCostlyGiftTray

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 180, 40);
        
        self.backgroundView = [[UIImageView alloc] init];
        self.backgroundView.frame = self.bounds;
        self.backgroundView.image = [UIImage imageNamed:@"live_ani_gift_board_3"];
        [self addSubview:self.backgroundView];
        
        self.redBackgroundView = [[UIImageView alloc] init];
        self.redBackgroundView.frame = self.bounds;
        self.redBackgroundView.image = [UIImage imageNamed:@"live_ani_gift_board_red"];
        self.redBackgroundView.alpha = 0;
        [self addSubview:self.redBackgroundView];
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.frame = CGRectMake(1, 1, 38, 38);
        [self addSubview:self.avatarImageView];
        
        UIView *viewOfLabels = [[UIView alloc] init];
        viewOfLabels.frame = CGRectMake(43, 3, 83, 34);
        viewOfLabels.backgroundColor = [UIColor clearColor];
        [self addSubview:viewOfLabels];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxX(self.avatarImageView.frame) + 4, 83, 19);
        self.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:12];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.frame = CGRectMake(0, CGRectGetMaxX(self.titleLabel.frame), 105, 13);
        self.detailLabel.textColor = [UIColor lightTextColor];
        self.detailLabel.layer.opacity = 0.6;
        self.detailLabel.font = [UIFont systemFontOfSize:11];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        [viewOfLabels addSubview:self.detailLabel];
        
        self.giftIconView = [[UIView alloc] init];
        self.giftIconView.frame = CGRectMake(126, -6, 52, 52);
        [self addSubview:self.giftIconView];
        
        self.buttonAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonAvatar.frame = CGRectMake(0, 0, 180, 40);
        [self.buttonAvatar addTarget:self action:@selector(avatarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonAvatar];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.redBackgroundView.alpha = 0;
}

- (IBAction)avatarButtonTapped:(id)sender {
    if (self.avatarImageViewTappedHandler) {
        self.avatarImageViewTappedHandler();
    }
}

- (void)performLightEffectAnimationWithAnimationImages:(NSArray <UIImage *> *)images {
    if (images.count > 0) {
        UIView *container = [[UIView alloc] initWithFrame:self.bounds];
        container.userInteractionEnabled = NO;
        container.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
        container.layer.masksToBounds = YES;
        [self insertSubview:container aboveSubview:self.redBackgroundView];
        
        UIImageView *lightView = [[UIImageView alloc] initWithFrame:container.bounds];
        lightView.animationImages = images;
        [container addSubview:lightView];
        [lightView startAnimating];
    }
}

- (void)showComboWithCount:(NSInteger)comboCount style:(MSCostlyGiftComboStyle)style {
    [self.comboLabel removeFromSuperview];
    if (comboCount > 0) {
        UILabel *comboLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        comboLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"×%@",@(comboCount)] attributes:MSCostlyGiftComboTextAttributesForComboStyle(style)];
        [comboLabel sizeToFit];
        comboLabel.frame = CGRectMake(CGRectGetMaxX(self.bounds) + 8, 0, CGRectGetWidth(comboLabel.frame), CGRectGetHeight(self.bounds));
        [self addSubview:comboLabel];
        self.comboLabel = comboLabel;
        
        comboLabel.layer.transform = CATransform3DMakeScale(3.0, 3.0, 1.0);
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             comboLabel.layer.transform = CATransform3DIdentity;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)performBreathingAnimation {
    if (self.performingBreathingAnimation) {
        return;
    }
    self.performingBreathingAnimation = YES;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.2
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         weakSelf.redBackgroundView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              weakSelf.redBackgroundView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              weakSelf.performingBreathingAnimation = NO;
                                              [weakSelf performBreathingAnimation];
                                          }];
                     }];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundView.image = backgroundImage;
}

- (void)setBreathingBackgroundImage:(UIImage *)breathingBackgroundImage {
    _breathingBackgroundImage = breathingBackgroundImage;
    self.redBackgroundView.image = breathingBackgroundImage;
}

- (void)performHighlightAnimation {
    UIImageView *hightlightedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_ani_gift_board_highlight"]];
    hightlightedBackgroundView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    hightlightedBackgroundView.alpha = 0;
    [self insertSubview:hightlightedBackgroundView aboveSubview:self.redBackgroundView];
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         hightlightedBackgroundView.alpha = 1;
                     } completion:^(BOOL finished) {
                         self.redBackgroundView.alpha = 1;
                         [self performBreathingAnimation];
                         [UIView animateWithDuration:1.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              hightlightedBackgroundView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [hightlightedBackgroundView removeFromSuperview];
                                          }];
                     }];
}

- (void)performComboSpecialEffectAnimation {
    //
}

@end
