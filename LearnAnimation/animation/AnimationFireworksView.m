//
//  AnimationFireworksView.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "AnimationFireworksView.h"



typedef NS_ENUM(NSUInteger, LYAnimationFireworksColor) {
    LYAnimationFireworksGreen,
    LYAnimationFireworksRed,
    LYAnimationFireworksYellow,
    LYAnimationFireworksBlue,
};

@interface AnimationFireworksView()
@property (nonatomic , assign) long mCurrentFarme;

@property (nonatomic , strong) NSTimer* mAnimationTimer;
@property (nonatomic , strong) UIImageView* mImageView;
@property (nonatomic , strong) UIImageView* mHeartImageView;
@property (nonatomic , strong) NSMutableArray* mExplosionImageViewsArray;

@property (nonatomic , weak) id<AnimationCallBackDelegate> delegate;

@end

#define const_red_point_x 15.0
#define const_red_point_y 38.0
#define const_blue_point_x 68.0
#define const_blue_point_y 60.0
#define const_yellow_point_x 83.0
#define const_yellow_point_y 14.0
#define const_green_point_x 183.0
#define const_green_point_y 34.0

#define const_heart_point_x 85.0
#define const_heart_point_y 30.0

#define const_default_image_size 200.0

#define const_default_fireworks_size_rate 0.5
#define const_explosion_time 5.0
#define const_heart_time 5.0
#define const_scale_time 2.0

static NSArray<UIImage *>* gFireworksFramesArray;          //烟花帧图片
static NSArray<UIImage *>* gHeartFramesArray;              //心形帧图片
static NSArray<UIImage *>* gExplosionFramesArray;          //爆炸帧图片

@implementation AnimationFireworksView

+ (void)load {
    
}

+ (void)initialize {
    
    
    // 1
    NSMutableArray* imagesArr = [NSMutableArray array];
    UIImage* sourceImage = [UIImage imageNamed:@"gift_fireworks_1"];
    CGSize sourceSize = sourceImage.size;
    long imagesNum = 10;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        [imagesArr addObject:tmp];
    }
    gFireworksFramesArray = imagesArr;
    
    
    // 2
    imagesArr = [NSMutableArray array];
    sourceImage = [UIImage imageNamed:@"gift_fireworks_2"];
    sourceSize = sourceImage.size;
    imagesNum = 4;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        [imagesArr addObject:tmp];
    }
    gExplosionFramesArray = imagesArr;
    
    // 3
    imagesArr = [NSMutableArray array];
    sourceImage = [UIImage imageNamed:@"gift_heart"];
    sourceSize = sourceImage.size;
    imagesNum = 22;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        [imagesArr addObject:tmp];
    }
    gHeartFramesArray = imagesArr;
    
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
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

- (void) customInit {
    self.mCurrentFarme = 0;
    
    if (self.mImageView) {
        [self.mImageView removeFromSuperview];
    }
    self.mImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mImageView];
    //    self.backgroundColor = [UIColor grayColor];
    
    self.mExplosionImageViewsArray = [NSMutableArray array];
}

- (void)setFrameWithContainer:(id)containerView {
    UIView* view = (UIView *)containerView;
    self.frame = CGRectMake(0, 0, const_default_image_size, const_default_image_size);
    [view addSubview:self];
    [self customInit];
}

- (void)startAnimationWithDelegate:(id<AnimationCallBackDelegate>)delegate {
    self.mAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(onPlayNext) userInfo:nil repeats:YES];
    self.mCurrentFarme = 0;
    self.delegate = delegate;
}

