#import "ParticleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ParticleView
{
    CAEmitterLayer* fireEmitter; //1
}

-(void)awakeFromNib
{
    //set ref to the layer
    fireEmitter = (CAEmitterLayer*)self.layer; //2
    //configure the emitter layer
    fireEmitter.emitterPosition = CGPointMake(self.center.x, 0);
    fireEmitter.emitterSize = self.frame.size;
    fireEmitter.emitterShape = @"line";
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 5;
    fire.lifetime = 10;
    fire.contents = (id)[[UIImage imageNamed:@"money"] CGImage];
    fire.velocity = 50;
    fire.velocityRange = 20;
    fire.yAcceleration = 20;
    
    fire.spin = 3.0;
    fire.spinRange = 5.0;

    fireEmitter.renderMode = kCAEmitterLayerUnordered;
    [fire setName:@"fire"];
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

@end