//
//  CAEmitterHelperLayer.m
//  BaseLibrary
//
//  Created by MacCoder on 10/3/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "CAEmitterHelperLayer.h"

@interface CAEmitterHelperLayer()

@property (nonatomic) CGFloat cellBirthRate;

@end

@implementation CAEmitterHelperLayer

+ (CAEmitterHelperLayer *)emitter:(NSString *)json onView:(UIView *)view {
    CAEmitterHelperLayer *emitterLayer = [[CAEmitterHelperLayer alloc] init];
    [view.layer addSublayer:emitterLayer];
    [emitterLayer setupWithJson:json];
    emitterLayer.position = CGPointMake(emitterLayer.superlayer.bounds.size.width / 2,
                                              emitterLayer.superlayer.bounds.size.height / 2);
    return emitterLayer;
}

- (void)setupWithJson:(NSString *)json {
    NSString* path = [[NSBundle mainBundle] pathForResource:json
                                                     ofType:nil];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.scale = [[dictionary objectForKey:@"scale"] floatValue];
    self.velocity = [[dictionary objectForKey:@"velocity"] floatValue];
    self.birthRate = [[dictionary objectForKey:@"birthRate"] floatValue];
    self.lifetime = [[dictionary objectForKey:@"lifetime"] floatValue];
    self.lifeSpan = [[dictionary objectForKey:@"lifeSpan"] floatValue];
    self.renderMode = [dictionary objectForKey:@"renderMode"];
    self.emitterShape = [dictionary objectForKey:@"emitterShape"];
    self.emitterSize = self.superlayer.bounds.size;
    NSArray *emitterCells = [dictionary objectForKey:@"emitterCells"];
    NSDictionary *emitterCellDictionary = [emitterCells objectAtIndex:0];
    
    CAEmitterCell* fire = [self createEmitterCell:emitterCellDictionary];
    self.emitterCells = [NSArray arrayWithObject:fire];
    [self startEmitting];
}

- (void)setCellImage:(UIImage *)cellImage {
    _cellImage = cellImage;
    
    CAEmitterCell* fire = self.emitterCells[0];
    fire.contents = (id)[_cellImage CGImage];
}

- (CAEmitterCell *)createEmitterCell:(NSDictionary *)emitterCellDictionary {
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = [[emitterCellDictionary valueForKey:@"birthRate"] floatValue];
    self.cellBirthRate = fire.birthRate;
    
    fire.lifetime = [[emitterCellDictionary valueForKey:@"lifetime"] floatValue];
    fire.lifetimeRange = [[emitterCellDictionary valueForKey:@"lifetimeRange"] floatValue];

    CGFloat red = [[emitterCellDictionary valueForKey:@"colorRed"] floatValue];
    CGFloat green = [[emitterCellDictionary valueForKey:@"colorGreen"] floatValue];
    CGFloat blue = [[emitterCellDictionary valueForKey:@"colorBlue"] floatValue];
    CGFloat alpha = [[emitterCellDictionary valueForKey:@"colorAlpha"] floatValue];
    fire.color = [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] CGColor];
    
    fire.greenRange = [[emitterCellDictionary valueForKey:@"greenRange"] floatValue];
    fire.redRange = [[emitterCellDictionary valueForKey:@"redRange"] floatValue];
    fire.blueRange = [[emitterCellDictionary valueForKey:@"blueRange"] floatValue];
    
    NSString *imageName = [emitterCellDictionary objectForKey:@"textureName"];
    fire.contents = (id)[[UIImage imageNamed:imageName] CGImage];

    [fire setName:@"fire"];
    
    fire.alphaSpeed = [[emitterCellDictionary valueForKey:@"alphaSpeed"] floatValue];
    fire.velocity = [[emitterCellDictionary valueForKey:@"velocity"] floatValue];
    fire.velocityRange = [[emitterCellDictionary valueForKey:@"velocityRange"] floatValue];
    fire.emissionRange = [[emitterCellDictionary valueForKey:@"emissionRange"] floatValue];
    fire.scaleRange = [[emitterCellDictionary valueForKey:@"scaleRange"] floatValue];
    fire.scale = [[emitterCellDictionary valueForKey:@"scale"] floatValue];
    fire.scaleSpeed = [[emitterCellDictionary valueForKey:@"scaleSpeed"] floatValue];
    fire.spin = [[emitterCellDictionary valueForKey:@"spin"] floatValue];
    fire.emissionLongitude = [[emitterCellDictionary valueForKey:@"emissionLongitude"] floatValue];
    fire.yAcceleration = [[emitterCellDictionary valueForKey:@"yAcceleration"] floatValue];
    fire.xAcceleration = [[emitterCellDictionary valueForKey:@"xAcceleration"] floatValue];
    
    return fire;
}

- (void)refreshEmitter {
    [self startEmitting];
}

- (void)startEmitting {
    [self emittingCallback];
    if (self.lifeSpan > 0) {
        [self performSelector:@selector(emittingCallback) withObject:nil afterDelay:self.lifeSpan];
    }
    [self setIsEmitting:YES];
}

- (void)emittingCallback {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(emittingCallback) object:nil];
    [self setIsEmitting:NO];
}

-(void)setIsEmitting:(BOOL)isEmitting {
    //turn on/off the emitting of particles
    [self setValue:[NSNumber numberWithInt:isEmitting?self.cellBirthRate:0] forKeyPath:@"emitterCells.fire.birthRate"];
}


@end