- (void)onPlayNext {
    if (self.mCurrentFarme >= gFireworksFramesArray.count) { //爆炸
        [self.mAnimationTimer invalidate];
        self.mAnimationTimer = nil;
        [self playColorFireworksWithCenter:[self getCenterPointByColor:LYAnimationFireworksRed] color:LYAnimationFireworksRed];
        [self playColorFireworksWithCenter:[self getCenterPointByColor:LYAnimationFireworksYellow] color:LYAnimationFireworksYellow];
        [self playColorFireworksWithCenter:[self getCenterPointByColor:LYAnimationFireworksGreen] color:LYAnimationFireworksGreen];
        [self playColorFireworksWithCenter:[self getCenterPointByColor:LYAnimationFireworksBlue] color:LYAnimationFireworksBlue];
        
        ESWeakSelf
        // 播放心形❤️
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(const_explosion_time * 0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf
            [self playHeart];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((const_explosion_time * 0.2 + const_heart_time) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf
            [self playHeart];
            
        });
        
        // 回收烟花
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(const_explosion_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf
            [UIView animateWithDuration:1.0 animations:^{
                ESStrongSelf
                for (UIImageView* imageView in self.mExplosionImageViewsArray) {
                    imageView.alpha = 0;
                }
                self.mImageView.alpha = 0;
            } completion:^(BOOL finished) {
                ESStrongSelf
                for (UIImageView* imageView in self.mExplosionImageViewsArray) {
                    [imageView setImage:nil];
                    [imageView removeFromSuperview];
                }
                [self.mImageView setImage:nil];
                
            }];
        });
        
        // 结束
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((const_explosion_time + const_heart_time * 2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf
            
            [self removeFromSuperview];
            [self.delegate onAnimationEndWithView:self];
        });
        
        return ;
    }
    
    [self.mImageView setImage:[gFireworksFramesArray objectAtIndex:self.mCurrentFarme]];
    ++self.mCurrentFarme;
}

- (CGPoint)getCenterPointByColor:(LYAnimationFireworksColor)color {
    long width = self.bounds.size.width;
    long height = self.bounds.size.height;
    CGPoint ret = CGPointZero;
    switch (color) {
        case LYAnimationFireworksRed:{
            ret.x = width * const_red_point_x / const_default_image_size;
            ret.y = height * const_red_point_y / const_default_image_size;
            break;
        }
            
        case LYAnimationFireworksBlue:{
            ret.x = width * const_blue_point_x / const_default_image_size;
            ret.y = height * const_blue_point_y / const_default_image_size;
            break;
        }
            
        case LYAnimationFireworksGreen:{
            ret.x = width * const_green_point_x / const_default_image_size;
            ret.y = height * const_green_point_y / const_default_image_size;
            break;
        }
            
        case LYAnimationFireworksYellow:{
            ret.x = width * const_yellow_point_x / const_default_image_size;
            ret.y = height * const_yellow_point_y / const_default_image_size;
            break;
        }
            
        default:
            break;
    }
    return ret;
}

- (void)playHeart {
    self.mHeartImageView = [[UIImageView alloc] initWithFrame:
                            CGRectMake(self.bounds.size.width * const_default_fireworks_size_rate / 2,
                                       -self.bounds.size.height * const_default_fireworks_size_rate / 2,
                                       self.bounds.size.width * const_default_fireworks_size_rate,
                                       self.bounds.size.height * const_default_fireworks_size_rate)];
    [self addSubview:self.mHeartImageView];
    
    self.mAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(onPlayNextHeart) userInfo:nil repeats:YES];
    self.mCurrentFarme = 0;
}

- (void)onPlayNextHeart {
    if (self.mCurrentFarme >= gHeartFramesArray.count - 2) {
        [self.mAnimationTimer invalidate];
        self.mAnimationTimer = nil;
        ESWeakSelf
        [UIView animateWithDuration:const_scale_time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            ESStrongSelf
            self.mHeartImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(self.mHeartImageView.bounds), 10, CGRectGetWidth(self.mHeartImageView.bounds), CGRectGetHeight(self.mHeartImageView.bounds))];
            //            [imageView setBackgroundColor:[UIColor yellowColor]];
            [self addSubview:imageView];
            [imageView setImage:gHeartFramesArray[gHeartFramesArray.count - 2]];
            
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            UIBezierPath* path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(-CGRectGetWidth(imageView.bounds) / 2, 30)];
            [path addCurveToPoint:CGPointMake(CGRectGetWidth(self.bounds) * 3 / 2, 20) controlPoint1:CGPointMake(100, 15) controlPoint2:CGPointMake(150, 15)];
            // 测试曲线用
            //            UIGraphicsBeginImageContext(self.bounds.size);
            //            [path stroke];
            //            UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
            //            UIImageView* testView = [[UIImageView alloc] initWithFrame:self.bounds];
            //            [testView setImage:image];
            //            [self addSubview:testView];
            //            UIGraphicsEndImageContext();
            
            animation.path = path.CGPath;
            animation.fillMode              = kCAFillModeForwards;
            animation.removedOnCompletion   = NO;
            animation.duration              = 1.0;
            animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            animation.delegate              = self;
            [animation setValue:@"heartArrowFly" forKey:@"id"];
            [animation setValue:imageView forKey:@"object"];
            [imageView.layer addAnimation:animation forKey:@"position"];
        }];
    }
    else {
        [self.mHeartImageView setImage:gHeartFramesArray[self.mCurrentFarme]];
        ++self.mCurrentFarme;
    }
}



