//
//  Vertex.metal
//  Metallic Bird
//
//  Created by Alex Sigalos on 10/19/25.
//

#include <metal_stdlib>
#include "Common.h"
using namespace metal;

struct VSIn {
    float2 corner [[attribute(0)]];   // unit quad corners (-0.5..0.5)
};

struct VSOut {
    float4 pos [[position]];
};

vertex VSOut vertex_main(
    VSIn                    in [[stage_in]],
    uint                    iid [[instance_id]],
    constant SpriteInstance *I [[buffer(1)]],
    constant FrameUniforms &u [[buffer(11)]]
    ) {
    SpriteInstance inst = I[iid];

    float2 scaled = in.corner * inst.size;

    float2 p = float2(
        inst.cosTheta * scaled.x - inst.sinTheta * scaled.y,
        inst.sinTheta * scaled.x + inst.cosTheta * scaled.y
        );

    float2 worldXY = p + inst.pos;
    float4 world = float4(worldXY, inst.z, 1);

    VSOut out {
        .pos = u.proj * world
    };

    return out;
}
