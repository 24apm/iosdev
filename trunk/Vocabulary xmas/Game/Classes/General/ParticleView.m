#import "ParticleView.h"
#import <QuartzCore/QuartzCore.h>
#import "GameConstants.h"
@interface ParticleView()

@property (nonatomic, strong) CAEmitterCell* fire;

@end

@implementation ParticleView 

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self performSelector:@selector(createParticle) withObject:nil afterDelay:0.5f];
}

- (void)createParticle {
    //set ref to the layer
    self.fireEmitter = (CAEmitterLayer*)self.layer; //2
    //configure the emitter layer
    self.fireEmitter.emitterPosition = CGPointMake(self.center.x, 0);
    self.fireEmitter.emitterSize = self.frame.size;
    self.fireEmitter.emitterShape = @"line";
    self.fireEmitter.birthRate = 1.f;
    self.fire = [CAEmitterCell emitterCell];
    self.fire.birthRate = 4.f;
    self.fire.lifetime = 30;
    self.fire.contents = (id)[[UIImage imageNamed:@"speedline"] CGImage];
    self.fire.velocity = 250 * IPAD_SCALE;
    //self.fire.velocityRange = 20 * IPAD_SCALE;
    self.fire.yAcceleration = 500 * IPAD_SCALE;
    self.fire.scale *= IPAD_SCALE;
    // self.fire.spin = 3.0;
    // self.fire.spinRange = 5.0;
    
    self.fireEmitter.renderMode = kCAEmitterLayerUnordered;
    [self.fire setName:@"fire"];
    
    //add the cell to the layer and we're done
    self.fireEmitter.emitterCells = [NSArray arrayWithObject:self.fire];
 
}

-(void)changeAndRenewFireCell {
}

- (void)showSpeedLines:(BOOL)setting {
   // [self.fireEmitter.emitterCells setValue:[NSNumber numberWithInt:birthRate]
   //            forKeyPath:@"birthRate"];
   // self.fire.birthRate = birthRate;
    self.fireEmitter.hidden = !setting;
   // self.fireEmitter.birthRate = birthRate;
    

}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

@end