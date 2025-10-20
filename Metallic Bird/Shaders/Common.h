//
//  Params.h
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

#ifndef Common_h
#define Common_h

#include <simd/simd.h>

typedef struct {
    uint32_t width;
    uint32_t height;
} WindowSize;

typedef struct {
    simd_float2 pos;
    simd_float2 size;
    float cosTheta;
    float sinTheta;
    float z;
} SpriteInstance;

typedef struct {
    simd_float4x4 proj;
} FrameUniforms;

typedef enum {
    Position = 0,
    UV = 1
} Attributes;

typedef enum {
    VertexBuffer = 0,
    UVBuffer = 1,
    UniformsBuffer = 11,
} Buffers;

#endif /* Common_h */
