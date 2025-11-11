//
//  ShaderStructs.metal
//  Metallic Bird
//
//  Created by Alex Sigalos on 11/10/25.
//

#include <metal_stdlib>
using namespace metal;

struct VSIn {
    float2 pos [[attribute(0)]];
    float2 uv [[attribute(1)]];
};

struct RastData {
    float4 pos [[position]];
    float2 uv;
};
