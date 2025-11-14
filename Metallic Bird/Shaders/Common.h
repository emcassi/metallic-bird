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
    simd_float4x4 transform;
} FrameUniforms;

typedef struct {
    simd_float2 position;
} Vertex;

typedef struct {
    simd_float2 position;
    simd_float2 uv;
} UVVertex;

typedef enum {
    Position = 0,
    UV = 1
} Attributes;

typedef enum {
    VertexBuffer = 0,
    UVBuffer = 1,
    UniformsBuffer = 11,
} Buffers;

typedef enum {
    BaseColor = 0
} TextureIndices;

#endif /* Common_h */
