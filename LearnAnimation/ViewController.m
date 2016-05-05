//
//  ViewController.m
//  LearnAnimation
//
//  Created by 林伟池 on 16/5/4.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"
#import "AnimationFireworksView.h"
#import "AnimationBoatView.h"
#import "AnimationManager.h"

@interface ViewController ()

@property (nonatomic , strong) IBOutlet UIImageView* myImageView;
@property (nonatomic , strong) IBOutlet UIImageView* mBounceImageView;

@property (nonatomic , strong) IBOutlet AnimationBoatView* mAnimationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.mAnimationFireworksView = [[AnimationFireworksView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [self.view addSubview:self.mAnimationFireworksView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)onUIViewAnimation:(id)sender {
    
    NSMutableArray* imagesArr = [NSMutableArray array];
    UIImage* sourceImage = [UIImage imageNamed:@"gift_fireworks_1"];
    CGSize sourceSize = sourceImage.size;
    long imagesNum = 10;
    for (int i = 0; i < imagesNum; ++i) {
        CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
        UIImage* tmp = [UIImage imageWithCGImage:cgimage];
        [imagesArr addObject:tmp];
    }
    UIImage* image = [UIImage animatedImageWithImages:imagesArr duration:1.1];
    
    [self.myImageView setImage:image];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.myImageView setImage:[imagesArr lastObject]];
        
        
        self.mBounceImageView.backgroundColor = [UIColor clearColor];
        CAShapeLayer* circleLayer = [CAShapeLayer layer];
        circleLayer.fillColor = [UIColor clearColor].CGColor;//这个必须透明，因为这样内圆才是不透明的
        circleLayer.strokeColor = [UIColor yellowColor].CGColor;//注意这个不能透明，因为实际上是这个显示出后面的图片了
        circleLayer.path = [self pathWithDiameter:10 uiview:self.mBounceImageView].CGPath;
        self.mBounceImageView.layer.mask = circleLayer;
        
        //让圆的变大的动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        UIBezierPath *toPath = [self pathWithDiameter: sqrt(CGRectGetWidth(self.mBounceImageView.bounds)*CGRectGetWidth(self.mBounceImageView.bounds) + CGRectGetHeight(self.mBounceImageView.bounds) *CGRectGetHeight(self.mBounceImageView.bounds)) uiview:self.mBounceImageView];
        pathAnimation.toValue = (id)toPath.CGPath;
        pathAnimation.duration = 1.0;
        
        
        CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        lineWidthAnimation.toValue = @(sqrt(CGRectGetWidth(self.mBounceImageView.bounds)*CGRectGetWidth(self.mBounceImageView.bounds) + CGRectGetHeight(self.mBounceImageView.bounds) *CGRectGetHeight(self.mBounceImageView.bounds)));
        lineWidthAnimation.duration = 1.0;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[pathAnimation, lineWidthAnimation];
        group.duration = 1.0;
        group.removedOnCompletion = NO;//这两句的效果是让动画结束后不会回到原处，必须加
        group.fillMode = kCAFillModeForwards;//这两句的效果是让动画结束后不会回到原处，必须加
        
        
        [circleLayer addAnimation:group forKey:@"revealAnimation"];

        NSMutableArray* imagesArr = [NSMutableArray array];
        UIImage* sourceImage = [UIImage imageNamed:@"gift_fireworks_2"];
        CGSize sourceSize = sourceImage.size;
        long imagesNum = 4;
        for (int i = 0; i < imagesNum; ++i) {
            CGImageRef cgimage = CGImageCreateWithImageInRect(sourceImage.CGImage, CGRectMake(i * sourceSize.width / imagesNum, 0, sourceSize.width / imagesNum, sourceSize.height));
            UIImage* tmp = [UIImage imageWithCGImage:cgimage];
            [imagesArr addObject:tmp];
        }
        
        UIImage* image = [UIImage animatedImageWithImages:imagesArr duration:1.0];
        
        [self.mBounceImageView setImage:image];
        
        self.mBounceImageView.alpha = 0.5;
        [UIView animateWithDuration:1.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.mBounceImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
            [self.mBounceImageView setImage:nil];
            NSLog(@"2complete");
        }];
        
    });
}


- (IBAction)onKeyFrameAnimation:(id)sender {
//    [[AnimationManager instance] startAnimationWithView:self.mAnimationView Type:LYAnimationBoat];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 200, CGRectGetWidth(self.view.bounds), 200)];
    [self.view addSubview:view];
    [[AnimationManager instance] startAnimationWithView:view Type:LYAnimationBoat];
}



/**
 *  根据直径生成圆的path，注意圆点是self的中心点，所以（x，y）不是（0，0）
 */
- (UIBezierPath *)pathWithDiameter:(CGFloat)diameter uiview:(UIView *)uiview {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(uiview.bounds) - diameter) / 2, (CGRectGetHeight(uiview.bounds) - diameter) / 2, diameter, diameter)];
}

@end
