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
    emitterLayer.frame = CGRectMake(0,
                                    0,
                                    emitterLayer.superlayer.frame.size.width,
                                    emitterLayer.superlayer.frame.size.height);
    
    emitterLayer.emitterPosition = CGPointMake(emitterLayer.superlayer.bounds.size.width / 2,
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
    
    CAEmitterCell* emitterCell = [self createEmitterCell:emitterCellDictionary];
    self.emitterCells = [NSArray arrayWithObject:emitterCell];
    [self startEmitting];
}

- (void)setCellImage:(UIImage *)cellImage {
    _cellImage = cellImage;
    
    CAEmitterCell* emitterCell = self.emitterCells[0];
    emitterCell.contents = (id)[_cellImage CGImage];
}

- (CAEmitterCell *)createEmitterCell:(NSDictionary *)emitterCellDictionary {
    CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
    emitterCell.birthRate = [[emitterCellDictionary valueForKey:@"birthRate"] floatValue];
    self.cellBirthRate = emitterCell.birthRate;
    
    emitterCell.lifetime = [[emitterCellDictionary valueForKey:@"lifetime"] floatValue];
    emitterCell.lifetimeRange = [[emitterCellDictionary valueForKey:@"lifetimeRange"] floatValue];

    CGFloat red = [[emitterCellDictionary valueForKey:@"colorRed"] floatValue];
    CGFloat green = [[emitterCellDictionary valueForKey:@"colorGreen"] floatValue];
    CGFloat blue = [[emitterCellDictionary valueForKey:@"colorBlue"] floatValue];
    CGFloat alpha = [[emitterCellDictionary valueForKey:@"colorAlpha"] floatValue];
    emitterCell.color = [[UIColor colorWithRed:red green:green blue:blue alpha:alpha] CGColor];
    
    emitterCell.greenRange = [[emitterCellDictionary valueForKey:@"greenRange"] floatValue];
    emitterCell.redRange = [[emitterCellDictionary valueForKey:@"redRange"] floatValue];
    emitterCell.blueRange = [[emitterCellDictionary valueForKey:@"blueRange"] floatValue];
    
    NSString *imageName = [emitterCellDictionary objectForKey:@"textureName"];
    emitterCell.contents = (id)[[UIImage imageNamed:imageName] CGImage];

    [emitterCell setName:@"emitterCell"];
    
    emitterCell.alphaSpeed = [[emitterCellDictionary valueForKey:@"alphaSpeed"] floatValue];
    emitterCell.velocity = [[emitterCellDictionary valueForKey:@"velocity"] floatValue];
    emitterCell.velocityRange = [[emitterCellDictionary valueForKey:@"velocityRange"] floatValue];
    emitterCell.emissionRange = [[emitterCellDictionary valueForKey:@"emissionRange"] floatValue];
    emitterCell.scaleRange = [[emitterCellDictionary valueForKey:@"scaleRange"] floatValue];
    emitterCell.scale = [[emitterCellDictionary valueForKey:@"scale"] floatValue];
    emitterCell.scaleSpeed = [[emitterCellDictionary valueForKey:@"scaleSpeed"] floatValue];
    emitterCell.spin = [[emitterCellDictionary valueForKey:@"spin"] floatValue];
    emitterCell.emissionLongitude = [[emitterCellDictionary valueForKey:@"emissionLongitude"] floatValue];
    emitterCell.yAcceleration = [[emitterCellDictionary valueForKey:@"yAcceleration"] floatValue];
    emitterCell.xAcceleration = [[emitterCellDictionary valueForKey:@"xAcceleration"] floatValue];
    
    return emitterCell;
}

- (void)refreshEmitter {
    [self startEmitting];
}

- (CGFloat)totalDuration {
    CAEmitterCell* emitterCell = self.emitterCells[0];
    return self.lifeSpan + emitterCell.lifetime + emitterCell.lifetimeRange;
}

- (void)startEmitting {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopEmitter) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cleanUpEmitter) object:nil];

    if (self.lifeSpan > 0) {
        [self performSelector:@selector(stopEmitter) withObject:nil afterDelay:self.lifeSpan];
        [self performSelector:@selector(cleanUpEmitter) withObject:nil afterDelay:[self totalDuration]];
    } else {
        [self cleanUpEmitter];
    }
    
    [self setIsEmitting:YES];
}

- (void)stopEmitter {
    [self setIsEmitting:NO];
}

- (void)cleanUpEmitter {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cleanUpEmitter) object:nil];
    [self setIsEmitting:NO];
    [self removeFromSuperlayer];
}

-(void)setIsEmitting:(BOOL)isEmitting {
    //turn on/off the emitting of particles
    [self setValue:[NSNumber numberWithInt:isEmitting?self.cellBirthRate:0] forKeyPath:@"emitterCells.emitterCell.birthRate"];
}


@end
