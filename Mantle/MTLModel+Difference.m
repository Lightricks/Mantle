// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

#import "MTLModel+Difference.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MTLModel (Difference)

- (NSArray<NSString *> *)differenceFrom:(nullable id)object {
  MTLModel *actual = (MTLModel *)object;

  if (!actual) {
    return @[
      [NSString stringWithFormat:@"Expected: object of type %@, got: nil", NSStringFromClass([self class])]
    ];
  }

  if (![[actual class] isEqual:[self class]]) {
    return @[
      [NSString stringWithFormat:@"Expected: object of type %@, got: %@",
       NSStringFromClass([self class]), NSStringFromClass([object class])]
    ];
  }

  NSMutableArray<NSString *> *differences = [NSMutableArray array];
  for (NSString *key in self.class.propertyKeys) {
    id expectedValue = [self valueForKey:key];
    id actualValue = [actual valueForKey:key];

    BOOL valuesEqual = ((expectedValue == nil && actualValue == nil) || [expectedValue isEqual:actualValue]);
    if (!valuesEqual) {
      [differences addObject:[NSString stringWithFormat:@"%@:", key]];
      if ([expectedValue respondsToSelector:@selector(differenceFrom:)]) {
        NSArray<NSString *> *diffLines = [expectedValue differenceFrom:actualValue];
        for (NSString *line in diffLines) {
          [differences addObject:[NSString stringWithFormat:@"|\t%@", line]];
        }
      }
      else {
        [differences addObject:[NSString stringWithFormat:@"|\tExpected: %@", expectedValue]];
        [differences addObject:[NSString stringWithFormat:@"|\tActual\t: %@", actualValue]];
      }
    }
  }

  return differences;
}

@end

NS_ASSUME_NONNULL_END
