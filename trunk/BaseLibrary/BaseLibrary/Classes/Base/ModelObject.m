//
//  ModelObject.m
//  BaseLibrary
//
//  Created by MacCoder on 10/12/14.
//  Copyright (c) 2014 MacCoder. All rights reserved.
//

#import "ModelObject.h"
#import <objc/runtime.h>

@implementation ModelObject

- (NSString *)description {
    [super description];
    return [NSString stringWithFormat:@"%@", [self serialize]];
}

- (void)deserialize:(NSDictionary *)dict {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            
            [self setValue:[dict objectForKey:propertyName] forKey:propertyName];
        }
    }
    free(properties);
}

- (NSDictionary *)serialize {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            NSString *propertyType = [NSString stringWithCString:propType
                                                        encoding:[NSString defaultCStringEncoding]];
            propertyType = propertyType; //todo
            [dictionary setObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    free(properties);
    return dictionary;
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

@end