- (void)playColorFireworksWithCenter:(CGPoint)centerPoint color:(LYAnimationFireworksColor)color{
    UIImageView* mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * const_default_fireworks_size_rate, self.bounds.size.height * const_default_fireworks_size_rate)];
    mImageView.layer.position = centerPoint;
    [mImageView setImage:[gExplosionFramesArray objectAtIndex:color]];
    [self addSubview:mImageView];
    //    mImageView.backgroundColor = [UIColor clearColor];
    CAShapeLayer* circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor clearColor].CGColor;//这个必须透明，因为这样内圆才是不透明的
    circleLayer.strokeColor = [UIColor yellowColor].CGColor;//注意这个不能透明，因为实际上是这个显示出后面的图片了
    circleLayer.path = [self pathWithDiameter:1 uiview:mImageView].CGPath;
    mImageView.layer.mask = circleLayer;
    
    //让圆的变大的动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    UIBezierPath *toPath = [self pathWithDiameter: sqrt(CGRectGetWidth(mImageView.bounds)*CGRectGetWidth(mImageView.bounds) + CGRectGetHeight(mImageView.bounds) *CGRectGetHeight(mImageView.bounds)) uiview:mImageView];
    pathAnimation.toValue = (id)toPath.CGPath;
    pathAnimation.duration = 1.0;
    
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.toValue = @(sqrt(CGRectGetWidth(mImageView.bounds)*CGRectGetWidth(mImageView.bounds) + CGRectGetHeight(mImageView.bounds) *CGRectGetHeight(mImageView.bounds)));
    lineWidthAnimation.duration = 1.0;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[pathAnimation, lineWidthAnimation];
    group.duration = 1.0;
    group.removedOnCompletion = NO;//这两句的效果是让动画结束后不会回到原处，必须加
    group.fillMode = kCAFillModeForwards;//这两句的效果是让动画结束后不会回到原处，必须加
    [circleLayer addAnimation:group forKey:@"revealAnimation"];
    
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = @(1.3);
    scaleAnimation.duration = const_explosion_time;
    
    CABasicAnimation *fallAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    fallAnimation.toValue = @(mImageView.layer.position.y + 2);
    fallAnimation.duration = const_explosion_time;
    
    
    CAAnimationGroup *colorImageGroup = [CAAnimationGroup animation];
    colorImageGroup.animations = @[scaleAnimation, fallAnimation];
    colorImageGroup.duration = const_explosion_time;
    colorImageGroup.removedOnCompletion = NO;
    colorImageGroup.fillMode = kCAFillModeForwards;
    [mImageView.layer addAnimation:colorImageGroup forKey:@"imageAnimation"];
    
    [self.mExplosionImageViewsArray addObject:mImageView];
}


/**
 *  根据直径生成圆的path，圆点是中心点
 */
- (UIBezierPath *)pathWithDiameter:(CGFloat)diameter uiview:(UIView *)uiview {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(uiview.bounds) - diameter) / 2, (CGRectGetHeight(uiview.bounds) - diameter) / 2, diameter, diameter)];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString* identifer = [anim valueForKey:@"id"];
    if ([identifer isEqualToString:@"heartArrowFly"]) {
        UIImageView* imageView = [anim valueForKey:@"object"];
        
        ESWeakSelf
        [UIView animateWithDuration:1.0 animations:^{
            ESStrongSelf
            self.mHeartImageView.alpha = 0;
        } completion:^(BOOL finished) {
            ESStrongSelf
            self.mHeartImageView.image = nil;
            self.mHeartImageView.alpha = 1;
        }];
        
        [imageView setImage:nil];
    }
}
@end
