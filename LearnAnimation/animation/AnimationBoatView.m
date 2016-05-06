//
//  AnimationBoatView.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/5.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AnimationBoatView.h"

@interface AnimationBoatView ()
@property (nonatomic , strong) UIImageView* mWaveLeftImageView;
@property (nonatomic , strong) UIImageView* mWaveRightImageView;
@property (nonatomic , strong) UIScrollView* mScrollView;

@property (nonatomic , strong) UIView* mBoatView;
@property (nonatomic , strong) UIImageView* mBoatImageView;
@property (nonatomic , strong) UIImageView* mShadowImageView;

@property (nonatomic , readonly) float mBoatHeight;
@property (nonatomic , readonly) float mBoatWidth;
@property (nonatomic , readonly) float mBoatHeightOffset;


@property (nonatomic , weak) id<AnimationCallBackDelegate> delegate;
@end




@implementation AnimationBoatView

static UIImage* gWaveFrameImage;
static UIImage* gBoatFrameImage;
static UIImage* gShadowFrameImage;

#define const_position_boat_x 1538
#define const_position_boat_width 622
#define const_shadow_height_rate 0.7
#define const_boat_height 380

+ (void)initialize {
    UIImage* sourceImage = [UIImage imageNamed:@"gift_boat"];
    CGSize sourceSize = sourceImage.size;
    CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                                      CGRectMake(0, 0, const_position_boat_x, sourceSize.height));
    gWaveFrameImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    
    cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                           CGRectMake(const_position_boat_x, 0, const_position_boat_width, sourceSize.height));
    gBoatFrameImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    
    cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage,
                                           CGRectMake(const_position_boat_x + const_position_boat_width, 0, sourceSize.width - const_position_boat_x - const_position_boat_width, sourceSize.height));
    gShadowFrameImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
}

- (void)dealloc {
//    NSLog(@"dealloc %@", self);
}

- (instancetype)init {
    self = [super init];
    [self customInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self customInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self customInit];
    return self;
}

- (void)customInit {
    if (self.mScrollView) {
        [self.mScrollView removeFromSuperview];
    }
    self.mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mScrollView];
    
    if (self.mWaveLeftImageView) {
        [self.mWaveLeftImageView removeFromSuperview];
    }
    self.mWaveLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.mScrollView addSubview:self.mWaveLeftImageView];
    
    if (self.mWaveRightImageView) {
        [self.mWaveRightImageView removeFromSuperview];
    }
    self.mWaveRightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.mScrollView addSubview:self.mWaveRightImageView];
    
    if (self.mBoatView) {
        [self.mBoatView removeFromSuperview];
    }
    self.mBoatView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, self.mBoatWidth, CGRectGetHeight(self.bounds))];
    [self addSubview:self.mBoatView];
    
    
    if (self.mBoatImageView) {
        [self.mBoatImageView removeFromSuperview];
    }
    self.mBoatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mBoatView.bounds), CGRectGetHeight(self.bounds))];
    [self.mBoatView addSubview:self.mBoatImageView];
    
    
    if (self.mShadowImageView) {
        [self.mShadowImageView removeFromSuperview];
    }
    self.mShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.mBoatImageView.bounds) * const_shadow_height_rate, CGRectGetWidth(self.mBoatImageView.bounds), CGRectGetHeight(self.mBoatImageView.bounds))];
    [self.mBoatView addSubview:self.mShadowImageView];
//    NSLog(@"boat width%f", self.mBoatWidth);
}

- (float)mBoatWidth {
    return const_position_boat_width / 3;
}

- (float)mBoatHeight {
    return const_boat_height / 3;//[UIScreen mainScreen].scale;
}

- (float)mBoatHeightOffset {
    return const_boat_height / 3;//[UIScreen mainScreen].scale;
}

- (void)setFrameWithContainer:(id)containerView {
    UIView* view = (UIView *)containerView;
    self.frame = CGRectMake(0, CGRectGetHeight(view.bounds) - self.mBoatHeight, CGRectGetWidth(view.bounds), self.mBoatHeight);
    [view addSubview:self];
    [self customInit];
    
}

- (void)startAnimationWithDelegate:(id<AnimationCallBackDelegate>)delegate {
    self.delegate = delegate;
    [self play];
}

- (void)play {
    [self.mWaveLeftImageView setImage:gWaveFrameImage];
    [self.mWaveLeftImageView sizeToFit];
    [self.mWaveRightImageView setImage:gWaveFrameImage];
    [self.mWaveRightImageView sizeToFit];
    
    CGRect frame = self.mWaveLeftImageView.frame;
    frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
    [self.mWaveRightImageView setFrame:frame];
    
    //boat
    [self.mBoatImageView setImage:gBoatFrameImage];
    [self.mShadowImageView setImage:gShadowFrameImage];
    
    [self.mBoatView setFrame:CGRectMake(-self.mBoatWidth, -self.mBoatHeightOffset, CGRectGetWidth(self.mBoatView.bounds), CGRectGetHeight(self.mBoatView.bounds))];
    
//    NSLog(@"self %@", [self description]);
//    NSLog(@"%f %f", self.mBoatWidth, self..mBoatHeightOffset);
    
    ESWeakSelf
    [UIView animateWithDuration:11.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        ESStrongSelf
        CGRect frame = self.mWaveLeftImageView.frame;
        frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
        [self.mWaveLeftImageView setFrame:frame];
        
        frame.origin.x = 0;
        [self.mWaveRightImageView setFrame:frame];
        
    } completion:^(BOOL finished) {
        ESStrongSelf
        CGRect frame = self.mWaveLeftImageView.frame;
        frame.origin.x = 0;
        [self.mWaveLeftImageView setFrame:frame];
        
        frame.origin.x = self.mScrollView.frame.size.width - frame.size.width;
        [self.mWaveRightImageView setFrame:frame];
    }];
    
    self.mBoatView.transform = CGAffineTransformMakeScale(0.5, 0.5);

    [UIView animateWithDuration:2.0 animations:^{
        ESStrongSelf
        self.mBoatView.transform = CGAffineTransformIdentity;

        self.mBoatView.center = CGPointMake(self.mBoatWidth / 4, self.mBoatHeight / 4);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:4.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            ESStrongSelf
            CGRect frame;
            // boat
            frame = self.mBoatView.frame;
            frame.origin.x = CGRectGetWidth(self.bounds);
            frame.origin.y = CGRectGetHeight(self.mBoatImageView.bounds);
            [self.mBoatView setFrame:frame];
        } completion:^(BOOL finished) {
            ESStrongSelf
            self.mBoatView.layer.transform =
            CATransform3DRotate(
                                CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f), - M_PI / 18, 0.0f, 0.0f, 1.0f);
            
            [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                ESStrongSelf
                CGRect frame;
                frame = self.mBoatView.frame;
                frame.origin = CGPointMake(-CGRectGetWidth(self.mBoatView.bounds), -self.mBoatHeightOffset);
                [self.mBoatView setFrame:frame];
            } completion:^(BOOL finished) {
                ESStrongSelf
                self.mBoatView.layer.transform = CATransform3DIdentity;
                [UIView animateWithDuration:1.0 animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    [self.delegate onAnimationEndWithView:self];
                }];
            }];
        }];

    }];
    
}


@end
