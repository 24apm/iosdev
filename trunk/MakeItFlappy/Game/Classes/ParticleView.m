#import "ParticleView.h"
#import <QuartzCore/QuartzCore.h>
#import "GameConstants.h"
@interface ParticleView()

@property (nonatomic, strong) CAEmitterCell* fire;

@end

@implementation ParticleView 

- (void)awakeFromNib
{
    //set ref to the layer
    self.fireEmitter = (CAEmitterLayer*)self.layer; //2
    //configure the emitter layer
    self.fireEmitter.emitterPosition = CGPointMake(self.center.x, 0);
    self.fireEmitter.emitterSize = self.frame.size;
    self.fireEmitter.emitterShape = @"line";
    self.fireEmitter.birthRate = 1.f;
    self.fire = [CAEmitterCell emitterCell];
    self.fire.birthRate = 5;
    self.fire.lifetime = 12;
    self.fire.contents = (id)[[UIImage imageNamed:@"money"] CGImage];
    self.fire.velocity = 50 * IPAD_SCALE;
    self.fire.velocityRange = 20 * IPAD_SCALE;
    self.fire.yAcceleration = 20 * IPAD_SCALE;
    self.fire.scale *= IPAD_SCALE;
    self.fire.spin = 3.0;
    self.fire.spinRange = 5.0;

    self.fireEmitter.renderMode = kCAEmitterLayerUnordered;
    [self.fire setName:@"fire"];

    //add the cell to the layer and we're done
    self.fireEmitter.emitterCells = [NSArray arrayWithObject:self.fire];

}

-(void)changeAndRenewFireCell {
}

- (void)updateBirthRate:(int)birthRate {
    self.fireEmitter.birthRate = birthRate;
    self.fireEmitter.emitterCells = [NSArray arrayWithObject:self.fire];

}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

@end